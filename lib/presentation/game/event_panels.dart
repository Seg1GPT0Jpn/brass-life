import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/game/engine/contest_engine.dart';
import '../../domain/game/engine/performance.dart';
import '../../domain/game/engine/relations.dart';
import '../../domain/game/engine/time_manager.dart';
import '../../domain/game/master/approach_cards.dart';
import '../../domain/game/models/game_enums.dart';
import '../../domain/value_objects/school_enums.dart';
import '../common/widgets/common_widgets.dart';
import 'game_controller.dart';

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
      final lines = switch (widget.type) {
        PendingEventType.audition => vm.resolveAudition(card),
        PendingEventType.contest => vm.resolveContest(card),
        _ => vm.resolveConcert(card),
      };
      if (!context.mounted) return;
      await showResultDialog(context, title.replaceFirst('イベント：', ''), lines);
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
class ExecutivePanel extends ConsumerWidget {
  const ExecutivePanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ctx = ref.watch(gameContextProvider)!;
    final s = ref.watch(gameControllerProvider)!;
    final club = ctx.club(s);
    final theme = Theme.of(context);
    Future<void> choose(CandidacyChoice c) async {
      final lines = ref
          .read(gameControllerProvider.notifier)
          .resolveExecutive(c);
      if (!context.mounted) return;
      await showResultDialog(context, '幹部選出', lines);
    }

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
          const SizedBox(height: 8),
          Text(
            '部長（代表）に選ばれるかは、統率力に関わる性格・仲間からの信頼・顧問の評価、'
            'そして決め方によって変わる。',
            style: theme.textTheme.bodySmall,
          ),
          const SizedBox(height: 12),
          for (final c in CandidacyChoice.values)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: OutlinedButton(
                onPressed: () => choose(c),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Column(
                    children: [
                      Text(c.label, style: theme.textTheme.titleSmall),
                      Text(c.description, style: theme.textTheme.bodySmall),
                    ],
                  ),
                ),
              ),
            ),
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
