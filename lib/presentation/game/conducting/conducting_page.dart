import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/game/conducting/conducting.dart';
import '../../../domain/game/conducting/rehearsal.dart';
import '../../../domain/game/models/game_state.dart';
import '../../../domain/game/models/piece.dart';
import '../pieces/piece_player.dart';

/// 指揮者ミニゲーム（Tactical Conducting）を開き、プランを返す（やめたら null）。
Future<ConductingPlan?> showConductingPage(
  BuildContext context, {
  required String title,
  required Piece piece,
  required ConductingParams params,
  required bool fullAuthority,
  RehearsalMemory rehearsal = const RehearsalMemory(),
}) => Navigator.of(context).push<ConductingPlan>(
  MaterialPageRoute(
    fullscreenDialog: true,
    builder: (_) => ConductingPage(
      title: title,
      piece: piece,
      params: params,
      fullAuthority: fullAuthority,
      rehearsal: rehearsal,
    ),
  ),
);

/// 曲の流れ（フレーズ）に合わせて、ダイナミクスと表現力のスライダーを動かす。
///
/// 各フレーズは [phraseSeconds] 秒で次へ進み、その時点のスライダーの位置がプランになる。
/// 動かすたびに、部の地力（スタミナ・技術・団結）との判定がその場で表示される。
class ConductingPage extends ConsumerStatefulWidget {
  const ConductingPage({
    super.key,
    required this.title,
    required this.piece,
    required this.params,
    required this.fullAuthority,
    this.rehearsal = const RehearsalMemory(),
  });

  final String title;
  final Piece piece;
  final ConductingParams params;
  final bool fullAuthority;

  /// 日頃の練習の記憶（ここから大きく外れた指示は崩れやすい）。
  final RehearsalMemory rehearsal;

  static const phraseSeconds = 10;

  @override
  ConsumerState<ConductingPage> createState() => _ConductingPageState();
}

class _ConductingPageState extends ConsumerState<ConductingPage> {
  late final phrases = PieceStructure.of(widget.piece);
  final _steps = <(int, int)>[];
  int _dyn = 50;
  int _expr = 50;
  int _elapsedMs = 0;
  bool _started = false;
  Timer? _timer;

  static const _tick = Duration(milliseconds: 250);

  int get _index => _steps.length;
  bool get _done => _index >= phrases.length;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _start() {
    setState(() => _started = true);
    // 曲を流す（直接再生できない環境では無音で進む）
    final st = ref.read(piecePlayerProvider);
    if (!st.streamBlocked || st.fromAsset) {
      ref.read(piecePlayerProvider.notifier).play(widget.piece);
    }
    _timer = Timer.periodic(_tick, (_) {
      if (!mounted || _done) return;
      setState(() {
        _elapsedMs += _tick.inMilliseconds;
        if (_elapsedMs >= ConductingPage.phraseSeconds * 1000) _commit();
      });
    });
  }

  void _commit() {
    if (_done) return;
    _steps.add((_dyn, _expr));
    _elapsedMs = 0;
    if (_done) _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('指揮台：${widget.title}'),
        automaticallyImplyLeading: false,
        actions: [
          if (!_done)
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('おまかせにする'),
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            '課題曲 ${widget.piece.category}「${widget.piece.title}」',
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: 4),
          Text(
            '曲の流れに合わせて、音量（ダイナミクス）と表現の振れ幅を決める。'
            '攻めるほど決まれば高評価だが、部の地力が足りないと音が割れる。'
            '${widget.fullAuthority ? '' : '（指揮者ではないので、効果は半分）'}',
            style: theme.textTheme.bodySmall,
          ),
          const SizedBox(height: 12),
          _Timeline(phrases: phrases, index: _index),
          const SizedBox(height: 12),
          _CapacityRow(params: widget.params),
          const SizedBox(height: 4),
          Text(
            widget.rehearsal.sessions == 0
                ? '今年はまだ合奏練習の記録がない。'
                : '日頃の練習：${dynamicsMarkOf(widget.rehearsal.avgDynamics)}'
                      '（${widget.rehearsal.avgDynamics}）・表現 ${widget.rehearsal.avgExpression}'
                      '（${widget.rehearsal.sessions} 回）。ここから大きく外れると崩れやすい。',
            style: theme.textTheme.bodySmall,
          ),
          const SizedBox(height: 12),
          if (!_started)
            FilledButton.icon(
              onPressed: _start,
              icon: const Icon(Icons.play_arrow),
              label: const Text('タクトを構える（演奏開始）'),
            )
          else if (!_done)
            _PhraseControl(
              phrase: phrases[_index],
              index: _index,
              total: phrases.length,
              progress: _elapsedMs / (ConductingPage.phraseSeconds * 1000),
              dynamics: _dyn,
              expression: _expr,
              params: widget.params,
              rehearsal: widget.rehearsal,
              onDynamics: (v) => setState(() => _dyn = v),
              onExpression: (v) => setState(() => _expr = v),
              onNext: () => setState(_commit),
            )
          else
            _ResultView(
              result: ConductingEvaluator.evaluate(
                widget.piece,
                widget.params,
                ConductingPlan(_steps),
                rehearsal: widget.rehearsal,
              ),
              fullAuthority: widget.fullAuthority,
              onFinish: () =>
                  Navigator.pop(context, ConductingPlan(List.of(_steps))),
            ),
        ],
      ),
    );
  }
}

class _Timeline extends StatelessWidget {
  const _Timeline({required this.phrases, required this.index});

