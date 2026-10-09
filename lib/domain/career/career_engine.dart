import '../entities/memory_tag.dart';
import '../entities/world.dart';
import '../game/engine/game_context.dart';
import '../game/engine/memory_writer.dart';
import '../game/engine/relations.dart';
import '../game/engine/roster_service.dart';
import '../game/engine/school_calendar.dart';
import '../game/models/game_enums.dart';
import '../game/models/game_state.dart';
import '../value_objects/relationship_vector.dart';
import 'game_mode.dart';
import 'mode_states.dart';

/// 大人編（キャリアモード）の始め方と、週のコマンドの効果。
///
/// 週の流れ: コマンドの効果 → 毎週の効果（練習メニュー・収入）→ 部員の自律行動（本編の DramaEngine）。
/// 揺らぎは決定論的乱数（domain 'career'）で、同じコマンドなら同じ結果になる。
class CareerEngine {
  const CareerEngine(this.ctx);

  final GameContext ctx;

  /// 大人編を始める。[schoolId] は顧問の赴任先・講師の拠点校・OB/OG の母校。
  GameState start(
    World world,
    GameMode mode, {
    required String schoolId,
    required String familyName,
    required String givenName,
    String? originTitle,
  }) {
    if (!mode.isCareer) throw ArgumentError('大人編のモードではない');
    final club = ctx.index.clubOfSchool(schoolId);
    final (roster, npcs) = RosterService(ctx).initialRoster(club);
    final p = world.player;
    final school = ctx.index.schoolById[schoolId]!;
    final termEnd = SchoolCalendar(ctx.calendar)
        .turnOf(ctx.calendar.dateOf(0).fiscalYear + GameMode.termYears, 4, 1);
    return GameState(
      worldSeed: world.seed,
      generatorVersion: world.generatorVersion,
      turn: 0,
      stage: GameStage.middle,
      schoolId: schoolId,
      schoolHistory: [schoolId],
      roster: roster,
      npcs: npcs,
      mode: mode,
      choices: ['career:${mode.name}:$schoolId'],
      career: CareerState(
        // 任期が終わるターン（4 年目の 4 月第 1 週）
        termEndTurn: termEnd,
        contractedSchoolIds: mode == GameMode.instructor
            ? [schoolId, ...partnerSchools(schoolId)]
            : const [],
        money: mode == GameMode.alumni ? 30000 : 0,
        originTitle: originTitle,
        servedSchoolIds: mode == GameMode.teacher ? [schoolId] : const [],
      ),
      player: PlayerState(
        familyName: familyName,
        givenName: givenName,
        gender: p.gender,
        personality: p.personality,
        traits: p.traits,
        aptitude: p.aptitude,
        background: p.background,
        // 大人編のプレイヤーは学年を持たない（部員ではない）
        grade: 0,
        academic: p.academic * 10,
        stamina: p.stamina,
        advisorTrust: 60,
      ),
      logs: [
        WeekLog(
          turn: 0,
          dateLabel: ctx.calendar.dateOf(0).label,
          lines: [
            switch (mode) {
              GameMode.teacher => '${school.name}の吹奏楽部の顧問として着任した。',
              GameMode.instructor => '${school.name}を拠点に、外部講師としての仕事が始まった。',
              _ => '母校・${school.name}の吹奏楽部を、OB/OG として支えることにした。',
            },
            '部員は ${roster.length} 人。任期は ${GameMode.termYears} 年。',
          ],
        ),
      ],
    );
  }

  /// 顧問: 異動を受けて、[schoolId] で次の任期を始める（暦は続きから）。
  ///
  /// 名簿はその年度の部（RosterService.materialize）に入れ替え、関係性・記憶・実績は引き継ぐ。
  GameState startNextTerm(GameState s, String schoolId) {
    final career = s.career!;
    if (s.mode != GameMode.teacher) throw StateError('顧問モードのみ');
    if (!career.transferOffers.any((o) => o.schoolId == schoolId)) {
      throw ArgumentError('オファーのない学校: $schoolId');
    }
    final fy = ctx.calendar.dateOf(s.turn).fiscalYear;
    final club = ctx.index.clubOfSchool(schoolId);
    final m = RosterService(ctx).materialize(club, fy);
    final npcs = {
      for (final e in s.npcs.entries) e.key: e.value.copyWith(active: false),
      ...m.states,
    };
    final school = ctx.index.schoolById[schoolId]!;
    final offer = career.transferOffers.firstWhere(
      (o) => o.schoolId == schoolId,
    );
    return s.copyWith(
      stage: GameStage.middle,
      pending: null,
      schoolId: schoolId,
      schoolHistory: [...s.schoolHistory, schoolId],
      roster: [...m.roster],
      npcs: npcs,
      extraNpcs: {...s.extraNpcs, ...m.extra},
      roles: const {},
      contest: null,
      contestMembers: const [],
      soloistId: null,
      executiveSelectionTurn: null,
      condition: const ClubCondition(),
      rehearsal: const RehearsalMemory(),
      choices: [...s.choices, '${s.turn}:transfer:$schoolId'],
      career: career.copyWith(
        termEndTurn: SchoolCalendar(ctx.calendar)
            .turnOf(fy + GameMode.termYears, 4, 1),
        transferOffers: const [],
        servedSchoolIds: [...career.servedSchoolIds, schoolId],
      ),
      logs: [
        ...s.logs,
        WeekLog(
          turn: s.turn,
          dateLabel: ctx.dateLabelOf(s),
          actionLabel: '異動',
          lines: [
            '${offer.kind == 'promotion' ? '栄転' : '立て直しのため'}、${school.name}の吹奏楽部の顧問として着任した。',
            '部員は ${m.roster.length} 人。新しい任期は ${GameMode.termYears} 年。',
          ],
        ),
      ],
    );
  }

