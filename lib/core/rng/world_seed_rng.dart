import 'rng_stream.dart';
import 'seed_hasher.dart';

/// 世界生成専用の乱数工場。
///
/// ストリームは「パス」で識別され、パスごとに独立した Seed から生成される。
/// これにより、ある学校の生成で乱数を余分に消費しても他の学校の結果は変わらない
/// （変更の局所性）。また後から必要になる NPC も同じパスで遅延生成できる。
///
/// パス例:
/// - `world/region`
/// - `world/school/7`
/// - `world/school/sch_07/club`
/// - `world/school/sch_07/member/2/13`
class WorldSeedRng {
  const WorldSeedRng(this.worldSeed);

  final int worldSeed;

  static const String _domain = 'world';

  /// パスに対応するストリームを払い出す。同じパスは常に同じ数列を返す。
  RngStream stream(String path, [List<int> ints = const []]) =>
      RngStream(SeedHasher.derive(_rootSeed, path, ints));

  int get _rootSeed => SeedHasher.derive(worldSeed, _domain);
}
