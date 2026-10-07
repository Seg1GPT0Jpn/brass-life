import '../../../core/rng/rng_stream.dart';
import '../../entities/npc.dart';
import '../../value_objects/instrument.dart';
import '../../value_objects/person_enums.dart';
import '../../value_objects/school_enums.dart';
import 'name_generator.dart';
import 'personality_generator.dart';

/// NPC 1 人分の生成。各メソッドは渡された 1 本のストリームだけを消費する。
abstract final class NpcGenerator {
  /// 部員（楽器は未設定。楽器割当は [SeatAssigner] が行う）。
  static Npc student(
    RngStream rng, {
    required String id,
    required String schoolId,
    required int grade,
    required SchoolLevel level,
    required ClubTier tier,
    required bool girlsOnly,
    required int schoolAcademic,
    required Set<String> usedNames,
  }) {
    final femaleRate = level == SchoolLevel.middle ? 7200 : 6800;
    final gender = girlsOnly || rng.chance(femaleRate)
        ? Gender.female
        : Gender.male;
    final (family, given) = NameGenerator.personName(
      rng,
      gender: gender,
      used: usedNames,
    );
    final personality = PersonalityGenerator.axes(rng);
    final traits = PersonalityGenerator.traits(rng, personality);
    final background = _studentBackground(rng, level, tier);
    final aptitude = PersonalityGenerator.aptitude(
      rng,
      traits: traits,
      background: background,
    );
    return Npc(
      id: id,
      familyName: family,
      givenName: given,
      gender: gender,
      role: NpcRole.student,
      schoolId: schoolId,
      grade: grade,
      personality: personality,
      traits: traits,
      aptitude: aptitude,
      academic: rng.normalInt(mean: schoolAcademic, sd: 14, min: 0, max: 100),
      stamina: rng.normalInt(mean: 50, sd: 15, min: 0, max: 100),
      background: background,
    );
  }

  /// 入部前の音楽経験。高校では強豪ほど中学吹奏楽部経験者が多い。
  static MusicBackground _studentBackground(
    RngStream rng,
    SchoolLevel level,
    ClubTier tier,
  ) {
    if (level == SchoolLevel.middle) {
      return rng.weighted(
        [
          MusicBackground.none,
          MusicBackground.piano,
          MusicBackground.elementaryBand,
        ],
        [60, 28, 12],
      );
    }
    final experienced = switch (tier) {
      ClubTier.national => 8500,
      ClubTier.block => 7500,
      ClubTier.prefectural => 6000,
      ClubTier.district => 4500,
      ClubTier.weak => 3000,
    };
    if (rng.chance(experienced)) return MusicBackground.middleSchoolBand;
    return rng.chance(2500) ? MusicBackground.piano : MusicBackground.none;
  }

  /// 新入生の希望楽器。人気度に性格・経験・適性の補正をかけて抽選する。
  static InstrumentType wishInstrument(RngStream rng, Npc npc) {
    final weights = <int>[];
    for (final t in InstrumentType.values) {
      var w = t.popularity * 10;
      if (npc.hasTrait('attention_seeker') &&
          (t == InstrumentType.trumpet ||
              t == InstrumentType.altoSax ||
              t == InstrumentType.percussion)) {
        w *= 2;
      }
      if (npc.hasTrait('shy') &&
          (t == InstrumentType.clarinet ||
              t == InstrumentType.horn ||
              t == InstrumentType.euphonium)) {
        w = w * 3 ~/ 2;
      }
      if (npc.hasTrait('music_nerd') &&
          (t == InstrumentType.oboe ||
              t == InstrumentType.bassoon ||
              t == InstrumentType.horn ||
              t == InstrumentType.bassClarinet)) {
        w = w * 3 + 20;
      }
      // 自分の適性が高い楽器にも少し惹かれる。
      w += npc.aptitude.fitFor(t) ~/ 10;
      weights.add(w);
    }
    return rng.weighted(InstrumentType.values, weights);
  }

  /// 経験者が中学で担当していた楽器（人気度と適性で抽選）。
  static InstrumentType previousInstrument(RngStream rng, Npc npc) {
    final weights = [
      for (final t in InstrumentType.values)
        t.standardRatio * 10 + npc.aptitude.fitFor(t) ~/ 5,
    ];
    return rng.weighted(InstrumentType.values, weights);
  }

