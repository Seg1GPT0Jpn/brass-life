import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../domain/value_objects/school_enums.dart';
import '../../common/widgets/common_widgets.dart';
import '../../world/world_controller.dart';
import 'school_list_view_model.dart';

class SchoolListPage extends ConsumerWidget {
  const SchoolListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rows = ref.watch(filteredSchoolsProvider);
    final f = ref.watch(schoolFilterProvider);
    final vm = ref.read(schoolFilterProvider.notifier);
    final districts = ref.watch(sessionProvider).world.region.districts;
    final theme = Theme.of(context);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              SegmentedButton<SchoolLevel?>(
                segments: const [
                  ButtonSegment(value: null, label: Text('全て')),
                  ButtonSegment(value: SchoolLevel.middle, label: Text('中学')),
                  ButtonSegment(value: SchoolLevel.high, label: Text('高校')),
                ],
                selected: {f.level},
                onSelectionChanged: (s) => vm.setLevel(s.first),
                showSelectedIcon: false,
              ),
              FilterDropdown<String?>(
                value: f.districtId,
                hint: '地区',
                items: [
                  (null, '全地区'),
                  for (final d in districts) (d.id, d.name),
                ],
                onChanged: vm.setDistrict,
              ),
              FilterDropdown<ClubTier?>(
                value: f.tier,
                hint: '強さ',
                items: [
                  (null, '全ての強さ'),
                  for (final t in ClubTier.values) (t, t.label),
                ],
                onChanged: vm.setTier,
              ),
              FilterDropdown<SchoolOwnership?>(
                value: f.ownership,
                hint: '設置',
                items: [
                  (null, '公立・私立'),
                  for (final o in SchoolOwnership.values) (o, o.label),
                ],
                onChanged: vm.setOwnership,
              ),
              FilterDropdown<SchoolSort>(
                value: f.sort,
                hint: '並び順',
                items: [for (final s in SchoolSort.values) (s, s.label)],
                onChanged: (v) => vm.setSort(v ?? SchoolSort.id),
              ),
              Text('${rows.length} 校', style: theme.textTheme.bodySmall),
            ],
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.only(bottom: 16),
            itemCount: rows.length,
            separatorBuilder: (_, _) => const Divider(height: 1),
            itemBuilder: (context, i) {
              final r = rows[i];
              final s = r.school;
              final academic = s.deviation != null
                  ? '偏差値 ${s.deviation}'
                  : '学力 ${s.academicLevel}';
              return ListTile(
                onTap: () => context.go('/debug/schools/${s.id}'),
                leading: CircleAvatar(
                  child: Text(s.level == SchoolLevel.middle ? '中' : '高'),
                ),
                title: Row(
                  children: [
                    if (r.isPlayerSchool)
                      const Padding(
                        padding: EdgeInsets.only(right: 4),
                        child: Icon(Icons.person_pin, size: 18),
                      ),
                    Flexible(
                      child: Text(s.name, overflow: TextOverflow.ellipsis),
                    ),
                    const SizedBox(width: 8),
                    TierBadge(r.club.tier),
                  ],
                ),
                subtitle: Text(
                  '${r.districtName}・${s.town} ／ ${s.ownership.label} ／ $academic ／ '
                  '部員 ${r.club.memberIds.length} 人 ／ ${r.club.executiveSystem.label.split('：').first}\n'
                  '${s.cultures.map((c) => c.label).join('・')}',
                ),
                isThreeLine: true,
              );
            },
          ),
        ),
      ],
    );
  }
}
