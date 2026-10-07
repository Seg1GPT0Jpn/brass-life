import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../domain/game/engine/interaction_rules.dart';
import '../../../domain/game/engine/relations.dart';
import '../../../domain/game/models/game_enums.dart';
import '../../../domain/game/scene/scene_models.dart';
import '../game_controller.dart';
import 'diorama_view.dart';

/// シートでの選択。
sealed class ActionChoice {
  const ActionChoice();
}

/// 行動を選んだ（相手つき）。
class ChooseAction extends ActionChoice {
  const ChooseAction(this.action, this.targetId);
  final WeeklyAction action;
  final String? targetId;
}

/// 場所のシートから、そこにいる人を開く。
class OpenActor extends ActionChoice {
  const OpenActor(this.actor);
  final SceneActor actor;
}

/// 自分をタップ → 自主練系の行動。
Future<ActionChoice?> showSelfSheet(BuildContext context, WidgetRef ref) {
  final s = ref.read(gameControllerProvider)!;
  final ctx = ref.read(gameContextProvider)!;
  final p = s.player;
  return _show(
    context,
    title: '${p.fullName}（自分）',
    subtitle:
        '疲労 ${p.fatigue} ／ ストレス ${p.stress} ／ やる気 ${p.motivation}'
        '${p.instrument == null ? '' : ' ／ 熟練度 ${p.skill}'}',
    options: InteractionRules(ctx).forSelf(s),
    targetId: null,
  );
}

/// 部員をタップ → 相手のいる行動。
Future<ActionChoice?> showMemberSheet(
  BuildContext context,
  WidgetRef ref,
  SceneActor actor,
) {
  final s = ref.read(gameControllerProvider)!;
  final ctx = ref.read(gameContextProvider)!;
  final st = s.npcs[actor.id];
  final toMe = Relations.get(s, actor.id, Relations.player);
  final fromMe = Relations.get(s, Relations.player, actor.id);
  final rel = st == null
      ? null
      : '相手→あなた：好意 ${toMe.affection}・信頼 ${toMe.trust}・ライバル心 ${toMe.rivalry}\n'
            'あなた→相手：好意 ${fromMe.affection}・信頼 ${fromMe.trust}';
  return _show(
    context,
    title: actor.name,
    subtitle: [
      if (actor.grade != null) '${actor.grade}年',
      actor.instrumentLabel ?? (actor.isAdvisor ? '顧問' : '楽器未定'),
      actor.activity.label,
      if (st != null && actor.instrumentLabel != null) '熟練度 ${st.skill}',
    ].join(' ／ '),
    note: rel,
    leading: actor,
    options: actor.isAdvisor
        ? const []
        : InteractionRules(ctx).forMember(s, actor.id),
    targetId: actor.id,
    detailRoute: actor.isAdvisor ? null : '/game/person/${actor.id}',
  );
}

/// 場所をタップ → その場所でできる行動と、そこにいる人。
Future<ActionChoice?> showLocationSheet(
  BuildContext context,
  WidgetRef ref,
  SceneLocation location,
  List<SceneActor> here,
) {
  final s = ref.read(gameControllerProvider)!;
  final ctx = ref.read(gameContextProvider)!;
  final rules = InteractionRules(ctx);
  return _show(
    context,
    title: location.label,
    subtitle: here.isEmpty
        ? '誰もいない'
        : here.map((a) => '${a.name}（${a.activity.label}）').join('、'),
    options: [
      for (final a in location.actions)
        InteractionOption(a, rules.unavailableReason(s, a, null)),
    ],
    targetId: null,
    people: here,
  );
}

Future<ActionChoice?> _show(
  BuildContext context, {
  required String title,
  required String subtitle,
  required List<InteractionOption> options,
  required String? targetId,
  String? note,
  SceneActor? leading,
  String? detailRoute,
  List<SceneActor> people = const [],
}) {
  return showModalBottomSheet<ActionChoice>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (sheetContext) {
      final theme = Theme.of(sheetContext);
      return SafeArea(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.sizeOf(sheetContext).height * 0.8,
          ),
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            children: [
              Row(
                children: [
                  if (leading != null) ...[
                    ActorToken(actor: leading, size: 36),
                    const SizedBox(width: 12),
                  ],
                  Expanded(
                    child: Text(title, style: theme.textTheme.titleLarge),
                  ),
                  if (detailRoute != null)
                    TextButton(
                      onPressed: () {
                        Navigator.pop(sheetContext);
                        context.push(detailRoute);
                      },
                      child: const Text('詳しく見る'),
                    ),
                ],
              ),
              const SizedBox(height: 4),
              Text(subtitle, style: theme.textTheme.bodySmall),
              if (note != null) ...[
                const SizedBox(height: 4),
                Text(note, style: theme.textTheme.bodySmall),
              ],
              const SizedBox(height: 8),
              if (options.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Text('ここで選べる行動はない'),
                ),
              for (final o in options)
                Card(
                  child: ListTile(
                    enabled: o.enabled,
                    title: Text(o.action.label),
                    subtitle: Text(o.reason ?? o.action.description),
                    trailing: o.enabled
                        ? const Icon(Icons.play_arrow)
                        : const Icon(Icons.lock_outline),
                    onTap: o.enabled
                        ? () => Navigator.pop<ActionChoice>(
                            sheetContext,
                            ChooseAction(
                              o.action,
                              o.action.needsTarget ? targetId : null,
                            ),
                          )
                        : null,
                  ),
                ),
              if (people.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text('ここにいる人', style: theme.textTheme.titleSmall),
                const SizedBox(height: 4),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    for (final a in people)
                      ActionChip(
                        avatar: ActorToken(actor: a, size: 22),
                        label: Text(a.name),
                        onPressed: () => Navigator.pop<ActionChoice>(
                          sheetContext,
                          OpenActor(a),
                        ),
                      ),
                  ],
                ),
              ],
            ],
          ),
        ),
      );
    },
  );
}
