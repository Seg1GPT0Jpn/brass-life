import '../../../core/rng/rng_stream.dart';
import '../../entities/club.dart';
import '../../value_objects/instrument.dart';
import '../../value_objects/school_enums.dart';
import 'allocation.dart';

/// 保有楽器（学校所有分）の生成。ストリーム: `world/club/{id}/inventory`。
///
/// 1. 標準編成テンプレートを部員数に合わせて縮尺し、楽器ごとの必要数を求める。
/// 2. 希少楽器は「予算・校種」で補正した保有確率で有無を判定する。
/// 3. 保有台数は予算で増減。私物率の低い楽器（チューバ・打楽器等）は必要数を必ず満たす。
/// 4. 1 台ずつ状態（良好〜要修理）を予算と伝統で決め、種別×状態でまとめる。
abstract final class InstrumentInventoryGenerator {
  static List<InstrumentSlot> generate(
    RngStream rng, {
    required int plannedSize,
    required BudgetBand budget,
    required SchoolLevel level,
    required int tradition,
  }) {
    final types = InstrumentType.values;
    final need = allocateLargestRemainder(plannedSize < 12 ? 12 : plannedSize, [
      for (final t in types) t.standardRatio,
    ]);

    final presenceFactor = switch (budget) {
      BudgetBand.low => 55,
      BudgetBand.mid => 100,
      BudgetBand.high => 135,
    };
    final ownFactor = switch (budget) {
      BudgetBand.low => 70,
      BudgetBand.mid => 85,
      BudgetBand.high => 105,
    };
    final conditionWeights = switch (budget) {
      BudgetBand.low => [5, 35, 40, 20],
      BudgetBand.mid => [15, 45, 30, 10],
      BudgetBand.high => [35, 45, 15, 5],
    };
    // 伝統校ほど古い楽器が多い。
    conditionWeights[2] += tradition ~/ 10;

    final slots = <InstrumentSlot>[];
    for (var i = 0; i < types.length; i++) {
      final t = types[i];
      var presence = t.presencePermyriad;
      if (!t.isStandard) {
        presence = presence * presenceFactor ~/ 100;
        if (level == SchoolLevel.middle) presence = presence * 80 ~/ 100;
      }
      // 判定と台数の乱数は常に消費し、他楽器の結果を有無に依存させない。
      final present = rng.chance(presence);
      final jitter = rng.range(-1, 1);
      final spare = rng.range(0, 2);

      if (!present) continue;
      var owned = (need[i] * ownFactor + 50) ~/ 100 + jitter;
      if (t.personalPermyriad < 500) {
        // 私物がほぼ存在しない楽器は、学校が必要数を揃えている。
        owned = owned < need[i] ? need[i] : owned;
        if (t == InstrumentType.percussion) owned += spare;
      }
      if (owned < 1) owned = 1;

      final counts = List.filled(InstrumentCondition.values.length, 0);
      for (var u = 0; u < owned; u++) {
        counts[rng.weightedIndex(conditionWeights)]++;
      }
      for (var c = 0; c < counts.length; c++) {
        if (counts[c] == 0) continue;
        slots.add(
          InstrumentSlot(
            type: t,
            count: counts[c],
            condition: InstrumentCondition.values[c],
          ),
        );
      }
    }
    return slots;
  }
}
