import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../domain/entities/npc.dart';
import '../../../domain/value_objects/instrument.dart';
import '../../common/widgets/common_widgets.dart';
import 'school_detail_view_model.dart';

class SchoolDetailPage extends ConsumerWidget {
  const SchoolDetailPage({super.key, required this.schoolId});

  final String schoolId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final d = ref.watch(schoolDetailProvider(schoolId));
    if (d == null) {
      return const Scaffold(body: Center(child: Text('学校が見つかりません')));
    }
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text(d.school.name),
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: '基本'),
              Tab(text: '部活'),
              Tab(text: '楽器'),
              Tab(text: '部員'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _BasicTab(d),
            _ClubTab(d),
            _InstrumentTab(d),
            _MembersTab(d),
          ],
        ),
      ),
    );
  }
}

class _BasicTab extends StatelessWidget {
  const _BasicTab(this.d);
  final SchoolDetail d;

  @override
  Widget build(BuildContext context) {
    final s = d.school;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        SectionCard(
          title: '学校情報',
          child: Column(
            children: [
              if (d.isPlayerSchool) const KvRow('', '★ プレイヤーの所属校'),
              KvRow('校種', s.level.label),
              KvRow('設置', '${s.ownership.label}${s.girlsOnly ? '（女子校）' : ''}'),
              KvRow('所在地', '${d.district.name}・${s.town}'),
              KvRow('創立', '${s.foundedYear}年'),
              KvRow('生徒数', '${s.studentCount} 人'),
              if (s.deviation != null) KvRow('偏差値', '${s.deviation}'),
              KvRow('学力水準', '${s.academicLevel}'),
              if (d.affiliated != null)
                KvRow(
                  '系列校',
                  d.affiliated!.name,
                  onTap: () => context.go('/debug/schools/${d.affiliated!.id}'),
                ),
            ],
          ),
        ),
        SectionCard(
          title: '校風',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (final c in s.cultures) KvRow(c.label, c.description),
            ],
          ),
        ),
      ],
    );
  }
}

class _ClubTab extends StatelessWidget {
  const _ClubTab(this.d);
  final SchoolDetail d;

  @override
  Widget build(BuildContext context) {
    final c = d.club;
    final a = d.advisor;
    final ap = a.advisorProfile!;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        SectionCard(
          title: '吹奏楽部',
          trailing: TierBadge(c.tier),
          child: Column(
            children: [
              KvRow(
                '部員数',
                '${c.memberIds.length} 人（3年 ${d.membersByGrade[0].length} / '
                    '2年 ${d.membersByGrade[1].length} / 新1年 ${d.membersByGrade[2].length}）',
              ),
              KvRow('出場部門', c.division.label),
              KvRow('伝統値', '${c.tradition}'),
              KvRow(
                '練習強度',
                '${'●' * c.practiceIntensity}${'○' * (5 - c.practiceIntensity)}',
              ),
              KvRow('雰囲気', '${c.mood.label}（${c.mood.description}）'),
              KvRow('予算', c.budget.label),
            ],
          ),
        ),
        SectionCard(
          title: '部内政治',
          child: Column(
            children: [
              KvRow('幹部制度', c.executiveSystem.label),
              KvRow('', c.executiveSystem.description),
              KvRow(
                '選出文化',
                '${c.selectionCulture.label}（${c.selectionCulture.description}）',
              ),
            ],
          ),
        ),
        SectionCard(
          title: '指導者',
          child: Column(
            children: [
              KvRow(
                '顧問',
                '${a.fullName}（${a.age}歳）',
                onTap: () => context.go('/debug/npcs/${a.id}'),
              ),
              KvRow('指導スタイル', '${ap.style.label}：${ap.style.description}'),
              KvRow('指導力 / 熱意', '${ap.teachingSkill} / ${ap.passion}'),
              KvRow(
                '在任',
                ap.isNewlyTransferred
                    ? '今年度着任（指導歴 ${ap.careerYears} 年）'
                    : '${ap.yearsAtSchool} 年目（指導歴 ${ap.careerYears} 年）',
              ),
              KvRow('専門', ap.specialty.label),
              if (d.coach != null)
                KvRow(
                  '外部講師',
                  '${d.coach!.fullName}（${d.coach!.advisorProfile!.specialty.label}・'
                      '指導力 ${d.coach!.advisorProfile!.teachingSkill}）',
                  onTap: () => context.go('/debug/npcs/${d.coach!.id}'),
                ),
            ],
          ),
        ),
        SectionCard(
          title: '過去のコンクール成績',
          child: Column(
            children: [
              for (final h in c.history.reversed)
                KvRow('${h.fiscalYear}年度', '${h.summary}（${h.division.label}）'),
            ],
          ),
        ),
      ],
    );
  }
}

