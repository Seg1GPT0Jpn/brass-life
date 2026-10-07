import '../../entities/club.dart';
import '../../entities/memory_tag.dart';
import '../../value_objects/school_enums.dart';
import '../master/approach_cards.dart';
import '../models/game_enums.dart';
import '../models/game_state.dart';
import 'game_context.dart';
import 'memory_writer.dart';
import 'performance.dart';
import 'relations.dart';
import 'school_calendar.dart';

/// 架空の管楽合奏コンクール（地区 → 県 → 支部 → 全国）。
///
/// 演奏の出来 v は次の合計:
/// - 部の強さ帯の基準値 + 伝統補正
/// - メンバー平均熟練度と「強さ帯として標準的な熟練度」の差 / 12
/// - 結束（メンバー間の好感）/ 4、平均やる気、プレイヤーの貢献
/// - アプローチカードの効果、揺らぎ（カードで幅が変わる）
///
/// 他校は「年度の調子」+「当日の揺らぎ」で v を持つ（どちらも SimulationRng）。
/// 支部・全国には県外の代表校（架空）も出場する。
/// 賞は v の基準値で決まり、代表は金賞のうち上位の枠で選ばれる。
class ContestEngine {
  const ContestEngine(this.ctx);

  final GameContext ctx;

  static int tierBase(ClubTier t) => switch (t) {
    ClubTier.national => 93,
    ClubTier.block => 83,
    ClubTier.prefectural => 70,
    ClubTier.district => 58,
    ClubTier.weak => 45,
  };

  /// 大会の日程（月, 週）。
  static (int, int) dateOf(ContestStage stage) => switch (stage) {
    ContestStage.district => (7, 4),
    ContestStage.prefectural => (8, 2),
    ContestStage.block => (8, 4),
    ContestStage.national => (10, 3),
    ContestStage.none => (7, 4),
  };

  int stageTurn(int fiscalYear, ContestStage stage) {
    final (m, w) = dateOf(stage);
    return SchoolCalendar(ctx.calendar).turnOf(fiscalYear, m, w);
  }

  /// 金賞・銀賞の基準。
  static (int, int) thresholds(ContestStage stage, BandDivision division) =>
      switch (stage) {
        ContestStage.district => (55, 47),
        ContestStage.prefectural =>
          division == BandDivision.large ? (70, 62) : (68, 60),
        ContestStage.block => (82, 75),
        ContestStage.national => (92, 87),
        ContestStage.none => (100, 100),
      };

  static bool isFinal(ContestStage stage, BandDivision division) =>
      division == BandDivision.large
      ? stage == ContestStage.national
      : stage == ContestStage.block;

  static ContestStage? nextOf(ContestStage stage, BandDivision division) {
    if (isFinal(stage, division)) return null;
    return switch (stage) {
      ContestStage.district => ContestStage.prefectural,
      ContestStage.prefectural => ContestStage.block,
      ContestStage.block => ContestStage.national,
      _ => null,
    };
  }

  /// 今年度のコンクールを開始する（オーディション後）。
  ContestProgress start(GameState s, int fiscalYear) => ContestProgress(
    fiscalYear: fiscalYear,
    division: ctx.club(s).division,
    nextStage: ContestStage.district,
  );

  // ───────────────────────── 他校 ─────────────────────────

  int _yearForm(String schoolId, int fiscalYear) {
    final club = ctx.index.clubOfSchool(schoolId);
    final rng = ctx.sim.stream(
      turn: ctx.calendar.firstTurnOfFiscalYear(fiscalYear),
      domain: 'contest_year',
      actor: schoolId,
    );
    return tierBase(club.tier) +
        (club.tradition - 50) ~/ 10 +
        rng.normalInt(mean: 0, sd: 6, min: -20, max: 20);
  }

  int _otherScore(String schoolId, int fiscalYear, ContestStage stage) {
    final rng = ctx.sim.stream(
      turn: stageTurn(fiscalYear, stage),
      domain: 'contest_stage',
      actor: schoolId,
    );
    return _yearForm(schoolId, fiscalYear) +
        rng.normalInt(mean: 0, sd: 3, min: -10, max: 10);
  }

  /// 県外の代表校（架空）。
  List<(String, int)> _virtual(
    int fiscalYear,
    ContestStage stage,
    BandDivision division,
  ) {
    final (count, mean, sd) = switch ((stage, division)) {
      (ContestStage.block, BandDivision.large) => (9, 85, 4),
      (ContestStage.block, BandDivision.small) => (9, 76, 5),
      (ContestStage.national, _) => (28, 89, 4),
      _ => (0, 0, 0),
    };
    final block = ctx.world.region.blockName;
    return [
      for (var k = 0; k < count; k++)
        (
          stage == ContestStage.national
              ? '他支部代表 ${k + 1}'
              : '$block 他県代表 ${k + 1}',
          ctx.sim
              .stream(
                turn: stageTurn(fiscalYear, stage),
                domain: 'contest_virtual',
                actor: 'v$k',
              )
              .normalInt(mean: mean, sd: sd, min: mean - 15, max: mean + 15),
        ),
    ];
  }

