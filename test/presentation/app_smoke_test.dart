import 'package:brass_life/app/app.dart';
import 'package:brass_life/app/providers.dart';
import 'package:brass_life/app/router.dart';
import 'package:brass_life/data/repositories/hive_game_save_repository.dart';
import 'package:brass_life/data/repositories/hive_world_meta_repository.dart';
import 'package:brass_life/core/rng/seed_code.dart';
import 'package:brass_life/domain/game/engine/game_context.dart';
import 'package:brass_life/domain/game/engine/time_manager.dart';
import 'package:brass_life/domain/game/models/game_enums.dart';
import 'package:brass_life/domain/game/models/save_summary.dart';
import 'package:brass_life/domain/services/world_generation/world_generator.dart';
import 'package:brass_life/domain/value_objects/instrument.dart';
import 'package:brass_life/domain/value_objects/person_enums.dart';
import 'package:brass_life/presentation/game/game_controller.dart';
import 'package:brass_life/presentation/game/scene/diorama_view.dart';
import 'package:brass_life/presentation/game/scene/performance_stage.dart';
import 'package:brass_life/presentation/world/world_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// タイトル → 生成 → 各デバッグ画面を一通り開き、例外が出ないことを確認する。
void main() {
  Future<ProviderContainer> pumpApp(WidgetTester tester, Size size) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final container = ProviderContainer(
      overrides: [
        worldMetaRepositoryProvider.overrideWithValue(
          InMemoryWorldMetaRepository(),
        ),
        gameSaveRepositoryProvider.overrideWithValue(
          InMemoryGameSaveRepository(),
        ),
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
    return container;
  }

  for (final (label, size) in [
    ('スマホ幅', const Size(390, 844)),
    ('PC 幅', const Size(1280, 900)),
  ]) {
    testWidgets('$label: 生成から全画面の表示まで', (tester) async {
      final container = await pumpApp(tester, size);

      expect(find.text('この Seed で人生を始める'), findsOneWidget);
      await tester.enterText(find.byType(TextField), 'TEST');
      await tester.pump();
      expect(find.textContaining('シードコード:'), findsOneWidget);

      await tester.runAsync(() async {
        await tester.tap(find.text('世界を生成して中身を見る（デバッグ）'));
        await Future<void>.delayed(const Duration(milliseconds: 600));
      });
      await tester.pumpAndSettle();

      final session = container.read(worldControllerProvider).value;
      expect(session, isNotNull);
      expect(find.text('決定性の検証'), findsOneWidget);

      // 決定性の検証ボタン
      await tester.runAsync(() async {
        await tester.tap(find.text('再生成して比較'));
        await Future<void>.delayed(const Duration(milliseconds: 600));
      });
      await tester.pumpAndSettle();
      expect(find.text('完全一致（再現性 OK）'), findsOneWidget);

      // 学校一覧 → プレイヤーの学校の詳細（全タブ）
      await tester.tap(find.text('学校').last);
      await tester.pumpAndSettle();
      expect(find.textContaining('64 校'), findsOneWidget);

      final schoolId = session!.world.player.schoolId;
      final router = container.read(routerProvider);
      router.go('/debug/schools/$schoolId');
      await tester.pumpAndSettle();
      for (final tab in ['部活', '楽器', '部員', '基本']) {
        await tester.tap(find.text(tab).last);
        await tester.pumpAndSettle();
      }

      // NPC 一覧 → 部員と顧問の詳細
      router.go('/debug/npcs');
      await tester.pumpAndSettle();
      expect(
        find.textContaining('${session.world.npcs.length} 人'),
        findsOneWidget,
      );
      final student = session.world.npcs.firstWhere(
        (n) => n.role == NpcRole.student && (n.grade ?? 0) >= 2,
      );
      router.go('/debug/npcs/${student.id}');
      await tester.pumpAndSettle();
      expect(find.text('性格タグ'), findsOneWidget);
      final advisor =
          session.index.npcById[session.world.clubs.first.advisorId]!;
      router.go('/debug/npcs/${advisor.id}');
      await tester.pumpAndSettle();
      expect(find.text(advisor.fullName), findsWidgets);
      await tester.scrollUntilVisible(
        find.text('指導者プロフィール'),
        300,
        scrollable: find.byType(Scrollable).last,
      );

      // 記憶ログ
      router.go('/debug/memories');
      await tester.pumpAndSettle();
      expect(find.textContaining('件'), findsWidgets);

      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('ゲーム: 人生を始める → 楽器決定 → 行動 → 月スキップ', (tester) async {
    final container = await pumpApp(tester, const Size(1280, 900));
    await tester.enterText(find.byType(TextField), 'TEST');
    await tester.pump();
    await tester.runAsync(() async {
      await tester.tap(find.text('この Seed で人生を始める'));
      await Future<void>.delayed(const Duration(milliseconds: 600));
    });
    await tester.pumpAndSettle();
    // 主人公をつくる画面: 名前を変えて始める
    expect(find.text('主人公をつくる'), findsOneWidget);
    await tester.enterText(find.byType(TextField).at(0), '音羽');
    await tester.enterText(find.byType(TextField).at(1), '奏');
    await tester.pump();
    final startButton = find.text('この主人公で始める');
    await tester.scrollUntilVisible(
      startButton,
      400,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    await tester.tap(startButton);
    await tester.pumpAndSettle();
    expect(container.read(gameControllerProvider), isNotNull);
    expect(container.read(gameControllerProvider)!.player.fullName, '音羽 奏');
    // ホームはジオラマ。自分（★）をタップ → 自主練メニュー
    expect(find.byType(DioramaView), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('actor-player')));
    await tester.pumpAndSettle();
    expect(find.text('基礎練'), findsOneWidget);
    expect(find.text('楽器メンテ'), findsOneWidget);
    expect(find.text('担当楽器が決まってから'), findsWidgets);
    await tester.tap(find.text('曲練'));
    await tester.pumpAndSettle();
    expect(find.text('イベント：担当楽器の決定'), findsOneWidget);

    await tester.tap(find.textContaining('トランペット').first);
    await tester.pump();
    await tester.tap(find.text('希望を提出する'));
    await tester.pumpAndSettle();
    expect(find.text('楽器決定'), findsWidgets);
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    var s = container.read(gameControllerProvider)!;
    expect(s.player.instrument, isNotNull);

    // 部員をタップ → 相手との行動メニュー（雑談）
    final ctx0 = container.read(gameContextProvider)!;
    final mate = ctx0.activeMembers(s).first;
    await tester.tap(find.byKey(ValueKey('actor-${mate.id}')));
    await tester.pumpAndSettle();
    expect(find.text('一緒に練習'), findsOneWidget);
    expect(find.text('指導する'), findsOneWidget);
    await tester.tap(find.text('雑談'));
    await tester.pumpAndSettle();
    s = container.read(gameControllerProvider)!;
    expect(s.choices.last, endsWith('chat:${mate.id}'));

    // 場所（音楽室）をタップ → 合奏練習 → 合奏の演出
    final room = find.byKey(const ValueKey('loc-musicRoom'));
    await tester.tapAt(tester.getTopLeft(room) + const Offset(6, 6));
    await tester.pumpAndSettle();
    await tester.tap(find.text('合奏練習'));
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.byType(PerformanceStage), findsOneWidget);
    await tester.pumpAndSettle();
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    expect(find.byType(PerformanceStage), findsNothing);
    s = container.read(gameControllerProvider)!;
    expect(s.choices.last, endsWith('ensemble'));

    // ホームの縦リスト（ジオラマ・方針パネル・ログのどれかが見えている）
    Finder homeScrollable() {
      for (final f in [
        find.byType(DioramaView),
        find.text('月の方針でまとめて進める'),
        find.text('最近の出来事'),
      ]) {
        if (f.evaluate().isNotEmpty) {
          final scrollable = find
              .ancestor(of: f, matching: find.byType(Scrollable))
              .first
              .evaluate()
              .first
              .widget;
          return find.byWidget(scrollable);
        }
      }
      throw StateError('ホームのリストが見つからない');
    }

    final homeList = homeScrollable();
    final skipMonth = find.text('月末までスキップ（イベントで停止）');
    await tester.scrollUntilVisible(skipMonth, 300, scrollable: homeList);
    await tester.pumpAndSettle();
    await tester.tap(skipMonth);
    await tester.pumpAndSettle();
    expect(container.read(gameControllerProvider)!.turn, greaterThan(s.turn));

    // 次のイベント（オーディション）まで進めてカードを選ぶ
    for (
      var i = 0;
      i < 6 &&
          container.read(gameControllerProvider)!.pending?.type !=
              PendingEventType.audition;
      i++
    ) {
      // 方針パネルのボタンは月スキップで確認済みなので、ここはコントローラから進める
      final vm = container.read(gameControllerProvider.notifier);
      final cur = container.read(gameControllerProvider)!;
      if (cur.pending != null && cur.pending!.type == PendingEventType.notice) {
        vm.resolveNotice();
      } else {
        vm.skipToNextEvent(cur.policy);
      }
      await tester.pumpAndSettle();
    }
    expect(
      container.read(gameControllerProvider)!.pending?.type,
      PendingEventType.audition,
    );
    // イベントパネルはリストの先頭（上へスクロールして確認）
    await tester.scrollUntilVisible(
      find.text('アプローチカード（1枚選ぶ）'),
      -300,
      scrollable: homeScrollable(),
    );
    expect(find.text('アプローチカード（1枚選ぶ）'), findsOneWidget);
    // カードの選択はコントローラ経由で行う（UI の表示はここまでで確認済み）
    final ctx = container.read(gameContextProvider)!;
    final pendingState = container.read(gameControllerProvider)!;
    final firstCard = TimeManager(ctx).cardsOf(pendingState).first;
    container.read(gameControllerProvider.notifier).resolveAudition(firstCard);
    await tester.pumpAndSettle();
    expect(container.read(gameControllerProvider)!.contest, isNotNull);

    for (final tab in ['部員', '人間関係', '記録', 'ホーム']) {
      await tester.tap(find.text(tab));
      await tester.pumpAndSettle();
    }
    // 人物詳細（関係の履歴）
    final firstMember = container.read(gameControllerProvider)!.roster.first;
    container.read(routerProvider).go('/game/person/$firstMember');
    await tester.pumpAndSettle();
    expect(find.text('あなたとの関係'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('スマホ幅: ジオラマと合奏の演出が崩れない', (tester) async {
    final container = await pumpApp(tester, const Size(390, 844));
    await tester.runAsync(() async {
      await container.read(worldControllerProvider.notifier).generate('TEST');
    });
    await tester.pumpAndSettle();
    final vm = container.read(gameControllerProvider.notifier);
    vm.newGame();
    vm.submit(WeeklyAction.individualPractice);
    vm.resolveInstrument([InstrumentType.flute]);
    container.read(routerProvider).go('/game');
    await tester.pumpAndSettle();
    expect(find.byType(DioramaView), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('actor-player')));
    await tester.pumpAndSettle();
    expect(find.text('基礎練'), findsOneWidget);
    await tester.tap(find.text('基礎練'));
    await tester.pumpAndSettle();
    final room = find.byKey(const ValueKey('loc-musicRoom'));
    await tester.tapAt(tester.getTopLeft(room) + const Offset(4, 4));
    await tester.pumpAndSettle();
    await tester.tap(find.text('合奏練習'));
    await tester.pumpAndSettle();
    expect(find.byType(PerformanceStage), findsOneWidget);
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets('幹部選出: 役職と気持ちを選んで立候補できる', (tester) async {
    final saves = InMemoryGameSaveRepository();
    final world = const WorldGenerator().generate(
      SeedCode.seedFromInput('TEST'),
    );
    final ctx = GameContext(world);
    final tm = TimeManager(ctx);
    var s = tm.newGame(world);
    while (!(s.pending?.type == PendingEventType.executiveSelection &&
        s.player.grade == 2)) {
      s = s.pending != null
          ? tm.autoResolve(s)
          : tm.submitAction(s, WeeklyAction.partPractice);
    }
    await saves.save(
      '1',
      s,
      SaveSummary(
        slot: '1',
        worldSeed: s.worldSeed,
        seedCode: SeedCode.format(s.worldSeed),
        playerName: s.player.fullName,
        dateLabel: '',
        schoolName: '',
        savedAt: '',
      ),
    );
    tester.view.physicalSize = const Size(1280, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final container = ProviderContainer(
      overrides: [
        worldMetaRepositoryProvider.overrideWithValue(
          InMemoryWorldMetaRepository(),
        ),
        gameSaveRepositoryProvider.overrideWithValue(saves),
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
      await container.read(gameControllerProvider.notifier).load('1');
    });
    await tester.pumpAndSettle();
    container.read(routerProvider).go('/game');
    await tester.pumpAndSettle();

    expect(find.text('イベント：新幹部の選出'), findsOneWidget);
    await tester.tap(find.text('立候補する'));
    await tester.pumpAndSettle();
    expect(find.text('どの役職に立候補する？'), findsOneWidget);
    await tester.tap(find.text('学生指揮'));
    await tester.pumpAndSettle();
    expect(find.textContaining('心の傷 +'), findsOneWidget);
    // 気持ちを最大に
    await tester.drag(find.byType(Slider), const Offset(600, 0));
    await tester.pumpAndSettle();
    expect(find.text('なりたい気持ち：すべてを懸けてなりたい'), findsOneWidget);
    final submit = find.text('「学生指揮」に立候補する');
    await tester.ensureVisible(submit);
    await tester.pumpAndSettle();
    await tester.tap(submit);
    await tester.pumpAndSettle();
    expect(find.text('幹部選出'), findsWidgets);
    final after = container.read(gameControllerProvider)!;
    expect(after.choices.last, endsWith('executive:run:conductor:5'));
    expect(
      after.roles['player'] == ClubRole.conductor || after.player.heartache > 0,
      isTrue,
    );
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets('退部: 理由を選んで退部届を出し、また部に戻れる', (tester) async {
    final container = await pumpApp(tester, const Size(1280, 900));
    await tester.runAsync(() async {
      await container.read(worldControllerProvider.notifier).generate('TEST');
    });
    await tester.pumpAndSettle();
    final vm = container.read(gameControllerProvider.notifier);
    vm.newGame();
    vm.submit(WeeklyAction.individualPractice);
    vm.resolveInstrument([InstrumentType.flute]);
    container.read(routerProvider).go('/game');
    await tester.pumpAndSettle();

    final quit = find.text('退部を考える…');
    await tester.ensureVisible(quit);
    await tester.pumpAndSettle();
    await tester.tap(quit);
    await tester.pumpAndSettle();
    expect(find.text('退部届を出す？'), findsOneWidget);
    await tester.tap(find.text('心が疲れてしまった'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('退部届を出す'));
    await tester.pumpAndSettle();
    expect(container.read(gameControllerProvider)!.player.quitClub, isTrue);
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    expect(find.text('退部中'), findsOneWidget);

    final back = find.text('部に戻る');
    await tester.ensureVisible(back);
    await tester.pumpAndSettle();
    await tester.tap(back);
    await tester.pumpAndSettle();
    await tester.tap(find.text('戻る'));
    await tester.pumpAndSettle();
    expect(container.read(gameControllerProvider)!.player.inClub, isTrue);
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets('エンディング: 6 年間を終えたセーブを読み込み、エンディングを表示', (tester) async {
    final saves = InMemoryGameSaveRepository();
    // 6 年間を自動で遊び終えた状態を用意する
    final world = const WorldGenerator().generate(
      SeedCode.seedFromInput('TEST'),
    );
    final ctx = GameContext(world);
    final tm = TimeManager(ctx);
    var s = tm.newGame(world);
    for (var i = 0; i < 2000 && s.stage != GameStage.finished; i++) {
      s = s.pending != null
          ? tm.autoResolve(s)
          : tm.submitAction(s, tm.actionForPolicy(s));
    }
    while (s.pending != null) {
      s = tm.autoResolve(s);
    }
    await saves.save(
      '1',
      s,
      SaveSummary(
        slot: '1',
        worldSeed: s.worldSeed,
        seedCode: SeedCode.format(s.worldSeed),
        playerName: s.player.fullName,
        dateLabel: '卒業',
        schoolName: '',
        savedAt: '',
      ),
    );

    tester.view.physicalSize = const Size(1280, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final container = ProviderContainer(
      overrides: [
        worldMetaRepositoryProvider.overrideWithValue(
          InMemoryWorldMetaRepository(),
        ),
        gameSaveRepositoryProvider.overrideWithValue(saves),
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
    expect(find.textContaining('スロット 1'), findsOneWidget);

    await tester.runAsync(() async {
      await container.read(gameControllerProvider.notifier).load('1');
    });
    await tester.pumpAndSettle();
    container.read(routerProvider).go('/game');
    await tester.pumpAndSettle();
    expect(find.text('エンディングを見る'), findsOneWidget);
    await tester.tap(find.text('エンディングを見る'));
    await tester.pumpAndSettle();
    expect(find.text('称号'), findsOneWidget);
    expect(find.text('エピローグ'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
