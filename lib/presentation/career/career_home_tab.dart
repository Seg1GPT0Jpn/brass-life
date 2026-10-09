import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../domain/career/career_engine.dart';
import '../../domain/career/game_mode.dart';
import '../../domain/career/mode_states.dart';
import '../../domain/game/engine/audition_engine.dart';
import '../../domain/game/engine/piece_selection.dart';
import '../../domain/game/engine/relations.dart';
import '../../domain/game/models/game_enums.dart';
import '../../domain/game/models/game_state.dart';
import '../../domain/game/scene/scene_models.dart';
import '../common/widgets/common_widgets.dart';
import '../game/conducting/performance_flow.dart';
import '../game/event_panels.dart';
import '../game/exam_panels.dart';
import '../game/game_controller.dart';
import '../game/home_tab.dart';
import '../game/pieces/piece_selection_panel.dart';
import '../game/scene/diorama_view.dart';

/// 大人編のホーム画面。
class CareerHomeTab extends ConsumerWidget {
  const CareerHomeTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(gameControllerProvider)!;
    final wide = MediaQuery.sizeOf(context).width >= 900;
    final finished = s.stage == GameStage.finished;
    final main = switch (s) {
      GameState(stage: GameStage.finished) => const _CareerFinishedCard(),
      GameState(pending: PendingEvent(type: PendingEventType.pieceSelection)) =>
        const PieceSelectionPanel(),
      GameState(
        pending: PendingEvent(type: PendingEventType.teacherAudition),
      ) =>
        const TeacherAuditionPanel(),
      GameState(
        pending: PendingEvent(
          type: PendingEventType.contest || PendingEventType.concert,
        ),
      ) =>
        TeacherPerformancePanel(type: s.pending!.type),
      GameState(pending: PendingEvent(type: PendingEventType.notice)) =>
        const NoticePanel(),
      _ => null,
    };
    final idle = !finished && s.pending == null;
    final status = const CareerStatusCard();
    final diorama = finished ? null : const _CareerDioramaCard();
    final commands = idle ? const CareerCommandPanel() : null;
    final skip = idle ? const _CareerSkipPanel() : null;
    final log = GameLogCard(s);
    if (wide) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 380,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [status, ?skip],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [?main, ?commands, ?diorama, log],
            ),
          ),
        ],
      );
    }
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [?main, ?commands, ?diorama, status, ?skip, log],
    );
  }
}

