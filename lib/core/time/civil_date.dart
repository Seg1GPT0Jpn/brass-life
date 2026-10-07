/// グレゴリオ暦の日付演算（`DateTime` に依存しない純粋な整数演算）。
///
/// タイムゾーン・夏時間・プラットフォーム差の影響を一切受けないよう、
/// Howard Hinnant の days_from_civil / civil_from_days アルゴリズムを用いる。
/// 日番号 0 = 1970-01-01（木曜日）。
library;

class CivilDate implements Comparable<CivilDate> {
  const CivilDate(this.year, this.month, this.day);

  factory CivilDate.fromDayNumber(int z0) {
    final z = z0 + 719468;
    final era = (z >= 0 ? z : z - 146096) ~/ 146097;
    final doe = z - era * 146097;
    final yoe = (doe - doe ~/ 1460 + doe ~/ 36524 - doe ~/ 146096) ~/ 365;
    final y = yoe + era * 400;
    final doy = doe - (365 * yoe + yoe ~/ 4 - yoe ~/ 100);
    final mp = (5 * doy + 2) ~/ 153;
    final d = doy - (153 * mp + 2) ~/ 5 + 1;
    final m = mp < 10 ? mp + 3 : mp - 9;
    return CivilDate(m <= 2 ? y + 1 : y, m, d);
  }

  final int year;
  final int month;
  final int day;

  /// 1970-01-01 からの日数。
  int get dayNumber {
    final y = month <= 2 ? year - 1 : year;
    final era = (y >= 0 ? y : y - 399) ~/ 400;
    final yoe = y - era * 400;
    final doy = (153 * (month + (month > 2 ? -3 : 9)) + 2) ~/ 5 + day - 1;
    final doe = yoe * 365 + yoe ~/ 4 - yoe ~/ 100 + doy;
    return era * 146097 + doe - 719468;
  }

  /// ISO 曜日（月曜=1 … 日曜=7）。
  int get weekday => ((dayNumber + 3) % 7) + 1;

  CivilDate addDays(int days) => CivilDate.fromDayNumber(dayNumber + days);

  static bool isLeapYear(int y) => (y % 4 == 0 && y % 100 != 0) || y % 400 == 0;

  static int daysInMonth(int y, int m) {
    const days = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
    if (m == 2 && isLeapYear(y)) return 29;
    return days[m - 1];
  }

  /// その日以降で最初の月曜日。
  CivilDate firstMondayOnOrAfter() {
    final diff = (8 - weekday) % 7;
    return addDays(diff);
  }

  @override
  int compareTo(CivilDate other) => dayNumber.compareTo(other.dayNumber);

  @override
  bool operator ==(Object other) =>
      other is CivilDate &&
      other.year == year &&
      other.month == month &&
      other.day == day;

  @override
  int get hashCode => Object.hash(year, month, day);

  @override
  String toString() =>
      '$year-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}';
}
