// 立候補の結果の分布（開発用）。
// ignore_for_file: avoid_print
import 'package:brass_life/core/rng/seed_code.dart';
import 'package:brass_life/domain/game/engine/executive_engine.dart';
import 'package:brass_life/domain/game/engine/game_context.dart';
import 'package:brass_life/domain/game/engine/time_manager.dart';
import 'package:brass_life/domain/game/models/candidacy.dart';
import 'package:brass_life/domain/game/models/game_enums.dart';
import 'package:brass_life/domain/services/world_generation/world_generator.dart';

void main(List<String> args) {
  final seeds = args.isEmpty ? ['TEST', 'hello', 'A1', 'B2', 'C3', 'D4'] : args;
  final wins = <String, int>{};
  final tries = <String, int>{};
  for (final seed in seeds) {
    final world = const WorldGenerator().generate(SeedCode.seedFromInput(seed));
    final ctx = GameContext(world);
    final tm = TimeManager(ctx);
    var s = tm.newGame(world);
    while (!(s.pending?.type == PendingEventType.executiveSelection &&
        s.player.grade == 2)) {
      if (s.stage != GameStage.middle) break;
      s = s.pending != null
          ? tm.autoResolve(s)
          : tm.submitAction(s, tm.actionForPolicy(s));
    }
    if (s.pending?.type != PendingEventType.executiveSelection) continue;
    final roles = ExecutiveEngine(ctx).runnableRoles(s);
    final sy = [
      for (final m in ctx.activeMembers(s))
        if (m.grade == 2) m,
    ];
    final npcMus = [
      for (final m in sy)
        ctx.npc(s, m.id).aptitude.expression * 5 + m.skill ~/ 2,
    ]..sort();
    print(
      '  player mus=${s.player.musicality} skill=${s.player.skill} expr=${s.player.aptitude.expression} -> ${s.player.musicality ~/ 2 + s.player.skill ~/ 2}; npc top=${npcMus.reversed.take(3).toList()}',
    );
    final line = StringBuffer(
      '$seed ${ctx.club(s).executiveSystem.name} '
      '${ctx.club(s).selectionCulture.name} ${s.player.instrument?.label}: ',
    );
    for (final r in roles) {
      line.write('${r.label}[');
      for (var d = 1; d <= 5; d++) {
        final out = tm.resolveExecutive(s, Candidacy.run(r, d)).state;
        final ok = out.roles['player'] == r;
        line.write(ok ? 'o' : 'x');
        final k = '${r.name}:$d';
        tries[k] = (tries[k] ?? 0) + 1;
        if (ok) wins[k] = (wins[k] ?? 0) + 1;
      }
      line.write('] ');
    }
    print(line);
  }
  for (final k in tries.keys) {
    print('$k ${wins[k] ?? 0}/${tries[k]}');
  }
}
