// ignore_for_file: avoid_print

// 開発用: 同じ Seed で方針だけを変えて 6 年間を自動プレイし、人生の違いを比べる。
import 'package:brass_life/core/rng/seed_code.dart';
import 'package:brass_life/domain/game/engine/ending_analyzer.dart';
import 'package:brass_life/domain/game/engine/game_context.dart';
import 'package:brass_life/domain/game/engine/time_manager.dart';
import 'package:brass_life/domain/game/models/game_enums.dart';
import 'package:brass_life/domain/services/world_generation/world_generator.dart';

void main(List<String> args) {
  final seed = args.isEmpty ? 'TEST' : args.first;
  final world = const WorldGenerator().generate(SeedCode.seedFromInput(seed));
  final ctx = GameContext(world);
  final tm = TimeManager(ctx);
  for (final policy in MonthlyPolicy.values) {
    var s = tm.newGame(world).copyWith(policy: policy);
    for (var i = 0; i < 2000 && s.stage != GameStage.finished; i++) {
      s = s.pending != null ? tm.autoResolve(s) : tm.submitAction(s, tm.actionForPolicy(s));
    }
    while (s.pending != null) {
      s = tm.autoResolve(s);
    }
    final e = EndingAnalyzer(ctx).analyze(s);
    final high = ctx.index.schoolById[s.schoolHistory.last]!.name;
    final best = e.stats.firstWhere((x) => x.$1 == '最高成績').$2;
    final uni = e.stats.firstWhere((x) => x.$1 == '進路').$2;
    print('【${policy.label}】高校=$high 熟練度=${s.player.skill} 学力=${s.player.academic} 最高成績=$best 進路=$uni 称号=「${e.title}」');
  }
}
