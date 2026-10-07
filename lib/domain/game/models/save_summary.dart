import 'package:freezed_annotation/freezed_annotation.dart';

part 'save_summary.freezed.dart';
part 'save_summary.g.dart';

/// セーブデータの一覧表示用の要約。
@freezed
abstract class SaveSummary with _$SaveSummary {
  const factory SaveSummary({
    required String slot,
    required int worldSeed,
    required String seedCode,
    required String playerName,
    required String dateLabel,
    required String schoolName,
    required String savedAt,
  }) = _SaveSummary;

  factory SaveSummary.fromJson(Map<String, dynamic> json) =>
      _$SaveSummaryFromJson(json);
}
