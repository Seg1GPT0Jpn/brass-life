import '../../../core/time/game_calendar.dart';
import '../../entities/club.dart';
import '../../entities/memory_tag.dart';
import '../../entities/npc.dart';
import '../../entities/region.dart';
import '../../entities/school.dart';
import '../../value_objects/school_enums.dart';

/// ゲーム開始前の背景となる記憶（入部・過去のコンクール・指導者の着任）を生成する。
/// 乱数は使わず、生成済みの世界データから決定論的に導出する。
class MemorySeeder {
  MemorySeeder(this._calendar, this._region);

  final GameCalendar _calendar;
  final Region _region;
  int _seq = 0;

  String _nextId() => 'mem_${(_seq++).toString().padLeft(5, '0')}';

  List<MemoryTag> seed({
    required List<School> schools,
    required List<Club> clubs,
    required Map<String, Npc> npcById,
  }) {
    final schoolById = {for (final s in schools) s.id: s};
    final out = <MemoryTag>[];
    for (final club in clubs) {
      final school = schoolById[club.schoolId]!;
      final advisor = npcById[club.advisorId]!;
      out.add(_appointment(advisor, school, 'advisor_appointed'));
      if (club.coachId != null) {
        out.add(
          _appointment(npcById[club.coachId]!, school, 'coach_appointed'),
        );
      }
      for (final id in club.memberIds) {
        final m = npcById[id]!;
        if (m.grade! < 2) continue;
        out.add(_joined(m, school));
        for (final record in club.history) {
          // 2 年生は昨年度、3 年生は過去 2 年度のコンクールに参加している。
          if (record.fiscalYear < _calendar.startYear - (m.grade! - 1)) {
            continue;
          }
          if (record.stage == ContestStage.none) continue;
          out.add(_contest(m, school, club, record));
        }
      }
    }
    return out;
  }

  MemoryTag _appointment(Npc adult, School school, String key) {
    final years = adult.advisorProfile!.yearsAtSchool;
    final turn = _calendar.firstTurnOfAcademicYear(-(years - 1));
    return MemoryTag(
      id: _nextId(),
      date: _calendar.dateOf(turn),
      category: MemoryCategory.appointment,
      subjectId: adult.id,
      objectIds: [school.clubId],
      reasonKey: key,
      params: {'school': school.name},
      importance: 40,
      visibility: MemoryVisibility.public,
    );
  }

  MemoryTag _joined(Npc m, School school) {
    // 入部はその学年の新年度 3 週目。
    final turn = _calendar.firstTurnOfAcademicYear(-(m.grade! - 1)) + 2;
    return MemoryTag(
      id: _nextId(),
      date: _calendar.dateOf(turn),
      category: MemoryCategory.joinedClub,
      subjectId: m.id,
      objectIds: [school.clubId],
      reasonKey: 'joined_club',
      params: {'school': school.name, 'instrument': m.instrument!.label},
      importance: 30,
      visibility: MemoryVisibility.involved,
    );
  }

  MemoryTag _contest(Npc m, School school, Club club, ContestRecord r) {
    final (month, week) = switch (r.stage) {
      ContestStage.district => (7, 4),
      ContestStage.prefectural => (8, 2),
      ContestStage.block => (8, 4),
      ContestStage.national => (10, 3),
      ContestStage.none => (7, 4),
    };
    final weeks = GameCalendar.mondaysInMonth(r.fiscalYear, month);
    final turn = _calendar.turnOf(
      r.fiscalYear,
      month,
      week > weeks ? weeks : week,
    );
    final importance =
        r.stage.level * 15 +
        (r.award == ContestAward.gold ? 10 : 0) +
        (r.isGoldWithoutAdvance ? 10 : 0);
    return MemoryTag(
      id: _nextId(),
      date: _calendar.dateOf(turn),
      category: MemoryCategory.contestResult,
      subjectId: m.id,
      objectIds: [club.id],
      reasonKey: 'contest_result',
      params: {
        'fiscalYear': '${r.fiscalYear}',
        'contest': _region.contestName,
        'stage': r.stage.label,
        'award': r.award.label,
        'suffix': r.isGoldWithoutAdvance ? '（代表落ち）' : '',
        'division': r.division.label,
      },
      importance: importance.clamp(0, 100),
      visibility: MemoryVisibility.public,
    );
  }
}