/// 立場・学校・資源の状態。
class CareerStatusCard extends ConsumerWidget {
  const CareerStatusCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(gameControllerProvider)!;
    final ctx = ref.watch(gameContextProvider)!;
    final c = s.career!;
    final theme = Theme.of(context);
    final members = ctx.activeMembers(s);
    int avg(int Function(NpcState) f) => members.isEmpty
        ? 0
        : members.fold(0, (a, m) => a + f(m)) ~/ members.length;
    final weeksLeft = (c.termEndTurn - s.turn).clamp(0, 9999);
    final piece = PieceSelection(ctx).currentOf(s);
    final menu = PracticeMenuPreset.values.byName(c.menu);
    return SectionCard(
      title: '${s.player.fullName}（${s.mode.label}）',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          KvRow(
            s.mode == GameMode.alumni ? '母校' : '学校',
            '${ctx.school(s).name}（${ctx.club(s).tier.label}）',
          ),
          KvRow('部員', '${members.length} 人'),
          KvRow('任期', 'あと $weeksLeft 週'),
          if (s.condition.techniqueShock > 0 || s.condition.tensionShock > 0)
            KvRow(
              '部の調子',
              '引退ショック（技術 -${s.condition.techniqueShock}・テンション -${s.condition.tensionShock}）',
            ),
          if (piece != null) KvRow('課題曲', '${piece.category}「${piece.title}」'),
          ValueBar(label: '部員のやる気', value: avg((m) => m.motivation), max: 100),
          ValueBar(label: '部員のストレス', value: avg((m) => m.stress), max: 100),
          ValueBar(
            label: 'あなたへの信頼',
            value: members.isEmpty
                ? 0
                : (members.fold(
                            0,
                            (a, m) =>
                                a +
                                Relations.get(s, m.id, Relations.player).trust,
                          ) ~/
                          members.length)
                      .clamp(0, 100),
            max: 100,
          ),
          const Divider(),
          ...switch (s.mode) {
            GameMode.teacher => [
              Text('練習メニュー', style: theme.textTheme.titleSmall),
              DropdownButton<PracticeMenuPreset>(
                isExpanded: true,
                value: menu,
                items: [
                  for (final m in PracticeMenuPreset.values)
                    DropdownMenuItem(value: m, child: Text(m.label)),
                ],
                onChanged: s.pending != null || s.stage == GameStage.finished
                    ? null
                    : (m) => ref
                          .read(gameControllerProvider.notifier)
                          .setPracticeMenu(m!),
              ),
              Text(menu.description, style: theme.textTheme.bodySmall),
            ],
            GameMode.instructor => [
              ValueBar(label: '評判', value: c.reputation, max: 100),
              const SizedBox(height: 4),
              Text('契約校', style: theme.textTheme.titleSmall),
              for (final id in c.contractedSchoolIds)
                KvRow(
                  id == s.schoolId ? '拠点' : '出張先',
                  '${ctx.index.schoolById[id]!.name}'
                  '${(c.schoolBoosts[id] ?? 0) > 0 ? '（上乗せ +${c.schoolBoosts[id]}）' : ''}',
                ),
            ],
            GameMode.alumni => [
              KvRow('所持金', '${c.money} 円'),
              ValueBar(label: '部との絆', value: c.bond, max: 100),
            ],
            GameMode.student => const <Widget>[],
          },
        ],
      ),
    );
  }
}

/// 今週のコマンド（相手のいないもの・学校を選ぶもの）。部員が相手のものはジオラマから。
class CareerCommandPanel extends ConsumerWidget {
  const CareerCommandPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(gameControllerProvider)!;
    final ctx = ref.watch(gameContextProvider)!;
    final engine = CareerEngine(ctx);
    final theme = Theme.of(context);
    final commands = CareerCommand.of(s.mode);
    final memberCommands = commands
        .where((c) => c.target == CommandTarget.member)
        .map((c) => c.label)
        .join('・');
    return SectionCard(
      title: '今週の行動',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final c in commands.where((c) => c.target == CommandTarget.none))
            _CommandButton(
              label: c.label,
              description: c.description,
              reason: engine.unavailableReason(s, c, null),
              onPressed: () => submitCareerCommand(context, ref, c, null),
            ),
          for (final c in commands.where(
            (c) => c.target == CommandTarget.school,
          ))
            for (final id in s.career!.contractedSchoolIds.where(
              (id) => id != s.schoolId,
            ))
              _CommandButton(
                label: '${c.label}：${ctx.index.schoolById[id]!.name}',
                description: c.description,
                reason: engine.unavailableReason(s, c, id),
                onPressed: () => submitCareerCommand(context, ref, c, id),
              ),
          if (memberCommands.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                '部員をタップすると「$memberCommands」ができる。',
                style: theme.textTheme.bodySmall,
              ),
            ),
        ],
      ),
    );
  }
}

class _CommandButton extends StatelessWidget {
  const _CommandButton({
    required this.label,
    required this.description,
    required this.reason,
    required this.onPressed,
  });

  final String label;
  final String description;
  final String? reason;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => Card(
    child: ListTile(
      enabled: reason == null,
      title: Text(label),
      subtitle: Text(reason ?? description),
      trailing: Icon(reason == null ? Icons.play_arrow : Icons.lock_outline),
      onTap: reason == null ? onPressed : null,
    ),
  );
}

