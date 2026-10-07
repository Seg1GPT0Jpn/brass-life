import '../../../core/rng/world_seed_rng.dart';
import '../../entities/club.dart';
import '../../entities/npc.dart';
import '../../entities/school.dart';
import '../../entities/world_gen_config.dart';
import '../../value_objects/instrument.dart';
import '../../value_objects/person_enums.dart';
import '../../value_objects/school_enums.dart';
import 'allocation.dart';
import 'contest_history_generator.dart';
import 'instrument_inventory_generator.dart';
import 'npc_generator.dart';
import 'seat_assigner.dart';

/// 部の計画値（部員数の全体補正前）。
class ClubPlan {
  ClubPlan({
    required this.school,
    required this.tier,
    required this.advisor,
    required this.coach,
    required this.tradition,
    required this.practiceIntensity,
    required this.mood,
    required this.budget,
    required this.executiveSystem,
    required this.selectionCulture,
    required this.rawSize,
  }) : size = rawSize;

  final School school;
  final ClubTier tier;
  final Npc advisor;
  final Npc? coach;
  final int tradition;
  final int practiceIntensity;
  final ClubMood mood;
  final BudgetBand budget;
  final ExecutiveSystem executiveSystem;
  final SelectionCulture selectionCulture;
  final int rawSize;

  /// 全体補正後の部員数（新 1 年生を含む）。
  int size;

  String get clubId => school.clubId;
  int get adultCount => coach == null ? 1 : 2;
}

/// 吹奏楽部と部員の生成。
///
/// ストリーム:
/// - `world/clubs/{level}/tier`: 強さ帯のランク付け
/// - `world/club/{id}`: 部の属性
/// - `world/club/{id}/advisor`, `/coach`: 指導者
/// - `world/club/{id}/inventory`, `/history`, `/grades`, `/seats`
/// - `world/club/{id}/member/{grade}/{n}` (+ `/skill`, `/wish`, `/previous`): 部員 1 人ずつ
class ClubGenerator {
  ClubGenerator(this._rng);

  final WorldSeedRng _rng;

  static const _tierOrder = [
    ClubTier.national,
    ClubTier.block,
    ClubTier.prefectural,
    ClubTier.district,
    ClubTier.weak,
  ];

  /// 強さ帯の構成比（％）。
  static const _tierShare = [8, 13, 25, 33, 21];

  // ───────────────────────── 計画 ─────────────────────────

  List<ClubPlan> plan(List<School> schools) {
    final tiers = <String, ClubTier>{
      ..._assignTiers(schools, SchoolLevel.high),
      ..._assignTiers(schools, SchoolLevel.middle),
    };
    return [for (final s in schools) _planClub(s, tiers[s.id]!)];
  }

  /// 校種ごとに「スコア = 正規揺らぎ + 学校属性ボーナス」で順位付けし、
  /// 上位から構成比どおりに強さ帯を割り当てる（層化）。
  Map<String, ClubTier> _assignTiers(List<School> all, SchoolLevel level) {
    final schools = [
      for (final s in all)
        if (s.level == level) s,
    ];
    final rng = _rng.stream('world/clubs/${level.name}/tier');
    final scored = <(School, int)>[];
    for (final s in schools) {
      var score = rng.normalInt(mean: 0, sd: 30, min: -120, max: 120);
      if (s.isPrivate) score += 15;
      if (s.hasCulture(SchoolCulture.traditional)) score += 15;
      if (s.hasCulture(SchoolCulture.clubFocused)) score += 20;
      if (s.hasCulture(SchoolCulture.arts)) score += 10;
      if (s.hasCulture(SchoolCulture.academic)) score -= 8;
      if (s.hasCulture(SchoolCulture.newSchool)) score -= 5;
      if (s.girlsOnly) score += 5;
      score += s.studentCount ~/ 40;
      scored.add((s, score));
    }
    scored.sort((a, b) {
      final c = b.$2.compareTo(a.$2);
      return c != 0 ? c : a.$1.id.compareTo(b.$1.id);
    });
    final quota = allocateLargestRemainder(schools.length, _tierShare);
    final result = <String, ClubTier>{};
    var k = 0;
    for (var t = 0; t < _tierOrder.length; t++) {
      for (var q = 0; q < quota[t]; q++) {
        result[scored[k].$1.id] = _tierOrder[t];
        k++;
      }
    }
    return result;
  }

