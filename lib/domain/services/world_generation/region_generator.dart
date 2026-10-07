import '../../../core/rng/world_seed_rng.dart';
import '../../entities/region.dart';
import '../../entities/world_gen_config.dart';
import '../../master/name_pools.dart';
import 'name_generator.dart';

/// 架空の県・地区・市町の生成。ストリーム: `world/region`。
class RegionGenerator {
  RegionGenerator(this._rng, this._names);

  final WorldSeedRng _rng;
  final NameGenerator _names;

  Region generate(WorldGenConfig config) {
    final rng = _rng.stream('world/region');
    final pref = _names.prefectureName(rng);
    final block = _names.blockName(rng, pref);

    final directionCount = config.districtCount.clamp(
      1,
      districtDirections.length,
    );
    // 方角語の抽出結果を元リストの順序に並べ直し、表示を安定させる。
    final picked = rng.sample(districtDirections, directionCount);
    final directions = [
      for (final d in districtDirections)
        if (picked.contains(d)) d,
    ];

    final totalSchools = config.middleSchoolCount + config.highSchoolCount;
    final perDistrict = (totalSchools / directionCount).ceil();
    final districts = <District>[];
    for (var i = 0; i < directions.length; i++) {
      // 地区あたりの市町数: 学校数の 1/3 程度 ± 1。
      final townCount = (perDistrict ~/ 3 + rng.range(-1, 1)).clamp(2, 8);
      final towns = [for (var t = 0; t < townCount; t++) _names.placeName(rng)];
      districts.add(
        District(id: 'dst_$i', name: '${directions[i]}地区', towns: towns),
      );
    }

    return Region(
      prefectureName: '$pref県',
      federationName: '$pref県管楽合奏連盟',
      contestName: '管楽合奏コンクール',
      blockName: '$block支部',
      districts: districts,
    );
  }
}