/// コマンドを実行し、結果を短く知らせる。
void submitCareerCommand(
  BuildContext context,
  WidgetRef ref,
  CareerCommand c,
  String? targetId,
) {
  ref.read(gameControllerProvider.notifier).submitCareer(c, targetId: targetId);
  final s = ref.read(gameControllerProvider)!;
  final log = s.logs.lastWhere((l) => l.actionLabel != null);
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        content: Text(
          '${log.actionLabel}：${log.lines.isEmpty ? '' : log.lines.first}',
        ),
      ),
    );
}

class _CareerDioramaCard extends ConsumerWidget {
  const _CareerDioramaCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scene = ref.watch(clubSceneProvider)!;
    final s = ref.watch(gameControllerProvider)!;
    final ctx = ref.watch(gameContextProvider)!;
    final idle = s.pending == null && s.stage != GameStage.finished;
    return SectionCard(
      title: '${ctx.dateLabelOf(s)}　${scene.season.label}・${scene.time.label}',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DioramaView(
            scene: scene,
            onActorTap: idle
                ? (a) {
                    if (a.isPlayer || a.isAdvisor) return;
                    _showMemberSheet(context, ref, a);
                  }
                : null,
          ),
          const SizedBox(height: 4),
          Text(
            idle ? '部員をタップすると、その部員への行動を選べる。' : 'イベントに答えると、また動けるようになる。',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

Future<void> _showMemberSheet(
  BuildContext context,
  WidgetRef ref,
  SceneActor actor,
) async {
  final s = ref.read(gameControllerProvider)!;
  final ctx = ref.read(gameContextProvider)!;
  final engine = CareerEngine(ctx);
  final st = s.npcs[actor.id];
  final rel = Relations.get(s, actor.id, Relations.player);
  final chosen = await showModalBottomSheet<CareerCommand>(
    context: context,
    showDragHandle: true,
    builder: (sheet) {
      final theme = Theme.of(sheet);
      return SafeArea(
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          children: [
            Row(
              children: [
                ActorToken(actor: actor, size: 36),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(actor.name, style: theme.textTheme.titleLarge),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(sheet);
                    context.push('/game/person/${actor.id}');
                  },
                  child: const Text('詳しく見る'),
                ),
              ],
            ),
            Text(
              [
                if (actor.grade != null) '${actor.grade}年',
                actor.instrumentLabel ?? '楽器未定',
                actor.activity.label,
                if (st != null)
                  'やる気 ${st.motivation}・ストレス ${st.stress}・熟練度 ${st.skill}',
              ].join(' ／ '),
              style: theme.textTheme.bodySmall,
            ),
            Text(
              'あなたへの好意 ${rel.affection}・信頼 ${rel.trust}',
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(height: 8),
            for (final c in CareerCommand.of(
              s.mode,
            ).where((c) => c.target == CommandTarget.member))
              () {
                final reason = engine.unavailableReason(s, c, actor.id);
                return Card(
                  child: ListTile(
                    enabled: reason == null,
                    title: Text(c.label),
                    subtitle: Text(reason ?? c.description),
                    trailing: const Icon(Icons.play_arrow),
                    onTap: reason == null
                        ? () => Navigator.pop(sheet, c)
                        : null,
                  ),
                );
              }(),
          ],
        ),
      );
    },
  );
  if (chosen == null || !context.mounted) return;
  submitCareerCommand(context, ref, chosen, actor.id);
}

class _CareerSkipPanel extends ConsumerWidget {
  const _CareerSkipPanel();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(gameControllerProvider)!;
    final ctx = ref.watch(gameContextProvider)!;
    final vm = ref.read(gameControllerProvider.notifier);
    final auto = CareerEngine(ctx).autoCommand(s);
    return SectionCard(
      title: 'まとめて進める',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'まとめて進める週は「${auto.label}」で過ごす'
            '${s.mode == GameMode.alumni ? '（所持金が十分なら差し入れと仕事を交互に）' : ''}。',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: () => vm.skipMonth(s.policy),
            icon: const Icon(Icons.fast_forward),
            label: const Text('月末まで進める（イベントで停止）'),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: () => vm.skipToNextEvent(s.policy),
            icon: const Icon(Icons.skip_next),
            label: const Text('次のイベントまで進める'),
          ),
        ],
      ),
    );
  }
}