  ClubPlan _planClub(School s, ClubTier tier) {
    final clubId = s.clubId;
    final rng = _rng.stream('world/club/$clubId');
    final isHigh = s.level == SchoolLevel.high;
    final suffix = s.id.substring(4);

    final advisor = NpcGenerator.advisor(
      _rng.stream('world/club/$clubId/advisor'),
      id: 'npc_${suffix}_adv',
      schoolId: s.id,
      tier: tier,
      cultures: s.cultures,
    );
    final coachChance = switch (tier) {
      ClubTier.national => 6000,
      ClubTier.block => 3500,
      ClubTier.prefectural => 1200,
      _ => 300,
    };
    final coach = rng.chance(coachChance)
        ? NpcGenerator.coach(
            _rng.stream('world/club/$clubId/coach'),
            id: 'npc_${suffix}_coach',
            schoolId: s.id,
          )
        : null;

    final traditionBase = switch (tier) {
      ClubTier.national => 80,
      ClubTier.block => 65,
      ClubTier.prefectural => 50,
      ClubTier.district => 35,
      ClubTier.weak => 20,
    };
    var tradition = rng.normalInt(
      mean: traditionBase,
      sd: 10,
      min: 0,
      max: 100,
    );
    if (s.hasCulture(SchoolCulture.traditional)) tradition += 15;
    if (s.hasCulture(SchoolCulture.newSchool)) tradition -= 20;
    tradition = tradition.clamp(0, 100);

    final intensityBase = switch (tier) {
      ClubTier.national => 5,
      ClubTier.block => 4,
      ClubTier.prefectural => 3,
      ClubTier.district => 3,
      ClubTier.weak => 2,
    };
    var intensity = intensityBase + rng.range(-1, 1);
    if (s.hasCulture(SchoolCulture.strict)) intensity++;
    if (s.hasCulture(SchoolCulture.free)) intensity--;
    intensity = intensity.clamp(1, 5);

    final style = advisor.advisorProfile!.style;
    final moodWeights = [
      15 +
          (s.hasCulture(SchoolCulture.strict) ? 25 : 0) +
          (style == AdvisorStyle.strict ? 15 : 0),
      15 + (tier.rank >= 4 ? 20 : 0),
      30 + (style == AdvisorStyle.gentle ? 10 : 0),
      15 +
          (tier == ClubTier.weak ? 25 : 0) +
          (style == AdvisorStyle.handsOff ? 15 : 0),
      8,
    ];
    final mood = rng.weighted(ClubMood.values, moodWeights);

    final budgetPoints =
        (s.isPrivate ? 2 : 0) +
        (tier.rank >= 4 ? 2 : (tier.rank == 3 ? 1 : 0)) +
        (s.studentCount > 800 ? 1 : 0) +
        rng.range(-1, 1);
    final budget = budgetPoints <= 0
        ? BudgetBand.low
        : (budgetPoints <= 2 ? BudgetBand.mid : BudgetBand.high);

    final execWeights = [45, 30, 25];
    if (s.hasCulture(SchoolCulture.traditional)) execWeights[0] += 20;
    if (s.hasCulture(SchoolCulture.free)) execWeights[1] += 20;
    if (s.hasCulture(SchoolCulture.strict)) execWeights[2] += 25;
    if (style == AdvisorStyle.strict || style == AdvisorStyle.charismatic) {
      execWeights[2] += 15;
    }
    final exec = rng.weighted(ExecutiveSystem.values, execWeights);

    // [vote, nomination, advisorAppointment, discussion]
    final selWeights = switch (exec) {
      ExecutiveSystem.a => [40, 30, 10, 20],
      ExecutiveSystem.b => [30, 15, 5, 50],
      ExecutiveSystem.c => [5, 20, 60, 15],
    };
    if (s.hasCulture(SchoolCulture.strict)) selWeights[2] += 15;
    if (s.hasCulture(SchoolCulture.free)) {
      selWeights[0] += 10;
      selWeights[3] += 10;
    }
    if (s.hasCulture(SchoolCulture.traditional)) selWeights[1] += 15;
    final selection = rng.weighted(SelectionCulture.values, selWeights);

    final (lo, hi) = switch ((isHigh, tier)) {
      (true, ClubTier.national) => (60, 90),
      (true, ClubTier.block) => (40, 64),
      (true, ClubTier.prefectural) => (28, 44),
      (true, ClubTier.district) => (16, 30),
      (true, ClubTier.weak) => (5, 15),
      (false, ClubTier.national) => (40, 64),
      (false, ClubTier.block) => (30, 48),
      (false, ClubTier.prefectural) => (20, 34),
      (false, ClubTier.district) => (11, 22),
      (false, ClubTier.weak) => (4, 12),
    };
    final schoolAdj = isHigh
        ? (s.studentCount - 700) ~/ 70
        : (s.studentCount - 450) ~/ 60;
    final rawSize =
        (rng.normalInt(
                  mean: (lo + hi) ~/ 2,
                  sd: (hi - lo) ~/ 4,
                  min: lo,
                  max: hi,
                ) +
                schoolAdj)
            .clamp(3, 120);

    return ClubPlan(
      school: s,
      tier: tier,
      advisor: advisor,
      coach: coach,
      tradition: tradition,
      practiceIntensity: intensity,
      mood: mood,
      budget: budget,
      executiveSystem: exec,
      selectionCulture: selection,
      rawSize: rawSize,
    );
  }

