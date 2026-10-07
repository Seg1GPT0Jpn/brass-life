import '../../core/rng/seed_code.dart';
import '../entities/world.dart';
import '../entities/world_gen_config.dart';
import '../entities/world_meta.dart';
import '../repositories/world_meta_repository.dart';
import '../services/world_fingerprint.dart';
import '../services/world_generation/world_generator.dart';

class GeneratedWorld {
  const GeneratedWorld(this.world, this.meta);
  final World world;
  final WorldMeta meta;
}

/// Seed 入力から世界を生成し、メタ情報を保存する。
class GenerateWorldUseCase {
  const GenerateWorldUseCase(this._generator, this._repository);

  final WorldGenerator _generator;
  final WorldMetaRepository _repository;

  Future<GeneratedWorld> call(
    String input, {
    WorldGenConfig config = const WorldGenConfig(),
  }) async {
    final seed = SeedCode.seedFromInput(input);
    final world = _generator.generate(seed, config: config);
    final meta = WorldMeta(
      input: input.trim(),
      seed: seed,
      seedCode: SeedCode.format(seed),
      generatorVersion: WorldGenerator.generatorVersion,
      fingerprint: WorldFingerprint.compute(world),
    );
    await _repository.save(meta);
    return GeneratedWorld(world, meta);
  }
}

/// 同じ Seed で再生成し、フィンガープリントが一致するかを確認する（決定性の検証）。
class VerifyDeterminismUseCase {
  const VerifyDeterminismUseCase(this._generator);

  final WorldGenerator _generator;

  ({bool matched, String expected, String actual, int elapsedMs}) call(
    World world,
  ) {
    final sw = Stopwatch()..start();
    final again = _generator.generate(world.seed, config: world.config);
    final expected = WorldFingerprint.compute(world);
    final actual = WorldFingerprint.compute(again);
    return (
      matched: expected == actual,
      expected: expected,
      actual: actual,
      elapsedMs: sw.elapsedMilliseconds,
    );
  }
}
