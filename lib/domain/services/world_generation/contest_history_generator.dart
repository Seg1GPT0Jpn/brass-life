import '../../../core/rng/rng_stream.dart';
import '../../entities/club.dart';
import '../../value_objects/school_enums.dart';

/// 過去のコンクール成績の生成。ストリーム: `world/club/{id}/history`。
///
/// 年ごとに「演奏の出来」v = 強さ帯の基準値 + 伝統補正 + 正規揺らぎ を求め、
/// 地区 → 県 → 支部 → 全国 の各段階で代表基準値 T と比較する。
/// - v ≥ T: 金賞・代表として次の段階へ
/// - T-5 ≤ v < T: 金賞（代表落ち）
/// - T-13 ≤ v < T-5: 銀賞
/// - それ未満: 銅賞
/// 小編成の部は支部大会が最終段階。
abstract final class ContestHistoryGenerator {
  static const _large = [
    (ContestStage.district, 55),
    (ContestStage.prefectural, 72),
    (ContestStage.block, 86),
  ];
  static const _small = [
    (ContestStage.district, 55),
    (ContestStage.prefectural, 70),
  ];

  static List<ContestRecord> generate(
    RngStream rng, {
    required ClubTier tier,
    required int tradition,
    required BandDivision division,
    required int size,
    required int startYear,
    required int years,
  }) {
    final base = switch (tier) {
      ClubTier.national => 93,
      ClubTier.block => 83,
      ClubTier.prefectural => 70,
      ClubTier.district => 58,
      ClubTier.weak => 45,
    };
    final records = <ContestRecord>[];
    for (var y = startYear - years; y < startYear; y++) {
      final noise = rng.normalInt(mean: 0, sd: 8, min: -25, max: 25);
      if (size < 6) {
        records.add(
          ContestRecord(
            fiscalYear: y,
            division: division,
            stage: ContestStage.none,
            award: ContestAward.none,
          ),
        );
        continue;
      }
      final v = base + (tradition - 50) ~/ 10 + noise;
      records.add(_evaluate(v, division, y));
    }
    return records;
  }

  static ContestRecord _evaluate(int v, BandDivision division, int year) {
    final path = division == BandDivision.large ? _large : _small;
    for (final (stage, t) in path) {
      if (v >= t) continue; // 代表 → 次の段階へ
      final award = v >= t - 5
          ? ContestAward.gold
          : (v >= t - 13 ? ContestAward.silver : ContestAward.bronze);
      return ContestRecord(
        fiscalYear: year,
        division: division,
        stage: stage,
        award: award,
      );
    }
    // 最終段階（大編成: 全国大会 / 小編成: 支部大会）。
    final isLarge = division == BandDivision.large;
    final gold = isLarge ? 93 : 82;
    final silver = isLarge ? 87 : 75;
    return ContestRecord(
      fiscalYear: year,
      division: division,
      stage: isLarge ? ContestStage.national : ContestStage.block,
      award: v >= gold
          ? ContestAward.gold
          : (v >= silver ? ContestAward.silver : ContestAward.bronze),
    );
  }
}
