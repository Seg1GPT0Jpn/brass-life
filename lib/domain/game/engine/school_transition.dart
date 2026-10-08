import '../../entities/memory_tag.dart';
import '../../value_objects/person_enums.dart';
import '../../value_objects/relationship_vector.dart';
import '../../value_objects/school_enums.dart';
import '../models/game_enums.dart';
import '../models/game_state.dart';
import 'game_context.dart';
import 'memory_writer.dart';
import 'relations.dart';
import 'roster_service.dart';

/// 卒業した NPC の進学先決定と、プレイヤーの高校進学（環境の再構築）。
class SchoolTransition {
  const SchoolTransition(this.ctx);

  final GameContext ctx;

  /// 中学を卒業する NPC の進学先（高校）。Seed とその NPC の状態だけで決まる。
  ///
  /// 学力に近い偏差値の学校・同じ地区の学校を選びやすく、
  /// 上手くてやる気のある部員は吹奏楽部の強い学校を選びやすい。
  String highSchoolFor(GameState s, String npcId) {
    final n = ctx.npc(s, npcId);
    final st = s.npcs[npcId];
    final rng = ctx.sim.stream(
      turn: s.turn,
      domain: 'npc_destination',
      actor: npcId,
    );
    final target = 35 + n.academic * 4 ~/ 10;
    final home = ctx.index.schoolById[n.schoolId]!;
    final musical = st != null && st.skill >= 350 && st.motivation >= 50;
    final highs = [
      for (final sc in ctx.world.schools)
        if (sc.level == SchoolLevel.high) sc,
    ]..sort((a, b) => a.id.compareTo(b.id));
    final weights = [
      for (final h in highs)
        (30 - (h.deviation! - target).abs() * 3).clamp(1, 30) *
            (musical ? ctx.index.clubOfSchool(h.id).tier.rank : 1) *
            (n.gender == Gender.male && h.girlsOnly ? 0 : 1) *
            // 同じ地区の高校に進学しやすい
            (h.districtId == home.districtId ? 4 : 1),
    ];
    return rng.weighted(highs, weights).id;
  }

  /// 高校への進学: 名簿・役職・部の状態をリセットし、新しい学校で再構築する。
  ({GameState state, List<String> lines}) enterHighSchool(
    GameState s,
    String newSchoolId,
    int fiscalYear,
  ) {
    final club = ctx.index.clubOfSchool(newSchoolId);
    final school = ctx.index.schoolById[newSchoolId]!;
    final m = RosterService(ctx).materialize(club, fiscalYear);
    final roster = [...m.roster];
    final npcs = Map.of(s.npcs);
    // 旧所属の NPC は部員ではなくなる（関係性・記憶は残る）。
    for (final id in npcs.keys.toList()) {
      npcs[id] = npcs[id]!.copyWith(active: false);
    }
    npcs.addAll(m.states);
    final extra = {...s.extraNpcs, ...m.extra};
    final relations = Map.of(s.relations);
    final mem = MemoryWriter(ctx, s);
    final lines = <String>['${school.name}に入学した。'];

    // 中学の先輩・同級生との再会
    final reunited = <String>[];
    for (final e in s.npcDestinations.entries) {
      final (destId, gradYear) = parseDestination(e.value);
      if (destId != newSchoolId) continue;
      final old = s.npcs[e.key];
      if (old == null || old.quit) continue;
      final grade = fiscalYear - gradYear + 1;
      if (grade < 1 || grade > 3) continue;
      npcs[e.key] = old.copyWith(
        active: true,
        retired: false,
        grade: grade,
        lowMotivationWeeks: 0,
        // 1 年生は改めて楽器を決める（中学の楽器を希望する）
        instrument: grade == 1 ? null : old.instrument,
        wish: grade == 1 ? old.instrument : old.wish,
      );
      roster.add(e.key);
      reunited.add(e.key);
      // 再会は必ず記憶に残る。もともと仲が良ければ関係も深まる。
      final aff = Relations.get(s, Relations.player, e.key).affection;
      const d = RelationshipVector(affection: 5, trust: 5);
      if (aff > 0) Relations.addMutual(relations, Relations.player, e.key, d);
      mem.add(
        category: MemoryCategory.life,
        subjectId: Relations.player,
        objectIds: [e.key],
        reasonKey: 'reunited',
        params: {'target': ctx.npc(s, e.key).fullName, 'school': school.name},
        delta: aff > 0 ? d : null,
        importance: aff > 0 ? 30 : 20,
      );
    }
    if (reunited.isNotEmpty) {
      lines.add(
        '中学の吹奏楽部の仲間 ${reunited.length} 人（${reunited.take(4).map((id) => ctx.npc(s, id).fullName).join('、')}'
        '${reunited.length > 4 ? ' ほか' : ''}）と同じ部になった。',
      );
    }
    lines.add('吹奏楽部（${club.tier.label}・部員 ${roster.length + 1} 人）に入部した。');

    final p = s.player;
    final player = p.copyWith(
      grade: 1,
      retired: false,
      quitClub: false,
      quitCount: 0,
      quitTurn: null,
      previousInstrument: p.instrument ?? p.previousInstrument,
      instrument: null,
      wishes: const [],
      advisorTrust: 50,
      fatigue: 10,
      motivation: (p.motivation + 10).clamp(0, 100),
    );
    mem.add(
      category: MemoryCategory.joinedClub,
      subjectId: Relations.player,
      objectIds: [club.id],
      reasonKey: 'entered_high',
      params: {'school': school.name},
      importance: 60,
    );
    final next = mem.apply(
      s.copyWith(
        stage: GameStage.high,
        schoolId: newSchoolId,
        schoolHistory: [...s.schoolHistory, newSchoolId],
        roster: roster,
        npcs: npcs,
        extraNpcs: extra,
        relations: relations,
        player: player,
        roles: const {},
        contest: null,
        contestMembers: const [],
        soloistId: null,
        clubHistory: const [],
        executiveSelectionTurn: null,
        lastConcertYear: null,
        exam: null,
      ),
    );
    return (state: next, lines: lines);
  }

  /// 進学先の記録形式「学校ID|入学年度」。
  static String encodeDestination(String schoolId, int fiscalYear) =>
      '$schoolId|$fiscalYear';

  static (String, int) parseDestination(String v) {
    final parts = v.split('|');
    return (parts[0], int.parse(parts[1]));
  }
}
