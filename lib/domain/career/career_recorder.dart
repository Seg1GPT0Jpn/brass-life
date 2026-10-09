import '../game/engine/ending_analyzer.dart';
import '../game/models/game_state.dart';
import 'career_record.dart';

/// 6 年間を終えた GameState から、周回をまたいで残す記録を作る。
abstract final class CareerRecorder {
  /// [clearedAt] は記録日時（ドメインは時計を持たないので呼び出し側が渡す）。
  static CareerRecord record(
    GameState s,
    EndingResult ending, {
    required String clearedAt,
  }) {
    final path = s.achievements
        .where((a) => a.kind.startsWith('univ') || a.kind == 'ronin')
        .lastOrNull;
    final contests = s.achievements.where((a) => a.kind == 'contest').toList()
      ..sort((a, b) => b.weight.compareTo(a.weight));
    return CareerRecord(
      worldSeed: s.worldSeed,
      playerName: s.player.fullName,
      title: ending.title,
      pathKind: path?.kind ?? 'none',
      pathLabel: path?.label ?? '進路未定',
      finalSkill: s.player.skill,
      finalMusicality: s.player.musicality,
      roles: {
        for (final a in s.achievements)
          if (a.kind.startsWith('role:')) a.kind.substring(5),
      }.toList(),
      bestContest: contests.isEmpty ? '' : contests.first.label,
      quitAtEnd: s.player.quitClub,
      clearedAt: clearedAt,
    );
  }
}
