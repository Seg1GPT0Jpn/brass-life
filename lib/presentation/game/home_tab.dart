import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/feature_flags.dart';
import '../../domain/game/engine/contest_engine.dart';
import '../../domain/game/engine/practice_bgm.dart';
import '../../domain/game/engine/piece_selection.dart';
import '../../domain/game/engine/school_calendar.dart';
import '../../domain/game/models/game_enums.dart';
import '../../domain/game/models/game_state.dart';
import '../../domain/game/scene/scene_models.dart';
import '../../domain/value_objects/instrument.dart';
import '../common/widgets/common_widgets.dart';
import 'club_membership_card.dart';
import 'game_controller.dart';
import 'event_panels.dart';
import 'exam_panels.dart';
import 'instrument_decision_panel.dart';
import 'pieces/piece_player.dart';
import 'pieces/piece_selection_panel.dart';
import 'scene/action_sheets.dart';
import 'scene/ambient_audio.dart';
import 'scene/diorama_view.dart';
import 'scene/performance_stage.dart';
import 'scene/scene_palette.dart';

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
      GameState(pending: PendingEvent(type: PendingEventType.pieceSelection)) =>
        const PieceSelectionPanel(),
      GameState(pending: PendingEvent(:final type)) => CardEventPanel(
        type: type,
      ),
      _ => null,
    };
    final finished = s.stage == GameStage.finished;
    final diorama = finished ? null : const _DioramaCard();
    final skip = finished || s.pending != null ? null : const _SkipPanel();
    final membership = finished ? null : const ClubMembershipCard();
    final log = _LogCard(s);
    if (wide) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 380,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [status, ?membership],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [?main, ?diorama, ?skip, log],
            ),
          ),
        ],
      );
    }
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [?main, ?diorama, status, ?skip, ?membership, log],
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
          if (p.quitClub)
            const KvRow('部活', '退部中')
          else if (p.retired)
            const KvRow('部活', '引退済み'),
          if (!p.quitClub &&
              s.contest != null &&
              s.contest!.fiscalYear == ctx.calendar.dateOf(s.turn).fiscalYear)
            KvRow(
              'コンクール',
              '${s.contestMembers.contains('player') ? (s.soloistId == 'player' ? 'メンバー（ソリスト）' : 'メンバー') : 'B組（応援）'}'
                  '${s.contest!.nextStage == null ? ' ／ 今年の日程は終了' : ' ／ 次: ${nextContestLabel(ContestEngine(ctx), s.contest!.fiscalYear, s.contest!.nextStage)}'}',
            ),
          if (PieceSelection(ctx).currentOf(s) case final piece?)
            KvRow(
              '課題曲',
              '${piece.category}「${piece.title}」',
              onTap: () => context.push('/game/pieces'),
            ),
          if (p.instrument != null)
            ValueBar(label: '熟練度', value: p.skill, max: 1000),
          ValueBar(label: '音楽性', value: p.musicality, max: 1000),
          ValueBar(label: '学力', value: p.academic, max: 1000),
          const Divider(),
          ValueBar(label: '疲労', value: p.fatigue, max: 100),
          ValueBar(label: 'ストレス', value: p.stress, max: 100),
          ValueBar(label: 'やる気', value: p.motivation, max: 100),
          if (p.heartache > 0)
            ValueBar(label: '心の傷', value: p.heartache, max: 100),
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

/// ホーム画面の中心: 部活の様子のジオラマ。
///
/// 自分・部員・場所をタップすると、そこでできる行動のメニューが開く。
class _DioramaCard extends ConsumerStatefulWidget {
  const _DioramaCard();

  @override
  ConsumerState<_DioramaCard> createState() => _DioramaCardState();
}

class _DioramaCardState extends ConsumerState<_DioramaCard> {
  @override
  void initState() {
    super.initState();
    final scene = ref.read(clubSceneProvider);
    if (scene != null) ref.read(ambientAudioProvider).play(scene.ambience);
  }

