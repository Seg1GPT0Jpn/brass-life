import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers.dart';
import '../../../domain/game/models/piece.dart';
import '../../../domain/repositories/piece_repository.dart';

/// 音を鳴らす部分。テストでは偽物に差し替える。
abstract interface class AudioEngine {
  /// [start] の位置から再生する。
  Future<void> playUrl(String url, {Duration start = Duration.zero});

  /// [assetPath] は pubspec に書いたパス（例: assets/audio/y1_I.mp3）。
  Future<void> playAsset(String assetPath, {Duration start = Duration.zero});

  /// 最後まで鳴ったら頭から繰り返すか。
  Future<void> setLooping(bool loop);
  Future<void> pause();
  Future<void> resume();
  Future<void> stop();
  Future<void> seek(Duration position);
  Stream<Duration> get onPosition;
  Stream<Duration> get onDuration;
  Stream<void> get onComplete;
  Future<void> dispose();
}

/// audioplayers による実装（Web は HTML の audio 要素、各 OS はネイティブで再生）。
/// プレイヤーは最初に鳴らすときに作る。
class AudioplayersEngine implements AudioEngine {
  AudioPlayer? _player;
  final _position = StreamController<Duration>.broadcast();
  final _duration = StreamController<Duration>.broadcast();
  final _complete = StreamController<void>.broadcast();
  final _subs = <StreamSubscription<Object?>>[];

  AudioPlayer get _p {
    final existing = _player;
    if (existing != null) return existing;
    final p = AudioPlayer();
    _subs
      ..add(p.onPositionChanged.listen(_position.add))
      ..add(p.onDurationChanged.listen(_duration.add))
      ..add(p.onPlayerComplete.listen((_) => _complete.add(null)));
    return _player = p;
  }

  @override
  Future<void> playUrl(String url, {Duration start = Duration.zero}) =>
      _p.play(UrlSource(url), position: start == Duration.zero ? null : start);

  @override
  Future<void> playAsset(String assetPath, {Duration start = Duration.zero}) =>
      _p.play(
        // AudioCache は assets/ を前置するので取り除く
        AssetSource(assetPath.replaceFirst(RegExp(r'^assets/'), '')),
        position: start == Duration.zero ? null : start,
      );

  @override
  Future<void> setLooping(bool loop) =>
      _p.setReleaseMode(loop ? ReleaseMode.loop : ReleaseMode.stop);

  @override
  Future<void> pause() async => _player?.pause();

  @override
  Future<void> resume() async => _player?.resume();

  @override
  Future<void> stop() async => _player?.stop();

  @override
  Future<void> seek(Duration position) async => _player?.seek(position);

  @override
  Stream<Duration> get onPosition => _position.stream;

  @override
  Stream<Duration> get onDuration => _duration.stream;

  @override
  Stream<void> get onComplete => _complete.stream;

  @override
  Future<void> dispose() async {
    for (final s in _subs) {
      await s.cancel();
    }
    await _player?.dispose();
    await _position.close();
    await _duration.close();
    await _complete.close();
  }
}

final audioEngineProvider = Provider<AudioEngine>((ref) {
  final engine = AudioplayersEngine();
  ref.onDispose(engine.dispose);
  return engine;
});

enum PlaybackStatus { idle, loading, playing, paused, error }

/// いま鳴っている曲の状態。
class PlaybackState {
  const PlaybackState({
    this.piece,
    this.status = PlaybackStatus.idle,
    this.position = Duration.zero,
    this.duration = Duration.zero,
    this.fromAsset = false,
    this.streamBlocked = false,
  });

  final Piece? piece;
  final PlaybackStatus status;
  final Duration position;
  final Duration duration;

  /// 同梱音源から鳴らしているか（false ならネット配信）。
  final bool fromAsset;

  /// この起動中にネット配信の再生が失敗した（以降は Suno の埋め込みプレーヤーを使う）。
  final bool streamBlocked;

