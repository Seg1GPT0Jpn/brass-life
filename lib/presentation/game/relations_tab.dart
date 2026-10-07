import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../domain/game/engine/relations.dart';
import '../../domain/value_objects/relationship_vector.dart';
import '../common/widgets/common_widgets.dart';
import '../debug/npc_detail/npc_detail_page.dart';
import 'game_controller.dart';

enum _RelSort {
  affection('好感度順'),
  trust('信頼度順'),
  rivalry('ライバル度順'),
  dislike('険悪な順');

  const _RelSort(this.label);
  final String label;
}

/// 人間関係: 部員から見たあなた・部内の最近の出来事。
class RelationsTab extends ConsumerStatefulWidget {
  const RelationsTab({super.key});

  @override
  ConsumerState<RelationsTab> createState() => _RelationsTabState();
}

class _RelationsTabState extends ConsumerState<RelationsTab> {
  _RelSort _sort = _RelSort.affection;

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(gameControllerProvider)!;
    final ctx = ref.watch(gameContextProvider)!;
    final theme = Theme.of(context);
    final members = ctx.activeMembers(s);

    int key(RelationshipVector v) => switch (_sort) {
      _RelSort.affection => v.affection,
      _RelSort.trust => v.trust,
      _RelSort.rivalry => v.rivalry,
      _RelSort.dislike => -v.affection,
    };
    final rows =
        [
          for (final m in members)
            (
              m,
              Relations.get(s, m.id, Relations.player),
              Relations.get(s, Relations.player, m.id),
            ),
        ]..sort((a, b) {
          final c = key(b.$2).compareTo(key(a.$2));
          return c != 0 ? c : a.$1.id.compareTo(b.$1.id);
        });

