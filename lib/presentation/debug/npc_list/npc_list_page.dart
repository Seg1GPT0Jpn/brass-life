import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../domain/master/trait_definitions.dart';
import '../../../domain/value_objects/instrument.dart';
import '../../../domain/value_objects/person_enums.dart';
import '../../common/widgets/common_widgets.dart';
import '../../world/world_controller.dart';
import 'npc_list_view_model.dart';

class NpcListPage extends ConsumerWidget {
  const NpcListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final npcs = ref.watch(filteredNpcsProvider);
    final f = ref.watch(npcFilterProvider);
    final vm = ref.read(npcFilterProvider.notifier);
    final session = ref.watch(sessionProvider);
    final schools = session.world.schools;
    final schoolById = session.index.schoolById;
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
              SizedBox(
                width: 200,
                child: TextField(
                  decoration: const InputDecoration(
                    isDense: true,
                    prefixIcon: Icon(Icons.search, size: 18),
                    hintText: '名前・ID',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: vm.setQuery,
                ),
              ),
              FilterDropdown<String?>(
                value: f.schoolId,
                items: [
                  (null, '全ての学校'),
                  for (final s in schools) (s.id, s.name),
                ],
                onChanged: vm.setSchool,
              ),
              FilterDropdown<NpcRole?>(
                value: f.role,
                items: [
                  (null, '全ての役割'),
                  for (final r in NpcRole.values) (r, r.label),
                ],
                onChanged: vm.setRole,
              ),
              FilterDropdown<int?>(
                value: f.grade,
                items: const [(null, '全学年'), (1, '1年'), (2, '2年'), (3, '3年')],
                onChanged: vm.setGrade,
              ),
              FilterDropdown<InstrumentType?>(
                value: f.instrument,
                items: [
                  (null, '全ての楽器'),
                  for (final t in InstrumentType.values) (t, t.label),
                ],
                onChanged: vm.setInstrument,
              ),
              FilterDropdown<String?>(
                value: f.traitId,
                items: [
                  (null, '全ての性格'),
                  for (final t in traitDefinitions) (t.id, t.label),
                ],
                onChanged: vm.setTrait,
              ),
              if (!f.isEmpty)
                TextButton(onPressed: vm.reset, child: const Text('条件クリア')),
              Text('${npcs.length} 人', style: theme.textTheme.bodySmall),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: npcs.length,
            itemExtent: 76,
            itemBuilder: (context, i) {
              final n = npcs[i];
              final school = schoolById[n.schoolId]!;
              final who = n.role == NpcRole.student
                  ? '${n.grade}年'
                  : '${n.role.label}・${n.age}歳';
              return ListTile(
                onTap: () => context.go('/debug/npcs/${n.id}'),
                title: Text(
                  '${n.fullName}（${n.gender.label}）  $who',
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${school.name} ／ ${n.role == NpcRole.student ? instrumentSummary(n) : n.advisorProfile!.style.label}',
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    TraitChips(n.traits, dense: true, max: 4),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
