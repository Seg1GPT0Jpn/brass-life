import '../../career/game_mode.dart';
import '../../career/mode_states.dart';
import '../models/game_enums.dart';
import '../models/game_state.dart';

/// 日頃の練習の記憶（どんな音量・表現で練習してきたか）。
///
/// 部活に出た週は、部の通常練習（mf・ほどほど）と、その週の行動の練習が記録される。
/// 本番の指揮の指示がこの平均から大きく外れると、合奏が崩れやすくなる（[RehearsalPenalty]）。
abstract final class RehearsalRules {
  /// 部の通常練習。
  static const club = (55, 55);

  /// 本編の週の行動ごとの練習（ダイナミクス, 表現力）。練習でない行動は null。
  static (int, int)? ofAction(WeeklyAction a) => switch (a) {
    WeeklyAction.basics => (35, 35),
    WeeklyAction.individualPractice => (55, 55),
    WeeklyAction.partPractice => (62, 50),
    WeeklyAction.extraPractice => (75, 65),
    WeeklyAction.ensemble => (60, 70),
    WeeklyAction.practiceWith => (60, 55),
    WeeklyAction.learnFrom || WeeklyAction.teach => (50, 60),
    _ => null,
  };

  /// 大人編のコマンドと練習メニューから。
  static (int, int)? ofCareer(GameState s, CareerCommand c) => switch (s.mode) {
    GameMode.teacher => switch (PracticeMenuPreset.values.byName(
      s.career!.menu,
    )) {
      PracticeMenuPreset.balanced => (55, 55),
      PracticeMenuPreset.basics => (35, 35),
      PracticeMenuPreset.part => (65, 50),
      PracticeMenuPreset.ensemble => (60, 72),
      PracticeMenuPreset.rest => null,
    },
    GameMode.instructor => switch (c) {
      CareerCommand.intensiveCoaching => (72, 55),
      CareerCommand.masterclass => (55, 65),
      _ => null,
    },
    _ => null,
  };

  /// 練習を記録する（年度が変わっていればリセットしてから）。
  static RehearsalMemory record(
    RehearsalMemory m,
    int fiscalYear,
    List<(int, int)> samples,
  ) {
    var cur = m.fiscalYear == fiscalYear
        ? m
        : RehearsalMemory(fiscalYear: fiscalYear);
    for (final (d, e) in samples) {
      cur = cur.copyWith(
        dynamicsSum: cur.dynamicsSum + d,
        expressionSum: cur.expressionSum + e,
        sessions: cur.sessions + 1,
      );
    }
    return cur;
  }

  /// [fiscalYear] の記憶（別の年度なら空）。
  static RehearsalMemory of(GameState s, int fiscalYear) =>
      s.rehearsal.fiscalYear == fiscalYear
      ? s.rehearsal
      : RehearsalMemory(fiscalYear: fiscalYear);
}

/// 練習と違う指示のリスク。
///
/// 各軸で「練習の平均との差 − [tolerance]」が超過分。超過分の合計 × (6 + 慣れ ÷ 3) が減点（千分率、最大 400）。
/// 慣れ = 練習回数（最大 30）。よく練習した曲ほど、本番で急に変えると崩れやすい。
/// 超過分が [collapseExcess] 以上で、慣れが 10 以上なら「崩壊」。
abstract final class RehearsalPenalty {
  static const int tolerance = 45;
  static const int collapseExcess = 15;

  static int excess(RehearsalMemory m, int dynamics, int expression) {
    if (m.sessions == 0) return 0;
    int over(int v, int avg) {
      final d = (v - avg).abs() - tolerance;
      return d > 0 ? d : 0;
    }

    return over(dynamics, m.avgDynamics) + over(expression, m.avgExpression);
  }

  static int familiarity(RehearsalMemory m) =>
      m.sessions > 30 ? 30 : m.sessions;

  static int penaltyPermille(RehearsalMemory m, int dynamics, int expression) {
    final x = excess(m, dynamics, expression);
    final p = x * (6 + familiarity(m) ~/ 3);
    return p > 400 ? 400 : p;
  }

  static bool collapses(RehearsalMemory m, int dynamics, int expression) =>
      excess(m, dynamics, expression) >= collapseExcess && familiarity(m) >= 10;
}
