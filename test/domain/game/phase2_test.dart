import 'package:brass_life/core/rng/seed_code.dart';
import 'package:brass_life/domain/entities/world.dart';
import 'package:brass_life/domain/game/engine/game_context.dart';
import 'package:brass_life/domain/game/engine/time_manager.dart';
import 'package:brass_life/domain/game/models/game_enums.dart';
import 'package:brass_life/domain/game/models/game_state.dart';
import 'package:brass_life/domain/services/world_generation/world_generator.dart';
import 'package:brass_life/domain/value_objects/instrument.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late World world;
  late GameContext ctx;
  late TimeManager tm;

  setUpAll(() {
    world = const WorldGenerator().generate(SeedCode.seedFromInput('TEST'));
    ctx = GameContext(world);
    tm = TimeManager(ctx);
  });

  GameState startAndDecide(List<InstrumentType> wishes) {
    var s = tm.newGame(world);
    s = tm.submitAction(s, WeeklyAction.individualPractice);
    return tm.resolveInstrumentDecision(s, wishes).state;
  }

  test('開始直後は 2026年4月第1週、翌週に楽器決定イベントが発生する', () {
    final s = tm.newGame(world);
    expect(s.turn, 0);
    expect(s.pending, isNull);
    expect(s.player.instrument, isNull);
    final s1 = tm.submitAction(s, WeeklyAction.individualPractice);
    expect(s1.turn, 1);
    expect(s1.pending?.type, PendingEventType.instrumentDecision);
    expect(() => tm.submitAction(s1, WeeklyAction.study), throwsStateError);
  });

  test('楽器決定: プレイヤーと新入生全員に楽器が割り当てられる', () {
    final s = startAndDecide([
      InstrumentType.trumpet,
      InstrumentType.flute,
      InstrumentType.horn,
    ]);
    expect(s.pending, isNull);
    expect(s.player.instrument, isNotNull);
    for (final m in ctx.activeMembers(s)) {
      expect(m.instrument, isNotNull, reason: m.id);
    }
    expect(s.logs.last.lines.first, contains('担当楽器は'));
  });

  test('決定論: 同じ選択列からは完全に同じ状態になる', () {
    GameState play() {
      var s = startAndDecide([InstrumentType.clarinet]);
      for (var i = 0; i < 20; i++) {
        s = tm.submitAction(
          s,
          WeeklyAction.values[i % WeeklyAction.values.length],
        );
      }
      return s;
    }

    expect(play(), play());
  });

  test('選択が異なれば結果が変わる', () {
    final base = startAndDecide([InstrumentType.clarinet]);
    final a = tm.submitAction(base, WeeklyAction.study);
    final b = tm.submitAction(base, WeeklyAction.extraPractice);
    expect(a.player.academic, greaterThan(b.player.academic));
    expect(b.player.skill, greaterThan(a.player.skill));
    expect(b.player.fatigue, greaterThan(a.player.fatigue));
  });

  test('休養で疲労が下がる', () {
    var s = startAndDecide([InstrumentType.clarinet]);
    for (var i = 0; i < 4; i++) {
      s = tm.submitAction(s, WeeklyAction.extraPractice);
    }
    final rested = tm.submitAction(s, WeeklyAction.rest);
    expect(rested.player.fatigue, lessThan(s.player.fatigue));
  });

  test('月スキップ: 月が変わるところで止まる', () {
    final s = startAndDecide([InstrumentType.clarinet]);
    final month = ctx.calendar.dateOf(s.turn).month;
    final after = tm.skipMonth(s, MonthlyPolicy.balanced);
    expect(ctx.calendar.dateOf(after.turn).month, isNot(month));
    expect(ctx.calendar.dateOf(after.turn - 1).month, month);
  });

  test('1 年間スキップ: 定期テスト 5 回・評定 3 学期分・2 年生に進級・新入生入部', () {
    var s = startAndDecide([InstrumentType.trumpet]);
    final rosterBefore = s.roster.length;
    while (ctx.calendar.dateOf(s.turn).academicYearIndex == 0) {
      s = tm.skipMonth(s, MonthlyPolicy.balanced);
    }
    expect(s.player.exams.length, 5);
    expect(s.player.termGrades.length, 3);
    expect(s.player.grade, 2);
    final freshmen = ctx.activeMembers(s).where((m) => m.grade == 1).toList();
    expect(freshmen, isNotEmpty);
    expect(s.roster.length, isNot(rosterBefore));
    // 2 年目の楽器決定週を過ぎれば新入生も楽器が決まる。
    s = tm.submitAction(s, WeeklyAction.individualPractice);
    s = tm.submitAction(s, WeeklyAction.individualPractice);
    for (final m in ctx.activeMembers(s)) {
      expect(m.instrument, isNotNull);
    }
  });

  test('ゲーム状態は JSON で往復できる', () {
    var s = startAndDecide([InstrumentType.horn]);
    s = tm.skipMonth(s, MonthlyPolicy.practiceFocus);
    expect(GameState.fromJson(s.toJson()), s);
  });
}
