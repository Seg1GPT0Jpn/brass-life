import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import 'world_session.dart';

/// 現在の世界を保持する唯一の場所。null は「未生成」。
class WorldController extends AsyncNotifier<WorldSession?> {
  @override
  WorldSession? build() => null;

  /// Seed 入力から世界を生成する。生成中は [AsyncLoading]。
  Future<bool> generate(String input) async {
    state = const AsyncLoading();
    // ローディング表示を 1 フレーム描画させてから同期処理の生成を行う（Web はシングルスレッド）。
    await Future<void>.delayed(const Duration(milliseconds: 32));
    state = await AsyncValue.guard(() async {
      final result = await ref.read(generateWorldUseCaseProvider)(input);
      return WorldSession(world: result.world, meta: result.meta);
    });
    return state.hasValue && state.value != null;
  }

  void unload() => state = const AsyncData(null);
}

final worldControllerProvider =
    AsyncNotifierProvider<WorldController, WorldSession?>(WorldController.new);

/// 生成済みの世界（未生成時に参照すると例外）。デバッグ画面専用。
final sessionProvider = Provider<WorldSession>((ref) {
  final session = ref.watch(worldControllerProvider).value;
  if (session == null) throw StateError('World is not generated');
  return session;
});
