import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../domain/entities/memory_tag.dart';
import '../../common/widgets/common_widgets.dart';
import '../../world/world_controller.dart';
import '../npc_detail/npc_detail_page.dart';

class MemoryLogFilter extends Notifier<MemoryCategory?> {
  @override
  MemoryCategory? build() => null;

  void set(MemoryCategory? c) => state = c;
}

final memoryLogFilterProvider =
    NotifierProvider<MemoryLogFilter, MemoryCategory?>(MemoryLogFilter.new);

/// 新しい順（同ターン内は ID 順）に並べた記憶。
final memoryLogProvider = Provider<List<MemoryTag>>((ref) {
  final world = ref.watch(sessionProvider).world;
  final category = ref.watch(memoryLogFilterProvider);
  final list = [
    for (final m in world.memories)
      if (category == null || m.category == category) m,
  ];
  list.sort((a, b) {
    final c = b.date.turn.compareTo(a.date.turn);
    return c != 0 ? c : a.id.compareTo(b.id);
  });
  return list;
});

class MemoryLogPage extends ConsumerWidget {
  const MemoryLogPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final list = ref.watch(memoryLogProvider);
    final category = ref.watch(memoryLogFilterProvider);
    final idx = ref.watch(sessionProvider).index;
    final used = {
      for (final m in ref.watch(sessionProvider).world.memories) m.category,
    };

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
          child: Wrap(
            spacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              FilterDropdown<MemoryCategory?>(
                value: category,
                items: [
                  (null, '全カテゴリ'),
                  for (final c in MemoryCategory.values)
                    if (used.contains(c)) (c, c.label),
                ],
                onChanged: ref.read(memoryLogFilterProvider.notifier).set,
              ),
              Text(
                '${list.length} 件',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              Text(
                '※ Phase 1 ではゲーム開始前の背景（入部・過去のコンクール・着任）のみ',
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: list.length,
            itemBuilder: (context, i) {
              final m = list[i];
              final subject = idx.npcById[m.subjectId];
              return MemoryTile(
                m,
                subjectName: subject == null
                    ? m.subjectId
                    : '${subject.fullName}（${idx.schoolOf(subject).name}）',
                onSubjectTap: () => context.go('/debug/npcs/${m.subjectId}'),
              );
            },
          ),
        ),
      ],
    );
  }
}
