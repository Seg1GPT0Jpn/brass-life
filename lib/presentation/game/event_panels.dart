import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/game/engine/contest_engine.dart';
import '../../domain/game/engine/executive_engine.dart';
import '../../domain/game/engine/performance.dart';
import '../../domain/game/engine/relations.dart';
import '../../domain/game/engine/time_manager.dart';
import '../../domain/game/master/approach_cards.dart';
import '../../domain/game/models/candidacy.dart';
import '../../domain/game/models/game_enums.dart';
import '../../domain/value_objects/school_enums.dart';
import '../common/widgets/common_widgets.dart';
import 'game_controller.dart';
import 'scene/performance_stage.dart';

/// イベント結果のダイアログ。
Future<void> showResultDialog(
  BuildContext context,
  String title,
  List<String> lines,
) => showDialog<void>(
  context: context,
  builder: (context) => AlertDialog(
    title: Text(title),
    content: SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [for (final l in lines) Text(l)],
      ),
    ),
    actions: [
      FilledButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('OK'),
      ),
    ],
  ),
);

/// アプローチカードを選ぶイベント（オーディション・コンクール・定期演奏会）。
class CardEventPanel extends ConsumerStatefulWidget {
  const CardEventPanel({super.key, required this.type});

  final PendingEventType type;

  @override
  ConsumerState<CardEventPanel> createState() => _CardEventPanelState();
}

class _CardEventPanelState extends ConsumerState<CardEventPanel> {
  ApproachCard? _selected;

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(gameControllerProvider)!;
    final ctx = ref.watch(gameContextProvider)!;
    final cards = TimeManager(ctx).cardsOf(s);
    final theme = Theme.of(context);
    final club = ctx.club(s);
    final school = ctx.school(s);
    final limit = Performance.memberLimit(club.division, school.level);

    final (title, body) = switch (widget.type) {
      PendingEventType.audition => (
        'イベント：コンクールメンバー選考',
        s.pending!.data['needed'] == 'true'
            ? '夏の${ctx.world.region.contestName}（${club.division.label}）に向けて、'
                  'メンバーを決めるオーディションが行われる。出場できるのは $limit 人まで。'
                  'ソリストもここで決まる。どう臨む？'
            : '夏の${ctx.world.region.contestName}（${club.division.label}）のメンバー発表の日。'
                  '部員数が上限 $limit 人以内なので全員が出場できるが、ソリストはここで決まる。どう臨む？',
      ),
      PendingEventType.contest => (
        'イベント：${ContestStageName.of(s.pending!.data['stage'])}',
        'いよいよ本番。出場メンバー ${s.contestMembers.length} 人'
            '${s.soloistId == Relations.player ? '（あなたはソリスト）' : ''}。'
            'どんな気持ちで臨む？',
      ),
      _ => ('イベント：定期演奏会', '1年の締めくくりの定期演奏会。家族や友人も聴きに来ている。どう臨む？'),
    };

    Future<void> submit() async {
      final card = _selected!;
      final vm = ref.read(gameControllerProvider.notifier);
      // 演奏者（本番前の状態で決める）: コンクールは出場メンバー、それ以外は全員。
      final scene = ref.read(clubSceneProvider)!;
      final performers = [
        for (final a in scene.actors)
          if (!a.isAdvisor &&
              (widget.type != PendingEventType.contest ||
                  s.contestMembers.contains(a.id)))
            a,
      ];
      final lines = switch (widget.type) {
        PendingEventType.audition => vm.resolveAudition(card),
        PendingEventType.contest => vm.resolveContest(card),
        _ => vm.resolveConcert(card),
      };
      if (!context.mounted) return;
      await showPerformanceStage(
        context,
        title: title.replaceFirst('イベント：', ''),
        lines: lines,
        performers: performers,
      );
    }

    return SectionCard(
      title: title,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(body),
          const SizedBox(height: 12),
          Text('アプローチカード（1枚選ぶ）', style: theme.textTheme.titleSmall),
          const SizedBox(height: 8),
          for (final c in cards)
            Card(
              color: _selected == c ? theme.colorScheme.primaryContainer : null,
              child: ListTile(
                onTap: () => setState(() => _selected = c),
                leading: Icon(
                  _selected == c ? Icons.check_circle : Icons.style_outlined,
                ),
                title: Text(c.label),
                subtitle: Text(c.description),
              ),
            ),
          const SizedBox(height: 8),
          FilledButton(
            onPressed: _selected == null ? null : submit,
            child: const Text('このカードで臨む'),
          ),
        ],
      ),
    );
  }
}

/// 大会名の表示補助。
abstract final class ContestStageName {
  static String of(String? name) =>
      name == null ? 'コンクール' : ContestStage.values.byName(name).label;
}

/// 幹部選出イベント。
///
/// 「立候補する」を選ぶと、狙う役職となりたい気持ちの強さを決めてから名乗り出る。
class ExecutivePanel extends ConsumerStatefulWidget {
  const ExecutivePanel({super.key});

  @override
  ConsumerState<ExecutivePanel> createState() => _ExecutivePanelState();
}