class _InstrumentTab extends StatelessWidget {
  const _InstrumentTab(this.d);
  final SchoolDetail d;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          '学校所有の楽器と、上級生の担当者数・新入生の希望者数。'
          '「要修理」は使用できない。担当者が使用可能台数を超えた分は私物。',
          style: theme.textTheme.bodySmall,
        ),
        const SizedBox(height: 12),
        Card(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columnSpacing: 16,
              columns: const [
                DataColumn(label: Text('楽器')),
                DataColumn(label: Text('保有'), numeric: true),
                DataColumn(label: Text('使用可'), numeric: true),
                DataColumn(label: Text('状態内訳')),
                DataColumn(label: Text('担当'), numeric: true),
                DataColumn(label: Text('うち私物'), numeric: true),
                DataColumn(label: Text('新入生希望'), numeric: true),
              ],
              rows: [
                for (final r in d.instruments)
                  DataRow(
                    cells: [
                      DataCell(Text(r.type.label)),
                      DataCell(Text('${r.owned}')),
                      DataCell(Text('${r.usable}')),
                      DataCell(
                        Text(
                          r.byCondition.isEmpty
                              ? '（保有なし）'
                              : [
                                  for (final c in InstrumentCondition.values)
                                    if (r.byCondition[c] != null)
                                      '${c.label}${r.byCondition[c]}',
                                ].join(' '),
                        ),
                      ),
                      DataCell(Text('${r.players}')),
                      DataCell(Text('${r.personalPlayers}')),
                      DataCell(
                        Text(
                          '${r.wishes}',
                          style: r.wishes > r.usable - r.players
                              ? TextStyle(color: theme.colorScheme.error)
                              : null,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _MembersTab extends StatelessWidget {
  const _MembersTab(this.d);
  final SchoolDetail d;

  @override
  Widget build(BuildContext context) {
    const labels = ['3年生', '2年生', '新1年生（楽器未決定）'];
    final items = <Widget>[];
    for (var i = 0; i < 3; i++) {
      items.add(
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
          child: Text(
            '${labels[i]}（${d.membersByGrade[i].length}人）',
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ),
      );
      for (final m in d.membersByGrade[i]) {
        items.add(_MemberTile(m));
      }
    }
    return ListView(children: items);
  }
}

class _MemberTile extends StatelessWidget {
  const _MemberTile(this.m);
  final Npc m;

  @override
  Widget build(BuildContext context) {
    final skill = m.instrument != null
        ? ' ／ 熟練度 ${m.instrumentSkill}${m.ownsPersonalInstrument ? '（私物）' : ''}'
        : (m.previousInstrument != null
              ? ' ／ 経験: ${m.previousInstrument!.label}'
              : '');
    return ListTile(
      dense: true,
      onTap: () => context.go('/debug/npcs/${m.id}'),
      title: Text('${m.fullName}（${m.gender.label}）'),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${instrumentSummary(m)}$skill ／ ${m.background.label}'),
          const SizedBox(height: 2),
          TraitChips(m.traits, dense: true),
        ],
      ),
    );
  }
}
