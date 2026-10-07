// ignore_for_file: avoid_print

// 開発用: 方針ごとに 1 年間プレイし、プレイヤーと部員の成長を表示する。
import 'package:brass_life/core/rng/seed_code.dart';
import 'package:brass_life/domain/game/engine/game_context.dart';
import 'package:brass_life/domain/game/engine/time_manager.dart';
import 'package:brass_life/domain/game/models/game_enums.dart';
import 'package:brass_life/domain/services/world_generation/world_generator.dart';
import 'package:brass_life/domain/value_objects/instrument.dart';

void main() {
  final world = const WorldGenerator().generate(SeedCode.seedFromInput('TEST'));
  final ctx = GameContext(world);
  final tm = TimeManager(ctx);
  for (final policy in MonthlyPolicy.values) {
    var s = tm.newGame(world);
    s = tm.submitAction(s, WeeklyAction.individualPractice);
    s = tm.resolveInstrumentDecision(s, [
      InstrumentType.trumpet,
      InstrumentType.horn,
    ]).state;
    final sw = Stopwatch()..start();
    while (ctx.calendar.dateOf(s.turn).academicYearIndex < 2 &&
        s.pending == null) {
      s = tm.skipMonth(s, policy);
    }
    final p = s.player;
    final members = ctx.activeMembers(s).where((m) => m.grade == 2).toList();
    final avg = members.isEmpty
        ? 0
        : members.map((m) => m.skill).reduce((a, b) => a + b) ~/ members.length;
    print(
      '${policy.label}: ${p.instrument?.label} skill=${p.skill} mus=${p.musicality} acad=${p.academic} fat=${p.fatigue} str=${p.stress} mot=${p.motivation} grades=${p.termGrades.map((g) => g.grade).toList()} | 同期(2年)平均=$avg | ${sw.elapsedMilliseconds}ms',
    );
  }
}
