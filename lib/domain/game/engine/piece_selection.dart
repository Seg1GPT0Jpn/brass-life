import '../../career/game_mode.dart';
import '../../entities/memory_tag.dart';
import '../master/set_pieces.dart';
import '../models/game_enums.dart';
import '../models/game_state.dart';
import '../models/piece.dart';
import 'game_context.dart';
import 'memory_writer.dart';
import 'piece_fit.dart';
import 'relations.dart';

/// 春の課題曲の選曲（その年の I〜IV から 1 曲）。
///
/// 顧問は部の実力に最も合う曲を選ぼうとする。プレイヤーの推した曲は、
/// 発言力（幹部・学生指揮、または顧問の評価 65 以上）があればそのまま採用され、
/// なくても顧問の評価が 50 以上で、部の相性が最善の曲と大差なければ採用される。
class PieceSelection {
  const PieceSelection(this.ctx);

  final GameContext ctx;

  /// 今年度（ゲーム内の年数 1..6）の課題曲。
  List<Piece> optionsFor(GameState s) =>
      SetPieces.byYear(ctx.calendar.dateOf(s.turn).academicYearIndex + 1);

  bool hasVoice(GameState s) {
    if (s.mode == GameMode.teacher) return true;
    final role = s.roles[Relations.player];
    return role == ClubRole.captain ||
        role == ClubRole.viceCaptain ||
        role == ClubRole.gradeRep ||
        role == ClubRole.viceRep ||
        role == ClubRole.conductor ||
        s.player.advisorTrust >= 65;
  }

  /// 選曲する。[proposedId] はプレイヤーが推した曲（推していなければ null）。
  ({GameState state, List<String> lines}) run(GameState s, String? proposedId) {
    final options = optionsFor(s);
    final fy = ctx.calendar.dateOf(s.turn).fiscalYear;
    final fit = PieceFit(ctx);
    final stats = fit.bandStats(s, fit.candidates(s));
    final best = fit.bestFor(s, options);
    final proposed = proposedId == null
        ? null
        : options.where((p) => p.id == proposedId).firstOrNull;
    if (proposedId != null && proposed == null) {
      throw ArgumentError('今年の課題曲ではない: $proposedId');
    }
    final lines = <String>[];
    Piece chosen;
    var adopted = false;
    if (proposed == null) {
      chosen = best;
    } else if (proposed == best || hasVoice(s)) {
      chosen = proposed;
      adopted = true;
    } else if (s.player.advisorTrust >= 50 &&
        PieceFit.margin(proposed, stats) >= PieceFit.margin(best, stats) - 5) {
      chosen = proposed;
      adopted = true;
    } else {
      chosen = best;
    }
    final adv = ctx.advisor(s).fullName;
    if (proposed != null) {
      lines.add('あなたは${proposed.label}を推した。');
      lines.add(
        adopted
            ? (proposed == best ? '$adv先生も同じ考えだった。' : '$adv先生はあなたの意見を汲んでくれた。')
            : '$adv先生は「今の部には${best.label}のほうが合っている」と判断した。',
      );
    }
    final margin = PieceFit.margin(chosen, stats);
    lines.add(
      '今年の課題曲は${chosen.label}に決まった。'
      '（部との相性：${PieceFit.fitLabel(margin)}）',
    );
    final weakest = [
      for (final (stat, w) in chosen.demands)
        if ((stats[stat] ?? 0) < PieceFit.requiredLevel(w)) stat,
    ];
    if (weakest.isNotEmpty) {
      lines.add('課題は${weakest.map((e) => e.label).join('・')}。本番までに鍛えたい。');
    }

    final mem = MemoryWriter(ctx, s);
    if (proposed != null) {
      mem.add(
        category: MemoryCategory.practice,
        subjectId: Relations.player,
        objectIds: [ctx.club(s).id],
        reasonKey: adopted
            ? 'piece_proposal_adopted'
            : 'piece_proposal_rejected',
        params: {'actor': s.player.fullName, 'piece': proposed.title},
        importance: adopted ? 25 : 15,
      );
    }
    var player = s.player;
    if (proposed != null) {
      player = player.copyWith(
        motivation: (player.motivation + (adopted ? 4 : -2)).clamp(0, 100),
      );
    }
    final out = mem.apply(
      s.copyWith(player: player, setPieces: {...s.setPieces, '$fy': chosen.id}),
    );
    return (state: out, lines: lines);
  }

  /// 今年度の課題曲（未決定なら null）。
  Piece? currentOf(GameState s) {
    final fy = ctx.calendar.dateOf(s.turn).fiscalYear;
    final id = s.setPieces['$fy'];
    return id == null ? null : SetPieces.byId(id);
  }
}
