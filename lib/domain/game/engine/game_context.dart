import '../../../core/rng/simulation_rng.dart';
import '../../../core/rng/world_seed_rng.dart';
import '../../../core/time/game_calendar.dart';
import '../../entities/club.dart';
import '../../entities/npc.dart';
import '../../entities/school.dart';
import '../../entities/world.dart';
import '../../services/world_index.dart';
import '../../value_objects/school_enums.dart';
import '../models/game_state.dart';

/// ゲームエンジンが参照する不変の文脈（世界・暦・乱数工場）。
class GameContext {
  GameContext(this.world)
    : index = WorldIndex(world),
      calendar = GameCalendar(world.config.startYear),
      sim = SimulationRng(world.seed),
      worldRng = WorldSeedRng(world.seed);

  final World world;
  final WorldIndex index;
  final GameCalendar calendar;
  final SimulationRng sim;
  final WorldSeedRng worldRng;

  int get startYear => world.config.startYear;

  /// コンクール期の「その強さ帯の部として標準的な」メンバー平均熟練度。
  /// 世界生成時の全部活から、校種×強さ帯ごとに
  /// 「上級生 + 新入生（熟練度 60 とみなす）の上位・出場上限人数」の平均を求め、
  /// 4 月から夏までの成長分（+35）を足したもの。演奏評価の基準に使う。
  late final Map<(SchoolLevel, ClubTier), int> expectedContestSkill = () {
    final sums = <(SchoolLevel, ClubTier), (int, int)>{};
    for (final club in world.clubs) {
      final school = index.schoolById[club.schoolId]!;
      final limit = club.division == BandDivision.small
          ? 30
          : (school.level == SchoolLevel.high ? 55 : 50);
      final skills = [
        for (final id in club.memberIds)
          if ((index.npcById[id]!.grade ?? 1) >= 2)
            index.npcById[id]!.instrumentSkill
          else
            60,
      ]..sort((a, b) => b.compareTo(a));
      final top = skills.take(limit).toList();
      if (top.isEmpty) continue;
      final avg = top.reduce((a, b) => a + b) ~/ top.length;
      final key = (school.level, club.tier);
      final cur = sums[key] ?? (0, 0);
      sums[key] = (cur.$1 + avg, cur.$2 + 1);
    }
    return {for (final e in sums.entries) e.key: e.value.$1 ~/ e.value.$2 + 35};
  }();

  /// NPC の静的データ（世界生成分 + ゲーム中に生成された分）。
  Npc npc(GameState s, String id) => s.extraNpcs[id] ?? index.npcById[id]!;

  Npc? npcOrNull(GameState s, String id) =>
      s.extraNpcs[id] ?? index.npcById[id];

  School school(GameState s) => index.schoolById[s.schoolId]!;

  Club club(GameState s) => index.clubOfSchool(s.schoolId);

  Npc advisor(GameState s) => index.npcById[club(s).advisorId]!;

  /// 現在の部員のうち部活動に参加している者（引退した 3 年生を除く。順序は roster の順）。
  List<NpcState> activeMembers(GameState s) => [
    for (final id in s.roster)
      if ((s.npcs[id]?.active ?? false) && !s.npcs[id]!.retired) s.npcs[id]!,
  ];
}
