import '../../entities/club.dart';
import '../../entities/npc.dart';
import '../../value_objects/instrument.dart';
import '../../value_objects/person_enums.dart';
import '../../value_objects/school_enums.dart';
import '../../services/world_generation/allocation.dart';
import '../../services/world_generation/npc_generator.dart';
import '../../services/world_generation/seat_assigner.dart';
import '../models/game_state.dart';
import 'game_context.dart';

/// 部員名簿の管理（初期名簿・翌年度以降の新入生の遅延生成・ある年度の名簿の具現化）。
///
/// 新入生は WorldSeedRng のパス `world/club/{id}/cohort/{入学年度}/{n}` から生成するため、
/// プレイヤーの選択とは無関係に、Seed だけで誰が入部するかが決まる。
class RosterService {
  const RosterService(this.ctx);

  final GameContext ctx;

  /// NPC の初期状態（世界生成時の値から作る）。
  static NpcState initialState(Npc n) => NpcState(
    id: n.id,
    grade: n.grade ?? 1,
    instrument: n.instrument,
    skill: n.instrument != null ? n.instrumentSkill : 0,
    motivation:
        (60 +
                n.personality.conscientiousness ~/ 5 +
                n.personality.ambition ~/ 10)
            .clamp(20, 95),
    stress: (20 + n.personality.neuroticism ~/ 5).clamp(0, 60),
    wish: n.wishInstrument,
  );

  /// ゲーム開始時点の名簿。
  (List<String>, Map<String, NpcState>) initialRoster(Club club) {
    final members = ctx.index.membersOf(club);
    return (
      [for (final m in members) m.id],
      {for (final m in members) m.id: initialState(m)},
    );
  }

  /// [entryYear] 年度に入学する新入生（[entryYear] が開始年度以前なら世界生成済みの部員）。
  List<Npc> cohort(Club club, int entryYear) {
    final start = ctx.startYear;
    if (entryYear <= start) {
      final grade = start - entryYear + 1;
      return [
        for (final m in ctx.index.membersOf(club))
          if (m.grade == grade) m,
      ];
    }
    final school = ctx.index.schoolById[club.schoolId]!;
    final suffix = school.id.substring(4);
    final base = 'world/club/${club.id}/cohort/$entryYear';
    final rng = ctx.worldRng.stream(base);
    final avg = club.memberIds.length / 3;
    final count = rng.normalInt(
      mean: avg.round(),
      sd: (avg * 0.2).round() + 1,
      min: 1,
      max: (avg * 1.8).round() + 2,
    );
    final usedNames = <String>{};
    final out = <Npc>[];
    for (var n = 0; n < count; n++) {
      final path = '$base/$n';
      var npc = NpcGenerator.student(
        ctx.worldRng.stream(path),
        id: 'npc_${suffix}_e${entryYear}_${n.toString().padLeft(2, '0')}',
        schoolId: school.id,
        grade: 1,
        level: school.level,
        tier: club.tier,
        girlsOnly: school.girlsOnly,
        schoolAcademic: school.academicLevel,
        usedNames: usedNames,
      );
      if (school.level == SchoolLevel.high &&
          npc.background == MusicBackground.middleSchoolBand) {
        final prevRng = ctx.worldRng.stream('$path/previous');
        final prev = NpcGenerator.previousInstrument(prevRng, npc);
        npc = npc.copyWith(
          previousInstrument: prev,
          previousSkill: NpcGenerator.skill(
            prevRng,
            fit: npc.aptitude.fitFor(prev),
            yearsTenths: 30,
            practiceIntensity: 3,
            teaching: 50,
          ),
        );
      }
      final wishRng = ctx.worldRng.stream('$path/wish');
      final keep = wishRng.chance(7000);
      npc = npc.copyWith(
        wishInstrument: npc.previousInstrument != null && keep
            ? npc.previousInstrument
            : NpcGenerator.wishInstrument(wishRng, npc),
      );
      out.add(npc);
    }
    return out;
  }

  /// [fiscalYear] 年度の 4 月時点の名簿を具現化する（プレイヤーが途中から所属する学校用）。
  ///
  /// 2・3 年生は楽器が割り当てられ、在籍年数に応じた熟練度を持つ。
  /// 1 年生は楽器未定（希望あり）。生成済みでない NPC は戻り値の extra に含まれる。
  ({List<String> roster, Map<String, NpcState> states, Map<String, Npc> extra})
  materialize(Club club, int fiscalYear) {
    final advisor = ctx.index.npcById[club.advisorId]!;
    final teaching = advisor.advisorProfile!.teachingSkill;
    final roster = <String>[];
    final states = <String, NpcState>{};
    final extra = <String, Npc>{};

    for (var grade = 3; grade >= 1; grade--) {
      final entryYear = fiscalYear - grade + 1;
      final members = cohort(club, entryYear);
      if (entryYear > ctx.startYear) {
        for (final m in members) {
          extra[m.id] = m;
        }
      }
      if (grade == 1) {
        for (final m in members) {
          roster.add(m.id);
          states[m.id] = NpcState(
            id: m.id,
            grade: 1,
            wish: m.wishInstrument,
            motivation: initialState(m).motivation,
            stress: initialState(m).stress,
          );
        }
        continue;
      }
      // 上級生: 世界生成時に楽器があればそれを使い、なければ席を割り当てる。
      final needSeats = [
        for (final m in members)
          if (m.instrument == null) m,
      ];
      final seats = SeatAssigner.resolveSeats(
        ctx.worldRng.stream('world/club/${club.id}/cohort/$entryYear/seats'),
        seatCount: needSeats.length,
        club: club,
      );
      final assigned = {
        for (final m in SeatAssigner.assign(
          ctx.worldRng.stream('world/club/${club.id}/cohort/$entryYear/assign'),
          members: needSeats,
          seats: seats,
        ))
          m.id: m,
      };
      for (final m0 in members) {
        final m = assigned[m0.id] ?? m0;
        final years =
            (grade - 1) * 10 + (m.previousInstrument == m.instrument ? 24 : 0);
        final skill = m0.instrument != null && entryYear <= ctx.startYear
            ? _agedSkill(m0, fiscalYear)
            : NpcGenerator.skill(
                ctx.worldRng.stream(
                  'world/club/${club.id}/cohort/$entryYear/${m.id}/skill',
                ),
                fit: m.aptitude.fitFor(m.instrument!),
                yearsTenths: years,
                practiceIntensity: club.practiceIntensity,
                teaching: teaching,
              );
        if (entryYear > ctx.startYear) extra[m.id] = m;
        roster.add(m.id);
        states[m.id] = initialState(m).copyWith(grade: grade, skill: skill);
      }
    }
    return (roster: roster, states: states, extra: extra);
  }

  /// 世界生成時点の熟練度を、経過年数ぶん成長させた値。
  int _agedSkill(Npc m, int fiscalYear) {
    final years = fiscalYear - ctx.startYear;
    final grown =
        m.instrumentSkill + years * (60 + m.aptitude.fitFor(m.instrument!));
    return grown.clamp(0, 1000);
  }

  /// 標準編成比で [total] 人を配分したときの楽器別の目標人数（InstrumentType.values の順）。
  static List<int> targetSeats(int total) => allocateLargestRemainder(total, [
    for (final t in InstrumentType.values) t.standardRatio,
  ]);
}
