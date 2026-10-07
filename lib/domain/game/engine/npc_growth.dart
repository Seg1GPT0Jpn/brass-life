import '../models/game_state.dart';
import 'game_context.dart';

/// NPC の週ごとの基礎的な上達（部活に通常参加した分）。
///
/// 乱数: SimulationRng(turn, 'npc_growth', actor: NPC ID)。NPC ごとに独立。
/// Phase 3 の Drama Engine は、この上に性格に基づく自律行動を重ねる。
class NpcGrowth {
  const NpcGrowth(this.ctx);

  final GameContext ctx;

  GameState apply(GameState s) {
    final club = ctx.club(s);
    final teaching = ctx.advisor(s).advisorProfile!.teachingSkill;
    final npcs = Map.of(s.npcs);
    for (final m in ctx.activeMembers(s)) {
      if (m.instrument == null) continue;
      final n = ctx.npc(s, m.id);
      final rng = ctx.sim.stream(
        turn: s.turn,
        domain: 'npc_growth',
        actor: m.id,
      );
      final fit =
          n.aptitude.fitFor(m.instrument!) + (n.hasTrait('genius') ? 15 : 0);
      var pct = 100;
      if (n.hasTrait('hardworking')) pct += 30;
      if (n.hasTrait('lazy')) pct -= 40;
      if (n.hasTrait('late_bloomer')) pct += (m.grade - 2) * 25;
      pct = pct * (50 + m.motivation) ~/ 100;
      // 年あたり（約 45 週）の伸び ≒ (30 + 強度×12 + 指導力×0.6) × (適性+50)/100
      final perYear =
          (30 + club.practiceIntensity * 12 + teaching * 6 ~/ 10) *
          (fit + 50) ~/
          100;
      var gain = perYear * pct * rng.range(70, 130) ~/ (45 * 100 * 100);
      gain = gain * (1200 - m.skill) ~/ 1200;
      npcs[m.id] = m.copyWith(skill: (m.skill + gain).clamp(0, 1000));
    }
    return s.copyWith(npcs: npcs);
  }
}
