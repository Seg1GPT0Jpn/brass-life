import 'civil_date.dart';
import 'game_date.dart';

/// 実カレンダーに準拠したターン ⇔ 日付変換。
///
/// ターン 0 = 開始年の 4 月 1 日以降で最初の月曜日の週。
class GameCalendar {
  GameCalendar(this.startYear)
    : _startMonday = CivilDate(startYear, 4, 1).firstMondayOnOrAfter();

  /// 中学 1 年の年度（西暦）。
  final int startYear;
  final CivilDate _startMonday;

  /// ターン 0 の月曜日。
  CivilDate get startMonday => _startMonday;

  /// 指定ターンの週の月曜日。
  CivilDate mondayOf(int turn) => _startMonday.addDays(turn * 7);

  /// ターン → [GameDate]。
  GameDate dateOf(int turn) {
    final monday = mondayOf(turn);
    final fiscalYear = monday.month >= 4 ? monday.year : monday.year - 1;
    final ayStartTurn = firstTurnOfFiscalYear(fiscalYear);
    return GameDate(
      turn: turn,
      year: monday.year,
      month: monday.month,
      day: monday.day,
      weekOfMonth: (monday.day - 1) ~/ 7 + 1,
      weeksInMonth: mondaysInMonth(monday.year, monday.month),
      academicYearIndex: fiscalYear - startYear,
      weekOfAcademicYear: turn - ayStartTurn + 1,
    );
  }

  /// 指定年度（西暦）の第 1 週のターン番号。
  int firstTurnOfFiscalYear(int fiscalYear) {
    final monday = CivilDate(fiscalYear, 4, 1).firstMondayOnOrAfter();
    return (monday.dayNumber - _startMonday.dayNumber) ~/ 7;
  }

  /// 指定年度インデックス（0 = 中1）の第 1 週のターン番号。
  int firstTurnOfAcademicYear(int academicYearIndex) =>
      firstTurnOfFiscalYear(startYear + academicYearIndex);

  /// 指定年度の週数（52 または 53）。
  int weeksInAcademicYear(int academicYearIndex) =>
      firstTurnOfAcademicYear(academicYearIndex + 1) -
      firstTurnOfAcademicYear(academicYearIndex);

  /// 指定年月の第 [week] 週（その月の [week] 番目の月曜日の週）のターン番号。
  int turnOf(int year, int month, int week) {
    final first = CivilDate(year, month, 1).firstMondayOnOrAfter();
    final monday = first.addDays((week - 1) * 7);
    return (monday.dayNumber - _startMonday.dayNumber) ~/ 7;
  }

  /// その月に含まれる月曜日の数 = その月の週数。
  static int mondaysInMonth(int year, int month) {
    final first = CivilDate(year, month, 1).firstMondayOnOrAfter();
    final days = CivilDate.daysInMonth(year, month);
    return (days - first.day) ~/ 7 + 1;
  }
}
