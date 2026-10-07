import '../../../core/time/game_calendar.dart';
import '../../../core/time/game_date.dart';

/// 学校行事の暦（定期テストなど）。月と「月内の第 n 週」で指定し、
/// その月に第 n 週がなければ最終週に寄せる。
class SchoolCalendar {
  const SchoolCalendar(this.calendar);

  final GameCalendar calendar;

  /// 定期テスト（名称, 月, 週, 学期, 学期末か）。
  static const exams = [
    ('1学期中間テスト', 5, 4, 1, false),
    ('1学期期末テスト', 7, 1, 1, true),
    ('2学期中間テスト', 10, 2, 2, false),
    ('2学期期末テスト', 12, 1, 2, true),
    ('学年末テスト', 2, 4, 3, true),
  ];

  /// 指定年度・月・週のターン番号。
  int turnOf(int fiscalYear, int month, int week) {
    final year = month >= 4 ? fiscalYear : fiscalYear + 1;
    final weeks = GameCalendar.mondaysInMonth(year, month);
    return calendar.turnOf(year, month, week > weeks ? weeks : week);
  }

  /// その週に行われる定期テスト。
  ({String name, int term, bool endsTerm})? examAt(GameDate d) {
    for (final (name, month, week, term, ends) in exams) {
      if (turnOf(d.fiscalYear, month, week) == d.turn) {
        return (name: name, term: term, endsTerm: ends);
      }
    }
    return null;
  }

  /// 翌週にテストがあるか（テスト前の自動勉強用）。
  bool examNextWeek(int turn) => examAt(calendar.dateOf(turn + 1)) != null;

  bool isExamWeek(int turn) => examAt(calendar.dateOf(turn)) != null;

  /// 楽器決定イベントの週（4 月第 2 週）。
  int instrumentDecisionTurn(int fiscalYear) => turnOf(fiscalYear, 4, 2);
}
