import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/career/game_mode.dart';
import '../game/game_controller.dart';

/// タイトルのキャリアモード（大人編）一覧。解放状況だけを見せる（大人編は準備中）。
class CareerModesCard extends ConsumerWidget {
  const CareerModesCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final records = ref.watch(careerRecordsProvider).value ?? const [];
    final unlocked = CareerUnlocks.unlocked(records);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('キャリアモード（大人編）', style: theme.textTheme.titleSmall),
        const SizedBox(height: 4),
        Text(
          records.isEmpty
              ? '6年間を最後まで遊ぶと、進路に応じて大人になってからのモードが解放されます。'
              : 'これまでの卒業 ${records.length} 回（最新：${records.last.playerName}「${records.last.title}」）',
          style: theme.textTheme.bodySmall,
        ),
        const SizedBox(height: 4),
        for (final mode in GameMode.values.where((m) => m != GameMode.student))
          ListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            leading: Icon(
              unlocked.contains(mode) ? Icons.lock_open : Icons.lock_outline,
            ),
            title: Text(
              '${mode.label}モード'
              '${unlocked.contains(mode) ? (mode.implemented ? '' : '（解放済み・準備中）') : ''}',
            ),
            subtitle: Text(
              unlocked.contains(mode)
                  ? mode.description
                  : '解放条件：${CareerUnlocks.conditionOf(mode)}',
            ),
            enabled: unlocked.contains(mode) && mode.implemented,
          ),
      ],
    );
  }
}
