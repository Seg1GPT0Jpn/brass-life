// ignore_for_file: avoid_print

// 開発用: 高校入学時に中学の仲間と再会しているかを確認する。
import 'package:brass_life/core/rng/seed_code.dart';
import 'package:brass_life/domain/game/engine/game_context.dart';
import 'package:brass_life/domain/game/engine/time_manager.dart';
import 'package:brass_life/domain/game/models/game_enums.dart';
import 'package:brass_life/domain/services/world_generation/world_generator.dart';

void main() {
  for (final seed in ['TEST', 'ABC', 'hello', 'brass', 'q1', 'q2']) {
    final world = const WorldGenerator().generate(SeedCode.seedFromInput(seed));
    final ctx = GameContext(world);
    final tm = TimeManager(ctx);
    var s = tm.newGame(world);
    while (s.stage == GameStage.middle) {
      s = s.pending != null ? tm.autoResolve(s) : tm.submitAction(s, tm.actionForPolicy(s));
    }
    final middleIds = s.npcDestinations.keys.toSet();
    final reunion = s.roster.where(middleIds.contains).toList();
    print('[$seed] ${ctx.school(s).name} destinations=${middleIds.length} reunion=${reunion.length} ${reunion.map((id) => 'g${s.npcs[id]!.grade}').toList()} memories=${s.memories.where((m) => m.reasonKey == 'reunited').length}');
  }
}
