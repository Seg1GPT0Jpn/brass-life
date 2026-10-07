// ignore_for_file: avoid_print

// 開発用: 複数 Seed で 3 年間（中学）を自動プレイし、コンクール・幹部選出の結果を表示する。
import 'package:brass_life/core/rng/seed_code.dart';
import 'package:brass_life/domain/game/engine/game_context.dart';
import 'package:brass_life/domain/game/engine/time_manager.dart';
import 'package:brass_life/domain/game/models/game_enums.dart';
import 'package:brass_life/domain/services/world_generation/world_generator.dart';

void main(List<String> args) {
  final seeds = args.isEmpty ? ['TEST', 'ABC', 'hello', 'brass', 'seed5', 'x9'] : args;
  for (final seed in seeds) {
    final world = const WorldGenerator().generate(SeedCode.seedFromInput(seed));
    final ctx = GameContext(world);
    final tm = TimeManager(ctx);
    var s = tm.newGame(world);
    final sw = Stopwatch()..start();
    s = tm.autoPlayMonths(s, 34, MonthlyPolicy.practiceFocus);
    final club = ctx.club(s);
    print('[$seed] ${ctx.school(s).name} ${club.tier.label} ${club.division.label} 部員${club.memberIds.length} 制度${club.executiveSystem.name}/${club.selectionCulture.label} 顧問指導力${ctx.advisor(s).advisorProfile!.teachingSkill} (${sw.elapsedMilliseconds}ms)');
    print('  過去: ${club.history.map((h) => h.summary).join(' / ')}');
    print('  ゲーム中: ${s.clubHistory.map((h) => h.summary).join(' / ')}');
    for (final a in s.achievements) {
      print('  実績: ${a.label} (${a.weight})');
    }
    print('  役職: ${s.roles.entries.where((e) => e.value != ClubRole.partLeader).map((e) => '${e.value.label}=${e.key}').join(', ')}  player skill=${s.player.skill} retired=${s.player.retired} turn=${s.turn}');
  }
}
