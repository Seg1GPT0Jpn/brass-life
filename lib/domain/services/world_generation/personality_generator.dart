import '../../../core/rng/rng_stream.dart';
import '../../master/trait_definitions.dart';
import '../../value_objects/aptitude.dart';
import '../../value_objects/person_enums.dart';
import '../../value_objects/personality.dart';

/// 性格軸・性格タグ・音楽適性の生成。
abstract final class PersonalityGenerator {
  /// 性格軸（各軸 平均 0 / 標準偏差 40、-100..100）。
  static PersonalityAxes axes(RngStream rng) => PersonalityAxes(
    extraversion: _axis(rng),
    agreeableness: _axis(rng),
    conscientiousness: _axis(rng),
    neuroticism: _axis(rng),
    ambition: _axis(rng),
  );

  static int _axis(RngStream rng) =>
      rng.normalInt(mean: 0, sd: 40, min: -100, max: 100);

  /// 性格軸から性格タグを導出する。
  ///
  /// 1. 導出タグ: スコアが正のものを候補とし、スコアを重みとして 1〜4 個を抽選。
  ///    同じグループのタグは共存させない。強度はスコアの大きさで 1〜3。
  /// 2. 特殊タグ: 各タグの付与確率で独立に判定（最大 2 個）。
  static List<TraitTag> traits(RngStream rng, PersonalityAxes p) {
    final candidates = <(TraitDefinition, int)>[];
    for (final def in traitDefinitions) {
      if (def.score == null) continue;
      final s = def.score!(p);
      if (s > 0) candidates.add((def, s));
    }

    final picked = <TraitTag>[];
    final usedGroups = <String>{};
    final target = rng.weighted([1, 2, 3, 4], [15, 40, 35, 10]);

    if (candidates.isEmpty) {
      // どの傾向も弱い「普通の人」: 最もスコアの高い導出タグを弱く付与する。
      TraitDefinition? best;
      var bestScore = -1000000; // Web では負数のシフトが符号なしになるためリテラルで指定
      for (final def in traitDefinitions) {
        if (def.score == null) continue;
        final s = def.score!(p);
        if (s > bestScore) {
          best = def;
          bestScore = s;
        }
      }
      picked.add(TraitTag(traitId: best!.id, intensity: 1));
      if (best.group != null) usedGroups.add(best.group!);
    } else {
      final pool = List.of(candidates);
      while (picked.length < target && pool.isNotEmpty) {
        final idx = rng.weightedIndex([for (final c in pool) c.$2]);
        final (def, s) = pool.removeAt(idx);
        picked.add(TraitTag(traitId: def.id, intensity: _intensity(s)));
        if (def.group != null) {
          usedGroups.add(def.group!);
          pool.removeWhere((c) => c.$1.group == def.group);
        }
      }
    }

    var specials = 0;
    for (final def in traitDefinitions) {
      if (!def.isSpecial) continue;
      final chance = def.specialChance!(p);
      // 判定は常に行い、乱数の消費量をタグ構成に依存させない。
      final hit = rng.chance(chance);
      final intensity = rng.weighted([1, 2, 3], [50, 35, 15]);
      if (hit && specials < 2) {
        picked.add(TraitTag(traitId: def.id, intensity: intensity));
        specials++;
      }
    }

    final order = {
      for (var i = 0; i < traitDefinitions.length; i++)
        traitDefinitions[i].id: i,
    };
    picked.sort((a, b) => order[a.traitId]!.compareTo(order[b.traitId]!));
    return picked;
  }

  static int _intensity(int score) => score >= 60 ? 3 : (score >= 30 ? 2 : 1);

  /// 音楽適性（平均 [mean] / 標準偏差 15）。経験・特性による補正を含む。
  static AptitudeStats aptitude(
    RngStream rng, {
    required List<TraitTag> traits,
    required MusicBackground background,
    int mean = 50,
  }) {
    int roll() => rng.normalInt(mean: mean, sd: 15, min: 5, max: 100);
    final values = [roll(), roll(), roll(), roll(), roll(), roll()];
    // 0:pitch 1:rhythm 2:breath 3:dexterity 4:expression 5:reading
    void add(int i, int v) => values[i] = (values[i] + v).clamp(0, 100);

    switch (background) {
      case MusicBackground.piano:
        add(5, 12);
        add(0, 6);
        add(3, 4);
      case MusicBackground.elementaryBand:
        add(2, 6);
        add(1, 6);
        add(5, 6);
      case MusicBackground.middleSchoolBand:
        add(2, 5);
        add(1, 5);
        add(5, 8);
      case MusicBackground.none:
        break;
    }

    // 天才肌: 3 つの適性が大きく伸びる（どれが伸びるかは乱数）。
    final boostTargets = rng.sample([0, 1, 2, 3, 4, 5], 3);
    if (traits.any((t) => t.traitId == 'genius')) {
      for (final i in boostTargets) {
        add(i, 15);
      }
    }

    return AptitudeStats(
      pitch: values[0],
      rhythm: values[1],
      breath: values[2],
      dexterity: values[3],
      expression: values[4],
      reading: values[5],
    );
  }
}
