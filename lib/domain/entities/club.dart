import 'package:freezed_annotation/freezed_annotation.dart';

import '../value_objects/instrument.dart';
import '../value_objects/school_enums.dart';

part 'club.freezed.dart';
part 'club.g.dart';

/// 吹奏楽部。
@freezed
abstract class Club with _$Club {
  const factory Club({
    required String id,
    required String schoolId,
    required ClubTier tier,

    /// 伝統値（0..100）。
    required int tradition,

    /// 練習強度（1..5）。
    required int practiceIntensity,
    required ClubMood mood,
    required ExecutiveSystem executiveSystem,
    required SelectionCulture selectionCulture,
    required BudgetBand budget,
    required BandDivision division,
    required String advisorId,
    String? coachId,

    /// 保有楽器（学校所有分）。
    required List<InstrumentSlot> inventory,

    /// 過去 5 年のコンクール成績（古い順）。
    required List<ContestRecord> history,

    /// 部員 NPC の ID（学年降順・ID 昇順）。
    required List<String> memberIds,
  }) = _Club;

  const Club._();

  factory Club.fromJson(Map<String, dynamic> json) => _$ClubFromJson(json);

  /// 楽器種別ごとの保有台数（状態問わず）。
  int ownedCount(InstrumentType type) =>
      inventory.where((s) => s.type == type).fold(0, (sum, s) => sum + s.count);

  /// 楽器種別ごとの使用可能台数（要修理を除く）。
  int usableCount(InstrumentType type) => inventory
      .where((s) => s.type == type && s.condition.usable)
      .fold(0, (sum, s) => sum + s.count);
}

/// 保有楽器の 1 区分（同じ種別・同じ状態の楽器の台数）。
@freezed
abstract class InstrumentSlot with _$InstrumentSlot {
  const factory InstrumentSlot({
    required InstrumentType type,
    required int count,
    required InstrumentCondition condition,
  }) = _InstrumentSlot;

  factory InstrumentSlot.fromJson(Map<String, dynamic> json) =>
      _$InstrumentSlotFromJson(json);
}

/// 1 年度分のコンクール成績。
@freezed
abstract class ContestRecord with _$ContestRecord {
  const factory ContestRecord({
    required int fiscalYear,
    required BandDivision division,

    /// 最後に出場した大会（＝その年の最終到達段階）。
    required ContestStage stage,

    /// その大会での賞。
    required ContestAward award,
  }) = _ContestRecord;

  const ContestRecord._();

  factory ContestRecord.fromJson(Map<String, dynamic> json) =>
      _$ContestRecordFromJson(json);

  /// その部門の最終段階（大編成: 全国大会 / 小編成: 支部大会）まで到達したか。
  bool get reachedFinal => division == BandDivision.large
      ? stage == ContestStage.national
      : stage == ContestStage.block;

  /// 金賞だが代表に選ばれなかった（いわゆる「ダメ金」）。
  bool get isGoldWithoutAdvance =>
      award == ContestAward.gold && !reachedFinal && stage != ContestStage.none;

  String get summary {
    if (stage == ContestStage.none) return '不出場';
    final base = '${stage.label} ${award.label}';
    if (isGoldWithoutAdvance) return '$base（代表落ち）';
    return base;
  }
}
