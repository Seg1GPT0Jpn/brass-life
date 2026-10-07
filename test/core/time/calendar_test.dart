import 'package:brass_life/core/time/civil_date.dart';
import 'package:brass_life/core/time/game_calendar.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CivilDate', () {
    test('既知の曜日', () {
      expect(const CivilDate(1970, 1, 1).weekday, 4); // 木
      expect(const CivilDate(2026, 4, 1).weekday, 3); // 水
      expect(const CivilDate(2026, 4, 6).weekday, 1); // 月
      expect(const CivilDate(2000, 2, 29).weekday, 2); // 火
    });

    test('日番号の往復', () {
      for (var z = -800000; z < 800000; z += 997) {
        expect(CivilDate.fromDayNumber(z).dayNumber, z);
      }
    });

    test('うるう年', () {
      expect(CivilDate.daysInMonth(2028, 2), 29);
      expect(CivilDate.daysInMonth(2100, 2), 28);
      expect(CivilDate.daysInMonth(2000, 2), 29);
    });
  });

  group('GameCalendar', () {
    final cal = GameCalendar(2026);

    test('ターン 0 は 2026/4/6（4 月最初の月曜日）', () {
      final d = cal.dateOf(0);
      expect((d.year, d.month, d.day), (2026, 4, 6));
      expect(d.weekOfMonth, 1);
      expect(d.academicYearIndex, 0);
      expect(d.weekOfAcademicYear, 1);
      expect(d.stageLabel, '中1');
    });

    test('月の週数は実カレンダーに従い 4 または 5', () {
      // 2026 年 4 月の月曜: 6, 13, 20, 27 → 4 週
      expect(GameCalendar.mondaysInMonth(2026, 4), 4);
      // 2026 年 6 月の月曜: 1, 8, 15, 22, 29 → 5 週
      expect(GameCalendar.mondaysInMonth(2026, 6), 5);
      for (var y = 2026; y < 2033; y++) {
        for (var m = 1; m <= 12; m++) {
          expect(GameCalendar.mondaysInMonth(y, m), inInclusiveRange(4, 5));
        }
      }
    });

    test('連続するターンの月曜日は 7 日ずつ進み、学年は 4 月で切り替わる', () {
      var prevAy = 0;
      for (var t = 0; t < 52 * 6 + 10; t++) {
        final a = cal.mondayOf(t);
        final b = cal.mondayOf(t + 1);
        expect(b.dayNumber - a.dayNumber, 7);
        final d = cal.dateOf(t);
        if (d.academicYearIndex != prevAy) {
          expect(d.month, 4);
          expect(d.weekOfMonth, 1);
          expect(d.weekOfAcademicYear, 1);
          prevAy = d.academicYearIndex;
        }
      }
    });

    test('各年度の週数は 52 または 53 で、6 年分のターンが連続する', () {
      var total = 0;
      for (var ay = 0; ay < 6; ay++) {
        final weeks = cal.weeksInAcademicYear(ay);
        expect(weeks, anyOf(52, 53));
        expect(cal.firstTurnOfAcademicYear(ay), total);
        total += weeks;
      }
    });

    test('turnOf と dateOf の往復', () {
      final t = cal.turnOf(2026, 8, 2);
      final d = cal.dateOf(t);
      expect((d.year, d.month, d.weekOfMonth), (2026, 8, 2));
    });

    test('開始前（負のターン）も扱える', () {
      final d = cal.dateOf(cal.firstTurnOfAcademicYear(-1));
      expect((d.year, d.month, d.weekOfMonth), (2025, 4, 1));
      expect(d.academicYearIndex, -1);
    });
  });
}
