import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/game/models/game_enums.dart';
import '../common/widgets/common_widgets.dart';
import '../debug/npc_detail/npc_detail_page.dart';
import 'game_controller.dart';

/// 記録: 自分の記憶・成績・行動の累計。
class RecordsTab extends ConsumerWidget {
  const RecordsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(gameControllerProvider)!;
    final p = s.player;
    final mine = [
      for (final m in s.memories.reversed)
        if (m.subjectId == 'player') m,
    ];
    const stages = ['中1', '中2', '中3', '高1', '高2', '高3'];
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        SectionCard(
          title: '成績',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (p.exams.isEmpty) const Text('まだテストを受けていません。'),
              for (final e in p.exams.reversed)
                KvRow(
                  '${e.academicYearIndex >= 0 && e.academicYearIndex < 6 ? stages[e.academicYearIndex] : ''} ${e.name}',
                  '${e.score} 点',
                ),
              if (p.termGrades.isNotEmpty) ...[
                const Divider(),
                for (final g in p.termGrades.reversed)
                  KvRow(
                    '${stages[g.academicYearIndex.clamp(0, 5)]} ${g.term}学期',
                    '評定 ${g.grade}',
                  ),
              ],
            ],
          ),
        ),
        SectionCard(
          title: '実績',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (s.achievements.isEmpty) const Text('まだ実績はありません。'),
              for (final a in s.achievements.reversed) Text('・${a.label}'),
            ],
          ),
        ),
        SectionCard(
          title: '部のコンクール成績（在籍中）',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (s.clubHistory.isEmpty) const Text('まだありません。'),
              for (final h in s.clubHistory.reversed)
                KvRow('${h.fiscalYear}年度', '${h.summary}（${h.division.label}）'),
              if (s.contest != null)
                for (final r in s.contest!.results) ...[
                  const Divider(),
                  Text(
                    '${s.contest!.fiscalYear}年度 ${r.stage.label}：${r.award.label}'
                    '${r.advanced ? '（代表）' : ''}　${r.entrants}団体中 ${r.rank}位',
                  ),
                  for (final b in r.board)
                    Text('　$b', style: Theme.of(context).textTheme.bodySmall),
                ],
            ],
          ),
        ),
        SectionCard(
          title: '行動の記録',
          child: Column(
            children: [
              for (final e in p.actionCounts.entries)
                KvRow(_actionLabel(e.key), '${e.value} 回'),
            ],
          ),
        ),
        SectionCard(
          title: '自分の記憶（${mine.length}件）',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [for (final m in mine.take(80)) MemoryTile(m)],
          ),
        ),
      ],
    );
  }

  static String _actionLabel(String name) => WeeklyAction.values
      .firstWhere((a) => a.name == name, orElse: () => WeeklyAction.rest)
      .label;
}
