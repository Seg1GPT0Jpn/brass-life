import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'pieces/piece_widgets.dart';
import 'game_controller.dart';
import 'home_tab.dart';
import 'members_tab.dart';
import 'records_tab.dart';
import 'save_dialog.dart';
import 'relations_tab.dart';

/// ゲーム本編の画面（ホーム / 部員 / 記録）。
class GamePage extends ConsumerWidget {
  const GamePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(gameControllerProvider);
    final ctx = ref.watch(gameContextProvider);
    if (s == null || ctx == null) {
      return Scaffold(
        body: Center(
          child: FilledButton(
            onPressed: () => context.go('/'),
            child: const Text('タイトルへ'),
          ),
        ),
      );
    }
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text(ctx.dateLabelOf(s)),
          actions: [
            IconButton(
              tooltip: '課題曲',
              icon: const Icon(Icons.library_music_outlined),
              onPressed: () => context.push('/game/pieces'),
            ),
            IconButton(
              tooltip: 'セーブ',
              icon: const Icon(Icons.save_outlined),
              onPressed: () => showDialog<void>(
                context: context,
                builder: (_) => const SaveDialog(),
              ),
            ),
            IconButton(
              tooltip: '世界のデバッグ表示',
              icon: const Icon(Icons.bug_report_outlined),
              onPressed: () => context.go('/debug/overview'),
            ),
            IconButton(
              tooltip: 'タイトルへ（オートセーブ済み）',
              icon: const Icon(Icons.home_outlined),
              onPressed: () => context.go('/'),
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(text: 'ホーム'),
              Tab(text: '部員'),
              Tab(text: '人間関係'),
              Tab(text: '記録'),
            ],
          ),
        ),
        bottomNavigationBar: const NowPlayingBar(),
        body: const TabBarView(
          children: [HomeTab(), MembersTab(), RelationsTab(), RecordsTab()],
        ),
      ),
    );
  }
}