    final recentTurn = s.turn - 4;
    final recent = [
      for (final m in s.memories.reversed)
        if (m.date.turn >= recentTurn &&
            m.objectIds.isNotEmpty &&
            m.reasonKey != 'instrument_wish_granted' &&
            m.reasonKey != 'instrument_wish_denied')
          m,
    ];

    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        SectionCard(
          title: '最近の部内の出来事（4週間）',
          child: recent.isEmpty
              ? Text('特に目立った出来事はない。', style: theme.textTheme.bodySmall)
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [for (final m in recent.take(30)) MemoryTile(m)],
                ),
        ),
        SectionCard(
          title: '部員から見たあなた',
          trailing: FilterDropdown<_RelSort>(
            value: _sort,
            items: [for (final v in _RelSort.values) (v, v.label)],
            onChanged: (v) => setState(() => _sort = v ?? _RelSort.affection),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                '棒は「相手→あなた」の好感・信頼・ライバル心。右の数字は「あなた→相手」。'
                'タップすると関係の履歴（なぜ変わったか）が見られる。',
                style: theme.textTheme.bodySmall,
              ),
              const SizedBox(height: 8),
              for (final (m, toMe, fromMe) in rows)
                InkWell(
                  onTap: () => context.go('/game/person/${m.id}'),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          '${ctx.npc(s, m.id).fullName}（${m.grade}年・${m.instrument?.label ?? '未定'}）',
                          style: theme.textTheme.bodyMedium,
                        ),
                        RelationBars(toMe, compareTo: fromMe),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

/// 関係性ベクトルの 3 本棒。
class RelationBars extends StatelessWidget {
  const RelationBars(this.v, {super.key, this.compareTo});

  final RelationshipVector v;
  final RelationshipVector? compareTo;

  @override
  Widget build(BuildContext context) {
    String text(int a, int? b) => b == null ? '$a' : '$a／$b';
    return Column(
      children: [
        ValueBar(
          label: '好感',
          value: v.affection,
          min: -100,
          max: 100,
          labelWidth: 48,
          valueText: text(v.affection, compareTo?.affection),
        ),
        ValueBar(
          label: '信頼',
          value: v.trust,
          min: -100,
          max: 100,
          labelWidth: 48,
          valueText: text(v.trust, compareTo?.trust),
        ),
        ValueBar(
          label: 'ライバル',
          value: v.rivalry,
          min: -100,
          max: 100,
          labelWidth: 48,
          valueText: text(v.rivalry, compareTo?.rivalry),
        ),
      ],
    );
  }
}

/// 人物詳細: 基本情報・あなたとの関係・その人の人間関係・関係の履歴。
class PersonPage extends ConsumerWidget {
  const PersonPage({super.key, required this.npcId});

  final String npcId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(gameControllerProvider);
    final ctx = ref.watch(gameContextProvider);
    if (s == null || ctx == null || ctx.npcOrNull(s, npcId) == null) {
      return const Scaffold(body: Center(child: Text('見つかりません')));
    }
    final n = ctx.npc(s, npcId);
    final st = s.npcs[npcId];
    final theme = Theme.of(context);

    String nameOf(String id) =>
        id == Relations.player ? 'あなた' : (ctx.npcOrNull(s, id)?.fullName ?? id);

    final outgoing = <(String, RelationshipVector)>[];
    final prefix = '$npcId>';
    for (final e in s.relations.entries) {
      if (e.key.startsWith(prefix)) {
        outgoing.add((e.key.substring(prefix.length), e.value));
      }
    }
    final friends = [...outgoing]
      ..sort((a, b) => b.$2.affection.compareTo(a.$2.affection));
    final rivals = [...outgoing]
      ..sort((a, b) => b.$2.rivalry.compareTo(a.$2.rivalry));
    final history = [
      for (final m in s.memories.reversed)
        if (m.subjectId == npcId || m.objectIds.contains(npcId)) m,
    ];

    return Scaffold(
      appBar: AppBar(title: Text(n.fullName)),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          SectionCard(
            title: '基本情報',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                KvRow(
                  '学年',
                  st == null
                      ? '－'
                      : (st.active ? '${st.grade}年' : (st.quit ? '退部' : '卒業')),
                ),
                KvRow('担当', st?.instrument?.label ?? '未定'),
                if (st != null) ...[
                  ValueBar(label: '熟練度', value: st.skill, max: 1000),
                  ValueBar(label: 'やる気', value: st.motivation, max: 100),
                  ValueBar(label: 'ストレス', value: st.stress, max: 100),
                ],
                const SizedBox(height: 6),
                TraitChips(n.traits),
              ],
            ),
          ),
          SectionCard(
            title: 'あなたとの関係',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('相手 → あなた', style: theme.textTheme.labelLarge),
                RelationBars(Relations.get(s, npcId, Relations.player)),
                const SizedBox(height: 8),
                Text('あなた → 相手', style: theme.textTheme.labelLarge),
                RelationBars(Relations.get(s, Relations.player, npcId)),
              ],
            ),
          ),
          SectionCard(
            title: 'この人の人間関係',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('好意を持っている相手', style: theme.textTheme.labelLarge),
                for (final (id, v)
                    in friends.where((e) => e.$2.affection > 0).take(5))
                  KvRow(nameOf(id), '好感 ${v.affection} ／ 信頼 ${v.trust}'),
                const SizedBox(height: 8),
                Text('苦手な相手', style: theme.textTheme.labelLarge),
                for (final (id, v)
                    in friends.reversed
                        .where((e) => e.$2.affection < 0)
                        .take(5))
                  KvRow(nameOf(id), '好感 ${v.affection} ／ 信頼 ${v.trust}'),
                const SizedBox(height: 8),
                Text('ライバル視している相手', style: theme.textTheme.labelLarge),
                for (final (id, v)
                    in rivals.where((e) => e.$2.rivalry > 0).take(5))
                  KvRow(nameOf(id), 'ライバル度 ${v.rivalry}'),
              ],
            ),
          ),
          SectionCard(
            title: '関係の履歴（なぜ変わったか）${history.length}件',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (history.isEmpty)
                  Text('まだ記録はない。', style: theme.textTheme.bodySmall),
                for (final m in history.take(100)) MemoryTile(m),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
