import 'dart:async';

import 'package:brass_life/presentation/game/pieces/piece_player.dart';

/// 再生の記録だけをとる偽のエンジン。
class FakeAudioEngine implements AudioEngine {
  final calls = <String>[];
  bool fail = false;
  final position = StreamController<Duration>.broadcast();
  final duration = StreamController<Duration>.broadcast();
  final complete = StreamController<void>.broadcast();

  @override
  Future<void> playUrl(String url, {Duration start = Duration.zero}) async {
    calls.add(
      start == Duration.zero ? 'url:$url' : 'url:$url@${start.inSeconds}',
    );
    if (fail) throw Exception('network');
  }

  @override
  Future<void> playAsset(
    String assetPath, {
    Duration start = Duration.zero,
  }) async => calls.add('asset:$assetPath');

  @override
  Future<void> setLooping(bool loop) async => calls.add('loop:$loop');

  @override
  Future<void> pause() async => calls.add('pause');

  @override
  Future<void> resume() async => calls.add('resume');

  @override
  Future<void> stop() async => calls.add('stop');

  @override
  Future<void> seek(Duration p) async => calls.add('seek:${p.inSeconds}');

  @override
  Stream<Duration> get onPosition => position.stream;

  @override
  Stream<Duration> get onDuration => duration.stream;

  @override
  Stream<void> get onComplete => complete.stream;

  @override
  Future<void> dispose() async {}
}