  /// 指定段階の出場校（実在の架空校のみ。自校を含む）。
  List<String> _realEntrants(
    GameState s,
    ContestStage stage,
    int fiscalYear,
    BandDivision division,
  ) {
    final mySchool = ctx.school(s);
    final pool = [
      for (final sc in ctx.world.schools)
        if (sc.level == mySchool.level &&
            ctx.index.clubOfSchool(sc.id).division == division &&
            (sc.id == mySchool.id ||
                ctx.index.clubOfSchool(sc.id).memberIds.length >= 6))
          sc.id,
    ];
    if (stage == ContestStage.district) {
      return [
        for (final id in pool)
          if (ctx.index.schoolById[id]!.districtId == mySchool.districtId) id,
      ];
    }
    // 前の段階の代表校
    final prev = switch (stage) {
      ContestStage.prefectural => ContestStage.district,
      ContestStage.block => ContestStage.prefectural,
      ContestStage.national => ContestStage.block,
      _ => ContestStage.district,
    };
    final advanced = <String>[];
    if (prev == ContestStage.district) {
      for (final d in ctx.world.region.districts) {
        final entrants = [
          for (final id in pool)
            if (ctx.index.schoolById[id]!.districtId == d.id) id,
        ];
        advanced.addAll(
          _advancers(
            s,
            entrants,
            ContestStage.district,
            fiscalYear,
            division,
            const [],
          ),
        );
      }
    } else {
      final entrants = _realEntrants(s, prev, fiscalYear, division);
      advanced.addAll(
        _advancers(
          s,
          entrants,
          prev,
          fiscalYear,
          division,
          _virtual(fiscalYear, prev, division),
        ),
      );
    }
    return advanced;
  }

  /// 代表枠。
  static int _quota(ContestStage stage, BandDivision division, int entrants) =>
      switch (stage) {
        ContestStage.district => (entrants * 45 + 99) ~/ 100,
        ContestStage.prefectural => division == BandDivision.large ? 3 : 2,
        ContestStage.block => 2,
        _ => 0,
      };

  /// 自校の確定済みの得点（その段階の結果があれば）。
  int? _myScore(GameState s, ContestStage stage) {
    for (final r in s.contest?.results ?? const <ContestStageResult>[]) {
      if (r.stage == stage) return r.score;
    }
    return null;
  }

  List<String> _advancers(
    GameState s,
    List<String> entrants,
    ContestStage stage,
    int fiscalYear,
    BandDivision division,
    List<(String, int)> virtual,
  ) {
    final (gold, _) = thresholds(stage, division);
    final scored =
        <(String, int)>[
          for (final id in entrants)
            (
              id,
              id == s.schoolId
                  ? (_myScore(s, stage) ?? -1)
                  : _otherScore(id, fiscalYear, stage),
            ),
          ...virtual,
        ]..sort((a, b) {
          final c = b.$2.compareTo(a.$2);
          return c != 0 ? c : a.$1.compareTo(b.$1);
        });
    final quota = _quota(stage, division, scored.length);
    return [
      for (final (id, v) in scored.take(quota))
        if (v >= gold && ctx.index.schoolById.containsKey(id)) id,
    ];
  }

  // ───────────────────────── 自校の演奏 ─────────────────────────

