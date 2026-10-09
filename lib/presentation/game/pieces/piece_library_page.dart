import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers.dart';
import '../../../domain/game/engine/piece_fit.dart';
import '../game_controller.dart';
import 'piece_widgets.dart';

/// 曲の一覧（課題曲 6 年分・24 曲と、自由曲 10 曲）。
class PieceLibraryPage extends ConsumerWidget {
  const PieceLibraryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(pieceRepositoryProvider);
    final s = ref.watch(gameControllerProvider);
    final ctx = ref.watch(gameContextProvider);
    final currentYear = s == null || ctx == null
        ? 1
        : ctx.calendar.dateOf(s.turn).academicYearIndex + 1;
    final chosen = s?.setPieces.values.toSet() ?? const <String>{};
    final stats = s == null || ctx == null
        ? null
        : PieceFit(ctx).bandStats(s, PieceFit(ctx).candidates(s));
    return DefaultTabController(
      length: 7,
      initialIndex: (currentYear - 1).clamp(0, 5),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('課題曲・自由曲'),
          bottom: TabBar(
            isScrollable: true,
            tabs: [
              for (var y = 1; y <= 6; y++)
                Tab(text: '${y <= 3 ? '中$y' : '高${y - 3}'}（$y年目）'),
              const Tab(text: '自由曲'),
            ],
          ),
        ),
        bottomNavigationBar: const NowPlayingBar(),
        body: TabBarView(
          children: [
            for (var y = 1; y <= 6; y++)
              ListView(
                padding: const EdgeInsets.all(12),
                children: [
                  if (y == currentYear && stats != null)
                    const Padding(
                      padding: EdgeInsets.only(bottom: 8),
                      child: Text('今年の曲には、いまの部の実力と相性を並べて表示しています。'),
                    ),
                  for (final p in repo.byYear(y))
                    PieceCard(
                      piece: p,
                      bandStats: y == currentYear ? stats : null,
                      badge: chosen.contains(p.id)
                          ? (y == currentYear ? '今年の課題曲' : '演奏した曲')
                          : null,
                    ),
                ],
              ),
            ListView(
              padding: const EdgeInsets.all(12),
              children: [
                const Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: Text('どの年でも演奏できる自由曲です。難易度は B < A < S < SS。'),
                ),
                for (final p in repo.freePieces())
                  PieceCard(
                    piece: p,
                    bandStats: stats,
                    badge: chosen.contains(p.id) ? '演奏した曲' : null,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
