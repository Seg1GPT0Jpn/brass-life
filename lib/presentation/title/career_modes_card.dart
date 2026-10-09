import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/career/game_mode.dart';
import '../game/game_controller.dart';

/// タイトルのキャリアモード（大人編）。解放済みのモードを始められる。
///
/// 「お試し」をオンにすると、解放条件を満たしていなくても遊べる（記録には影響しない）。
class CareerModesCard extends ConsumerStatefulWidget {
  const CareerModesCard({super.key, required this.onStart, this.busy = false});

  /// モードを選んで始める（世界の生成と設定画面への移動は呼び出し側）。
  final ValueChanged<GameMode> onStart;
  final bool busy;

  @override
  ConsumerState<CareerModesCard> createState() => _CareerModesCardState();
}

class _CareerModesCardState extends ConsumerState<CareerModesCard> {
  bool _trial = false;

  @override
  Widget build(BuildContext context) {
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
        for (final mode in GameMode.values.where((m) => m.isCareer))
          _ModeTile(
            mode: mode,
            unlocked: unlocked.contains(mode),
            playable: unlocked.contains(mode) || _trial,
            busy: widget.busy,
            onStart: () => widget.onStart(mode),
          ),
        SwitchListTile(
          dense: true,
          contentPadding: EdgeInsets.zero,
          value: _trial,
          onChanged: (v) => setState(() => _trial = v),
          title: const Text('お試しプレイ（解放条件を無視して遊ぶ）'),
        ),
      ],
    );
  }
}

class _ModeTile extends StatelessWidget {
  const _ModeTile({
    required this.mode,
    required this.unlocked,
    required this.playable,
    required this.busy,
    required this.onStart,
  });

  final GameMode mode;
  final bool unlocked;
  final bool playable;
  final bool busy;
  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) => ListTile(
    dense: true,
    contentPadding: EdgeInsets.zero,
    leading: Icon(unlocked ? Icons.lock_open : Icons.lock_outline),
    title: Text('${mode.label}モード'),
    subtitle: Text(
      unlocked
          ? mode.description
          : '${mode.description}\n解放条件：${CareerUnlocks.conditionOf(mode)}',
    ),
    isThreeLine: !unlocked,
    trailing: OutlinedButton(
      onPressed: playable && !busy ? onStart : null,
      child: const Text('始める'),
    ),
  );
}
