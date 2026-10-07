import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/club.dart';
import '../../../domain/entities/school.dart';
import '../../../domain/value_objects/school_enums.dart';
import '../../world/world_controller.dart';

enum SchoolSort {
  id('ID順'),
  deviation('偏差値・学力順'),
  tier('強さ順'),
  members('部員数順');

  const SchoolSort(this.label);
  final String label;
}

class SchoolFilter {
  const SchoolFilter({
    this.level,
    this.districtId,
    this.tier,
    this.ownership,
    this.sort = SchoolSort.id,
  });

  final SchoolLevel? level;
  final String? districtId;
  final ClubTier? tier;
  final SchoolOwnership? ownership;
  final SchoolSort sort;

  SchoolFilter copyWith({
    SchoolLevel? Function()? level,
    String? Function()? districtId,
    ClubTier? Function()? tier,
    SchoolOwnership? Function()? ownership,
    SchoolSort? sort,
  }) => SchoolFilter(
    level: level != null ? level() : this.level,
    districtId: districtId != null ? districtId() : this.districtId,
    tier: tier != null ? tier() : this.tier,
    ownership: ownership != null ? ownership() : this.ownership,
    sort: sort ?? this.sort,
  );
}

class SchoolFilterViewModel extends Notifier<SchoolFilter> {
  @override
  SchoolFilter build() => const SchoolFilter();

  void setLevel(SchoolLevel? v) => state = state.copyWith(level: () => v);
  void setDistrict(String? v) => state = state.copyWith(districtId: () => v);
  void setTier(ClubTier? v) => state = state.copyWith(tier: () => v);
  void setOwnership(SchoolOwnership? v) =>
      state = state.copyWith(ownership: () => v);
  void setSort(SchoolSort v) => state = state.copyWith(sort: v);
}

final schoolFilterProvider =
    NotifierProvider<SchoolFilterViewModel, SchoolFilter>(
      SchoolFilterViewModel.new,
    );

/// 一覧の 1 行分。
class SchoolRow {
  const SchoolRow({
    required this.school,
    required this.club,
    required this.districtName,
    required this.isPlayerSchool,
  });

  final School school;
  final Club club;
  final String districtName;
  final bool isPlayerSchool;
}

final filteredSchoolsProvider = Provider<List<SchoolRow>>((ref) {
  final session = ref.watch(sessionProvider);
  final f = ref.watch(schoolFilterProvider);
  final idx = session.index;

  final rows = [
    for (final s in session.world.schools)
      if ((f.level == null || s.level == f.level) &&
          (f.districtId == null || s.districtId == f.districtId) &&
          (f.ownership == null || s.ownership == f.ownership) &&
          (f.tier == null || idx.clubById[s.clubId]!.tier == f.tier))
        SchoolRow(
          school: s,
          club: idx.clubById[s.clubId]!,
          districtName: idx.districtById[s.districtId]!.name,
          isPlayerSchool: s.id == session.world.player.schoolId,
        ),
  ];

  int byId(SchoolRow a, SchoolRow b) => a.school.id.compareTo(b.school.id);
  rows.sort(switch (f.sort) {
    SchoolSort.id => byId,
    SchoolSort.deviation => (a, b) {
      final c = b.school.academicLevel.compareTo(a.school.academicLevel);
      return c != 0 ? c : byId(a, b);
    },
    SchoolSort.tier => (a, b) {
      final c = b.club.tier.rank.compareTo(a.club.tier.rank);
      return c != 0 ? c : byId(a, b);
    },
    SchoolSort.members => (a, b) {
      final c = b.club.memberIds.length.compareTo(a.club.memberIds.length);
      return c != 0 ? c : byId(a, b);
    },
  });
  return rows;
});