  /// 顧問。
  static Npc advisor(
    RngStream rng, {
    required String id,
    required String schoolId,
    required ClubTier tier,
    required List<SchoolCulture> cultures,
  }) {
    final gender = rng.chance(4500) ? Gender.female : Gender.male;
    final (family, given) = NameGenerator.personName(
      rng,
      gender: gender,
      adult: true,
    );
    final age = rng.normalInt(mean: 42, sd: 9, min: 25, max: 62);
    final career = (age - 23 - rng.range(0, 3)).clamp(1, 40);
    final personality = PersonalityGenerator.axes(rng);
    final traits = PersonalityGenerator.traits(rng, personality);
    final aptitude = PersonalityGenerator.aptitude(
      rng,
      traits: traits,
      background: MusicBackground.none,
      mean: 70,
    );

    final skillBase = switch (tier) {
      ClubTier.national => 86,
      ClubTier.block => 73,
      ClubTier.prefectural => 60,
      ClubTier.district => 47,
      ClubTier.weak => 36,
    };
    var teaching = rng.normalInt(mean: skillBase, sd: 9, min: 10, max: 100);
    var yearsAtSchool = rng.range(1, career < 12 ? career : 12);

    // 「ねじれ」: 伝統校・強豪に、実力の伴わない新任顧問が着任しているケース。
    final twist = rng.chance(tier.rank >= 4 ? 1500 : 800);
    if (twist) {
      yearsAtSchool = 1;
      teaching = rng.range(25, 60);
    }

    final styleWeights = switch (tier) {
      ClubTier.national => [20, 25, 5, 20, 5, 25],
      ClubTier.block => [25, 25, 5, 20, 10, 15],
      ClubTier.prefectural => [25, 20, 10, 20, 20, 5],
      ClubTier.district => [20, 15, 20, 15, 28, 2],
      ClubTier.weak => [15, 10, 30, 10, 34, 1],
    };
    if (cultures.contains(SchoolCulture.strict)) styleWeights[3] += 15;
    if (cultures.contains(SchoolCulture.free)) styleWeights[2] += 10;

    return Npc(
      id: id,
      familyName: family,
      givenName: given,
      gender: gender,
      role: NpcRole.advisor,
      schoolId: schoolId,
      age: age,
      personality: personality,
      traits: traits,
      aptitude: aptitude,
      academic: rng.normalInt(mean: 65, sd: 10, min: 30, max: 100),
      stamina: rng.normalInt(mean: 50, sd: 15, min: 0, max: 100),
      background: MusicBackground.none,
      advisorProfile: AdvisorProfile(
        style: rng.weighted(AdvisorStyle.values, styleWeights),
        teachingSkill: teaching,
        passion: rng.normalInt(
          mean: 45 + tier.rank * 6,
          sd: 15,
          min: 0,
          max: 100,
        ),
        careerYears: career,
        yearsAtSchool: yearsAtSchool,
        specialty: rng.weighted(InstrumentFamily.values, [40, 45, 10, 5]),
      ),
    );
  }

  /// 外部講師。
  static Npc coach(
    RngStream rng, {
    required String id,
    required String schoolId,
  }) {
    final gender = rng.chance(4000) ? Gender.female : Gender.male;
    final (family, given) = NameGenerator.personName(
      rng,
      gender: gender,
      adult: true,
    );
    final age = rng.normalInt(mean: 48, sd: 10, min: 30, max: 70);
    final personality = PersonalityGenerator.axes(rng);
    final traits = PersonalityGenerator.traits(rng, personality);
    final aptitude = PersonalityGenerator.aptitude(
      rng,
      traits: traits,
      background: MusicBackground.none,
      mean: 80,
    );
    final career = (age - 22 - rng.range(0, 4)).clamp(1, 45);
    return Npc(
      id: id,
      familyName: family,
      givenName: given,
      gender: gender,
      role: NpcRole.coach,
      schoolId: schoolId,
      age: age,
      personality: personality,
      traits: traits,
      aptitude: aptitude,
      academic: rng.normalInt(mean: 65, sd: 10, min: 30, max: 100),
      stamina: rng.normalInt(mean: 50, sd: 15, min: 0, max: 100),
      background: MusicBackground.none,
      advisorProfile: AdvisorProfile(
        style: rng.weighted(AdvisorStyle.values, [20, 35, 5, 25, 10, 5]),
        teachingSkill: rng.normalInt(mean: 78, sd: 9, min: 40, max: 100),
        passion: rng.normalInt(mean: 60, sd: 15, min: 0, max: 100),
        careerYears: career,
        yearsAtSchool: rng.range(1, career < 10 ? career : 10),
        specialty: rng.weighted(InstrumentFamily.values, [40, 45, 12, 3]),
      ),
    );
  }

  /// 熟練度（0..1000）の算出。
  ///
  /// 80 + 経験年数 × 年あたり伸び × (楽器適性 + 50)/100 + 揺らぎ。
  /// 年あたり伸び = 30 + 練習強度×12 + 顧問指導力×0.6。
  static int skill(
    RngStream rng, {
    required int fit,
    required int yearsTenths,
    required int practiceIntensity,
    required int teaching,
  }) {
    final perYear = 30 + practiceIntensity * 12 + teaching * 6 ~/ 10;
    final grown = yearsTenths * perYear * (fit + 50) ~/ 1000;
    final v = 80 + grown + rng.normalInt(mean: 0, sd: 40, min: -120, max: 120);
    return v.clamp(0, 1000);
  }
}
