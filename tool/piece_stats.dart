// 課題曲と部の相性の分布（開発用）。
// ignore_for_file: avoid_print
import 'package:brass_life/core/rng/seed_code.dart';
import 'package:brass_life/domain/game/engine/game_context.dart';
import 'package:brass_life/domain/game/engine/piece_fit.dart';
import 'package:brass_life/domain/game/engine/time_manager.dart';
import 'package:brass_life/domain/game/master/set_pieces.dart';
import 'package:brass_life/domain/game/models/game_enums.dart';
import 'package:brass_life/domain/services/world_generation/world_generator.dart';

void main(List<String> args) {
  final seeds = args.isEmpty ? ['TEST', 'hello', 'A1', 'B2', 'C3'] : args;
  final margins = <String, List<int>>{};
  for (final seed in seeds) {
    final world = const WorldGenerator().generate(SeedCode.seedFromInput(seed));
    final ctx = GameContext(world);
    final tm = TimeManager(ctx);
    var s = tm.newGame(world);
    for (var i = 0; i < 2000 && s.stage != GameStage.finished; i++) {
      if (s.pending?.type == PendingEventType.pieceSelection) {
        final fit = PieceFit(ctx);
        final st = fit.bandStats(s, fit.candidates(s));
        final y = ctx.calendar.dateOf(s.turn).academicYearIndex + 1;
        final ms = [
          for (final p in SetPieces.byYear(y)) PieceFit.margin(p, st),
        ];
        print(
          '$seed y$y ${ctx.club(s).tier.name} '
          '${st.entries.map((e) => '${e.key.name}=${e.value}').join(' ')}',
        );
        print('   margins $ms');
        for (var k = 0; k < 4; k++) {
          (margins['y$y-${k + 1}'] ??= []).add(ms[k]);
        }
      }
      s = s.pending != null
          ? tm.autoResolve(s)
          : tm.submitAction(s, tm.actionForPolicy(s));
    }
  }
  for (final e in margins.entries) {
    final l = e.value;
    print('${e.key} avg ${l.fold(0, (a, b) => a + b) ~/ l.length} $l');
  }
}
