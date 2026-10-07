import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/npc.dart';
import '../../../domain/value_objects/instrument.dart';
import '../../../domain/value_objects/person_enums.dart';
import '../../world/world_controller.dart';

class NpcFilter {
  const NpcFilter({
    this.query = '',
    this.schoolId,
    this.role,
    this.grade,
    this.instrument,
    this.traitId,
  });

  final String query;
  final String? schoolId;
  final NpcRole? role;
  final int? grade;

  /// 担当楽器または希望楽器で一致。
  final InstrumentType? instrument;
  final String? traitId;

  bool get isEmpty =>
      query.isEmpty &&
      schoolId == null &&
      role == null &&
      grade == null &&
      instrument == null &&
      traitId == null;
}

class NpcFilterViewModel extends Notifier<NpcFilter> {
  @override
  NpcFilter build() => const NpcFilter();

  NpcFilter _with({
    String? query,
    String? Function()? schoolId,
    NpcRole? Function()? role,
    int? Function()? grade,
    InstrumentType? Function()? instrument,
    String? Function()? traitId,
  }) => NpcFilter(
    query: query ?? state.query,
    schoolId: schoolId != null ? schoolId() : state.schoolId,
    role: role != null ? role() : state.role,
    grade: grade != null ? grade() : state.grade,
    instrument: instrument != null ? instrument() : state.instrument,
    traitId: traitId != null ? traitId() : state.traitId,
  );

  void setQuery(String v) => state = _with(query: v.trim());
  void setSchool(String? v) => state = _with(schoolId: () => v);
  void setRole(NpcRole? v) => state = _with(role: () => v);
  void setGrade(int? v) => state = _with(grade: () => v);
  void setInstrument(InstrumentType? v) => state = _with(instrument: () => v);
  void setTrait(String? v) => state = _with(traitId: () => v);
  void reset() => state = const NpcFilter();
}

final npcFilterProvider = NotifierProvider<NpcFilterViewModel, NpcFilter>(
  NpcFilterViewModel.new,
);

final filteredNpcsProvider = Provider<List<Npc>>((ref) {
  final session = ref.watch(sessionProvider);
  final f = ref.watch(npcFilterProvider);
  return [
    for (final n in session.world.npcs)
      if ((f.schoolId == null || n.schoolId == f.schoolId) &&
          (f.role == null || n.role == f.role) &&
          (f.grade == null || n.grade == f.grade) &&
          (f.instrument == null ||
              n.instrument == f.instrument ||
              n.wishInstrument == f.instrument) &&
          (f.traitId == null || n.hasTrait(f.traitId!)) &&
          (f.query.isEmpty ||
              '${n.familyName}${n.givenName}'.contains(f.query) ||
              n.id.contains(f.query)))
        n,
  ];
});
