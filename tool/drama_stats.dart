// ignore_for_file: avoid_print

// 開発用: 2 年間プレイし、Drama Engine の出来事の量と内訳を表示する。
import 'dart:convert';

import 'package:brass_life/core/rng/seed_code.dart';
import 'package:brass_life/domain/game/engine/game_context.dart';
import 'package:brass_life/domain/game/engine/time_manager.dart';
import 'package:brass_life/domain/game/models/game_enums.dart';
import 'package:brass_life/domain/master/memory_templates.dart';
import 'package:brass_life/domain/services/world_generation/world_generator.dart';
import 'package:brass_life/domain/value_objects/instrument.dart';

void main(List<String> args) {
  final world = const WorldGenerator().generate(SeedCode.seedFromInput(args.isEmpty ? 'TEST' : args.first));
  final ctx = GameContext(world);
  final tm = TimeManager(ctx);
  var s = tm.newGame(world);
  s = tm.submitAction(s, WeeklyAction.individualPractice);
  s = tm.resolveInstrumentDecision(s, [InstrumentType.trumpet]).state;
  s = tm.autoPlayMonths(s, 23, MonthlyPolicy.balanced);
  final counts = <String, int>{};
  for (final m in s.memories) {
    counts[m.reasonKey] = (counts[m.reasonKey] ?? 0) + 1;
  }
  print('memories=${s.memories.length} relations=${s.relations.length} quits=${s.npcs.values.where((n) => n.quit).length} json=${jsonEncode(s.toJson()).length ~/ 1024}KB');
  print(counts);
  final mine = s.memories.where((m) => m.subjectId == 'player' || m.objectIds.contains('player')).toList();
  print('player-related=${mine.length}');
  for (final m in mine.reversed.take(8)) {
    print('  ${m.date.label} ${renderMemory(m.reasonKey, m.params)} ${m.delta}');
  }
  for (final l in s.logs.reversed.take(4)) {
    print('${l.dateLabel} ${l.actionLabel}: ${l.lines}');
  }
}
