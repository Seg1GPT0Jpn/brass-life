import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/game/engine/contest_engine.dart';
import '../../domain/game/engine/school_calendar.dart';
import '../../domain/game/models/game_enums.dart';
import '../../domain/game/models/game_state.dart';
import '../common/widgets/common_widgets.dart';
import 'game_controller.dart';
import 'event_panels.dart';
import 'exam_panels.dart';
import 'instrument_decision_panel.dart';

class HomeTab extends ConsumerWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(gameControllerProvider)!;
    final wide = MediaQuery.sizeOf(context).width >= 900;
    final status = _StatusCard(s);
    final main = switch (s) {
      GameState(stage: GameStage.finished) => const _FinishedCard(),
      GameState(
        pending: PendingEvent(type: PendingEventType.instrumentDecision),
      ) =>
        const InstrumentDecisionPanel(),
      GameState(
        pending: PendingEvent(type: PendingEventType.executiveSelection),
      ) =>
        const ExecutivePanel(),
      GameState(pending: PendingEvent(type: PendingEventType.recommendation)) =>
        const RecommendationPanel(),
      GameState(
        pending: PendingEvent(type: PendingEventType.examApplication),
      ) =>
        const ApplicationPanel(),
      GameState(pending: PendingEvent(type: PendingEventType.notice)) =>
        const NoticePanel(),
      GameState(pending: PendingEvent(:final type)) => CardEventPanel(
        type: type,
      ),
      _ => const _ActionPanel(),
    };
    final log = _LogCard(s);
    if (wide) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 380,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [status],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [main, log],
            ),
          ),
        ],
      );
    }
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [main, status, log],
    );
  }
}

class _StatusCard extends ConsumerWidget {
  const _StatusCard(this.s);
  final GameState s;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ctx = ref.watch(gameContextProvider)!;
    final p = s.player;
    final school = ctx.index.schoolById[s.schoolId]!;
    final club = ctx.club(s);
    final lastGrade = p.termGrades.isEmpty ? null : p.termGrades.last.grade;
    final cal = SchoolCalendar(ctx.calendar);
    String? nextExam;
    for (var t = s.turn; t < s.turn + 60; t++) {
      final e = cal.examAt(ctx.calendar.dateOf(t));
      if (e != null) {
        nextExam = '${e.name}（${ctx.calendar.dateOf(t).label}）';
        break;
      }
    }
    return SectionCard(
      title: '${p.fullName}（${school.name} ${p.grade}年）',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          KvRow(
            '吹奏楽部',
            '${club.tier.label} ／ 部員 ${ctx.activeMembers(s).length + 1} 人',
          ),
          KvRow('担当', p.instrument?.label ?? '未定'),
          if (s.roles['player'] != null) KvRow('役職', s.roles['player']!.label),
          if (p.retired) const KvRow('部活', '引退済み'),
          if (s.contest != null &&
              s.contest!.fiscalYear == ctx.calendar.dateOf(s.turn).fiscalYear)
            KvRow(
              'コンクール',
              '${s.contestMembers.contains('player') ? (s.soloistId == 'player' ? 'メンバー（ソリスト）' : 'メンバー') : 'B組（応援）'}'
                  '${s.contest!.nextStage == null ? ' ／ 今年の日程は終了' : ' ／ 次: ${nextContestLabel(ContestEngine(ctx), s.contest!.fiscalYear, s.contest!.nextStage)}'}',
            ),
          if (p.instrument != null)
            ValueBar(label: '熟練度', value: p.skill, max: 1000),
          ValueBar(label: '音楽性', value: p.musicality, max: 1000),
          ValueBar(label: '学力', value: p.academic, max: 1000),
          const Divider(),
          ValueBar(label: '疲労', value: p.fatigue, max: 100),
          ValueBar(label: 'ストレス', value: p.stress, max: 100),
          ValueBar(label: 'やる気', value: p.motivation, max: 100),
          ValueBar(label: '社交性', value: p.social, max: 100),
          ValueBar(label: '顧問の評価', value: p.advisorTrust, max: 100),
          const Divider(),
          KvRow('直近の評定', lastGrade == null ? '－' : '$lastGrade'),
          KvRow('次のテスト', nextExam ?? '－'),
          const SizedBox(height: 6),
          TraitChips(p.traits, dense: true),
        ],
      ),
    );
  }
}

class _ActionPanel extends ConsumerStatefulWidget {
  const _ActionPanel();

  @override
  ConsumerState<_ActionPanel> createState() => _ActionPanelState();
}

class _ActionPanelState extends ConsumerState<_ActionPanel> {
  WeeklyAction _selected = WeeklyAction.individualPractice;

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(gameControllerProvider)!;
    final vm = ref.read(gameControllerProvider.notifier);
    final theme = Theme.of(context);
    return SectionCard(
      title: '今週の行動',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final a in WeeklyAction.values)
                ChoiceChip(
                  label: Text(a.label),
                  selected: _selected == a,
                  onSelected: (_) => setState(() => _selected = a),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(_selected.description, style: theme.textTheme.bodySmall),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: () => vm.submit(_selected),
            icon: const Icon(Icons.play_arrow),
            label: Text('「${_selected.label}」で1週間を過ごす'),
          ),
          const Divider(height: 32),
          Text('月の方針でまとめて進める', style: theme.textTheme.titleSmall),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              FilterDropdown<MonthlyPolicy>(
                value: s.policy,
                items: [for (final p in MonthlyPolicy.values) (p, p.label)],
                onChanged: (p) => vm.setPolicy(p ?? MonthlyPolicy.balanced),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Checkbox(
                    value: s.studyBeforeExams,
                    onChanged: (v) => vm.setStudyBeforeExams(v ?? true),
                  ),
                  const Text('テスト前は勉強'),
                ],
              ),
            ],
          ),
          Text(
            '方針の行動パターン：${s.policy.pattern.map((a) => a.label).join(' → ')}'
            '（疲労80以上なら休養、ストレス80以上なら遊ぶ）',
            style: theme.textTheme.bodySmall,
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: () => vm.skipMonth(s.policy),
            icon: const Icon(Icons.fast_forward),
            label: const Text('月末までスキップ（イベントで停止）'),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: () => vm.skipToNextEvent(s.policy),
            icon: const Icon(Icons.skip_next),
            label: const Text('次のイベントまで進める（最大半年）'),
          ),
        ],
      ),
    );
  }
}

class _FinishedCard extends StatelessWidget {
  const _FinishedCard();

  @override
  Widget build(BuildContext context) =>
      const SectionCard(title: 'おしまい', child: Text('この人生の物語はここまでです。'));
}

class _LogCard extends StatelessWidget {
  const _LogCard(this.s);
  final GameState s;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final recent = s.logs.reversed.take(12).toList();
    return SectionCard(
      title: '最近の出来事',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final l in recent)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${l.dateLabel}${l.actionLabel == null ? '' : '　${l.actionLabel}'}',
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  for (final line in l.lines)
                    Text(line, style: theme.textTheme.bodySmall),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