  /// 外部講師が契約する他校（同じ学校段階の、拠点校以外の 2 校。世界の並び順で決まる）。
  List<String> partnerSchools(String homeId) {
    final home = ctx.index.schoolById[homeId]!;
    return [
      for (final sc in ctx.world.schools)
        if (sc.id != homeId && sc.level == home.level) sc.id,
    ].take(2).toList();
  }

  /// コマンドを使えない理由（使えるなら null）。
  String? unavailableReason(GameState s, CareerCommand c, String? targetId) {
    if (s.mode != c.mode) return 'このモードでは使えない';
    final career = s.career!;
    if (c.cost > career.money) return '資金が足りない（所持金 ${career.money} 円）';
    switch (c.target) {
      case CommandTarget.none:
        if (targetId != null) return 'この行動に相手は不要';
      case CommandTarget.member:
        if (targetId == null) return '部員を選んでください';
        final t = s.npcs[targetId];
        if (t == null ||
            !t.active ||
            t.retired ||
            !s.roster.contains(targetId)) {
          return '今は部にいない';
        }
        if (c == CareerCommand.intensiveCoaching && t.instrument == null) {
          return '楽器がまだ決まっていない';
        }
      case CommandTarget.school:
        if (targetId == null) return '学校を選んでください';
        if (targetId == s.schoolId ||
            !career.contractedSchoolIds.contains(targetId)) {
          return '契約している他校を選んでください';
        }
    }
    return null;
  }