class _CareerFinishedCard extends StatelessWidget {
  const _CareerFinishedCard();

  @override
  Widget build(BuildContext context) => SectionCard(
    title: '任期が終わった',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text('${GameMode.termYears}年間の任期が終わった。あなたの歩みを振り返ろう。'),
        const SizedBox(height: 12),
        FilledButton.icon(
          onPressed: () => context.go('/game/ending'),
          icon: const Icon(Icons.auto_stories),
          label: const Text('エンディングを見る'),
        ),
      ],
    ),
  );
}

/// 顧問モード: オーディションの合否を決める。
class TeacherAuditionPanel extends ConsumerStatefulWidget {
  const TeacherAuditionPanel({super.key});

  @override
  ConsumerState<TeacherAuditionPanel> createState() =>
      _TeacherAuditionPanelState();
}

class _TeacherAuditionPanelState extends ConsumerState<TeacherAuditionPanel> {
  Set<String>? _selected;

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(gameControllerProvider)!;
    final ctx = ref.watch(gameContextProvider)!;
    final engine = AuditionEngine(ctx);
    final p = engine.preview(s);
    final selected = _selected ??= engine.recommended(s);
    final theme = Theme.of(context);
    final over = selected.length > p.limit;
    return SectionCard(
      title: 'イベント：オーディションの合否',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            '夏のコンクールに出るメンバーを決める。出場できるのは ${p.limit} 人まで（候補 ${p.candidates.length} 人）。'
            '初めは評価どおりの案が選ばれている。',
          ),
          Text(
            '評価の高い部員を外して低い部員を選ぶと、外された部員は納得できず、やる気と信頼を失う。',
            style: theme.textTheme.bodySmall,
          ),
          const SizedBox(height: 8),
          Text(
            '選択中 ${selected.length} / ${p.limit} 人',
            style: theme.textTheme.titleSmall?.copyWith(
              color: over ? theme.colorScheme.error : null,
            ),
          ),
          for (final id in p.candidates)
            CheckboxListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              value: selected.contains(id),
              onChanged: (v) => setState(() {
                if (v ?? false) {
                  selected.add(id);
                } else {
                  selected.remove(id);
                }
              }),
              title: Text(
                '${ctx.npc(s, id).fullName}（${s.npcs[id]!.grade}年・${s.npcs[id]!.instrument?.label ?? '－'}）',
              ),
              subtitle: Text('評価 ${p.scores[id]}・熟練度 ${s.npcs[id]!.skill}'),
            ),
          const SizedBox(height: 8),
          FilledButton(
            onPressed: selected.isEmpty || over
                ? null
                : () async {
                    final lines = ref
                        .read(gameControllerProvider.notifier)
                        .resolveTeacherAudition(Set.of(selected));
                    if (!context.mounted) return;
                    await showResultDialog(context, 'オーディション', lines);
                  },
            child: Text(
              over ? '${p.limit} 人までにしてください' : 'この ${selected.length} 人で発表する',
            ),
          ),
        ],
      ),
    );
  }
}

/// 顧問モード: コンクール・定期演奏会の本番（指揮台に立つ）。
class TeacherPerformancePanel extends ConsumerWidget {
  const TeacherPerformancePanel({super.key, required this.type});

  final PendingEventType type;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(gameControllerProvider)!;
    final title = type == PendingEventType.contest
        ? ContestStageName.of(s.pending!.data['stage'])
        : '定期演奏会';
    return SectionCard(
      title: 'イベント：$title',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            type == PendingEventType.contest
                ? 'いよいよ本番。出場メンバー ${s.contestMembers.length} 人の前で、指揮台に立つ。'
                : '1年の締めくくりの定期演奏会。指揮台に立つ。',
          ),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: () => runPerformance(
              context,
              ref,
              type: type,
              card: null,
              title: title,
            ),
            icon: const Icon(Icons.straighten),
            label: const Text('指揮台に立つ'),
          ),
        ],
      ),
    );
  }
}
