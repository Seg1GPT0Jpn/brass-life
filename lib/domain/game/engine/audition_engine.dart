import '../../entities/memory_tag.dart';
import '../../value_objects/instrument.dart';
import '../../value_objects/relationship_vector.dart';
import '../master/approach_cards.dart';
import '../models/game_state.dart';
import 'game_context.dart';
import 'memory_writer.dart';
import 'performance.dart';
import 'relations.dart';
import 'roster_service.dart';

/// 夏のコンクールに向けたオーディション（メンバー選考）とソリストの決定。
///
/// - 出場上限: 大編成 中学 50 / 高校 55、小編成 30。
/// - 部員数が上限以下なら全員出場（オーディションは行われない）。
/// - 評価 = 熟練度 + 表現力×2 + 顧問の評価 + 揺らぎ − あがり症の減点 (+ プレイヤーはカード効果)。
/// - 楽器ごとに編成比の席を割り当て、席のある楽器から評価順に選ぶ。残りの席は全体の上位で埋める。
/// - ソリストは、ソロ楽器のメンバーのうち評価が最も高い人。
class AuditionEngine {
  const AuditionEngine(this.ctx);

  final GameContext ctx;

  /// 今年度オーディションが必要か（プレイヤーを含めた人数が上限を超えるか）。
  bool needed(GameState s) {
    final limit = _limit(s);
    return _candidates(s).length > limit;
  }

  int _limit(GameState s) =>
      Performance.memberLimit(ctx.club(s).division, ctx.school(s).level);

  List<String> _candidates(GameState s) => [
    for (final m in ctx.activeMembers(s))
      if (m.instrument != null) m.id,
    if (s.player.instrument != null && !s.player.retired) Relations.player,
  ];

