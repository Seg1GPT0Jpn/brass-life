import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/game/engine/club_membership.dart';
import '../common/widgets/common_widgets.dart';
import 'event_panels.dart';
import 'game_controller.dart';

/// 部活を続けるか（退部・再入部）。
class ClubMembershipCard extends ConsumerWidget {
  const ClubMembershipCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(gameControllerProvider)!;
    final ctx = ref.watch(gameContextProvider)!;
    final rules = ClubMembership(ctx);
    final p = s.player;
    final theme = Theme.of(context);
    final quitReason = rules.quitUnavailableReason(s);
    final rejoinReason = rules.rejoinUnavailableReason(s);
    if (p.retired && !p.quitClub) return const SizedBox.shrink();

    final Widget body;
    if (p.quitClub) {
      final weeks = p.quitTurn == null ? 0 : s.turn - p.quitTurn!;
      body = Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            p.retired
                ? '同級生が引退し、もう部に戻る道はなくなった。'
                : '吹奏楽部を辞めている（$weeks週）。部活の時間を勉強や自主練、友達との時間に使える。'
                      '練習しない週は少しずつ腕が鈍る。',
            style: theme.textTheme.bodySmall,
          ),
          if (!p.retired) ...[
            const SizedBox(height: 8),
            FilledButton.icon(
              onPressed: rejoinReason != null
                  ? null
                  : () => _confirmRejoin(context, ref, p.quitCount),
              icon: const Icon(Icons.login),
              label: Text(rejoinReason ?? '部に戻る'),
            ),
          ],
        ],
      );
    } else {
      body = Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('つらいときは、部を離れる選択もある。', style: theme.textTheme.bodySmall),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              foregroundColor: theme.colorScheme.error,
            ),
            onPressed: quitReason != null
                ? null
                : () => _confirmQuit(context, ref),
            icon: const Icon(Icons.logout),
            label: Text(quitReason ?? '退部を考える…'),
          ),
        ],
      );
    }
    return SectionCard(title: '部活を続ける？', child: body);
  }

  Future<void> _confirmQuit(BuildContext context, WidgetRef ref) async {
    final why = await showDialog<QuitReason>(
      context: context,
      builder: (context) => const _QuitDialog(),
    );
    if (why == null || !context.mounted) return;
    final lines = ref.read(gameControllerProvider.notifier).quitClub(why);
    if (!context.mounted) return;
    await showResultDialog(context, '退部', lines);
  }

  Future<void> _confirmRejoin(
    BuildContext context,
    WidgetRef ref,
    int quitCount,
  ) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('部に戻る？'),
        content: Text(
          '仲の良かった部員は迎えてくれるが、少し気まずさは残る。'
          '${quitCount >= 2 ? '何度も出入りしているので、周りの目は冷たい。' : ''}'
          '今年のコンクールのメンバーには、もう入れないかもしれない。',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('やめておく'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('戻る'),
          ),
        ],
      ),
    );
    if (ok != true || !context.mounted) return;
    final lines = ref.read(gameControllerProvider.notifier).rejoinClub();
    if (!context.mounted) return;
    await showResultDialog(context, '再入部', lines);
  }
}

class _QuitDialog extends StatefulWidget {
  const _QuitDialog();

  @override
  State<_QuitDialog> createState() => _QuitDialogState();
}

class _QuitDialogState extends State<_QuitDialog> {
  QuitReason? _why;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AlertDialog(
      title: const Text('退部届を出す？'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '部を辞めると、合奏・パート練習・コンクール・定期演奏会・幹部選出から外れ、'
              '役職も失う。仲の良かった部員は寂しがり、顧問や部員からの信頼は下がる。'
              'ストレスは軽くなるが、胸にぽっかり穴が空く。'
              '退部中はいつでも戻れるが、3年生の引退を迎えると戻れなくなる。',
            ),
            const SizedBox(height: 12),
            Text('辞める理由', style: theme.textTheme.titleSmall),
            RadioGroup<QuitReason>(
              groupValue: _why,
              onChanged: (v) => setState(() => _why = v),
              child: Column(
                children: [
                  for (final r in QuitReason.values)
                    RadioListTile<QuitReason>(
                      value: r,
                      title: Text(r.label),
                      subtitle: Text(r.description),
                      contentPadding: EdgeInsets.zero,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('考え直す'),
        ),
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: theme.colorScheme.error,
          ),
          onPressed: _why == null ? null : () => Navigator.pop(context, _why),
          child: const Text('退部届を出す'),
        ),
      ],
    );
  }
}
