import '../entities/club.dart';
import '../entities/memory_tag.dart';
import '../entities/npc.dart';
import '../entities/region.dart';
import '../entities/school.dart';
import '../entities/world.dart';

/// [World] の高速参照用インデックス。World ごとに 1 度だけ構築する。
class WorldIndex {
  WorldIndex(this.world)
    : schoolById = {for (final s in world.schools) s.id: s},
      clubById = {for (final c in world.clubs) c.id: c},
      npcById = {for (final n in world.npcs) n.id: n},
      districtById = {for (final d in world.region.districts) d.id: d},
      clubBySchoolId = {for (final c in world.clubs) c.schoolId: c},
      memoriesBySubject = _groupMemories(world.memories);

  final World world;
  final Map<String, School> schoolById;
  final Map<String, Club> clubById;
  final Map<String, Npc> npcById;
  final Map<String, District> districtById;
  final Map<String, Club> clubBySchoolId;
  final Map<String, List<MemoryTag>> memoriesBySubject;

  static Map<String, List<MemoryTag>> _groupMemories(List<MemoryTag> all) {
    final map = <String, List<MemoryTag>>{};
    for (final m in all) {
      (map[m.subjectId] ??= []).add(m);
    }
    return map;
  }

  School schoolOf(Npc npc) => schoolById[npc.schoolId]!;

  Club clubOfSchool(String schoolId) => clubBySchoolId[schoolId]!;

  /// 部員（学年降順・ID 昇順）。
  List<Npc> membersOf(Club club) => [
    for (final id in club.memberIds) npcById[id]!,
  ];

  List<MemoryTag> memoriesOf(String subjectId) =>
      memoriesBySubject[subjectId] ?? const [];
}