  /// NPC 総数が [WorldGenConfig] の範囲外なら全部員数を比例補正する。
  static void scaleSizes(List<ClubPlan> plans, WorldGenConfig config) {
    final adults = plans.fold(0, (a, p) => a + p.adultCount);
    final members = plans.fold(0, (a, p) => a + p.rawSize);
    final total = adults + members;
    int? target;
    if (total > config.maxNpcCount) target = config.maxNpcCount - adults;
    if (total < config.minNpcCount) target = config.minNpcCount - adults;
    if (target == null || members == 0) return;
    for (final p in plans) {
      p.size = (p.rawSize * target ~/ members).clamp(3, 150);
    }
    // 端数で範囲を外れた場合は大きい部から 1 人ずつ調整する（決定論的）。
    final order = List.of(plans)
      ..sort((a, b) {
        final c = b.size.compareTo(a.size);
        return c != 0 ? c : a.clubId.compareTo(b.clubId);
      });
    var sum = plans.fold(0, (a, p) => a + p.size) + adults;
    var i = 0;
    while (sum > config.maxNpcCount) {
      order[i % order.length].size--;
      sum--;
      i++;
    }
    while (sum < config.minNpcCount) {
      order[i % order.length].size++;
      sum++;
      i++;
    }
  }

  // ───────────────────────── 構築 ─────────────────────────

  /// 計画から部と所属 NPC（顧問・講師・部員）を構築する。
  (Club, List<Npc>) build(ClubPlan p, WorldGenConfig config) {
    final s = p.school;
    final clubId = p.clubId;
    final isHigh = s.level == SchoolLevel.high;
    final suffix = s.id.substring(4);

    final division = p.size >= (isHigh ? 35 : 30)
        ? BandDivision.large
        : BandDivision.small;

    final inventory = InstrumentInventoryGenerator.generate(
      _rng.stream('world/club/$clubId/inventory'),
      plannedSize: p.size,
      budget: p.budget,
      level: s.level,
      tradition: p.tradition,
    );

    final history = ContestHistoryGenerator.generate(
      _rng.stream('world/club/$clubId/history'),
      tier: p.tier,
      tradition: p.tradition,
      division: division,
      size: p.size,
      startYear: config.startYear,
      years: config.historyYears,
    );

    // 学年構成: 3 学年に重み（平均 100 / 標準偏差 18）で配分。
    final gradeRng = _rng.stream('world/club/$clubId/grades');
    final gradeWeights = [
      for (var g = 0; g < 3; g++)
        gradeRng.normalInt(mean: 100, sd: 18, min: 40, max: 160),
    ];
    // gradeCounts[0]=1年, [1]=2年, [2]=3年
    final gradeCounts = allocateLargestRemainder(p.size, gradeWeights);

    final usedNames = <String>{};
    final members = <Npc>[];
    for (var grade = 3; grade >= 1; grade--) {
      for (var n = 0; n < gradeCounts[grade - 1]; n++) {
        final path = 'world/club/$clubId/member/$grade/$n';
        members.add(
          NpcGenerator.student(
            _rng.stream(path),
            id: 'npc_${suffix}_g${grade}_${n.toString().padLeft(2, '0')}',
            schoolId: s.id,
            grade: grade,
            level: s.level,
            tier: p.tier,
            girlsOnly: s.girlsOnly,
            schoolAcademic: s.academicLevel,
            usedNames: usedNames,
          ),
        );
      }
    }

    final draftClub = Club(
      id: clubId,
      schoolId: s.id,
      tier: p.tier,
      tradition: p.tradition,
      practiceIntensity: p.practiceIntensity,
      mood: p.mood,
      executiveSystem: p.executiveSystem,
      selectionCulture: p.selectionCulture,
      budget: p.budget,
      division: division,
      advisorId: p.advisor.id,
      coachId: p.coach?.id,
      inventory: inventory,
      history: history,
      memberIds: [for (final m in members) m.id],
    );

    final upper = [
      for (final m in members)
        if (m.grade! >= 2) m,
    ];
    final seats = SeatAssigner.resolveSeats(
      _rng.stream('world/club/$clubId/seats'),
      seatCount: upper.length,
      club: draftClub,
    );
    final assigned = {
      for (final m in SeatAssigner.assign(
        _rng.stream('world/club/$clubId/seats/assign'),
        members: upper,
        seats: seats,
      ))
        m.id: m,
    };

    final teaching = p.advisor.advisorProfile!.teachingSkill;
    final finalized = <Npc>[];
    for (final m in members) {
      final path = 'world/club/$clubId/member/${m.grade}/${_indexOf(m.id)}';
      if (m.grade! >= 2) {
        finalized.add(
          _finalizeUpper(
            assigned[m.id]!,
            path,
            p.practiceIntensity,
            teaching,
            isHigh,
          ),
        );
      } else {
        finalized.add(_finalizeFreshman(m, path, isHigh));
      }
    }

    return (draftClub, [p.advisor, ?p.coach, ...finalized]);
  }

