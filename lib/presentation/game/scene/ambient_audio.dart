import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/game/scene/scene_models.dart';

/// 環境音の再生口。
///
/// ジオラマは季節×時間帯から決まる [Ambience] を渡すだけで、
/// 実際に何を鳴らすかはこの実装が決める。音源を同梱したら
/// [ambientAudioProvider] を差し替える（既定は無音）。
abstract interface class AmbientAudio {
  /// [ambience] に切り替える（同じものなら何もしない）。
  void play(Ambience ambience);

  void stop();
}

/// 音源なしの既定実装。直近に要求された環境音だけ覚えておく。
class SilentAmbientAudio implements AmbientAudio {
  Ambience? current;

  @override
  void play(Ambience ambience) => current = ambience;

  @override
  void stop() => current = null;
}

final ambientAudioProvider = Provider<AmbientAudio>(
  (ref) => SilentAmbientAudio(),
);
