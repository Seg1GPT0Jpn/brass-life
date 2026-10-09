import 'package:brass_life/app/app.dart';
import 'package:brass_life/app/providers.dart';
import 'package:brass_life/app/router.dart';
import 'package:brass_life/data/repositories/hive_game_save_repository.dart';
import 'package:brass_life/data/repositories/hive_world_meta_repository.dart';
import 'package:brass_life/data/repositories/master_piece_repository.dart';
import 'package:brass_life/domain/career/game_mode.dart';
import 'package:brass_life/domain/career/mode_states.dart';
import 'package:brass_life/domain/game/engine/time_manager.dart';
import 'package:brass_life/domain/game/models/game_enums.dart';
import 'package:brass_life/domain/value_objects/instrument.dart';
import 'package:brass_life/presentation/game/conducting/conducting_page.dart';
import 'package:brass_life/presentation/game/game_controller.dart';
import 'package:brass_life/presentation/game/pieces/piece_player.dart';
import 'package:brass_life/presentation/game/scene/performance_stage.dart';
import 'package:brass_life/presentation/world/world_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/fake_audio_engine.dart';

/// 画面内のリストをすべて先頭まで戻す（イベントのパネルは先頭にある）。
Future<void> scrollToTop(WidgetTester tester) async {
  for (final e in find.byType(Scrollable).evaluate()) {
    final st = (e as StatefulElement).state as ScrollableState;
    if (st.position.pixels != 0) st.position.jumpTo(0);
  }
  await tester.pumpAndSettle();
}

