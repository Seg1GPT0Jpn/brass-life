import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../domain/entities/memory_tag.dart';
import '../../../domain/entities/npc.dart';
import '../../../domain/entities/school.dart';
import '../../../domain/master/memory_templates.dart';
import '../../../domain/master/trait_definitions.dart';
import '../../../domain/value_objects/instrument.dart';
import '../../../domain/value_objects/person_enums.dart';
import '../../common/widgets/common_widgets.dart';
import '../../world/world_controller.dart';

class NpcDetail {
  const NpcDetail({
    required this.npc,
    required this.school,
    required this.memories,
  });

  final Npc npc;
  final School school;
  final List<MemoryTag> memories;
}

final npcDetailProvider = Provider.family<NpcDetail?, String>((ref, id) {
  final idx = ref.watch(sessionProvider).index;
  final npc = idx.npcById[id];
  if (npc == null) return null;
  return NpcDetail(
    npc: npc,
    school: idx.schoolOf(npc),
    memories: idx.memoriesOf(id),
  );
});

class NpcDetailPage extends ConsumerWidget {
  const NpcDetailPage({super.key, required this.npcId});

  final String npcId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final d = ref.watch(npcDetailProvider(npcId));
    if (d == null) {
      return const Scaffold(body: Center(child: Text('NPC が見つかりません')));
    }
    final n = d.npc;
    final p = n.personality;
    final a = n.aptitude;
    final isStudent = n.role == NpcRole.student;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(n.fullName)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SectionCard(
            title: '基本情報',
            child: Column(
              children: [
                KvRow('ID', n.id),
                KvRow('性別', n.gender.label),
                KvRow(
                  '所属',
                  d.school.name,
                  onTap: () => context.go('/debug/schools/${d.school.id}'),
                ),
                KvRow(
                  '役割',
                  isStudent
                      ? '${n.role.label}（${n.grade}年）'
                      : '${n.role.label}（${n.age}歳）',
                ),
                if (isStudent) KvRow('音楽経験', n.background.label),
                KvRow('学力 / 体力', '${n.academic} / ${n.stamina}'),
              ],
            ),
          ),
          SectionCard(
            title: '性格タグ',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (final t in n.traits)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TraitChip(t),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            traitById[t.traitId]?.description ?? '',
                            style: theme.textTheme.bodySmall,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          SectionCard(
            title: '性格軸（隠し値）',
            child: Column(
              children: [
                ValueBar(
                  label: '外向性',
                  value: p.extraversion,
                  min: -100,
                  max: 100,
                ),
                ValueBar(
                  label: '協調性',
                  value: p.agreeableness,
                  min: -100,
                  max: 100,
                ),
                ValueBar(
                  label: '勤勉性',
                  value: p.conscientiousness,
                  min: -100,
                  max: 100,
                ),
                ValueBar(
                  label: '情緒不安定性',
                  value: p.neuroticism,
                  min: -100,
                  max: 100,
                ),
                ValueBar(label: '野心', value: p.ambition, min: -100, max: 100),
              ],
            ),
          ),
          SectionCard(
            title: '音楽適性（隠し値）',
            child: Column(
              children: [
                for (final k in AptitudeKind.values)
                  ValueBar(label: k.label, value: a.valueOf(k), max: 100),
              ],
            ),
          ),
          if (isStudent)
            SectionCard(
              title: '楽器',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (n.instrument != null) ...[
                    KvRow(
                      '担当',
                      '${n.instrument!.label}${n.ownsPersonalInstrument ? '（私物）' : '（学校所有）'}',
                    ),
                    ValueBar(label: '熟練度', value: n.instrumentSkill, max: 1000),
                  ],
                  if (n.wishInstrument != null)
                    KvRow('希望楽器', n.wishInstrument!.label),
                  if (n.previousInstrument != null)
                    KvRow(
                      '中学での担当',
                      '${n.previousInstrument!.label}（熟練度 ${n.previousSkill}）',
                    ),
                  const SizedBox(height: 8),
                  Text('楽器適性 上位', style: theme.textTheme.labelLarge),
                  for (final (t, fit) in a.rankedFits().take(6))
                    ValueBar(label: t.label, value: fit, max: 100),
                ],
              ),
            ),
          if (n.advisorProfile != null)
            SectionCard(
              title: '指導者プロフィール',
              child: Column(
                children: [
                  KvRow(
                    'スタイル',
                    '${n.advisorProfile!.style.label}：${n.advisorProfile!.style.description}',
                  ),
                  ValueBar(
                    label: '指導力',
                    value: n.advisorProfile!.teachingSkill,
                    max: 100,
                  ),
                  ValueBar(
                    label: '熱意',
                    value: n.advisorProfile!.passion,
                    max: 100,
                  ),
                  KvRow('指導歴', '${n.advisorProfile!.careerYears} 年'),
                  KvRow('在任', '${n.advisorProfile!.yearsAtSchool} 年目'),
                  KvRow('専門', n.advisorProfile!.specialty.label),
                ],
              ),
            ),
          SectionCard(
            title: '記憶（MemoryTag）${d.memories.length} 件',
            child: d.memories.isEmpty
                ? Text('まだ記憶はありません', style: theme.textTheme.bodySmall)
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [for (final m in d.memories) MemoryTile(m)],
                  ),
          ),
        ],
      ),
    );
  }
}

/// 記憶 1 件の表示。
class MemoryTile extends StatelessWidget {
  const MemoryTile(this.m, {super.key, this.subjectName, this.onSubjectTap});

  final MemoryTag m;
  final String? subjectName;
  final VoidCallback? onSubjectTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 128,
            child: Text(
              '${m.date.label}\n（${m.date.stageLabel}）',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (subjectName != null)
                  InkWell(
                    onTap: onSubjectTap,
                    child: Text(
                      subjectName!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                Text(renderMemory(m.reasonKey, m.params)),
                Text(
                  '[${m.category.label}] 重要度 ${m.importance} ／ ${m.visibility.label}'
                  '${m.delta == null ? '' : ' ／ 好感${m.delta!.affection} 信頼${m.delta!.trust} ライバル${m.delta!.rivalry}'}',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.outline,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
