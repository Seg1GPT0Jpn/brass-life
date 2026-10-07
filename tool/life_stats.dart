// ignore_for_file: avoid_print

// 開発用: 複数 Seed で中学〜高校を自動プレイし、受験・進学の結果を表示する。
import 'package:brass_life/core/rng/seed_code.dart';
import 'package:brass_life/domain/game/engine/game_context.dart';
import 'package:brass_life/domain/game/engine/time_manager.dart';
import 'package:brass_life/domain/game/models/game_enums.dart';
import 'package:brass_life/domain/master/memory_templates.dart';
import 'package:brass_life/domain/services/world_generation/world_generator.dart';

void main(List<String> args) {
  final seeds = args.isEmpty ? ['TEST', 'ABC', 'hello', 'brass'] : args;
  for (final seed in seeds) {
    final world = const WorldGenerator().generate(SeedCode.seedFromInput(seed));
    final ctx = GameContext(world);
    final tm = TimeManager(ctx);
    var s = tm.newGame(world);
    final sw = Stopwatch()..start();
    for (final policy in [MonthlyPolicy.studyFocus, MonthlyPolicy.balanced]) {
      s = tm.autoPlayMonths(s, 36, policy);
    }
    print('[$seed] stage=${s.stage.label} turn=${s.turn} ${sw.elapsedMilliseconds}ms schools=${s.schoolHistory.map((id) => ctx.index.schoolById[id]!.name)} now=${ctx.school(s).name}');
    print('  academic=${s.player.academic} skill=${s.player.skill} inst=${s.player.instrument?.label} prev=${s.player.previousInstrument?.label}');
    for (final l in s.logs.where((l) => l.actionLabel == null || !WeeklyAction.values.any((a) => a.label == l.actionLabel))) {
      if (l.lines.any((x) => x.contains('合格') || x.contains('入学') || x.contains('進学') || x.contains('出願') || x.contains('推薦') || x.contains('仲間'))) {
        print('  ${l.dateLabel} ${l.actionLabel ?? ''}: ${l.lines.join(' / ')}');
      }
    }
    for (final m in s.memories.where((m) => {'exam_passed', 'exam_failed', 'recommended', 'entered_high', 'reunited', 'graduated_middle'}.contains(m.reasonKey))) {
      print('  記憶: ${m.date.label} ${renderMemory(m.reasonKey, m.params)}');
    }
    for (final a in s.achievements) {
      print('  実績: ${a.label}');
    }
  }
}