void main() {
  late FakeAudioEngine engine;

  Future<ProviderContainer> pumpApp(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1280, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    engine = FakeAudioEngine();
    final container = ProviderContainer(
      overrides: [
        worldMetaRepositoryProvider.overrideWithValue(
          InMemoryWorldMetaRepository(),
        ),
        gameSaveRepositoryProvider.overrideWithValue(
          InMemoryGameSaveRepository(),
        ),
        audioEngineProvider.overrideWithValue(engine),
        pieceRepositoryProvider.overrideWithValue(MasterPieceRepository()),
      ],
    );
    addTearDown(container.dispose);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const BrassLifeApp(),
      ),
    );
    await tester.pumpAndSettle();
    await tester.runAsync(() async {
      await container.read(worldControllerProvider.notifier).generate('TEST');
    });
    await tester.pumpAndSettle();
    return container;
  }

  /// 指揮者ミニゲームで全フレーズを決めて、結果へ進む。
  Future<void> conduct(WidgetTester tester) async {
    expect(find.byType(ConductingPage), findsOneWidget);
    await tester.tap(find.text('タクトを構える（演奏開始）'));
    await tester.pump();
    for (var i = 0; i < 5; i++) {
      // 1 フレーズ目は思い切ってフォルテに
      if (i == 0) {
        await tester.drag(
          find.byKey(const ValueKey('dynamics')),
          const Offset(400, 0),
        );
        await tester.pump();
      }
      final next = find.textContaining(i < 4 ? '次のフレーズへ' : '締めくくる');
      await tester.ensureVisible(next);
      await tester.pump();
      await tester.tap(next);
      await tester.pump();
    }
    expect(find.text('演奏プラン'), findsOneWidget);
    final finish = find.text('本番の結果へ');
    await tester.ensureVisible(finish);
    await tester.pump();
    await tester.tap(finish);
    await tester.pumpAndSettle();
  }

  testWidgets('本編: コンクール本番で指揮者ミニゲームを遊んでから結果を見る', (tester) async {
    final container = await pumpApp(tester);
    final vm = container.read(gameControllerProvider.notifier);
    vm.newGame();
    vm.submit(WeeklyAction.individualPractice);
    vm.resolveInstrument([InstrumentType.trumpet]);
    final ctx = container.read(gameContextProvider)!;
    final tm = TimeManager(ctx);
    // コンクール本番（プレイヤーが出場メンバー）まで進める
    for (var i = 0; i < 80; i++) {
      final s = container.read(gameControllerProvider)!;
      if (s.pending?.type == PendingEventType.contest) break;
      if (s.pending?.type == PendingEventType.audition) {
        // 合格しやすいよう熟練度を上げてから臨む
        container
            .read(gameControllerProvider.notifier)
            .debugReplace(s.copyWith(player: s.player.copyWith(skill: 900)));
        vm.resolveAudition(tm.cardsOf(s).first);
        continue;
      }
      if (s.pending != null) {
        container
            .read(gameControllerProvider.notifier)
            .debugReplace(tm.autoResolve(s));
        continue;
      }
      vm.submit(WeeklyAction.partPractice);
    }
    final s = container.read(gameControllerProvider)!;
    expect(s.pending?.type, PendingEventType.contest);
    container.read(routerProvider).go('/game');
    await tester.pumpAndSettle();
    await tester.tap(find.byType(ListTile).first);
    await tester.pump();
    final go = find.text('このカードで臨む');
    await tester.ensureVisible(go);
    await tester.pumpAndSettle();
    await tester.tap(go);
    await tester.pumpAndSettle();
    await conduct(tester);
    expect(find.byType(PerformanceStage), findsOneWidget);
    expect(find.textContaining('指揮の出来'), findsWidgets);
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    final after = container.read(gameControllerProvider)!;
    expect(
      after.choices.any((c) => c.contains('contest:') && c.contains('-')),
      isTrue,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('練習 BGM: パート練習で今年の課題曲を区間ループで流し、オフにできる', (tester) async {
    final container = await pumpApp(tester);
    final vm = container.read(gameControllerProvider.notifier);
    vm.newGame();
    vm.submit(WeeklyAction.individualPractice);
    vm.resolveInstrument([InstrumentType.trumpet]);
    final tm = TimeManager(container.read(gameContextProvider)!);
    while (container.read(gameControllerProvider)!.setPieces.isEmpty) {
      final s = container.read(gameControllerProvider)!;
      if (s.pending != null) {
        vm.debugReplace(tm.autoResolve(s));
      } else {
        vm.submit(WeeklyAction.basics);
      }
    }
    container.read(routerProvider).go('/game');
    await tester.pumpAndSettle();
    final room = find.byKey(const ValueKey('loc-brassRoom'));
    await tester.tapAt(tester.getTopLeft(room) + const Offset(6, 6));
    await tester.pumpAndSettle();
    await tester.tap(find.text('パート練習'));
    await tester.pumpAndSettle();
    expect(engine.calls, contains('loop:true'));
    expect(container.read(piecePlayerProvider).isBgm, isTrue);
    // オフにすると止まる
    await tester.tap(find.text('練習BGM オン'));
    await tester.pumpAndSettle();
    expect(find.text('練習BGM オフ'), findsOneWidget);
    expect(container.read(piecePlayerProvider).active, isFalse);
    expect(tester.takeException(), isNull);
  });

  testWidgets('顧問モード: タイトルから始め、行動・選曲・オーディション・指揮をこなす', (tester) async {
    final container = await pumpApp(tester);
    container.read(routerProvider).go('/');
    await tester.pumpAndSettle();
    // お試しで顧問モードを始める
    final trial = find.text('お試しプレイ（解放条件を無視して遊ぶ）');
    await tester.scrollUntilVisible(
      trial,
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(trial);
    await tester.pumpAndSettle();
    await tester.runAsync(() async {
      await tester.tap(find.text('始める').first);
      await Future<void>.delayed(const Duration(milliseconds: 300));
    });
    await tester.pumpAndSettle();
    expect(find.text('顧問モードを始める'), findsOneWidget);
    await tester.tap(find.text('顧問として始める'));
    await tester.pumpAndSettle();
    var s = container.read(gameControllerProvider)!;
    expect(s.mode, GameMode.teacher);
    expect(find.text('今週の行動'), findsOneWidget);

    // 練習メニューを変えて、全体を激励
    container
        .read(gameControllerProvider.notifier)
        .setPracticeMenu(PracticeMenuPreset.part);
    await tester.pumpAndSettle();
    await tester.tap(find.text('全体を激励'));
    await tester.pumpAndSettle();
    expect(container.read(gameControllerProvider)!.turn, s.turn + 1);

    // 部員をタップして面談
    final member = container
        .read(gameContextProvider)!
        .activeMembers(container.read(gameControllerProvider)!)
        .first;
    await tester.tap(find.byKey(ValueKey('actor-${member.id}')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('面談'));
    await tester.pumpAndSettle();

    // 選曲イベントまで進める
    final vm = container.read(gameControllerProvider.notifier);
    while (container.read(gameControllerProvider)!.pending == null) {
      vm.skipToNextEvent(MonthlyPolicy.balanced);
    }
    await tester.pumpAndSettle();
    expect(find.text('イベント：課題曲の選曲'), findsOneWidget);
    final best = find.text('部にいちばん合う曲にする');
    await tester.ensureVisible(best);
    await tester.pumpAndSettle();
    await tester.tap(best);
    await tester.pumpAndSettle();
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();

    // オーディションの合否
    while (container.read(gameControllerProvider)!.pending?.type !=
        PendingEventType.teacherAudition) {
      final cur = container.read(gameControllerProvider)!;
      if (cur.pending == null) {
        vm.skipToNextEvent(MonthlyPolicy.balanced);
      } else {
        vm.debugReplace(
          TimeManager(container.read(gameContextProvider)!).autoResolve(cur),
        );
      }
    }
    await tester.pumpAndSettle();
    await scrollToTop(tester);
    expect(find.text('イベント：オーディションの合否'), findsOneWidget);
    final announce = find.textContaining('人で発表する');
    await tester.ensureVisible(announce);
    await tester.pumpAndSettle();
    await tester.tap(announce);
    await tester.pumpAndSettle();
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    expect(container.read(gameControllerProvider)!.contestMembers, isNotEmpty);

    // コンクール本番: 指揮台に立つ
    while (container.read(gameControllerProvider)!.pending?.type !=
        PendingEventType.contest) {
      vm.skipToNextEvent(MonthlyPolicy.balanced);
    }
    await tester.pumpAndSettle();
    await scrollToTop(tester);
    await tester.tap(find.text('指揮台に立つ'));
    await tester.pumpAndSettle();
    await conduct(tester);
    expect(find.byType(PerformanceStage), findsOneWidget);
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    s = container.read(gameControllerProvider)!;
    expect(s.pending?.type, isNot(PendingEventType.contest));
    expect(tester.takeException(), isNull);
  });

  testWidgets('OB/OG モード: 差し入れ・仕事をして、任期の終わりにエンディング', (tester) async {
    final container = await pumpApp(tester);
    final vm = container.read(gameControllerProvider.notifier);
    vm.newCareerGame(
      GameMode.alumni,
      schoolId: container
          .read(worldControllerProvider)
          .value!
          .world
          .player
          .schoolId,
      familyName: '音羽',
      givenName: '奏',
    );
    container.read(routerProvider).go('/game');
    await tester.pumpAndSettle();
    expect(find.textContaining('所持金'), findsWidgets);
    await tester.tap(find.text('差し入れ（5,000円）'));
    await tester.pumpAndSettle();
    expect(container.read(gameControllerProvider)!.career!.money, 28000);
    await tester.tap(find.text('仕事に打ち込む'));
    await tester.pumpAndSettle();
    // 任期の終わりまで進める
    final tm = TimeManager(container.read(gameContextProvider)!);
    var s = container.read(gameControllerProvider)!;
    while (s.stage != GameStage.finished) {
      s = s.pending != null
          ? tm.autoResolve(s)
          : tm.skipToNextEvent(s, s.policy);
    }
    vm.debugReplace(s);
    await tester.pumpAndSettle();
    expect(find.text('任期が終わった'), findsOneWidget);
    await tester.tap(find.text('エンディングを見る'));
    await tester.pumpAndSettle();
    expect(find.text('任期のまとめ'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('外部講師モード: 公開講座・出張レッスン・集中レッスン', (tester) async {
    final container = await pumpApp(tester);
    final vm = container.read(gameControllerProvider.notifier);
    vm.newCareerGame(
      GameMode.instructor,
      schoolId: container
          .read(worldControllerProvider)
          .value!
          .world
          .player
          .schoolId,
      familyName: '音羽',
      givenName: '奏',
    );
    container.read(routerProvider).go('/game');
    await tester.pumpAndSettle();
    await tester.tap(find.text('公開講座'));
    await tester.pumpAndSettle();
    final travel = find.textContaining('出張レッスン：').first;
    await tester.ensureVisible(travel);
    await tester.pumpAndSettle();
    await tester.tap(travel);
    await tester.pumpAndSettle();
    var s = container.read(gameControllerProvider)!;
    expect(s.career!.schoolBoosts.values.single, 2);
    await scrollToTop(tester);
    final m = container
        .read(gameContextProvider)!
        .activeMembers(s)
        .firstWhere((x) => x.instrument != null);
    final token = find.byKey(ValueKey('actor-${m.id}'));
    await tester.ensureVisible(token);
    await tester.pumpAndSettle();
    await tester.tap(token);
    await tester.pumpAndSettle();
    await tester.tap(find.text('集中レッスン'));
    await tester.pumpAndSettle();
    s = container.read(gameControllerProvider)!;
    expect(s.choices.last, contains('intensiveCoaching:${m.id}'));
    expect(tester.takeException(), isNull);
  });
}
