import 'package:brass_life/app/app.dart';
import 'package:brass_life/app/providers.dart';
import 'package:brass_life/app/router.dart';
import 'package:brass_life/data/repositories/hive_world_meta_repository.dart';
import 'package:brass_life/domain/value_objects/person_enums.dart';
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

      expect(find.text('世界を生成'), findsOneWidget);
      await tester.enterText(find.byType(TextField), 'TEST');
      await tester.pump();
      expect(find.textContaining('シードコード:'), findsOneWidget);

      await tester.runAsync(() async {
        await tester.tap(find.text('世界を生成'));
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
}
