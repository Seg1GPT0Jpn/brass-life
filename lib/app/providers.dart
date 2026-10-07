import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/rng/rng_service.dart';
import '../domain/repositories/world_meta_repository.dart';
import '../domain/services/world_generation/world_generator.dart';
import '../domain/usecases/generate_world_usecase.dart';
import '../presentation/world/world_controller.dart';

/// 依存関係の組み立て（DI）。実装の差し替えは main / テストで override する。

final worldMetaRepositoryProvider = Provider<WorldMetaRepository>(
  (ref) => throw UnimplementedError('main で override すること'),
);

final worldGeneratorProvider = Provider<WorldGenerator>(
  (ref) => const WorldGenerator(),
);

final generateWorldUseCaseProvider = Provider<GenerateWorldUseCase>(
  (ref) => GenerateWorldUseCase(
    ref.watch(worldGeneratorProvider),
    ref.watch(worldMetaRepositoryProvider),
  ),
);

final verifyDeterminismUseCaseProvider = Provider<VerifyDeterminismUseCase>(
  (ref) => VerifyDeterminismUseCase(ref.watch(worldGeneratorProvider)),
);

/// 現在の世界の乱数サービス（Phase 2 以降のシミュレーションで使用）。
final rngServiceProvider = Provider<RngService?>(
  (ref) => ref.watch(worldControllerProvider).value?.rng,
);
