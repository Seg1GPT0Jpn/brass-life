import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/time/game_calendar.dart';
import '../../../domain/master/trait_definitions.dart';
import '../../common/widgets/common_widgets.dart';
import '../../world/world_controller.dart';
import 'overview_view_model.dart';

class OverviewPage extends ConsumerWidget {
  const OverviewPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(sessionProvider);
    final stats = ref.watch(worldStatsProvider);
    final w = session.world;
    final region = w.region;
    final player = w.player;
    final playerSchool = session.index.schoolById[player.schoolId]!;
    final start = session.calendar.dateOf(0);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        SectionCard(
          title: 'Seed',
          trailing: IconButton(
            tooltip: 'シードコードをコピー',
            icon: const Icon(Icons.copy, size: 18),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: session.meta.seedCode));
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('シードコードをコピーしました')));
            },
          ),
          child: Column(
            children: [
              KvRow('シードコード', session.meta.seedCode),
              KvRow('入力', session.meta.input),
              KvRow('Seed 値', '${w.seed}'),
              KvRow('生成器バージョン', 'v${w.generatorVersion}'),
              KvRow('フィンガープリント', session.meta.fingerprint),
            ],
          ),
        ),
        const _VerificationCard(),
        SectionCard(
          title: '舞台',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              KvRow('県', region.prefectureName),
              KvRow('連盟', region.federationName),
              KvRow('コンクール', region.contestName),
              KvRow('支部', region.blockName),
              KvRow('開始', start.labelWithStage),
              const SizedBox(height: 8),
              for (final d in region.districts)
                KvRow(d.name, d.towns.join('・')),
            ],
          ),
        ),
        SectionCard(
          title: 'プレイヤー（Seed により自動決定）',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              KvRow('名前', '${player.fullName}（${player.gender.label}）'),
              KvRow(
                '所属',
                playerSchool.name,
                onTap: () => context.go('/debug/schools/${playerSchool.id}'),
              ),
              KvRow('音楽経験', player.background.label),
              KvRow('学力 / 体力', '${player.academic} / ${player.stamina}'),
              const SizedBox(height: 6),
              TraitChips(player.traits),
              const SizedBox(height: 8),
              Text('楽器適性 上位', style: Theme.of(context).textTheme.labelLarge),
              for (final (t, fit) in player.aptitude.rankedFits().take(5))
                ValueBar(label: t.label, value: fit, max: 100),
            ],
          ),
        ),
        SectionCard(
          title: '規模',
          child: Column(
            children: [
              KvRow(
                '学校',
                '${stats.middleCount + stats.highCount} 校'
                    '（中学 ${stats.middleCount} / 高校 ${stats.highCount}、うち私立 ${stats.privateCount}）',
              ),
              KvRow('NPC', '${w.npcs.length} 人'),
              KvRow('記憶（履歴）', '${stats.memoryCount} 件'),
              const SizedBox(height: 8),
              DistributionBars(entries: stats.npcByRole),
              const Divider(),
              DistributionBars(entries: stats.studentsByGrade),
            ],
          ),
        ),
        _StatCard('強さ帯（中学）', stats.tierMiddle),
        _StatCard('強さ帯（高校）', stats.tierHigh),
        _StatCard('高校の偏差値分布（層化抽選）', stats.deviationBands),
        _StatCard('幹部制度', stats.executive, labelWidth: 150),
        _StatCard('幹部の選出文化', stats.selection),
        _StatCard('部の雰囲気', stats.mood),
        _StatCard('性格タグの出現数', stats.traitCounts),
        _StatCard('担当楽器（上級生）', stats.instrumentPlayers, labelWidth: 130),
        _StatCard('新入生の希望楽器', stats.wishes, labelWidth: 130),
        const _CalendarCard(),
        SectionCard(
          title: '性格タグ一覧',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (final t in traitDefinitions)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: '${t.label}（${t.category.label}）',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        TextSpan(text: '  ${t.description}'),
                      ],
                    ),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard(this.title, this.entries, {this.labelWidth = 112});

  final String title;
  final List<(String, int)> entries;
  final double labelWidth;

  @override
  Widget build(BuildContext context) => SectionCard(
    title: title,
    child: DistributionBars(entries: entries, labelWidth: labelWidth),
  );
}

class _VerificationCard extends ConsumerWidget {
  const _VerificationCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(verificationViewModelProvider);
    final theme = Theme.of(context);
    return SectionCard(
      title: '決定性の検証',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            '同じ Seed で世界をもう一度生成し、全データのフィンガープリントが一致するか確認します。',
            style: theme.textTheme.bodySmall,
          ),
          const SizedBox(height: 8),
          switch (state) {
            VerificationIdle() => const SizedBox.shrink(),
            VerificationRunning() => const LinearProgressIndicator(),
            VerificationDone(
              :final matched,
              :final expected,
              :final actual,
              :final elapsedMs,
            ) =>
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Icon(
                        matched ? Icons.check_circle : Icons.error,
                        color: matched ? Colors.green : theme.colorScheme.error,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        matched ? '完全一致（再現性 OK）' : '不一致！',
                        style: theme.textTheme.titleSmall,
                      ),
                    ],
                  ),
                  KvRow('元の世界', expected),
                  KvRow('再生成', actual),
                  KvRow('再生成時間', '$elapsedMs ms'),
                ],
              ),
          },
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerLeft,
            child: OutlinedButton.icon(
              onPressed: state is VerificationRunning
                  ? null
                  : ref.read(verificationViewModelProvider.notifier).run,
              icon: const Icon(Icons.replay),
              label: const Text('再生成して比較'),
            ),
          ),
        ],
      ),
    );
  }
}

class _CalendarCard extends ConsumerWidget {
  const _CalendarCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cal = ref.watch(sessionProvider).calendar;
    final theme = Theme.of(context);
    const stages = ['中1', '中2', '中3', '高1', '高2', '高3'];
    final first = cal.dateOf(0);
    final months = <(int, int)>[];
    for (var m = 4; m <= 15; m++) {
      final month = m > 12 ? m - 12 : m;
      final year = m > 12 ? first.year + 1 : first.year;
      months.add((year, month));
    }
    return SectionCard(
      title: 'カレンダー（実カレンダー準拠・1 ターン = 1 週）',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            '${first.fiscalYear}年度（中1）の月ごとの週数',
            style: theme.textTheme.labelLarge,
          ),
          const SizedBox(height: 6),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              for (final (y, m) in months)
                Chip(
                  visualDensity: VisualDensity.compact,
                  label: Text('$m月 ${GameCalendar.mondaysInMonth(y, m)}週'),
                ),
            ],
          ),
          const SizedBox(height: 10),
          for (var ay = 0; ay < 6; ay++)
            KvRow(
              stages[ay],
              '${cal.dateOf(cal.firstTurnOfAcademicYear(ay)).label} 〜'
              '（${cal.weeksInAcademicYear(ay)} ターン、'
              'ターン ${cal.firstTurnOfAcademicYear(ay)}〜）',
            ),
        ],
      ),
    );
  }
}
