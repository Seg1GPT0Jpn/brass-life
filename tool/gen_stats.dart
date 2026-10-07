// ignore_for_file: avoid_print

// 開発用: 複数 Seed で世界を生成し、統計と所要時間を表示する。
// 実行: dart run tool/gen_stats.dart [seedの数]
import 'package:brass_life/domain/services/world_fingerprint.dart';
import 'package:brass_life/domain/services/world_generation/world_generator.dart';
import 'package:brass_life/domain/value_objects/school_enums.dart';

void main(List<String> args) {
  final n = args.isEmpty ? 20 : int.parse(args.first);
  const gen = WorldGenerator();
  var minNpc = 1000000000, maxNpc = 0, totalMs = 0;
  for (var s = 0; s < n; s++) {
    final sw = Stopwatch()..start();
    final w = gen.generate(s * 7919 + 1);
    totalMs += sw.elapsedMilliseconds;
    final npc = w.npcs.length;
    if (npc < minNpc) minNpc = npc;
    if (npc > maxNpc) maxNpc = npc;
    if (s < 3) {
      print(
        'seed=${w.seedCode} npcs=$npc memories=${w.memories.length} fp=${WorldFingerprint.compute(w)}',
      );
      print(
        '  pref=${w.region.prefectureName} ${w.region.blockName} districts=${w.region.districts.map((d) => '${d.name}${d.towns}').join(' ')}',
      );
      for (final sc in w.schools.take(4)) {
        final c = w.clubs.firstWhere((c) => c.schoolId == sc.id);
        print(
          '  ${sc.name} ${sc.ownership.label} dev=${sc.deviation} acad=${sc.academicLevel} ${sc.cultures.map((e) => e.label)} tier=${c.tier.label} members=${c.memberIds.length} ${c.executiveSystem.name}/${c.selectionCulture.label} ${c.history.map((h) => h.summary).join(',')}',
        );
      }
      final tiers = <ClubTier, int>{};
      for (final c in w.clubs) {
        tiers[c.tier] = (tiers[c.tier] ?? 0) + 1;
      }
      print('  tiers=$tiers');
    }
  }
  print('npc range over $n seeds: $minNpc..$maxNpc, avg gen ${totalMs ~/ n}ms');
}
