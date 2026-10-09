import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/hive_career_repository.dart';
import '../domain/repositories/career_repository.dart';
import '../data/repositories/master_piece_repository.dart';
import '../domain/repositories/piece_repository.dart';
import '../core/rng/rng_service.dart';
import '../domain/repositories/game_save_repository.dart';
import '../domain/repositories/world_meta_repository.dart';
import '../domain/services/world_generation/world_generator.dart';
import '../domain/usecases/generate_world_usecase.dart';
import '../presentation/world/world_controller.dart';

/// 依存関係の組み立て（DI）。実装の差し替えは main / テストで override する。

final worldMetaRepositoryProvider = Provider<WorldMetaRepository>(
  (ref) => throw UnimplementedError('main で override すること'),
);

final gameSaveRepositoryProvider = Provider<GameSaveRepository>(
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
/// 周回をまたぐ記録（main で Hive 実装に差し替える）。
final careerRepositoryProvider = Provider<CareerRepository>(
  (ref) => InMemoryCareerRepository(),
);

/// 課題曲のマスターデータ（同梱音源の一覧は起動後に非同期で読み込む）。
final pieceRepositoryProvider = Provider<PieceRepository>((ref) {
  final repo = MasterPieceRepository();
  repo.loadBundledAudio();
  return repo;
});

final rngServiceProvider = Provider<RngService?>(
  (ref) => ref.watch(worldControllerProvider).value?.rng,
);