  ({GameState state, List<String> lines}) run(GameState s, ApproachCard? card) {
    final limit = _limit(s);
    final candidates = _candidates(s);
    final mem = MemoryWriter(ctx, s);
    final lines = <String>[];
    var player = s.player;
    final npcs = Map.of(s.npcs);
    final relations = Map.of(s.relations);

    InstrumentType instOf(String id) =>
        id == Relations.player ? player.instrument! : npcs[id]!.instrument!;

    // 評価
    final scores = <String, int>{};
    for (final id in candidates) {
      final rng = ctx.sim.stream(
        turn: s.turn,
        domain: 'audition',
        actor: id,
        choice: id == Relations.player ? (card?.name ?? '') : '',
      );
      if (id == Relations.player) {
        var sd = 40;
        var bonus = 0;
        if (card != null) {
          final m = Performance(ctx).metrics(s, candidates);
          final e = Performance(ctx).cardEffect(s, card, m, rng);
          bonus = e.bonus * 10;
          sd = e.sd * 10;
          player = player.copyWith(
            fatigue: (player.fatigue + e.fatigueDelta).clamp(0, 100),
          );
          lines.add(e.note);
        }
        final fright =
            player.hasTrait('stage_fright') && card != ApproachCard.calmMind
            ? 40 *
                  player.traits
                      .firstWhere((t) => t.traitId == 'stage_fright')
                      .intensity
            : 0;
        scores[id] =
            player.skill +
            player.musicality ~/ 5 +
            (player.advisorTrust - 50) ~/ 2 +
            bonus -
            fright +
            rng.normalInt(mean: 0, sd: sd, min: -150, max: 150);
      } else {
        final n = ctx.npc(s, id);
        final st = npcs[id]!;
        final frightTag = n.traits.where((t) => t.traitId == 'stage_fright');
        scores[id] =
            st.skill +
            n.aptitude.expression * 2 +
            (st.motivation - 50) ~/ 2 +
            (n.hasTrait('hardworking') ? 10 : 0) -
            (frightTag.isEmpty ? 0 : 40 * frightTag.first.intensity) +
            rng.normalInt(mean: 0, sd: 40, min: -150, max: 150);
      }
    }

    int byScore(String a, String b) {
      final c = scores[b]!.compareTo(scores[a]!);
      return c != 0 ? c : a.compareTo(b);
    }

    // 選考
    final selected = <String>{};
    if (candidates.length <= limit) {
      selected.addAll(candidates);
    } else {
      final types = InstrumentType.values;
      final seats = RosterService.targetSeats(limit);
      for (var i = 0; i < types.length; i++) {
        final players =
            candidates.where((id) => instOf(id) == types[i]).toList()
              ..sort(byScore);
        selected.addAll(players.take(seats[i]));
      }
      final rest = candidates.where((id) => !selected.contains(id)).toList()
        ..sort(byScore);
      for (final id in rest) {
        if (selected.length >= limit) break;
        selected.add(id);
      }
    }

    // ソリスト
    final soloCandidates =
        selected
            .where((id) => Performance.soloInstruments.contains(instOf(id)))
            .toList()
          ..sort(byScore);
    final soloist = soloCandidates.isEmpty ? null : soloCandidates.first;

    final auditioned = candidates.length > limit;
    final club = ctx.club(s);
    // 結果の反映
    for (final id in candidates) {
      final passed = selected.contains(id);
      if (id == Relations.player) {
        player = player.copyWith(
          motivation: (player.motivation + (passed ? 5 : -12)).clamp(0, 100),
        );
        if (auditioned) {
          mem.add(
            category: MemoryCategory.audition,
            subjectId: id,
            objectIds: [club.id],
            reasonKey: passed ? 'audition_passed' : 'audition_failed',
            params: {'actor': player.fullName},
            importance: passed ? 45 : 60,
          );
          lines.add(
            passed
                ? 'オーディションに合格！コンクールメンバーに選ばれた。'
                : 'オーディションに落ちてしまった……。今年は B 組として支える。',
          );
        } else {
          lines.add('部員数が上限（$limit人）以内のため、全員がコンクールに出場する。');
        }
        continue;
      }
      final st = npcs[id]!;
      npcs[id] = st.copyWith(
        motivation: (st.motivation + (passed ? 3 : -6)).clamp(0, 100),
      );
      if (auditioned && !passed) {
        mem.add(
          category: MemoryCategory.audition,
          subjectId: id,
          objectIds: [club.id],
          reasonKey: 'audition_failed',
          params: {'actor': ctx.npc(s, id).fullName},
          importance: 25,
        );
        // 同じ楽器で選ばれた人へのライバル心
        for (final other in selected) {
          if (other != id && instOf(other) == instOf(id)) {
            const d = RelationshipVector(rivalry: 6, affection: -2);
            Relations.add(relations, id, other, d);
          }
        }
      }
    }
    if (soloist != null) {
      final name = soloist == Relations.player
          ? player.fullName
          : ctx.npc(s, soloist).fullName;
      mem.add(
        category: MemoryCategory.audition,
        subjectId: soloist,
        objectIds: [club.id],
        reasonKey: 'solo_chosen',
        params: {'actor': name, 'instrument': instOf(soloist).label},
        importance: soloist == Relations.player ? 55 : 30,
        visibility: MemoryVisibility.public,
      );
      lines.add(
        soloist == Relations.player
            ? 'さらに、自由曲の${instOf(soloist).label}ソロに抜擢された！'
            : '自由曲のソロは$name（${instOf(soloist).label}）に決まった。',
      );
    }
    if (auditioned) {
      final passedCount = selected.length;
      lines.add('${candidates.length}人中 $passedCount人が選ばれた。');
    }

    final next = mem.apply(
      s.copyWith(
        player: player,
        npcs: npcs,
        relations: relations,
        contestMembers: [
          for (final id in candidates)
            if (selected.contains(id)) id,
        ],
        soloistId: soloist,
      ),
    );
    return (state: next, lines: lines);
  }
}