  Future<void> _handle(ActionChoice? choice) async {
    switch (choice) {
      case null:
        return;
      case OpenActor(:final actor):
        if (actor.isPlayer) {
          return _handle(await showSelfSheet(context, ref));
        }
        return _handle(await showMemberSheet(context, ref, actor));
      case ChooseAction(:final action, :final targetId):
        final before = ref.read(clubSceneProvider)!;
        // Phase 7（準備中）: 練習の行動に合わせて課題曲を練習 BGM として流す
        if (FeatureFlags.practiceBgm) {
          final cue = PracticeBgm.cueFor(
            ref.read(gameContextProvider)!,
            ref.read(gameControllerProvider)!,
            action,
          );
          if (cue != null) {
            ref
                .read(piecePlayerProvider.notifier)
                .playFrom(
                  cue.piece,
                  start: Duration(seconds: cue.startSeconds),
                  loop: cue.loop,
                );
          }
        }
        ref
            .read(gameControllerProvider.notifier)
            .submit(action, targetId: targetId);
        final s = ref.read(gameControllerProvider)!;
        final log = s.logs.lastWhere((l) => l.actionLabel != null);
        if (!mounted) return;
        if (action == WeeklyAction.ensemble) {
          await showPerformanceStage(
            context,
            title: '合奏練習',
            lines: log.lines,
            performers: [
              for (final a in before.actors)
                if (!a.isAdvisor) a,
            ],
          );
        } else {
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
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(clubSceneProvider, (_, next) {
      if (next != null) ref.read(ambientAudioProvider).play(next.ambience);
    });
    final scene = ref.watch(clubSceneProvider)!;
    final s = ref.watch(gameControllerProvider)!;
    final ctx = ref.watch(gameContextProvider)!;
    final theme = Theme.of(context);
    final canAct = s.pending == null;
    final date = ctx.calendar.dateOf(s.turn);
    return SectionCard(
      title: '${date.label}　${scene.season.label}・${scene.time.label}',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(Icons.graphic_eq, size: 16),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  '環境音：${scene.ambience.label}',
                  style: theme.textTheme.bodySmall,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          DioramaView(
            scene: scene,
            onActorTap: canAct ? (a) => _handle(OpenActor(a)) : null,
            onLocationTap: canAct
                ? (l) async => _handle(
                    await showLocationSheet(context, ref, l, scene.at(l)),
                  )
                : null,
          ),
          const SizedBox(height: 8),
          Text(
            canAct
                ? '★（自分）・部員・場所をタップして、今週どこで誰と過ごすかを選ぶ。'
                      'ピンチで拡大できる。'
                : 'イベントに答えると、また動けるようになる。',
            style: theme.textTheme.bodySmall,
          ),
          const SizedBox(height: 4),
          const _Legend(),
        ],
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  const _Legend();

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.labelSmall;
    Widget dot(Color c, String label) => Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: c, shape: BoxShape.circle),
        ),
        const SizedBox(width: 3),
        Text(label, style: style),
      ],
    );
    return Wrap(
      spacing: 10,
      runSpacing: 4,
      children: [
        for (final f in InstrumentFamily.values)
          dot(ScenePalette.family(f), f.label),
        dot(const Color(0xFF37474F), '顧問'),
        dot(ScenePalette.mood(ActorMood.happy), '枠: ご機嫌'),
        dot(ScenePalette.mood(ActorMood.tired), '枠: 疲れ'),
        dot(ScenePalette.mood(ActorMood.angry), '枠: 怒り'),
      ],
    );
  }
}

/// 月の方針でまとめて進める。
class _SkipPanel extends ConsumerWidget {
  const _SkipPanel();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(gameControllerProvider)!;
    final vm = ref.read(gameControllerProvider.notifier);
    final theme = Theme.of(context);
    return SectionCard(
      title: '月の方針でまとめて進める',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
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
  Widget build(BuildContext context) => SectionCard(
    title: '6年間が終わった',
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text('中学・高校の6年間の物語はここまで。あなただけのエンディングが待っている。'),
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