class _ExecutivePanelState extends ConsumerState<ExecutivePanel> {
  bool _running = false;
  ClubRole? _role;
  int _desire = 3;

  static String _howChosen(ClubRole r) => switch (r) {
    ClubRole.conductor => '音楽性と熟練度で選ばれる',
    ClubRole.sectionLeader => '同じ系統（木管・金管・打楽器）の中で、実力と統率力で選ばれる',
    ClubRole.partLeader => '同じ楽器の中で一番上手い人がなる',
    _ => '決め方（投票・指名など）と、統率力・仲間からの信頼で選ばれる',
  };

  Future<void> _submit(Candidacy c) async {
    final lines = ref.read(gameControllerProvider.notifier).resolveExecutive(c);
    if (!mounted) return;
    await showResultDialog(context, '幹部選出', lines);
  }

  @override
  Widget build(BuildContext context) {
    final ctx = ref.watch(gameContextProvider)!;
    final s = ref.watch(gameControllerProvider)!;
    final club = ctx.club(s);
    final theme = Theme.of(context);
    final roles = ExecutiveEngine(ctx).runnableRoles(s);
    final canRun = s.player.grade == 2 && roles.isNotEmpty;
    final role = _role != null && roles.contains(_role) ? _role : null;
    final family = s.player.instrument?.family;

    Widget choiceButton(String label, String description, VoidCallback onTap) =>
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: OutlinedButton(
            onPressed: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                children: [
                  Text(label, style: theme.textTheme.titleSmall),
                  Text(description, style: theme.textTheme.bodySmall),
                ],
              ),
            ),
          ),
        );

    return SectionCard(
      title: 'イベント：新幹部の選出',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('3年生が引退し、2年生の中から新しい幹部を決める時が来た。'),
          const SizedBox(height: 8),
          KvRow('幹部制度', club.executiveSystem.label),
          KvRow('', club.executiveSystem.description),
          KvRow(
            '決め方',
            '${club.selectionCulture.label}（${club.selectionCulture.description}）',
          ),
          const SizedBox(height: 12),
          if (!_running) ...[
            if (canRun)
              choiceButton(
                CandidacyChoice.run.label,
                CandidacyChoice.run.description,
                () => setState(() => _running = true),
              ),
            choiceButton(
              CandidacyChoice.neutral.label,
              CandidacyChoice.neutral.description,
              () => _submit(const Candidacy.neutral()),
            ),
            choiceButton(
              CandidacyChoice.decline.label,
              CandidacyChoice.decline.description,
              () => _submit(const Candidacy.decline()),
            ),
          ] else ...[
            Text('どの役職に立候補する？', style: theme.textTheme.titleSmall),
            const SizedBox(height: 6),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final r in roles)
                  ChoiceChip(
                    label: Text(
                      r == ClubRole.sectionLeader && family != null
                          ? '${r.label}（${family.label}）'
                          : r == ClubRole.partLeader &&
                                s.player.instrument != null
                          ? '${r.label}（${s.player.instrument!.label}）'
                          : r.label,
                    ),
                    selected: role == r,
                    onSelected: (_) => setState(() => _role = r),
                  ),
              ],
            ),
            if (role != null) ...[
              const SizedBox(height: 6),
              Text(_howChosen(role), style: theme.textTheme.bodySmall),
            ],
            const SizedBox(height: 16),
            Text(
              'なりたい気持ち：${Candidacy.desireLabel(_desire)}',
              style: theme.textTheme.titleSmall,
            ),
            Slider(
              value: _desire.toDouble(),
              min: Candidacy.minDesire.toDouble(),
              max: Candidacy.maxDesire.toDouble(),
              divisions: Candidacy.maxDesire - Candidacy.minDesire,
              label: Candidacy.desireLabel(_desire),
              onChanged: (v) => setState(() => _desire = v.round()),
            ),
            Text(
              '気持ちが強いほど本気が伝わって選ばれやすくなる。'
              'でも選ばれなかったときの心の傷は深く、なかなか消えない'
              '${role == null ? '' : '（この役職でダメだった場合：心の傷 +${ExecutiveEngine.heartacheOf(role, _desire)}）'}。',
              style: theme.textTheme.bodySmall?.copyWith(
                color: _desire >= 4 ? theme.colorScheme.error : null,
              ),
            ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: role == null
                  ? null
                  : () => _submit(Candidacy.run(role, _desire)),
              child: Text(
                role == null ? '役職を選んでください' : '「${role.label}」に立候補する',
              ),
            ),
            TextButton(
              onPressed: () => setState(() => _running = false),
              child: const Text('やめて戻る'),
            ),
          ],
        ],
      ),
    );
  }
}

/// 次のコンクール日程の表示用。
String? nextContestLabel(
  ContestEngine engine,
  int fiscalYear,
  ContestStage? stage,
) {
  if (stage == null) return null;
  final turn = engine.stageTurn(fiscalYear, stage);
  return '${stage.label}（${engine.ctx.calendar.dateOf(turn).label}）';
}