  final List<ConductingPhrase> phrases;
  final int index;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Wrap(
      spacing: 6,
      runSpacing: 6,
      children: [
        for (var i = 0; i < phrases.length; i++)
          Chip(
            avatar: Icon(
              i < index
                  ? Icons.check
                  : (i == index ? Icons.graphic_eq : Icons.more_horiz),
              size: 16,
            ),
            label: Text(phrases[i].label),
            backgroundColor: i == index
                ? theme.colorScheme.primaryContainer
                : null,
          ),
      ],
    );
  }
}

/// 部の地力。
class _CapacityRow extends StatelessWidget {
  const _CapacityRow({required this.params});

  final ConductingParams params;

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.labelLarge;
    return Wrap(
      spacing: 16,
      children: [
        Text('部のスタミナ ${params.stamina}', style: style),
        Text('技術 ${params.technique}', style: style),
        Text('団結 ${params.cohesion}', style: style),
      ],
    );
  }
}

class _PhraseControl extends StatelessWidget {
  const _PhraseControl({
    required this.phrase,
    required this.index,
    required this.total,
    required this.progress,
    required this.dynamics,
    required this.expression,
    required this.params,
    required this.rehearsal,
    required this.onDynamics,
    required this.onExpression,
    required this.onNext,
  });

  final ConductingPhrase phrase;
  final int index;
  final int total;
  final double progress;
  final int dynamics;
  final int expression;
  final ConductingParams params;
  final RehearsalMemory rehearsal;
  final ValueChanged<int> onDynamics;
  final ValueChanged<int> onExpression;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // 本番と同じ評価（地力・曲との合い方・練習との差）
    final judged = ConductingJudge.judge(
      params,
      ConductingInput(atMs: 0, dynamics: dynamics, expression: expression),
    );
    final penalty = RehearsalPenalty.penaltyPermille(
      rehearsal,
      dynamics,
      expression,
    );
    final j = RehearsalPenalty.collapses(rehearsal, dynamics, expression)
        ? ConductingJudgement(
            multiplierPermille: judged.multiplierPermille,
            verdict: ConductingVerdict.collapse,
            reason: '練習と違いすぎて、合奏が崩れる',
          )
        : judged;
    final fit = ConductingEvaluator.fit(phrase, dynamics, expression);
    final total1000 =
        j.multiplierPermille * fit ~/ 1000 * (1000 - penalty) ~/ 1000;
    final color = switch (j.verdict) {
      ConductingVerdict.brilliant => Colors.amber.shade700,
      ConductingVerdict.collapse => theme.colorScheme.error,
      ConductingVerdict.steady => theme.colorScheme.primary,
    };
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'フレーズ ${index + 1}/$total「${phrase.label}」',
              style: theme.textTheme.titleMedium,
            ),
            Text(
              '曲の指示: ${phrase.dynamicsMark}・表現 ${phrase.idealExpression >= 70 ? 'たっぷり' : (phrase.idealExpression >= 50 ? 'ほどよく' : '控えめ')}',
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(height: 6),
            LinearProgressIndicator(value: progress.clamp(0, 1)),
            const SizedBox(height: 12),
            Text('ダイナミクス：${dynamicsMarkOf(dynamics)}（$dynamics）'),
            Slider(
              key: const ValueKey('dynamics'),
              value: dynamics.toDouble(),
              max: 100,
              divisions: 20,
              label: dynamicsMarkOf(dynamics),
              onChanged: (v) => onDynamics(v.round()),
            ),
            Text('表現力：$expression'),
            Slider(
              key: const ValueKey('expression'),
              value: expression.toDouble(),
              max: 100,
              divisions: 20,
              onChanged: (v) => onExpression(v.round()),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(color: color, width: 2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${j.verdict.label}　×${(total1000 / 1000).toStringAsFixed(2)}',
                    style: theme.textTheme.titleLarge?.copyWith(color: color),
                  ),
                  Text(j.reason, style: theme.textTheme.bodySmall),
                  Text(
                    '曲との合い方 ×${(fit / 1000).toStringAsFixed(2)}',
                    style: theme.textTheme.bodySmall,
                  ),
                  if (penalty > 0)
                    Text(
                      '練習との差が大きい ×${((1000 - penalty) / 1000).toStringAsFixed(2)}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.error,
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: onNext,
              child: Text(index + 1 < total ? 'この指示で次のフレーズへ' : 'この指示で締めくくる'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ResultView extends StatelessWidget {
  const _ResultView({
    required this.result,
    required this.fullAuthority,
    required this.onFinish,
  });

  final ConductingResult result;
  final bool fullAuthority;
  final VoidCallback onFinish;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bonus = fullAuthority ? result.bonus : result.bonus ~/ 2;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('演奏プラン', style: theme.textTheme.titleMedium),
            for (final p in result.phrases)
              ListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                leading: Icon(switch (p.judgement.verdict) {
                  ConductingVerdict.brilliant => Icons.star,
                  ConductingVerdict.collapse => Icons.warning,
                  ConductingVerdict.steady => Icons.check,
                }),
                title: Text(
                  '${p.phrase.label}：${dynamicsMarkOf(p.dynamics)}・表現 ${p.expression}',
                ),
                subtitle: Text(
                  '${p.judgement.verdict.label} ×${(p.permille / 1000).toStringAsFixed(2)}',
                ),
              ),
            const Divider(),
            Text(
              '全体 ×${(result.totalPermille / 1000).toStringAsFixed(2)}'
              '（演奏評価 ${bonus >= 0 ? '+' : ''}$bonus）',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            FilledButton(onPressed: onFinish, child: const Text('本番の結果へ')),
          ],
        ),
      ),
    );
  }
}
