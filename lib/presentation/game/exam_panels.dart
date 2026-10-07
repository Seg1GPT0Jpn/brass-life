import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/game/engine/entrance_exam_engine.dart';
import '../common/widgets/common_widgets.dart';
import 'event_panels.dart';
import 'game_controller.dart';

/// 推薦の打診（高校: 部活推薦 / 大学: 音大・指定校推薦）。
class RecommendationPanel extends ConsumerWidget {
  const RecommendationPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(gameControllerProvider)!;
    final ctx = ref.watch(gameContextProvider)!;
    final engine = EntranceExamEngine(ctx);
    final isHigh = s.exam!.kind == 'high';
    final offers = [
      for (final t in engine.targetsFor(s.exam!.kind))
        if (s.exam!.offers.contains(t.id)) t,
    ];
    Future<void> answer(String? id) async {
      final lines = ref
          .read(gameControllerProvider.notifier)
          .resolveRecommendation(id);
      if (!context.mounted) return;
      await showResultDialog(context, '推薦の打診', lines);
    }

    return SectionCard(
      title: isHigh ? 'イベント：部活推薦の打診' : 'イベント：大学推薦の打診',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            isHigh
                ? '吹奏楽部での活躍が評価され、強豪校から「推薦で来ないか」と声がかかった。'
                      '受ければ合格が内定し、一般入試は受けない。'
                : 'これまでの実績や成績が評価され、大学から推薦の話が来た。'
                      '受ければ合格が内定し、一般入試は受けない。',
          ),
          const SizedBox(height: 12),
          for (final t in offers)
            Card(
              child: ListTile(
                title: Text(t.name),
                subtitle: Text(
                  isHigh
                      ? '偏差値 ${t.deviation} ／ 吹奏楽部：${t.clubTier?.label ?? '－'} ／ ${t.note}'
                      : '偏差値 ${t.deviation} ／ ${t.note}',
                ),
                trailing: FilledButton(
                  onPressed: () => answer(t.id),
                  child: const Text('受ける'),
                ),
              ),
            ),
          const SizedBox(height: 8),
          OutlinedButton(
            onPressed: () => answer(null),
            child: const Text('すべて断って一般入試で受験する'),
          ),
        ],
      ),
    );
  }
}

/// 出願（高校: 私立 2 校まで + 公立 1 校まで / 大学: 3 校まで）。
class ApplicationPanel extends ConsumerStatefulWidget {
  const ApplicationPanel({super.key});

  @override
  ConsumerState<ApplicationPanel> createState() => _ApplicationPanelState();
}

class _ApplicationPanelState extends ConsumerState<ApplicationPanel> {
  final Set<String> _chosen = {};

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(gameControllerProvider)!;
    final ctx = ref.watch(gameContextProvider)!;
    final engine = EntranceExamEngine(ctx);
    final isHigh = s.exam!.kind == 'high';
    final targets = engine.targetsFor(s.exam!.kind);
    final theme = Theme.of(context);
    final chosen = [
      for (final t in targets)
        if (_chosen.contains(t.id)) t,
    ];
    final error = isHigh
        ? EntranceExamEngine.validateHighApplications(chosen)
        : EntranceExamEngine.validateUniversityApplications(chosen);
    final naishin = EntranceExamEngine.naishin10(s.player, high: !isHigh);

    Future<void> submit() async {
      final lines = ref
          .read(gameControllerProvider.notifier)
          .resolveApplication([for (final t in chosen) t.id]);
      if (!context.mounted) return;
      await showResultDialog(context, '出願', lines);
    }

    return SectionCard(
      title: isHigh ? 'イベント：高校の出願' : 'イベント：大学の出願',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            isHigh
                ? '受験する高校を選ぼう。私立（併願）は2校まで、公立は1校まで。'
                      '公立に合格すれば公立へ、そうでなければ合格した私立のうち偏差値の高い学校へ進学する。'
                : '受験する大学を3校まで選ぼう。音楽大学は学力ではなく実技（熟練度・音楽性）で判定される。'
                      '国公立に合格すれば国公立へ、そうでなければ合格した私立のうち偏差値の高い大学へ。'
                      'どこにも合格しなければ浪人になる。',
          ),
          const SizedBox(height: 8),
          KvRow('学力', '${s.player.academic ~/ 10}'),
          KvRow(isHigh ? '内申' : '評定平均', (naishin / 10).toStringAsFixed(1)),
          if (!isHigh)
            KvRow('実技', '熟練度 ${s.player.skill} ／ 音楽性 ${s.player.musicality}'),
          KvRow('部活実績', '+${EntranceExamEngine.clubBonus(s)}'),
          Text(
            '判定：A 合格確実 ／ B 有望 ／ C 五分五分 ／ D 厳しい ／ E 非常に厳しい',
            style: theme.textTheme.bodySmall,
          ),
          const SizedBox(height: 8),
          for (final t in targets)
            CheckboxListTile(
              dense: true,
              value: _chosen.contains(t.id),
              onChanged: (v) => setState(() {
                if (v == true) {
                  _chosen.add(t.id);
                } else {
                  _chosen.remove(t.id);
                }
              }),
              title: Text(
                '${t.name}（${t.isPrivate ? '私立' : (isHigh ? '公立' : '国公立')}）'
                '　判定 ${engine.estimate(s, t)}',
              ),
              subtitle: Text(
                isHigh
                    ? '偏差値 ${t.deviation} ／ 吹奏楽部：${t.clubTier?.label ?? '－'} ／ ${t.note}'
                    : '偏差値 ${t.deviation} ／ ${t.note}',
              ),
            ),
          const SizedBox(height: 8),
          if (error != null)
            Text(error, style: TextStyle(color: theme.colorScheme.error)),
          FilledButton(
            onPressed: error == null ? submit : null,
            child: const Text('この内容で出願する'),
          ),
        ],
      ),
    );
  }
}

/// お知らせ（合格発表・卒業式など）。
class NoticePanel extends ConsumerWidget {
  const NoticePanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(gameControllerProvider)!;
    final data = s.pending!.data;
    return SectionCard(
      title: data['title'] ?? 'お知らせ',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final l in (data['lines'] ?? '').split('\n'))
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(l, style: Theme.of(context).textTheme.bodyLarge),
            ),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: () =>
                ref.read(gameControllerProvider.notifier).resolveNotice(),
            child: const Text('次へ'),
          ),
        ],
      ),
    );
  }
}
