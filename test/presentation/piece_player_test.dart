import 'package:brass_life/app/providers.dart';
import 'package:brass_life/data/repositories/master_piece_repository.dart';
import 'package:brass_life/domain/game/master/set_pieces.dart';
import 'package:brass_life/domain/repositories/piece_repository.dart';
import 'package:brass_life/presentation/game/pieces/piece_player.dart';
import 'package:brass_life/presentation/game/pieces/piece_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/fake_audio_engine.dart';

void main() {
  final piece = SetPieces.byYear(1).first;

  group('リポジトリ', () {
    test('同梱音源がなければネット配信、あれば同梱音源を返す', () {
      final web = MasterPieceRepository();
      expect(
        web.audioOf(piece),
        isA<StreamPieceAudio>().having(
          (a) => a.url.toString(),
          'url',
          'https://cdn1.suno.ai/${piece.id}.mp3',
        ),
      );
      expect(web.pageOf(piece).toString(), piece.url);
      final local = MasterPieceRepository(
        bundledAssets: {'assets/audio/y1_I.wav'},
      );
      expect(
        local.audioOf(piece),
        isA<AssetPieceAudio>().having(
          (a) => a.assetPath,
          'path',
          'assets/audio/y1_I.wav',
        ),
      );
    });
  });

  group('プレイヤー', () {
    late FakeAudioEngine engine;
    late ProviderContainer c;

    setUp(() {
      engine = FakeAudioEngine();
      c = ProviderContainer(
        overrides: [
          audioEngineProvider.overrideWithValue(engine),
          pieceRepositoryProvider.overrideWithValue(MasterPieceRepository()),
        ],
      );
      addTearDown(c.dispose);
    });

    test('再生 → 一時停止 → 再開 → 停止', () async {
      final p = c.read(piecePlayerProvider.notifier);
      await p.toggle(piece);
      expect(engine.calls.last, 'url:${piece.streamUrl}');
      expect(c.read(piecePlayerProvider).status, PlaybackStatus.playing);
      await p.toggle(piece);
      expect(c.read(piecePlayerProvider).status, PlaybackStatus.paused);
      await p.toggle(piece);
      expect(engine.calls.last, 'resume');
      await p.stop();
      expect(c.read(piecePlayerProvider).piece, isNull);
    });

    test('練習 BGM 用: 指定秒数から、繰り返しで再生できる', () async {
      await c
          .read(piecePlayerProvider.notifier)
          .playFrom(piece, start: const Duration(seconds: 30), loop: true);
      expect(
        engine.calls,
        containsAllInOrder(['loop:true', 'url:${piece.streamUrl}@30']),
      );
      await c.read(piecePlayerProvider.notifier).play(piece);
      expect(engine.calls, contains('loop:false'));
    });

    test('別の曲を鳴らすと前の曲は止まる', () async {
      final p = c.read(piecePlayerProvider.notifier);
      final other = SetPieces.byYear(2).first;
      await p.play(piece);
      await p.play(other);
      expect(engine.calls, contains('stop'));
      expect(c.read(piecePlayerProvider).piece, same(other));
    });

    test('ネット配信に失敗するとエラーになり、以降は埋め込みプレーヤーを使う印が残る', () async {
      engine.fail = true;
      final p = c.read(piecePlayerProvider.notifier);
      expect(c.read(piecePlayerProvider).streamBlocked, isFalse);
      await p.play(piece);
      expect(c.read(piecePlayerProvider).status, PlaybackStatus.error);
      expect(c.read(piecePlayerProvider).streamBlocked, isTrue);
      await p.stop();
      expect(c.read(piecePlayerProvider).streamBlocked, isTrue);
      expect(piece.embedUrl, 'https://suno.com/embed/${piece.id}');
    });

    test('再生位置と長さ、最後まで鳴ったら頭に戻る', () async {
      await c.read(piecePlayerProvider.notifier).play(piece);
      engine.duration.add(const Duration(minutes: 3));
      engine.position.add(const Duration(seconds: 42));
      await Future<void>.delayed(Duration.zero);
      final st = c.read(piecePlayerProvider);
      expect(st.duration, const Duration(minutes: 3));
      expect(st.position, const Duration(seconds: 42));
      engine.complete.add(null);
      await Future<void>.delayed(Duration.zero);
      expect(c.read(piecePlayerProvider).status, PlaybackStatus.paused);
      expect(c.read(piecePlayerProvider).position, Duration.zero);
    });
  });

  testWidgets('曲カードの再生ボタンでアプリ内再生し、ミニプレイヤーが出る', (tester) async {
    final engine = FakeAudioEngine();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          audioEngineProvider.overrideWithValue(engine),
          pieceRepositoryProvider.overrideWithValue(MasterPieceRepository()),
        ],
        child: MaterialApp(
          home: Scaffold(
            body: ListView(children: [PieceCard(piece: piece)]),
            bottomNavigationBar: const NowPlayingBar(),
          ),
        ),
      ),
    );
    expect(find.text('アプリ内で聴く'), findsOneWidget);
    expect(find.byIcon(Icons.stop), findsNothing);

    await tester.tap(find.byTooltip('この曲を聴く'));
    await tester.pumpAndSettle();
    expect(engine.calls, contains('url:${piece.streamUrl}'));
    // ミニプレイヤー
    expect(find.textContaining('「${piece.title}」'), findsOneWidget);
    expect(find.byIcon(Icons.stop), findsOneWidget);

    engine.duration.add(const Duration(minutes: 3));
    engine.position.add(const Duration(seconds: 5));
    await tester.pumpAndSettle();
    expect(find.byType(Slider), findsOneWidget);
    expect(find.text('0:05 / 3:00'), findsWidgets);

    await tester.tap(find.byIcon(Icons.stop));
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.stop), findsNothing);

    engine.fail = true;
    await tester.tap(find.byTooltip('この曲を聴く'));
    await tester.pumpAndSettle();
    expect(find.textContaining('再生できませんでした'), findsOneWidget);
  });
}
