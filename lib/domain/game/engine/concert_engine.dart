import '../../entities/memory_tag.dart';
import '../master/approach_cards.dart';
import '../models/game_state.dart';
import 'game_context.dart';
import 'memory_writer.dart';
import 'performance.dart';
import 'relations.dart';

/// 3 月の定期演奏会。順位はなく、出来栄え（大成功〜課題が残った）が
/// 部員のやる気と記憶に影響する。
class ConcertEngine {
  const ConcertEngine(this.ctx);

  final GameContext ctx;

  List<String> performers(GameState s) => [
    for (final m in ctx.activeMembers(s))
      if (m.instrument != null) m.id,
    if (s.player.instrument != null && s.player.inClub) Relations.player,
  ];

  ({GameState state, List<String> lines}) run(GameState s, ApproachCard? card) {
    final perf = Performance(ctx);
    final members = performers(s);
    final m = perf.metrics(s, members);
    final school = ctx.school(s);
    final club = ctx.club(s);
    final rng = ctx.sim.stream(
      turn: s.turn,
      domain: 'concert',
      actor: s.schoolId,
      choice: card?.name ?? '',
    );
    final lines = <String>[];
    var player = s.player;
    final expected =
        ctx.expectedContestSkill[(school.level, club.tier)] ?? m.avgSkill;
    var v =
        (m.avgSkill - expected) ~/ 15 +
        (m.cohesion ~/ 4).clamp(-5, 7) +
        (m.avgMotivation - 60) ~/ 8;
    var sd = 4;
    final playerIn = members.contains(Relations.player);
    if (playerIn && card != null) {
      final e = perf.cardEffect(s, card, m, rng);
      v += e.bonus;
      sd = e.sd;
      player = player.copyWith(
        fatigue: (player.fatigue + e.fatigueDelta).clamp(0, 100),
      );
      lines.add('「${card.label}」で臨んだ。${e.note}');
    }
    v += rng.normalInt(mean: 0, sd: sd, min: -15, max: 15);
    final (rating, motivation, importance) = v >= 6
        ? ('大成功', 6, 40)
        : v >= 1
        ? ('成功', 3, 25)
        : v >= -4
        ? ('まずまず', 0, 15)
        : ('課題が残った', -3, 25);
    lines.add('定期演奏会は「$rating」だった。');

    final npcs = Map.of(s.npcs);
    for (final st in ctx.activeMembers(s)) {
      npcs[st.id] = st.copyWith(
        motivation: (st.motivation + motivation).clamp(0, 100),
      );
    }
    player = player.copyWith(
      motivation: (player.motivation + motivation).clamp(0, 100),
    );
    final mem = MemoryWriter(ctx, s);
    mem.add(
      category: MemoryCategory.life,
      subjectId: Relations.player,
      objectIds: [club.id],
      reasonKey: playerIn ? 'concert_result' : 'concert_watched',
      params: {'school': school.name, 'rating': rating},
      importance: importance,
    );
    final fy = ctx.calendar.dateOf(s.turn).fiscalYear;
    var achievements = s.achievements;
    if (playerIn && rating == '大成功') {
      achievements = [
        ...achievements,
        Achievement(
          fiscalYear: fy,
          schoolId: s.schoolId,
          kind: 'concert',
          label: '${ctx.calendar.dateOf(s.turn).stageLabel} 定期演奏会 大成功',
          weight: 15,
        ),
      ];
    }
    return (
      state: mem.apply(
        s.copyWith(
          player: player,
          npcs: npcs,
          achievements: achievements,
          lastConcertYear: fy,
        ),
      ),
      lines: lines,
    );
  }
}
