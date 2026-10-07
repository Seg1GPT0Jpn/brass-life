import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../world/world_controller.dart';

/// デバッグ画面の共通枠（タブ切替）。幅が広い場合は NavigationRail、狭い場合は NavigationBar。
class DebugShell extends ConsumerWidget {
  const DebugShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  static const _destinations = [
    (Icons.dashboard_outlined, Icons.dashboard, '概要'),
    (Icons.school_outlined, Icons.school, '学校'),
    (Icons.people_outline, Icons.people, 'NPC'),
    (Icons.history_edu_outlined, Icons.history_edu, '記憶'),
  ];

  void _go(int index) => navigationShell.goBranch(
    index,
    initialLocation: index == navigationShell.currentIndex,
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(worldControllerProvider).value;
    final wide = MediaQuery.sizeOf(context).width >= 840;
    final title =
        '${_destinations[navigationShell.currentIndex].$3}'
        '${session == null ? '' : '  ·  ${session.meta.seedCode}'}';

    final appBar = AppBar(
      title: Text(title),
      actions: [
        IconButton(
          tooltip: 'タイトルへ戻る',
          icon: const Icon(Icons.home_outlined),
          onPressed: () => context.go('/'),
        ),
      ],
    );

    if (wide) {
      return Scaffold(
        appBar: appBar,
        body: Row(
          children: [
            NavigationRail(
              selectedIndex: navigationShell.currentIndex,
              onDestinationSelected: _go,
              labelType: NavigationRailLabelType.all,
              destinations: [
                for (final (icon, selected, label) in _destinations)
                  NavigationRailDestination(
                    icon: Icon(icon),
                    selectedIcon: Icon(selected),
                    label: Text(label),
                  ),
              ],
            ),
            const VerticalDivider(width: 1),
            Expanded(child: navigationShell),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: appBar,
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: _go,
        destinations: [
          for (final (icon, selected, label) in _destinations)
            NavigationDestination(
              icon: Icon(icon),
              selectedIcon: Icon(selected),
              label: label,
            ),
        ],
      ),
    );
  }
}
