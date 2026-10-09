import '../models/game_enums.dart';
import '../models/game_state.dart';
import '../models/piece.dart';
import 'game_context.dart';
import 'piece_selection.dart';

/// 練習中に流す曲の指定（Phase 7）。
class PracticeBgmCue {
  const PracticeBgmCue({
    required this.piece,
    required this.startSeconds,
    required this.loop,
  });

  final Piece piece;

  /// 再生を始める位置（秒）。
  final int startSeconds;
  final bool loop;
}

/// 練習の行動に合わせて、今年の課題曲のどこを流すかを決める（乱数なし）。
///
/// - 合奏: 曲の頭から通しで
/// - パート練習・一緒に練習・居残り: 曲の一部分（週ごとに 0 / 30 / 60 / 90 秒から）を繰り返し
abstract final class PracticeBgm {
  static PracticeBgmCue? cueFor(
    GameContext ctx,
    GameState s,
    WeeklyAction action,
  ) {
    if (!s.player.inClub) return null;
    final piece = PieceSelection(ctx).currentOf(s);
    if (piece == null) return null;
    return switch (action) {
      WeeklyAction.ensemble => PracticeBgmCue(
        piece: piece,
        startSeconds: 0,
        loop: false,
      ),
      WeeklyAction.partPractice ||
      WeeklyAction.practiceWith ||
      WeeklyAction.extraPractice => PracticeBgmCue(
        piece: piece,
        startSeconds: (s.turn % 4) * 30,
        loop: true,
      ),
      _ => null,
    };
  }
}
