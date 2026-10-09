import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/feature_flags.dart';
import '../../../domain/game/conducting/conducting.dart';
import '../../../domain/game/conducting/conducting_effect.dart';
import '../../../domain/game/engine/concert_engine.dart';
import '../../../domain/game/engine/piece_fit.dart';
import '../../../domain/game/engine/piece_selection.dart';
import '../../../domain/game/master/approach_cards.dart';
import '../../../domain/game/models/game_enums.dart';
import '../game_controller.dart';
import '../pieces/piece_player.dart';
import '../scene/performance_stage.dart';
import 'conducting_page.dart';

/// 本番（オーディション・コンクール・定期演奏会）を行い、演出つきで結果を見せる。
///
/// コンクールと定期演奏会では、指揮者ミニゲームで演奏プランを立ててから臨める
/// （「おまかせ」ならプランなし）。[card] は顧問モードでは null。
Future<void> runPerformance(
  BuildContext context,
  WidgetRef ref, {
  required PendingEventType type,
  required ApproachCard? card,
  required String title,
}) async {
  final s = ref.read(gameControllerProvider)!;
  final ctx = ref.read(gameContextProvider)!;
  final vm = ref.read(gameControllerProvider.notifier);
  // 演奏者（本番前の状態で決める）: コンクールは出場メンバー、それ以外は全員。
  final scene = ref.read(clubSceneProvider)!;
  final performers = [
    for (final a in scene.actors)
      if (!a.isAdvisor &&
          (type != PendingEventType.contest ||
              s.contestMembers.contains(a.id) ||
              a.isPlayer && ConductingEffect.fullAuthority(s)))
        a,
  ];
  final piece = PieceSelection(ctx).currentOf(s);

  ConductingPlan? plan;
  final canConduct =
      FeatureFlags.conductingMiniGame &&
      piece != null &&
      (type == PendingEventType.contest || type == PendingEventType.concert);
  if (canConduct) {
    final members = type == PendingEventType.contest
        ? s.contestMembers
        : ConcertEngine(ctx).performers(s);
    plan = await showConductingPage(
      context,
      title: title,
      piece: piece,
      params: ConductingParams.fromBandStats(
        PieceFit(ctx).bandStats(s, members),
      ),
      fullAuthority: ConductingEffect.fullAuthority(s),
    );
    if (!context.mounted) return;
  }
  // 指揮をしなかったコンクールでも、今年の課題曲を流す
  if (plan == null &&
      type == PendingEventType.contest &&
      piece != null &&
      !ref.read(piecePlayerProvider).streamBlocked) {
    ref.read(piecePlayerProvider.notifier).play(piece);
  }
  final lines = switch (type) {
    PendingEventType.audition => vm.resolveAudition(card!),
    PendingEventType.contest => vm.resolveContest(card, plan: plan),
    _ => vm.resolveConcert(card, plan: plan),
  };
  if (!context.mounted) return;
  await showPerformanceStage(
    context,
    title: title,
    lines: lines,
    performers: performers,
  );
}