  /// コマンドの効果と毎週の効果を適用する（部員の自律行動はこの後に TimeManager が回す）。
  ({GameState state, List<String> lines}) apply(
    GameState s,
    CareerCommand c,
    String? targetId,
  ) {
    final reason = unavailableReason(s, c, targetId);
    if (reason != null) throw ArgumentError(reason);
    final rng = ctx.sim.stream(
      turn: s.turn,
      domain: 'career',
      actor: Relations.player,
      choice: '${c.name}:${targetId ?? ''}',
    );
    final npcs = Map.of(s.npcs);
    final relations = Map.of(s.relations);
    final mem = MemoryWriter(ctx, s);
    var career = s.career!;
    final lines = <String>[];
    final members = ctx.activeMembers(s);
    String name(String id) => ctx.npc(s, id).fullName;
    int grow(int skill, int base) =>
        (skill + base * (1200 - skill) ~/ 1200).clamp(0, 1000);
    void touch(String id, {int skill = 0, int mot = 0, int stress = 0}) {
      final st = npcs[id]!;
      npcs[id] = st.copyWith(
        skill: skill == 0 ? st.skill : grow(st.skill, skill),
        motivation: (st.motivation + mot).clamp(0, 100),
        stress: (st.stress + stress).clamp(0, 100),
        lowMotivationWeeks: mot > 0 ? 0 : st.lowMotivationWeeks,
      );
    }

    switch (c) {
      case CareerCommand.watch:
        lines.add('今週は生徒たちに任せて見守った。');
      case CareerCommand.encourage:
        for (final m in members) {
          touch(m.id, mot: 4, stress: -1);
        }
        lines.add('部員全員に声をかけて励ました。部全体のやる気が上がった。');
      case CareerCommand.counseling || CareerCommand.consultation:
        final t = targetId!;
        final bondBoost = c == CareerCommand.consultation
            ? career.bond ~/ 20
            : 0;
        touch(t, mot: 8 + bondBoost, stress: -15 - bondBoost * 2);
        final d = RelationshipVector(
          affection: 4 + bondBoost,
          trust: 6 + bondBoost,
        );
        Relations.add(relations, t, Relations.player, d);
        mem.add(
          category: MemoryCategory.life,
          subjectId: t,
          objectIds: [Relations.player],
          reasonKey: c == CareerCommand.counseling
              ? 'career_counseling'
              : 'alumni_consultation',
          params: {'actor': name(t), 'target': s.player.fullName},
          delta: d,
          importance: 25,
        );
        if (c == CareerCommand.consultation) {
          career = career.copyWith(bond: (career.bond + 2).clamp(0, 100));
        }
        lines.add('${name(t)}の話をじっくり聞いた。表情が少し明るくなった。');
      case CareerCommand.privateLesson:
        final t = targetId!;
        final before = npcs[t]!.skill;
        touch(t, skill: rng.range(10, 16), mot: 2);
        Relations.add(
          relations,
          t,
          Relations.player,
          const RelationshipVector(trust: 3),
        );
        lines.add(
          '${name(t)}を個別に指導した（熟練度 ${npcs[t]!.skill - before >= 0 ? '+' : ''}${npcs[t]!.skill - before}）。',
        );
      case CareerCommand.intensiveCoaching:
        final inst = npcs[targetId!]!.instrument!;
        final part = members.where((m) => m.instrument == inst).toList();
        for (final m in part) {
          touch(m.id, skill: rng.range(16, 26), stress: 4);
          Relations.add(
            relations,
            m.id,
            Relations.player,
            const RelationshipVector(trust: 4),
          );
        }
        career = career.copyWith(
          reputation: (career.reputation + 2).clamp(0, 100),
        );
        lines.add('${inst.label}パート（${part.length}人）に集中レッスンをした。見違えるように上達した。');
      case CareerCommand.masterclass:
        for (final m in members) {
          touch(m.id, skill: 3, mot: 2);
        }
        career = career.copyWith(
          reputation: (career.reputation + 1).clamp(0, 100),
        );
        lines.add('公開講座を開いた。部全体が少し上達した。');
      case CareerCommand.travelLesson:
        final id = targetId!;
        final boosts = Map.of(career.schoolBoosts);
        boosts[id] = ((boosts[id] ?? 0) + 2).clamp(0, 8);
        career = career.copyWith(
          schoolBoosts: boosts,
          reputation: (career.reputation + 3).clamp(0, 100),
        );
        for (final m in members) {
          touch(m.id, mot: -1);
        }
        lines.add(
          '${ctx.index.schoolById[id]!.name}へ出張レッスンに行った'
          '（コンクールでの上乗せ +${boosts[id]}）。拠点校の部員は少し寂しそうだった。',
        );
      case CareerCommand.restDay:
        lines.add('今週は休んだ。');
      case CareerCommand.snackGift:
        for (final m in members) {
          touch(m.id, mot: 3, stress: -6);
        }
        career = career.copyWith(
          money: career.money - c.cost,
          bond: (career.bond + 3).clamp(0, 100),
        );
        lines.add('差し入れを持って部室を訪ねた。みんな喜んでくれた。');
      case CareerCommand.donation:
        for (final m in members) {
          touch(m.id, skill: 2, mot: 6);
        }
        career = career.copyWith(
          money: career.money - c.cost,
          bond: (career.bond + 6).clamp(0, 100),
        );
        mem.add(
          category: MemoryCategory.life,
          subjectId: Relations.player,
          objectIds: [ctx.club(s).id],
          reasonKey: 'alumni_donation',
          params: {'actor': s.player.fullName},
          importance: 40,
          visibility: MemoryVisibility.public,
        );
        lines.add('新しい楽器と譜面台を寄付した。部室に歓声が上がった。');
      case CareerCommand.work:
        career = career.copyWith(money: career.money + 12000);
        lines.add('仕事に打ち込んだ（+12,000円）。');
    }

    // ── 毎週の効果 ──
    switch (s.mode) {
      case GameMode.teacher:
        final menu = PracticeMenuPreset.values.byName(career.menu);
        final active = ctx.activeMembers(s.copyWith(npcs: npcs));
        for (var i = 0; i < active.length; i++) {
          final m = active[i];
          if (m.instrument == null) continue;
          touch(m.id, skill: menu.skillGain, stress: menu.stressDelta);
          if (menu.cohesion > 0 && i + 1 < active.length) {
            Relations.addMutual(
              relations,
              m.id,
              active[i + 1].id,
              const RelationshipVector(affection: 1),
            );
          }
        }
      case GameMode.alumni:
        career = career.copyWith(
          money: career.money + 3000,
          bond: s.turn % 4 == 0 && c == CareerCommand.work
              ? (career.bond - 1).clamp(0, 100)
              : career.bond,
        );
      case GameMode.instructor:
      case GameMode.student:
        break;
    }

    final out = mem.apply(
      s.copyWith(npcs: npcs, relations: relations, career: career),
    );
    return (state: out, lines: lines);
  }

  /// まとめて進めるときの既定のコマンド。
  CareerCommand autoCommand(GameState s) => switch (s.mode) {
    GameMode.teacher => CareerCommand.watch,
    GameMode.instructor => CareerCommand.masterclass,
    GameMode.alumni =>
      s.career!.money >= 20000 && s.turn.isEven
          ? CareerCommand.snackGift
          : CareerCommand.work,
    GameMode.student => throw StateError('本編では使わない'),
  };
}
