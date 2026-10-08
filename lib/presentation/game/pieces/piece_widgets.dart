import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../app/providers.dart';
import '../../../domain/game/engine/piece_fit.dart';
import '../../../domain/game/models/piece.dart';
import '../../../domain/repositories/piece_repository.dart';

/// 曲を聴く。同梱音源があればそれを、なければ Suno のページをブラウザで開く。
Future<void> openPieceAudio(
  BuildContext context,
  WidgetRef ref,
  Piece piece,
) async {
  final audio = ref.read(pieceRepositoryProvider).audioOf(piece);
  final messenger = ScaffoldMessenger.of(context);
  switch (audio) {
    case WebPieceAudio(:final url):
      final ok = await launchUrl(url, mode: LaunchMode.externalApplication);
      if (!ok) {
        messenger.showSnackBar(SnackBar(content: Text('リンクを開けませんでした：$url')));
      }
    case AssetPieceAudio(:final assetPath):
      // 同梱音源の再生はオーディオ再生の実装時に対応する。
      messenger.showSnackBar(
        SnackBar(content: Text('同梱音源：$assetPath（アプリ内再生は今後対応）')),
      );
  }
}

/// 曲の情報（番号・曲名・求められる要素・試聴ボタン）。
///
/// [bandStats] を渡すと、要素ごとに部の実力と必要な実力を並べて相性を表示する。
class PieceCard extends ConsumerWidget {
  const PieceCard({
    super.key,
    required this.piece,
    this.bandStats,
    this.selected = false,
    this.onTap,
    this.badge,
  });

  final Piece piece;
  final Map<PieceStat, int>? bandStats;
  final bool selected;
  final VoidCallback? onTap;

  /// 右上に出す短い印（「今年の課題曲」など）。
  final String? badge;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final stats = bandStats;
    final margin = stats == null ? null : PieceFit.margin(piece, stats);
    final audio = ref.watch(pieceRepositoryProvider).audioOf(piece);
    return Card(
      color: selected ? theme.colorScheme.primaryContainer : null,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: theme.colorScheme.secondaryContainer,
                    child: Text(
                      piece.category,
                      style: theme.textTheme.labelLarge,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(piece.title, style: theme.textTheme.titleMedium),
                        Text(
                          '${piece.year}年目の${piece.type} ${piece.category}'
                          '　難しさ ${piece.difficulty}',
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  if (badge != null) Chip(label: Text(badge!)),
                  if (selected) const Icon(Icons.check_circle),
                ],
              ),
              const SizedBox(height: 8),
              for (final (stat, w) in piece.demands)
                _DemandRow(stat: stat, weight: w, band: stats?[stat]),
              if (margin != null) ...[
                const SizedBox(height: 4),
                Text(
                  'うちの部との相性：${PieceFit.fitLabel(margin)}'
                  '（余裕 ${margin >= 0 ? '+' : ''}$margin）',
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: margin >= 0
                        ? theme.colorScheme.primary
                        : theme.colorScheme.error,
                  ),
                ),
              ],
              const SizedBox(height: 6),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  onPressed: () => openPieceAudio(context, ref, piece),
                  icon: Icon(
                    audio is AssetPieceAudio
                        ? Icons.play_circle
                        : Icons.open_in_new,
                  ),
                  label: Text(
                    audio is AssetPieceAudio ? '聴く（同梱音源）' : 'Suno で聴く',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DemandRow extends StatelessWidget {
  const _DemandRow({required this.stat, required this.weight, this.band});

  final PieceStat stat;
  final int weight;
  final int? band;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final need = PieceFit.requiredLevel(weight);
    final b = band;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          SizedBox(
            width: 92,
            child: Text(stat.label, style: theme.textTheme.bodySmall),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: weight / 100,
                minHeight: 8,
                color: theme.colorScheme.tertiary,
                backgroundColor: theme.colorScheme.surfaceContainerHighest,
              ),
            ),
          ),
          SizedBox(
            width: 172,
            child: Text(
              b == null ? '　要求 $weight' : '　要求 $weight／部 $b（必要 $need）',
              style: theme.textTheme.bodySmall?.copyWith(
                color: b == null
                    ? null
                    : (b >= need
                          ? theme.colorScheme.primary
                          : theme.colorScheme.error),
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
