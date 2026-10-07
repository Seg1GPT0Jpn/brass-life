import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'game_controller.dart';

/// セーブスロット（1〜3）への保存。オートセーブは毎週自動で行われる。
class SaveDialog extends ConsumerWidget {
  const SaveDialog({super.key});

  static const slots = ['1', '2', '3'];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final saves = ref.watch(saveListProvider);
    final bySlot = {for (final s in saves.value ?? const []) s.slot: s};
    return AlertDialog(
      title: const Text('セーブ'),
      content: SizedBox(
        width: 420,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('オートセーブは毎週自動で行われます。別の時点を残したいときはスロットに保存してください。'),
            const SizedBox(height: 12),
            for (final slot in slots)
              Card(
                child: ListTile(
                  leading: const Icon(Icons.save),
                  title: Text('スロット $slot'),
                  subtitle: Text(
                    bySlot[slot] == null
                        ? '（空き）'
                        : '${bySlot[slot]!.playerName} ／ ${bySlot[slot]!.dateLabel}',
                  ),
                  trailing: FilledButton.tonal(
                    onPressed: () async {
                      await ref
                          .read(gameControllerProvider.notifier)
                          .saveTo(slot);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('スロット $slot に保存しました')),
                        );
                      }
                    },
                    child: Text(bySlot[slot] == null ? '保存' : '上書き'),
                  ),
                ),
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('閉じる'),
        ),
      ],
    );
  }
}
