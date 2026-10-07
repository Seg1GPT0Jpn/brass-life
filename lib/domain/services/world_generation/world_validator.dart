import '../../entities/world.dart';
import '../../value_objects/person_enums.dart';
import '../../value_objects/school_enums.dart';

/// 生成された世界の整合性チェック。問題があればその説明のリストを返す。
abstract final class WorldValidator {
  static List<String> validate(World w) {
    final problems = <String>[];
    final c = w.config;

    final middles = w.schools
        .where((s) => s.level == SchoolLevel.middle)
        .length;
    final highs = w.schools.where((s) => s.level == SchoolLevel.high).length;
    if (middles != c.middleSchoolCount) problems.add('中学校数 $middles');
    if (highs != c.highSchoolCount) problems.add('高校数 $highs');

    if (w.npcs.length < c.minNpcCount || w.npcs.length > c.maxNpcCount) {
      problems.add('NPC 数 ${w.npcs.length} が範囲外');
    }

    void unique(String label, Iterable<String> ids) {
      final seen = <String>{};
      for (final id in ids) {
        if (!seen.add(id)) problems.add('$label の ID 重複: $id');
      }
    }

    unique('学校', w.schools.map((s) => s.id));
    unique('校名', w.schools.map((s) => s.name));
    unique('部', w.clubs.map((c) => c.id));
    unique('NPC', w.npcs.map((n) => n.id));
    unique('記憶', w.memories.map((m) => m.id));

    final npcIds = {for (final n in w.npcs) n.id};
    final npcById = {for (final n in w.npcs) n.id: n};
    final schoolIds = {for (final s in w.schools) s.id};

    for (final s in w.schools) {
      if (s.level == SchoolLevel.high && s.deviation == null) {
        problems.add('${s.id}: 偏差値なし');
      }
      if (!w.clubs.any((c) => c.id == s.clubId)) {
        problems.add('${s.id}: 部が存在しない');
      }
    }

    for (final club in w.clubs) {
      if (!schoolIds.contains(club.schoolId)) {
        problems.add('${club.id}: 学校が存在しない');
      }
      if (!npcIds.contains(club.advisorId)) {
        problems.add('${club.id}: 顧問が存在しない');
      }
      for (final slot in club.inventory) {
        if (slot.count <= 0) problems.add('${club.id}: 楽器台数が不正');
      }
      for (final id in club.memberIds) {
        final m = npcById[id];
        if (m == null) {
          problems.add('${club.id}: 部員 $id が存在しない');
          continue;
        }
        if (m.role != NpcRole.student) problems.add('$id: 役割が部員でない');
        if (m.grade! >= 2 && m.instrument == null) {
          problems.add('$id: 上級生なのに担当楽器なし');
        }
        if (m.grade! == 1 && m.wishInstrument == null) {
          problems.add('$id: 新入生なのに希望楽器なし');
        }
      }
    }

    if (!schoolIds.contains(w.player.schoolId)) {
      problems.add('プレイヤーの所属校が存在しない');
    }
    return problems;
  }
}
