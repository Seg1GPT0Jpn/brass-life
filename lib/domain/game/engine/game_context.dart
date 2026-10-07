import '../../../core/rng/simulation_rng.dart';
import '../../../core/rng/world_seed_rng.dart';
import '../../../core/time/game_calendar.dart';
import '../../entities/club.dart';
import '../../entities/npc.dart';
import '../../entities/school.dart';
import '../../entities/world.dart';
import '../../services/world_index.dart';
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

  /// NPC の静的データ（世界生成分 + ゲーム中に生成された分）。
  Npc npc(GameState s, String id) => s.extraNpcs[id] ?? index.npcById[id]!;

  Npc? npcOrNull(GameState s, String id) =>
      s.extraNpcs[id] ?? index.npcById[id];

  School school(GameState s) => index.schoolById[s.schoolId]!;

  Club club(GameState s) => index.clubOfSchool(s.schoolId);

  Npc advisor(GameState s) => index.npcById[club(s).advisorId]!;

  /// 現在の部員のうち在籍中の者（ID 順は roster の順）。
  List<NpcState> activeMembers(GameState s) => [
    for (final id in s.roster)
      if (s.npcs[id]?.active ?? false) s.npcs[id]!,
  ];
}
