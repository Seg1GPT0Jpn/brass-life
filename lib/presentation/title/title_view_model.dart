import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../core/rng/seed_code.dart';
import '../../core/rng/seed_hasher.dart';
import '../../domain/entities/world_meta.dart';
import '../world/world_controller.dart';

class TitleState {
  const TitleState({this.input = '', this.preview});

  /// 入力中の Seed 文字列。
  final String input;

  /// 入力から求めた Seed のコード表示（空欄なら null）。
  final String? preview;

  TitleState copyWith({String? input, String? preview}) =>
      TitleState(input: input ?? this.input, preview: preview);
}

class TitleViewModel extends Notifier<TitleState> {
  @override
  TitleState build() => const TitleState();

  void setInput(String value) {
    final trimmed = value.trim();
    state = state.copyWith(
      input: value,
      preview: trimmed.isEmpty
          ? null
          : SeedCode.format(SeedCode.seedFromInput(trimmed)),
    );
  }

  /// ランダムな Seed を作る。非決定的な処理はアプリ内でここだけ（UI 層の境界）。
  String randomSeedText() {
    final now = DateTime.now().microsecondsSinceEpoch;
    final seed = SeedHasher.fmix32(
      SeedHasher.derive(now & 0xFFFFFFFF, 'ui/random', [now]),
    );
    final code = SeedCode.format(seed);
    setInput(code);
    return code;
  }

  /// 世界を生成する。空欄ならランダム Seed を使う。
  Future<bool> generate() async {
    final input = state.input.trim().isEmpty ? randomSeedText() : state.input;
    final ok = await ref.read(worldControllerProvider.notifier).generate(input);
    ref.invalidate(recentWorldsProvider);
    return ok;
  }
}

final titleViewModelProvider = NotifierProvider<TitleViewModel, TitleState>(
  TitleViewModel.new,
);

final recentWorldsProvider = FutureProvider<List<WorldMeta>>(
  (ref) => ref.watch(worldMetaRepositoryProvider).recent(),
);
