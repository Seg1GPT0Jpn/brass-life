import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../app/providers.dart';
import '../../../domain/game/engine/piece_fit.dart';
import '../../../domain/game/models/piece.dart';
import 'piece_player.dart';

/// 曲のページ（Suno）をブラウザで開く。
Future<void> openPiecePage(
  BuildContext context,
  WidgetRef ref,
  Piece piece,
) async {
  final url = ref.read(pieceRepositoryProvider).pageOf(piece);
  final messenger = ScaffoldMessenger.of(context);
  final ok = await launchUrl(url, mode: LaunchMode.externalApplication);
  if (!ok) {
    messenger.showSnackBar(SnackBar(content: Text('リンクを開けませんでした：$url')));
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
              PieceListenControls(piece: piece),
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

/// 再生・一時停止と、再生位置のシークバー。
class PieceListenControls extends ConsumerWidget {
  const PieceListenControls({super.key, required this.piece});

  final Piece piece;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final st = ref.watch(piecePlayerProvider);
    final player = ref.read(piecePlayerProvider.notifier);
    final current = st.isCurrent(piece);
    final status = current ? st.status : PlaybackStatus.idle;
    final playing = status == PlaybackStatus.playing;
    final total = st.duration.inMilliseconds;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            IconButton.filledTonal(
              tooltip: playing ? '一時停止' : 'この曲を聴く',
              onPressed: status == PlaybackStatus.loading
                  ? null
                  : () => player.toggle(piece),
              icon: status == PlaybackStatus.loading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Icon(playing ? Icons.pause : Icons.play_arrow),
            ),
            const SizedBox(width: 4),
            if (current && st.active && total > 0)
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: Slider(
                        value: st.position.inMilliseconds
                            .clamp(0, total)
                            .toDouble(),
                        max: total.toDouble(),
                        onChanged: (v) =>
                            player.seek(Duration(milliseconds: v.round())),
                      ),
                    ),
                    Text(
                      '${formatDuration(st.position)} / ${formatDuration(st.duration)}',
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              )
            else
              Expanded(
                child: Text(switch (status) {
                  PlaybackStatus.loading => '読み込み中…',
                  PlaybackStatus.error => '',
                  _ => 'アプリ内で聴く',
                }, style: theme.textTheme.bodySmall),
              ),
            TextButton.icon(
              onPressed: () => openPiecePage(context, ref, piece),
              icon: const Icon(Icons.open_in_new, size: 16),
              label: const Text('Suno で開く'),
            ),
          ],
        ),
        if (status == PlaybackStatus.error)
          Text(
            '再生できませんでした。インターネット接続を確かめるか、「Suno で開く」から聴いてください。',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.error,
            ),
          ),
      ],
    );
  }
}

/// 画面下に出す「再生中」のミニプレイヤー（何も鳴っていなければ表示しない）。
class NowPlayingBar extends ConsumerWidget {
  const NowPlayingBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final st = ref.watch(piecePlayerProvider);
    final piece = st.piece;
    if (piece == null || !st.active) return const SizedBox.shrink();
    final theme = Theme.of(context);
    final player = ref.read(piecePlayerProvider.notifier);
    final total = st.duration.inMilliseconds;
    return Material(
      color: theme.colorScheme.secondaryContainer,
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            LinearProgressIndicator(
              value: total <= 0
                  ? 0
                  : st.position.inMilliseconds.clamp(0, total) / total,
              minHeight: 2,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  const Icon(Icons.music_note, size: 18),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      '${piece.year}年目 ${piece.category}「${piece.title}」'
                      '${st.fromAsset ? '' : '（ネット再生）'}',
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyMedium,
                    ),
                  ),
                  if (total > 0)
                    Text(
                      '${formatDuration(st.position)} / ${formatDuration(st.duration)}',
                      style: theme.textTheme.bodySmall,
                    ),
                  IconButton(
                    tooltip: st.status == PlaybackStatus.playing
                        ? '一時停止'
                        : '再生',
                    onPressed: st.status == PlaybackStatus.loading
                        ? null
                        : () => player.toggle(piece),
                    icon: Icon(
                      st.status == PlaybackStatus.playing
                          ? Icons.pause
                          : Icons.play_arrow,
                    ),
                  ),
                  IconButton(
                    tooltip: '停止',
                    onPressed: player.stop,
                    icon: const Icon(Icons.stop),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
