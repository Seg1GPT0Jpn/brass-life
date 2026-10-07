import '../../../core/rng/world_seed_rng.dart';
import '../../master/name_pools.dart';
import 'entrance_exam_engine.dart';

/// 架空の大学の一覧。World Seed から決定論的に生成する（世界の設計図には含めず、
/// 生成器バージョンやフィンガープリントに影響しない）。ストリーム: `world/universities`。
///
/// - 国公立 5 校・私立 7 校（偏差値は 40〜72 を層化抽選）
/// - 音楽大学 2 校（実技試験。熟練度と音楽性で判定）
abstract final class UniversityCatalog {
  static List<ExamTarget> generate(int worldSeed, String prefectureName) {
    final rng = WorldSeedRng(worldSeed).stream('world/universities');
    final pref = prefectureName.replaceAll('県', '');
    final used = <String>{};
    String motto() {
      for (var i = 0; i < 100; i++) {
        final m = rng.pick(privatePrefixes) + rng.pick(privateSuffixes);
        if (!realNameBlocklist.contains(m) && used.add(m)) return m;
      }
      return '${rng.pick(privatePrefixes)}${used.length}';
    }

    // 偏差値帯（40〜72）を 12 校に層化して割り当てる
    final devs = rng.shuffled([
      for (var i = 0; i < 12; i++) 40 + i * 32 ~/ 12 + rng.range(0, 2),
    ]);
    final list = <ExamTarget>[];
    final publicNames = [
      '$pref大学',
      '$pref県立大学',
      '$pref教育大学',
      '${motto()}工科大学',
      '$pref医療大学',
    ];
    for (var i = 0; i < 5; i++) {
      list.add(
        ExamTarget(
          id: 'uni_p$i',
          name: publicNames[i],
          deviation: devs[i],
          isPrivate: false,
          note: '国公立',
        ),
      );
    }
    for (var i = 0; i < 7; i++) {
      list.add(
        ExamTarget(
          id: 'uni_s$i',
          name: '${motto()}${rng.pick(['大学', '学院大学', '女子大学', '大学'])}',
          deviation: devs[5 + i],
          isPrivate: true,
          note: '私立',
        ),
      );
    }
    list.add(
      ExamTarget(
        id: 'uni_m0',
        name: '${motto()}音楽大学',
        deviation: 62 + rng.range(0, 6),
        isPrivate: true,
        isMusic: true,
        note: '音楽大学（実技試験）',
      ),
    );
    list.add(
      ExamTarget(
        id: 'uni_m1',
        name: '$pref芸術大学 音楽学部',
        deviation: 66 + rng.range(0, 6),
        isPrivate: false,
        isMusic: true,
        note: '国公立の芸術大学（実技試験）',
      ),
    );
    list.sort((a, b) {
      final c = b.deviation.compareTo(a.deviation);
      return c != 0 ? c : a.id.compareTo(b.id);
    });
    return list;
  }
}
