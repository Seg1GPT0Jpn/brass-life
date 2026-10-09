import '../../career/game_mode.dart';
import '../engine/game_context.dart';
import '../engine/piece_fit.dart';
import '../engine/piece_selection.dart';
import '../engine/relations.dart';
import '../models/game_enums.dart';
import '../models/game_state.dart';
import 'conducting.dart';
import 'rehearsal.dart';

/// 本番の指揮プランを演奏評価に反映する（コンクール・定期演奏会で共通）。
///
/// 指揮の権限: 学生指揮（と顧問モードの顧問）は補正をそのまま、
/// それ以外の部員は「自分の演奏プラン」として半分だけ反映する。
abstract final class ConductingEffect {
  static bool fullAuthority(GameState s) =>
      s.roles[Relations.player] == ClubRole.conductor ||
      s.mode == GameMode.teacher;

  /// 補正値と結果の説明。今年の課題曲がなければ効果なし。
  static ({int bonus, List<String> lines}) apply(
    GameContext ctx,
    GameState s,
    List<String> members,
    ConductingPlan plan,
  ) {
    final piece = PieceSelection(ctx).currentOf(s);
    if (piece == null) return (bonus: 0, lines: const []);
    final params = ConductingParams.fromBandStats(
      PieceFit(ctx).bandStats(s, members),
    );
    final fy = ctx.calendar.dateOf(s.turn).fiscalYear;
    final result = ConductingEvaluator.evaluate(
      piece,
      params,
      plan,
      rehearsal: RehearsalRules.of(s, fy),
    );
    final full = fullAuthority(s);
    final bonus = full ? result.bonus : result.bonus ~/ 2;
    return (
      bonus: bonus,
      lines: [...result.summary(), if (!full) '（指揮者ではないので、演奏プランの効果は半分）'],
    );
  }
}
