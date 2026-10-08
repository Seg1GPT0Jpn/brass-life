import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/game/engine/piece_fit.dart';
import '../../../domain/game/engine/piece_selection.dart';
import '../../common/widgets/common_widgets.dart';
import '../event_panels.dart';
import '../game_controller.dart';
import 'piece_widgets.dart';

/// イベント：今年の課題曲を選ぶ（推す）。
class PieceSelectionPanel extends ConsumerStatefulWidget {
  const PieceSelectionPanel({super.key});

  @override
  ConsumerState<PieceSelectionPanel> createState() =>
      _PieceSelectionPanelState();
}

class _PieceSelectionPanelState extends ConsumerState<PieceSelectionPanel> {
  String? _selected;

  Future<void> _submit(String? pieceId) async {
    final lines = ref
        .read(gameControllerProvider.notifier)
        .resolvePieceSelection(pieceId);
    if (!mounted) return;
    await showResultDialog(context, '課題曲の選曲', lines);
  }

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(gameControllerProvider)!;
    final ctx = ref.watch(gameContextProvider)!;
    final sel = PieceSelection(ctx);
    final fit = PieceFit(ctx);
    final options = sel.optionsFor(s);
    final stats = fit.bandStats(s, fit.candidates(s));
    final theme = Theme.of(context);
    final year = options.isEmpty ? 0 : options.first.year;
    return SectionCard(
      title: 'イベント：課題曲の選曲',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            '今年（$year年目）のコンクールの課題曲を、I〜IV の中から選ぶ時期が来た。'
            'どの曲を推す？',
          ),
          const SizedBox(height: 4),
          Text(
            sel.hasVoice(s)
                ? 'あなたには発言力がある。推した曲がそのまま採用される。'
                : '最後は顧問が決める。顧問の評価が高ければ、意見を汲んでもらえることもある。',
            style: theme.textTheme.bodySmall,
          ),
          Text(
            '曲ごとに求められる要素と、いまの部の実力（必要な実力を上回ると青、下回ると赤）。'
            '相性が良いほどコンクールで有利になる。',
            style: theme.textTheme.bodySmall,
          ),
          const SizedBox(height: 8),
          for (final p in options)
            PieceCard(
              piece: p,
              bandStats: stats,
              selected: _selected == p.id,
              onTap: () => setState(() => _selected = p.id),
            ),
          const SizedBox(height: 8),
          FilledButton(
            onPressed: _selected == null ? null : () => _submit(_selected),
            child: Text(
              _selected == null
                  ? '推す曲を選んでください'
                  : '「${options.firstWhere((p) => p.id == _selected).title}」を推す',
            ),
          ),
          TextButton(
            onPressed: () => _submit(null),
            child: const Text('顧問に任せる'),
          ),
        ],
      ),
    );
  }
}