  static int _indexOf(String npcId) => int.parse(npcId.split('_').last);

  Npc _finalizeUpper(
    Npc m,
    String path,
    int intensity,
    int teaching,
    bool isHigh,
  ) {
    final rng = _rng.stream('$path/skill');
    final current = m.instrument!;
    final fit = m.aptitude.fitFor(current) + (m.hasTrait('genius') ? 15 : 0);

    // 在籍年数（0.1 年単位）: 新年度開始時点で 2 年生は 1 年、3 年生は 2 年。
    var yearsTenths = (m.grade! - 1) * 10;
    InstrumentType? previous;
    var previousSkill = 0;
    if (isHigh && m.background == MusicBackground.middleSchoolBand) {
      final prevRng = _rng.stream('$path/previous');
      previous = prevRng.chance(7000)
          ? current
          : NpcGenerator.previousInstrument(prevRng, m);
      // 同じ楽器なら中学 3 年分の経験の 8 割、別楽器なら 3 割を加算。
      yearsTenths += previous == current ? 24 : 9;
      previousSkill = NpcGenerator.skill(
        prevRng,
        fit: m.aptitude.fitFor(previous),
        yearsTenths: 30,
        practiceIntensity: 3,
        teaching: 50,
      );
    } else if (m.background == MusicBackground.elementaryBand &&
        current.family == InstrumentFamily.brass) {
      yearsTenths += 5;
    }

    final skill = NpcGenerator.skill(
      rng,
      fit: fit.clamp(0, 100),
      yearsTenths: yearsTenths,
      practiceIntensity: intensity,
      teaching: teaching,
    );
    return m.copyWith(
      instrumentSkill: skill,
      previousInstrument: previous,
      previousSkill: previousSkill,
    );
  }

  Npc _finalizeFreshman(Npc m, String path, bool isHigh) {
    var npc = m;
    if (isHigh && m.background == MusicBackground.middleSchoolBand) {
      final prevRng = _rng.stream('$path/previous');
      final previous = NpcGenerator.previousInstrument(prevRng, m);
      npc = npc.copyWith(
        previousInstrument: previous,
        previousSkill: NpcGenerator.skill(
          prevRng,
          fit: m.aptitude.fitFor(previous),
          yearsTenths: 30,
          practiceIntensity: 3,
          teaching: 50,
        ),
      );
    }
    final wishRng = _rng.stream('$path/wish');
    // 経験者は 7 割が中学と同じ楽器を希望する。
    final keep = wishRng.chance(7000);
    final wish = npc.previousInstrument != null && keep
        ? npc.previousInstrument!
        : NpcGenerator.wishInstrument(wishRng, npc);
    return npc.copyWith(wishInstrument: wish);
  }
}