  ({GameState state, List<String> lines}) perform(
    GameState s,
    ApproachCard? card,
  ) {
    final progress = s.contest!;
    final stage = progress.nextStage!;
    final division = progress.division;
    final fy = progress.fiscalYear;
    final club = ctx.club(s);
    final school = ctx.school(s);
    final members = s.contestMembers;
    final playerIn = members.contains(Relations.player);
    final perf = Performance(ctx);
    final m = perf.metrics(s, members);
    final rng = ctx.sim.stream(
      turn: s.turn,
      domain: 'contest',
      actor: s.schoolId,
      choice: card?.name ?? '',
    );
    final lines = <String>[];
    var player = s.player;

    // 演奏の出来
    final expected =
        ctx.expectedContestSkill[(school.level, club.tier)] ?? m.avgSkill;
    var v = tierBase(club.tier) + (club.tradition - 50) ~/ 10;
    v += (m.avgSkill - expected) ~/ 12;
    v += (m.cohesion ~/ 4).clamp(-5, 7);
    v += (m.avgMotivation - 60) ~/ 8;
    var sd = 4;
    if (playerIn) {
      v +=
          ((player.skill - m.avgSkill) ~/ 25 + (player.musicality - 300) ~/ 150)
              .clamp(-3, 4);
      if (s.roles[Relations.player] == ClubRole.conductor) v += 1;
      if (player.hasTrait('stage_fright') && card != ApproachCard.calmMind) {
        v -= 2;
      }
      if (card != null) {
        final e = perf.cardEffect(s, card, m, rng);
        v += e.bonus;
        sd = e.sd;
        player = player.copyWith(
          fatigue: (player.fatigue + e.fatigueDelta).clamp(0, 100),
        );
        lines.add('「${card.label}」で臨んだ。${e.note}');
      }
    } else {
      lines.add('今年はコンクールメンバーではないので、客席から仲間を応援した。');
    }
    v += rng.normalInt(mean: 0, sd: sd, min: -15, max: 15);

    // 順位と賞
    final s2 = s.copyWith(
      contest: progress.copyWith(
        results: [
          ...progress.results,
          ContestStageResult(
            stage: stage,
            award: ContestAward.none,
            advanced: false,
            score: v,
            rank: 0,
            entrants: 0,
          ),
        ],
      ),
    );
    final real = _realEntrants(s2, stage, fy, division);
    if (!real.contains(s.schoolId)) real.add(s.schoolId);
    final virtual = _virtual(fy, stage, division);
    final scored =
        <(String, int)>[
          for (final id in real)
            (id, id == s.schoolId ? v : _otherScore(id, fy, stage)),
          ...virtual,
        ]..sort((a, b) {
          final c = b.$2.compareTo(a.$2);
          return c != 0 ? c : a.$1.compareTo(b.$1);
        });
    final rank = scored.indexWhere((e) => e.$1 == s.schoolId) + 1;
    final (goldT, silverT) = thresholds(stage, division);
    final award = v >= goldT
        ? ContestAward.gold
        : (v >= silverT ? ContestAward.silver : ContestAward.bronze);
    final finalStage = isFinal(stage, division);
    final advancers = finalStage
        ? const <String>[]
        : _advancers(s2, real, stage, fy, division, virtual);
    final advanced = advancers.contains(s.schoolId);

    String label(String id) => ctx.index.schoolById[id]?.name ?? id;
    String awardOf(int score) =>
        score >= goldT ? '金' : (score >= silverT ? '銀' : '銅');
    final board = [
      for (final (id, score) in scored.take(6))
        '${label(id)}　${awardOf(score)}賞${advancers.contains(id) ? '（代表）' : ''}',
    ];

    final result = ContestStageResult(
      stage: stage,
      award: award,
      advanced: advanced,
      score: v,
      rank: rank,
      entrants: scored.length,
      board: board,
    );
    final next = advanced ? nextOf(stage, division) : null;
    final newProgress = progress.copyWith(
      results: [...progress.results, result],
      nextStage: next,
      finishedTurn: next == null ? s.turn : null,
    );

    final suffix = advanced
        ? '（代表）'
        : (award == ContestAward.gold && !finalStage ? '（代表落ち）' : '');
    lines.add(
      '${stage.label}：${award.label}$suffix（${scored.length}団体中 $rank位）',
    );
    if (advanced) lines.add('${nextOf(stage, division)!.label}への出場が決まった！');

    // やる気・記憶・実績
    final mem = MemoryWriter(ctx, s);
    final npcs = Map.of(s.npcs);
    final motivationDelta = advanced
        ? 6
        : (award == ContestAward.gold ? (finalStage ? 8 : -4) : -2);
    for (final id in ctx.activeMembers(s).map((e) => e.id)) {
      final st = npcs[id]!;
      npcs[id] = st.copyWith(
        motivation: (st.motivation + motivationDelta).clamp(0, 100),
      );
    }
    player = player.copyWith(
      motivation: (player.motivation + motivationDelta).clamp(0, 100),
    );
    final params = {
      'fiscalYear': '$fy',
      'contest': ctx.world.region.contestName,
      'stage': stage.label,
      'award': award.label,
      'suffix': suffix,
    };
    for (final id in members) {
      mem.add(
        category: MemoryCategory.contestResult,
        subjectId: id,
        objectIds: [club.id],
        reasonKey: 'contest_result',
        params: params,
        importance:
            stage.level * 15 +
            (award == ContestAward.gold ? 10 : 0) +
            (suffix.isEmpty ? 0 : 10),
        visibility: MemoryVisibility.public,
      );
    }
    if (!playerIn) {
      mem.add(
        category: MemoryCategory.contestResult,
        subjectId: Relations.player,
        objectIds: [club.id],
        reasonKey: 'contest_support',
        params: params,
        importance: stage.level * 8,
      );
    }

    var achievements = s.achievements;
    var history = s.clubHistory;
    if (next == null) {
      final record = ContestRecord(
        fiscalYear: fy,
        division: division,
        stage: stage,
        award: award,
      );
      history = [...history, record];
      final stageLabel = ctx.calendar.dateOf(s.turn).stageLabel;
      achievements = [
        ...achievements,
        Achievement(
          fiscalYear: fy,
          schoolId: s.schoolId,
          kind: playerIn ? 'contest' : 'contest_support',
          label: '$stageLabel ${record.summary}${playerIn ? '' : '（客席で応援）'}',
          weight:
              (stage.level * 20 + (award == ContestAward.gold ? 15 : 0)) ~/
              (playerIn ? 1 : 3),
        ),
      ];
    }

    final out = mem.apply(
      s.copyWith(
        player: player,
        npcs: npcs,
        contest: newProgress,
        clubHistory: history,
        achievements: achievements,
      ),
    );
    return (state: out, lines: lines);
  }
}
