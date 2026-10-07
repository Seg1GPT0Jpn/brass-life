import 'package:freezed_annotation/freezed_annotation.dart';

part 'game_date.freezed.dart';
part 'game_date.g.dart';

/// ゲーム内の日付（1 ターン = 1 週間）。
///
/// 週は月曜始まりで、その週の月曜日が属する月を「その週の月」とする。
/// したがって 1 ヶ月は実カレンダーに従い 4 週または 5 週になる。
/// 年度は 4 月始まりで、月曜日が 4 月に入った最初の週が新年度第 1 週。
@freezed
abstract class GameDate with _$GameDate {
  const factory GameDate({
    /// ゲーム開始週を 0 とする通算ターン番号（開始前の過去の出来事は負数）。
    required int turn,

    /// その週の月曜日の西暦年・月・日。
    required int year,
    required int month,
    required int day,

    /// 月内の第何週か（1 始まり）。
    required int weekOfMonth,

    /// その月の週数（4 または 5）。
    required int weeksInMonth,

    /// ゲーム開始年度を 0 とする年度インデックス（0〜2: 中学、3〜5: 高校）。
    required int academicYearIndex,

    /// 年度内の第何週か（1 始まり）。
    required int weekOfAcademicYear,
  }) = _GameDate;

  const GameDate._();

  factory GameDate.fromJson(Map<String, dynamic> json) =>
      _$GameDateFromJson(json);

  /// 4 月始まりの年度（西暦）。
  int get fiscalYear => month >= 4 ? year : year - 1;

  /// 学年ラベル（中1〜高3）。範囲外はその年度の西暦で表す。
  String get stageLabel => switch (academicYearIndex) {
    0 => '中1',
    1 => '中2',
    2 => '中3',
    3 => '高1',
    4 => '高2',
    5 => '高3',
    _ => '$fiscalYear年度',
  };

  String get label => '$year年$month月 第$weekOfMonth週';

  String get labelWithStage => '$label（$stageLabel）';
}