  bool isCurrent(Piece p) => piece?.id == p.id;
  bool get active =>
      status == PlaybackStatus.loading ||
      status == PlaybackStatus.playing ||
      status == PlaybackStatus.paused;

  PlaybackState copyWith({
    PlaybackStatus? status,
    Duration? position,
    Duration? duration,
  }) => PlaybackState(
    piece: piece,
    status: status ?? this.status,
    position: position ?? this.position,
    duration: duration ?? this.duration,
    fromAsset: fromAsset,
    streamBlocked: streamBlocked,
  );
}

/// 課題曲のプレイヤー（アプリ全体で 1 つ。新しい曲を鳴らすと前の曲は止まる）。
class PiecePlayer extends Notifier<PlaybackState> {
  @override
  PlaybackState build() {
    final engine = ref.watch(audioEngineProvider);
    final subs = [
      engine.onPosition.listen((p) => state = state.copyWith(position: p)),
      engine.onDuration.listen((d) => state = state.copyWith(duration: d)),
      engine.onComplete.listen(
        (_) => state = state.copyWith(
          status: PlaybackStatus.paused,
          position: Duration.zero,
        ),
      ),
    ];
    ref.onDispose(() {
      for (final s in subs) {
        s.cancel();
      }
    });
    return const PlaybackState();
  }

  AudioEngine get _engine => ref.read(audioEngineProvider);

  /// [piece] を最初から鳴らす。
  Future<void> play(Piece piece) =>
      playFrom(piece, start: Duration.zero, loop: false);

  /// [piece] を [start] から鳴らす。[loop] なら繰り返す（練習 BGM 用）。
  Future<void> playFrom(
    Piece piece, {
    required Duration start,
    required bool loop,
  }) async {
    final audio = ref.read(pieceRepositoryProvider).audioOf(piece);
    final fromAsset = audio is AssetPieceAudio;
    state = PlaybackState(
      piece: piece,
      status: PlaybackStatus.loading,
      fromAsset: fromAsset,
      streamBlocked: state.streamBlocked,
    );
    try {
      await _engine.stop();
      await _engine.setLooping(loop);
      switch (audio) {
        case AssetPieceAudio(:final assetPath):
          await _engine.playAsset(assetPath, start: start);
        case StreamPieceAudio(:final url):
          await _engine.playUrl(url.toString(), start: start);
      }
      if (state.isCurrent(piece)) {
        state = state.copyWith(status: PlaybackStatus.playing);
      }
    } on Object {
      if (state.isCurrent(piece)) {
        state = PlaybackState(
          piece: piece,
          status: PlaybackStatus.error,
          fromAsset: fromAsset,
          streamBlocked: state.streamBlocked || !fromAsset,
        );
      }
    }
  }

  /// 再生ボタン: 止まっていれば鳴らし、鳴っていれば一時停止する。
  Future<void> toggle(Piece piece) async {
    if (!state.isCurrent(piece) || state.status == PlaybackStatus.error) {
      return play(piece);
    }
    switch (state.status) {
      case PlaybackStatus.playing:
        await _engine.pause();
        state = state.copyWith(status: PlaybackStatus.paused);
      case PlaybackStatus.paused:
        await _engine.resume();
        state = state.copyWith(status: PlaybackStatus.playing);
      case PlaybackStatus.idle:
        return play(piece);
      case PlaybackStatus.loading:
      case PlaybackStatus.error:
        break;
    }
  }

  Future<void> seek(Duration position) async {
    await _engine.seek(position);
    state = state.copyWith(position: position);
  }

  Future<void> stop() async {
    await _engine.stop();
    state = PlaybackState(streamBlocked: state.streamBlocked);
  }
}

final piecePlayerProvider = NotifierProvider<PiecePlayer, PlaybackState>(
  PiecePlayer.new,
);

String formatDuration(Duration d) {
  final m = d.inMinutes;
  final s = d.inSeconds % 60;
  return '$m:${s.toString().padLeft(2, '0')}';
}
