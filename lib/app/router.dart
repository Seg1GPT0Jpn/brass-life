import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../domain/career/game_mode.dart';
import '../presentation/career/career_setup_page.dart';
import '../presentation/debug/memory_log/memory_log_page.dart';
import '../presentation/debug/npc_detail/npc_detail_page.dart';
import '../presentation/debug/npc_list/npc_list_page.dart';
import '../presentation/debug/school_detail/school_detail_page.dart';
import '../presentation/debug/school_list/school_list_page.dart';
import '../presentation/debug/shell/debug_shell.dart';
import '../presentation/debug/world_overview/overview_page.dart';
import '../presentation/game/pieces/piece_library_page.dart';
import '../presentation/game/character_creation_page.dart';
import '../presentation/game/ending_page.dart';
import '../presentation/game/game_controller.dart';
import '../presentation/game/game_page.dart';
import '../presentation/game/relations_tab.dart';
import '../presentation/title/title_page.dart';
import '../presentation/world/world_controller.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    // 世界が未生成のままデバッグ画面の URL を開いた場合（Web のリロード等）はタイトルへ。
    redirect: (context, state) {
      final hasWorld = ref.read(worldControllerProvider).value != null;
      if (!hasWorld &&
          (state.matchedLocation.startsWith('/debug') ||
              state.matchedLocation.startsWith('/create'))) {
        return '/';
      }
      final hasGame = ref.read(gameControllerProvider) != null;
      if (!hasGame && state.matchedLocation.startsWith('/game')) return '/';
      return null;
    },
    routes: [
      GoRoute(path: '/', builder: (_, _) => const TitlePage()),
      GoRoute(
        path: '/create',
        builder: (_, _) => const CharacterCreationPage(),
      ),
      GoRoute(
        path: '/career/:mode',
        builder: (_, state) => CareerSetupPage(
          mode: GameMode.values.byName(state.pathParameters['mode']!),
        ),
      ),
      GoRoute(
        path: '/game',
        builder: (_, _) => const GamePage(),
        routes: [
          GoRoute(path: 'ending', builder: (_, _) => const EndingPage()),
          GoRoute(path: 'pieces', builder: (_, _) => const PieceLibraryPage()),
          GoRoute(
            path: 'person/:id',
            builder: (_, state) =>
                PersonPage(npcId: state.pathParameters['id']!),
          ),
        ],
      ),
      StatefulShellRoute.indexedStack(
        builder: (_, _, shell) => DebugShell(navigationShell: shell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/debug/overview',
                builder: (_, _) => const OverviewPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/debug/schools',
                builder: (_, _) => const SchoolListPage(),
                routes: [
                  GoRoute(
                    path: ':id',
                    builder: (_, state) =>
                        SchoolDetailPage(schoolId: state.pathParameters['id']!),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/debug/npcs',
                builder: (_, _) => const NpcListPage(),
                routes: [
                  GoRoute(
                    path: ':id',
                    builder: (_, state) =>
                        NpcDetailPage(npcId: state.pathParameters['id']!),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/debug/memories',
                builder: (_, _) => const MemoryLogPage(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
