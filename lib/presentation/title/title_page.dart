import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/app_info.dart';
import '../../app/feature_flags.dart';
import '../../app/providers.dart';
import '../../domain/career/game_mode.dart';
import 'career_modes_card.dart';
import '../game/character_creation_page.dart';
import '../game/game_controller.dart';
import '../world/world_controller.dart';
import 'title_view_model.dart';

class TitlePage extends ConsumerStatefulWidget {
  const TitlePage({super.key});

  @override
  ConsumerState<TitlePage> createState() => _TitlePageState();
}

class _TitlePageState extends ConsumerState<TitlePage> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// 世界を生成してデバッグ表示へ。
  Future<void> _generate() async {
    final ok = await ref.read(titleViewModelProvider.notifier).generate();
    _controller.text = ref.read(titleViewModelProvider).input;
    if (ok && mounted) context.go('/debug/overview');
  }

  /// 世界を生成して新しい人生を始める。
  Future<void> _startLife() async {
    final ok = await ref.read(titleViewModelProvider.notifier).generate();
    _controller.text = ref.read(titleViewModelProvider).input;
    if (!ok || !mounted) return;
    ref.invalidate(characterCreationProvider);
    context.go('/create');
  }

  /// 世界を生成して大人編の設定画面へ。
  Future<void> _startCareer(GameMode mode) async {
    final ok = await ref.read(titleViewModelProvider.notifier).generate();
    _controller.text = ref.read(titleViewModelProvider).input;
    if (!ok || !mounted) return;
    context.go('/career/${mode.name}');
  }

  Future<void> _delete(String slot) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('セーブデータの削除'),
        content: Text(
          '${slot == 'auto' ? 'オートセーブ' : 'スロット $slot'}を削除します。元に戻せません。',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('やめる'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('削除する'),
          ),
        ],
      ),
    );
    if (ok != true) return;
    await ref.read(gameSaveRepositoryProvider).delete(slot);
    ref.invalidate(saveListProvider);
  }

  Future<void> _load(String slot) async {
    final error = await ref.read(gameControllerProvider.notifier).load(slot);
    if (!mounted) return;
    if (error != null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error)));
      return;
    }
    context.go('/game');
  }

  void _useSeed(String text) {
    _controller.text = text;
    ref.read(titleViewModelProvider.notifier).setInput(text);
  }

  @override
  Widget build(BuildContext context) {
    final vm = ref.watch(titleViewModelProvider);
    final world = ref.watch(worldControllerProvider);
    final recent = ref.watch(recentWorldsProvider);
    final saves = ref.watch(saveListProvider);
    final game = ref.watch(gameControllerProvider);
    final theme = Theme.of(context);
    final loading = world.isLoading;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 24),
                  Icon(
                    Icons.music_note,
                    size: 56,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'ブラス・ライフ',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '吹奏楽部 × 学校生活 × 人生シミュレーション',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 32),
                  Text('World Seed', style: theme.textTheme.titleMedium),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _controller,
                    enabled: !loading,
                    onChanged: ref
                        .read(titleViewModelProvider.notifier)
                        .setInput,
                    onSubmitted: (_) => _generate(),
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      hintText: '好きな言葉 / シードコード（空欄ならランダム）',
                      helperText: vm.preview == null
                          ? '同じ Seed からは必ず同じ世界が生まれます'
                          : 'シードコード: ${vm.preview}',
                      suffixIcon: IconButton(
                        tooltip: 'ランダムな Seed',
                        icon: const Icon(Icons.casino_outlined),
                        onPressed: loading
                            ? null
                            : () => _useSeed(
                                ref
                                    .read(titleViewModelProvider.notifier)
                                    .randomSeedText(),
                              ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  FilledButton.icon(
                    onPressed: loading ? null : _startLife,
                    icon: loading
                        ? const SizedBox.square(
                            dimension: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.play_arrow),
                    label: Text(loading ? '世界を生成中…' : 'この Seed で人生を始める'),
                  ),
                  const SizedBox(height: 8),
                  OutlinedButton.icon(
                    onPressed: loading ? null : _generate,
                    icon: const Icon(Icons.public),
                    label: const Text('世界を生成して中身を見る（デバッグ）'),
                  ),
                  if (world.hasError) ...[
                    const SizedBox(height: 12),
                    Text(
                      '生成に失敗しました: ${world.error}',
                      style: TextStyle(color: theme.colorScheme.error),
                    ),
                  ],
                  if (world.value != null) ...[
                    const SizedBox(height: 8),
                    OutlinedButton.icon(
                      onPressed: () => context.go('/debug/overview'),
                      icon: const Icon(Icons.bug_report_outlined),
                      label: Text('生成済みの世界を見る（${world.value!.meta.seedCode}）'),
                    ),
                  ],
                  if (game != null) ...[
                    const SizedBox(height: 8),
                    FilledButton.tonalIcon(
                      onPressed: () => context.go('/game'),
                      icon: const Icon(Icons.arrow_forward),
                      label: Text('プレイ中の人生に戻る（${game.player.fullName}）'),
                    ),
                  ],
                  const SizedBox(height: 32),
                  Text('続きから', style: theme.textTheme.titleSmall),
                  const SizedBox(height: 8),
                  saves.when(
                    data: (list) => list.isEmpty
                        ? Text('セーブデータはありません', style: theme.textTheme.bodySmall)
                        : Column(
                            children: [
                              for (final sv in list)
                                Card(
                                  child: ListTile(
                                    leading: Icon(
                                      sv.slot == 'auto'
                                          ? Icons.autorenew
                                          : Icons.save,
                                    ),
                                    title: Text(
                                      '${sv.slot == 'auto' ? 'オートセーブ' : 'スロット ${sv.slot}'}：'
                                      '${sv.playerName}',
                                    ),
                                    subtitle: Text(
                                      '${sv.dateLabel} ／ ${sv.schoolName} ／ ${sv.seedCode}',
                                    ),
                                    onTap: loading
                                        ? null
                                        : () => _load(sv.slot),
                                    trailing: IconButton(
                                      tooltip: '削除',
                                      icon: const Icon(Icons.delete_outline),
                                      onPressed: () => _delete(sv.slot),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                    loading: () => const LinearProgressIndicator(),
                    error: (e, _) => Text('読み込み失敗: $e'),
                  ),
                  const SizedBox(height: 32),
                  Text('最近の Seed', style: theme.textTheme.titleSmall),
                  const SizedBox(height: 8),
                  recent.when(
                    data: (list) => list.isEmpty
                        ? Text('まだありません', style: theme.textTheme.bodySmall)
                        : Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              for (final m in list)
                                ActionChip(
                                  avatar: const Icon(Icons.history, size: 16),
                                  label: Text(
                                    m.input == m.seedCode
                                        ? m.seedCode
                                        : '${m.input}（${m.seedCode}）',
                                  ),
                                  onPressed: loading
                                      ? null
                                      : () => _useSeed(m.input),
                                ),
                            ],
                          ),
                    loading: () => const LinearProgressIndicator(),
                    error: (e, _) => Text('読み込み失敗: $e'),
                  ),
                  if (FeatureFlags.careerModes) ...[
                    const SizedBox(height: 32),
                    CareerModesCard(onStart: _startCareer, busy: loading),
                  ],
                  const SizedBox(height: 32),
                  Text(
                    appBuildLabel,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.outline,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
