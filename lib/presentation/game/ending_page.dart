import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../domain/game/engine/ending_analyzer.dart';
import '../common/widgets/common_widgets.dart';
import 'game_controller.dart';

final endingProvider = Provider<EndingResult?>((ref) {
  final s = ref.watch(gameControllerProvider);
  final ctx = ref.watch(gameContextProvider);
  if (s == null || ctx == null) return null;
  return EndingAnalyzer(ctx).analyze(s);
});

/// エンディング: 称号・エピローグ・思い出・6 年間のまとめ。
class EndingPage extends ConsumerWidget {
  const EndingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final e = ref.watch(endingProvider);
    final s = ref.watch(gameControllerProvider);
    if (e == null || s == null) {
      return const Scaffold(body: Center(child: Text('エンディングがありません')));
    }
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('エンディング')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const SizedBox(height: 16),
              Text(
                s.player.fullName,
                textAlign: TextAlign.center,
                style: theme.textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                '称号',
                textAlign: TextAlign.center,
                style: theme.textTheme.labelLarge?.copyWith(
                  color: theme.colorScheme.outline,
                ),
              ),
              Text(
                '「${e.title}」',
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: 4),
              Text(e.titleReason, textAlign: TextAlign.center),
              if (e.otherTitles.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  'ほかにも：${e.otherTitles.join('／')}',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodySmall,
                ),
              ],
              const SizedBox(height: 24),
              SectionCard(
                title: 'エピローグ',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (final para in e.epilogue)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Text(
                          para,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            height: 1.7,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              SectionCard(
                title: '思い出',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (final h in e.highlights)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Text('・$h'),
                      ),
                  ],
                ),
              ),
              SectionCard(
                title: '6年間のまとめ',
                child: Column(
                  children: [for (final (k, v) in e.stats) KvRow(k, v)],
                ),
              ),
              const SizedBox(height: 8),
              FilledButton.icon(
                onPressed: () => context.go('/'),
                icon: const Icon(Icons.home),
                label: const Text('タイトルへ（別の Seed で新しい人生へ）'),
              ),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: () => context.go('/game'),
                icon: const Icon(Icons.history_edu),
                label: const Text('6年間の記録を見返す'),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
