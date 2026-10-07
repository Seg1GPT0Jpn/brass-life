import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/club.dart';
import '../../../domain/entities/npc.dart';
import '../../../domain/entities/region.dart';
import '../../../domain/entities/school.dart';
import '../../../domain/value_objects/instrument.dart';
import '../../world/world_controller.dart';

/// 楽器 1 種別の需給（保有台数・担当者・希望者）。
class InstrumentRow {
  const InstrumentRow({
    required this.type,
    required this.byCondition,
    required this.owned,
    required this.usable,
    required this.players,
    required this.personalPlayers,
    required this.wishes,
  });

  final InstrumentType type;
  final Map<InstrumentCondition, int> byCondition;
  final int owned;
  final int usable;
  final int players;
  final int personalPlayers;
  final int wishes;
}

class SchoolDetail {
  const SchoolDetail({
    required this.school,
    required this.club,
    required this.district,
    required this.advisor,
    required this.coach,
    required this.membersByGrade,
    required this.instruments,
    required this.affiliated,
    required this.isPlayerSchool,
  });

  final School school;
  final Club club;
  final District district;
  final Npc advisor;
  final Npc? coach;

  /// [3年, 2年, 1年]
  final List<List<Npc>> membersByGrade;
  final List<InstrumentRow> instruments;
  final School? affiliated;
  final bool isPlayerSchool;
}

final schoolDetailProvider = Provider.family<SchoolDetail?, String>((ref, id) {
  final session = ref.watch(sessionProvider);
  final idx = session.index;
  final school = idx.schoolById[id];
  if (school == null) return null;
  final club = idx.clubById[school.clubId]!;
  final members = idx.membersOf(club);

  final instruments = <InstrumentRow>[];
  for (final t in InstrumentType.values) {
    final byCondition = <InstrumentCondition, int>{};
    for (final slot in club.inventory.where((s) => s.type == t)) {
      byCondition[slot.condition] =
          (byCondition[slot.condition] ?? 0) + slot.count;
    }
    final players = members.where((m) => m.instrument == t).toList();
    final wishes = members.where((m) => m.wishInstrument == t).length;
    if (byCondition.isEmpty && players.isEmpty && wishes == 0) continue;
    instruments.add(
      InstrumentRow(
        type: t,
        byCondition: byCondition,
        owned: club.ownedCount(t),
        usable: club.usableCount(t),
        players: players.length,
        personalPlayers: players.where((m) => m.ownsPersonalInstrument).length,
        wishes: wishes,
      ),
    );
  }

  return SchoolDetail(
    school: school,
    club: club,
    district: idx.districtById[school.districtId]!,
    advisor: idx.npcById[club.advisorId]!,
    coach: club.coachId == null ? null : idx.npcById[club.coachId],
    membersByGrade: [
      for (var g = 3; g >= 1; g--)
        [
          for (final m in members)
            if (m.grade == g) m,
        ],
    ],
    instruments: instruments,
    affiliated: school.affiliatedSchoolId == null
        ? null
        : idx.schoolById[school.affiliatedSchoolId],
    isPlayerSchool: session.world.player.schoolId == id,
  );
});
