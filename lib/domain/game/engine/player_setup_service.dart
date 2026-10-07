import '../../../core/rng/rng_stream.dart';
import '../../../core/rng/seed_hasher.dart';
import '../../entities/world.dart';
import '../../services/world_generation/personality_generator.dart';
import '../../value_objects/aptitude.dart';
import '../../value_objects/person_enums.dart';
import '../../value_objects/personality.dart';
import '../../value_objects/school_enums.dart';
import '../models/player_setup.dart';

/// 主人公の設定（キャラクタークリエイト）に関するルール。
class PlayerSetupService {
  const PlayerSetupService(this.world);

  final World world;

  static const int minStat = 5;
  static const int maxStat = 100;
  static const int maxNameLength = 8;

  /// 音楽経験による適性の補正（世界生成時の NPC と同じ値）。
  static AptitudeStats withBackground(AptitudeStats a, MusicBackground b) {
    int c(int v) => v.clamp(0, 100);
    return switch (b) {
      MusicBackground.piano => a.copyWith(
        reading: c(a.reading + 12),
        pitch: c(a.pitch + 6),
        dexterity: c(a.dexterity + 4),
      ),
      MusicBackground.elementaryBand => a.copyWith(
        breath: c(a.breath + 6),
        rhythm: c(a.rhythm + 6),
        reading: c(a.reading + 6),
      ),
      MusicBackground.middleSchoolBand => a.copyWith(
        breath: c(a.breath + 5),
        rhythm: c(a.rhythm + 5),
        reading: c(a.reading + 8),
      ),
      MusicBackground.none => a,
    };
  }

  static AptitudeStats _withoutBackground(AptitudeStats a, MusicBackground b) {
    int c(int v) => v.clamp(minStat, maxStat);
    return switch (b) {
      MusicBackground.piano => a.copyWith(
        reading: c(a.reading - 12),
        pitch: c(a.pitch - 6),
        dexterity: c(a.dexterity - 4),
      ),
      MusicBackground.elementaryBand => a.copyWith(
        breath: c(a.breath - 6),
        rhythm: c(a.rhythm - 6),
        reading: c(a.reading - 6),
      ),
      MusicBackground.middleSchoolBand => a.copyWith(
        breath: c(a.breath - 5),
        rhythm: c(a.rhythm - 5),
        reading: c(a.reading - 8),
      ),
      MusicBackground.none => a,
    };
  }

  /// Seed が決めた主人公（「おまかせ」の設定）。
  PlayerSetup defaults() {
    final p = world.player;
    return PlayerSetup(
      familyName: p.familyName,
      givenName: p.givenName,
      gender: p.gender,
      schoolId: p.schoolId,
      background: p.background,
      personality: p.personality,
      aptitude: _withoutBackground(p.aptitude, p.background),
      academic: p.academic.clamp(minStat, maxStat),
      stamina: p.stamina.clamp(minStat, maxStat),
    );
  }

  /// 能力に配分できるポイントの上限（Seed の主人公の合計。ただし最低 360）。
  int get budget {
    final d = defaults();
    return d.pointsUsed < 360 ? 360 : d.pointsUsed;
  }

  /// 入学できる中学校（女子校は女性のみ）。
  List<String> selectableSchools(Gender gender) => [
    for (final s in world.schools)
      if (s.level == SchoolLevel.middle &&
          (!s.girlsOnly || gender == Gender.female))
        s.id,
  ];

  /// 設定の検証。問題がなければ null。
  String? validate(PlayerSetup s) {
    if (s.familyName.trim().isEmpty || s.givenName.trim().isEmpty) {
      return '名前を入力してください';
    }
    if (s.familyName.trim().length > maxNameLength ||
        s.givenName.trim().length > maxNameLength) {
      return '姓・名はそれぞれ$maxNameLength文字までです';
    }
    if (!selectableSchools(s.gender).contains(s.schoolId)) {
      return 'この中学校には入学できません';
    }
    if (s.background == MusicBackground.middleSchoolBand) {
      return '中学吹奏楽部の経験は選べません';
    }
    final stats = [
      s.aptitude.pitch,
      s.aptitude.rhythm,
      s.aptitude.breath,
      s.aptitude.dexterity,
      s.aptitude.expression,
      s.aptitude.reading,
      s.academic,
      s.stamina,
    ];
    if (stats.any((v) => v < minStat || v > maxStat)) {
      return '能力は$minStat〜$maxStatの範囲で設定してください';
    }
    if (s.pointsUsed > budget) {
      return '能力の合計が上限（$budget）を超えています';
    }
    final p = s.personality;
    final axes = [
      p.extraversion,
      p.agreeableness,
      p.conscientiousness,
      p.neuroticism,
      p.ambition,
    ];
    if (axes.any((v) => v < -100 || v > 100)) return '性格の値が範囲外です';
    return null;
  }

  /// 性格軸から決まる性格タグ（同じ Seed・同じ軸なら必ず同じ結果）。
  List<TraitTag> traitsFor(PersonalityAxes p) {
    // Seed のままの性格なら、世界生成時の性格タグをそのまま使う。
    if (p == world.player.personality) return world.player.traits;
    final seed = SeedHasher.derive(world.seed, 'player_setup/traits', [
      p.extraversion,
      p.agreeableness,
      p.conscientiousness,
      p.neuroticism,
      p.ambition,
    ]);
    return PersonalityGenerator.traits(RngStream(seed), p);
  }
}
