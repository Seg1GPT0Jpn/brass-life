import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers.dart';
import '../../../domain/master/trait_definitions.dart';
import '../../../domain/value_objects/instrument.dart';
import '../../../domain/value_objects/person_enums.dart';
import '../../../domain/value_objects/school_enums.dart';
import '../../world/world_controller.dart';

/// 世界全体の統計（表示用）。
class WorldStats {
  const WorldStats({
    required this.middleCount,
    required this.highCount,
    required this.privateCount,
    required this.npcByRole,
    required this.studentsByGrade,
    required this.tierMiddle,
    required this.tierHigh,
    required this.deviationBands,
    required this.executive,
    required this.selection,
    required this.mood,
    required this.traitCounts,
    required this.instrumentPlayers,
    required this.wishes,
    required this.memoryCount,
  });

  final int middleCount;
  final int highCount;
  final int privateCount;
  final List<(String, int)> npcByRole;
  final List<(String, int)> studentsByGrade;
  final List<(String, int)> tierMiddle;
  final List<(String, int)> tierHigh;
  final List<(String, int)> deviationBands;
  final List<(String, int)> executive;
  final List<(String, int)> selection;
  final List<(String, int)> mood;
  final List<(String, int)> traitCounts;
  final List<(String, int)> instrumentPlayers;
  final List<(String, int)> wishes;
  final int memoryCount;
}

final worldStatsProvider = Provider<WorldStats>((ref) {
  final w = ref.watch(sessionProvider).world;
  final schoolById = {for (final s in w.schools) s.id: s};

  List<(String, int)> countEnum<T extends Enum>(
    List<T> values,
    String Function(T) label,
    Iterable<T> items,
  ) {
    final counts = {for (final v in values) v: 0};
    for (final i in items) {
      counts[i] = counts[i]! + 1;
    }
    return [for (final v in values) (label(v), counts[v]!)];
  }

  final students = w.npcs.where((n) => n.role == NpcRole.student).toList();

  final bands = <(String, int)>[];
  for (var b = 35; b < 75; b += 5) {
    final c = w.schools
        .where(
          (s) =>
              s.deviation != null && s.deviation! >= b && s.deviation! < b + 5,
        )
        .length;
    bands.add(('$b〜${b + 4}', c));
  }

  final traitCounter = {for (final t in traitDefinitions) t.id: 0};
  for (final n in w.npcs) {
    for (final t in n.traits) {
      traitCounter[t.traitId] = traitCounter[t.traitId]! + 1;
    }
  }

  return WorldStats(
    middleCount: w.schools.where((s) => s.level == SchoolLevel.middle).length,
    highCount: w.schools.where((s) => s.level == SchoolLevel.high).length,
    privateCount: w.schools.where((s) => s.isPrivate).length,
    npcByRole: countEnum(
      NpcRole.values,
      (r) => r.label,
      w.npcs.map((n) => n.role),
    ),
    studentsByGrade: [
      for (final level in SchoolLevel.values)
        for (var g = 1; g <= 3; g++)
          (
            '${level == SchoolLevel.middle ? '中' : '高'}$g',
            students
                .where(
                  (n) => n.grade == g && schoolById[n.schoolId]!.level == level,
                )
                .length,
          ),
    ],
    tierMiddle: countEnum(
      ClubTier.values,
      (t) => t.label,
      w.clubs
          .where((c) => schoolById[c.schoolId]!.level == SchoolLevel.middle)
          .map((c) => c.tier),
    ),
    tierHigh: countEnum(
      ClubTier.values,
      (t) => t.label,
      w.clubs
          .where((c) => schoolById[c.schoolId]!.level == SchoolLevel.high)
          .map((c) => c.tier),
    ),
    deviationBands: bands,
    executive: countEnum(
      ExecutiveSystem.values,
      (e) => e.label,
      w.clubs.map((c) => c.executiveSystem),
    ),
    selection: countEnum(
      SelectionCulture.values,
      (e) => e.label,
      w.clubs.map((c) => c.selectionCulture),
    ),
    mood: countEnum(
      ClubMood.values,
      (e) => e.label,
      w.clubs.map((c) => c.mood),
    ),
    traitCounts: [
      for (final t in traitDefinitions) (t.label, traitCounter[t.id]!),
    ],
    instrumentPlayers: countEnum(
      InstrumentType.values,
      (t) => t.label,
      students.where((n) => n.instrument != null).map((n) => n.instrument!),
    ),
    wishes: countEnum(
      InstrumentType.values,
      (t) => t.label,
      students
          .where((n) => n.wishInstrument != null)
          .map((n) => n.wishInstrument!),
    ),
    memoryCount: w.memories.length,
  );
});

/// 決定性検証の状態。
sealed class VerificationState {
  const VerificationState();
}

class VerificationIdle extends VerificationState {
  const VerificationIdle();
}

class VerificationRunning extends VerificationState {
  const VerificationRunning();
}

class VerificationDone extends VerificationState {
  const VerificationDone({
    required this.matched,
    required this.expected,
    required this.actual,
    required this.elapsedMs,
  });

  final bool matched;
  final String expected;
  final String actual;
  final int elapsedMs;
}

class VerificationViewModel extends Notifier<VerificationState> {
  @override
  VerificationState build() {
    ref.watch(sessionProvider);
    return const VerificationIdle();
  }

  Future<void> run() async {
    state = const VerificationRunning();
    await Future<void>.delayed(const Duration(milliseconds: 32));
    final world = ref.read(sessionProvider).world;
    final r = ref.read(verifyDeterminismUseCaseProvider)(world);
    state = VerificationDone(
      matched: r.matched,
      expected: r.expected,
      actual: r.actual,
      elapsedMs: r.elapsedMs,
    );
  }
}

final verificationViewModelProvider =
    NotifierProvider<VerificationViewModel, VerificationState>(
      VerificationViewModel.new,
    );
