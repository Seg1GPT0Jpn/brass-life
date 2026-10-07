import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../domain/game/engine/game_context.dart';
import '../../domain/game/models/game_state.dart';
import '../common/widgets/common_widgets.dart';
import 'game_controller.dart';

/// 部員一覧（学年ごと）。
class MembersTab extends ConsumerWidget {
  const MembersTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(gameControllerProvider)!;
    final ctx = ref.watch(gameContextProvider)!;
    final members = ctx.activeMembers(s);
    final items = <Widget>[];
    for (var g = 3; g >= 1; g--) {
      final list = [
        for (final m in members)
          if (m.grade == g) m,
      ]..sort((a, b) => b.skill.compareTo(a.skill));
      final withPlayer = s.player.grade == g;
      items.add(
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
          child: Text(
            '$g年生（${list.length + (withPlayer ? 1 : 0)}人）',
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ),
      );
      if (withPlayer) {
        items.add(
          ListTile(
            dense: true,
            leading: const Icon(Icons.person),
            title: Text('${s.player.fullName}（あなた）'),
            subtitle: Text(
              '${s.player.instrument?.label ?? '未定'} ／ 熟練度 ${s.player.skill}',
            ),
          ),
        );
      }
      for (final m in list) {
        items.add(
          MemberTile(
            ctx: ctx,
            state: s,
            member: m,
            onTap: () => context.go('/game/person/${m.id}'),
          ),
        );
      }
    }
    return ListView(children: items);
  }
}

class MemberTile extends StatelessWidget {
  const MemberTile({
    super.key,
    required this.ctx,
    required this.state,
    required this.member,
    this.trailing,
    this.onTap,
  });

  final GameContext ctx;
  final GameState state;
  final NpcState member;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final n = ctx.npc(state, member.id);
    final inst =
        member.instrument?.label ??
        (member.wish == null ? '未定' : '未定（希望: ${member.wish!.label}）');
    return ListTile(
      dense: true,
      onTap: onTap,
      title: Text('${n.fullName}（${n.gender.label}）'),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$inst ／ 熟練度 ${member.skill} ／ やる気 ${member.motivation}'),
          const SizedBox(height: 2),
          TraitChips(n.traits, dense: true, max: 4),
        ],
      ),
      trailing: trailing,
    );
  }
}
