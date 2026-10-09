import 'package:brass_life/core/rng/seed_code.dart';
import 'package:brass_life/domain/career/game_mode.dart';
import 'package:brass_life/domain/career/mode_states.dart';
import 'package:brass_life/domain/game/conducting/conducting.dart';
import 'package:brass_life/domain/game/conducting/rehearsal.dart';
import 'package:brass_life/domain/game/engine/game_context.dart';
import 'package:brass_life/domain/game/engine/time_manager.dart';
import 'package:brass_life/domain/game/master/set_pieces.dart';
import 'package:brass_life/domain/game/models/game_enums.dart';
import 'package:brass_life/domain/game/models/game_state.dart';
import 'package:brass_life/domain/services/world_generation/world_generator.dart';
import 'package:brass_life/domain/value_objects/instrument.dart';
import 'package:flutter_test/flutter_test.dart';

/// 指揮ミニゲームの「リハーサル記憶」。
void main() {
  const params = ConductingParams(stamina: 95, technique: 95, cohesion: 95);
  final piece = SetPieces.byYear(1).first;

  RehearsalMemory practiced(int d, int e, int sessions) => RehearsalMemory(
    fiscalYear: 2026,
    dynamicsSum: d * sessions,
    expressionSum: e * sessions,
    sessions: sessions,
  );

  group('記録', () {
    test('平均と回数、年度が変わるとリセット', () {
      var m = RehearsalRules.record(const RehearsalMemory(), 2026, [
        (40, 60),
        (60, 40),
      ]);
      expect((m.avgDynamics, m.avgExpression, m.sessions), (50, 50, 2));
      m = RehearsalRules.record(m, 2027, [(70, 70)]);
      expect((m.fiscalYear, m.sessions, m.avgDynamics), (2027, 1, 70));
    });

    test('部活に出た週は通常練習と行動の練習が記録される', () {
      final world = const WorldGenerator().generate(
        SeedCode.seedFromInput('TEST'),
      );
      final ctx = GameContext(world);
      final tm = TimeManager(ctx);
      var s = tm.newGame(world);
      s = tm.submitAction(s, WeeklyAction.individualPractice);
      s = tm.resolveInstrumentDecision(s, [InstrumentType.trumpet]).state;
      final before = s.rehearsal.sessions;
      final loud = tm.submitAction(s, WeeklyAction.extraPractice);
      expect(loud.rehearsal.sessions, before + 2);
      final quiet = tm.submitAction(s, WeeklyAction.basics);
      expect(
        loud.rehearsal.avgDynamics,
        greaterThan(quiet.rehearsal.avgDynamics),
      );
      // 休養の週は記録されない
      expect(tm.submitAction(s, WeeklyAction.rest).rehearsal.sessions, before);
    });

    test('顧問モードでは練習メニューが記録される', () {
      final world = const WorldGenerator().generate(
        SeedCode.seedFromInput('TEST'),
      );
      final ctx = GameContext(world);
      final tm = TimeManager(ctx);
      var s = tm.newCareerGame(
        world,
        GameMode.teacher,
        schoolId: world.player.schoolId,
        familyName: 'a',
        givenName: 'b',
      );
      s = tm.setPracticeMenu(s, PracticeMenuPreset.basics);
      s = tm.submitCareerCommand(s, CareerCommand.watch);
      expect(s.rehearsal.avgDynamics, 35);
      final rested = tm.submitCareerCommand(
        tm.setPracticeMenu(s, PracticeMenuPreset.rest),
        CareerCommand.watch,
      );
      expect(rested.rehearsal.sessions, s.rehearsal.sessions);
    });
  });

  group('本番の判定', () {
    test('練習の範囲内なら減点なし', () {
      final m = practiced(55, 55, 20);
      expect(RehearsalPenalty.penaltyPermille(m, 90, 90), 0); // 差 35 は許容
      expect(RehearsalPenalty.collapses(m, 90, 90), isFalse);
    });

    test('練習から大きく外れると減点、よく練習した曲ほど重く、崩壊もする', () {
      final few = practiced(30, 30, 3);
      final many = practiced(30, 30, 30);
      final pFew = RehearsalPenalty.penaltyPermille(few, 100, 95);
      final pMany = RehearsalPenalty.penaltyPermille(many, 100, 95);
      expect(pFew, greaterThan(0));
      expect(pMany, greaterThan(pFew));
      expect(RehearsalPenalty.collapses(few, 100, 95), isFalse); // 慣れが浅い
      expect(RehearsalPenalty.collapses(many, 100, 95), isTrue);
    });

    test('記録がなければ減点しない', () {
      expect(
        RehearsalPenalty.penaltyPermille(const RehearsalMemory(), 100, 100),
        0,
      );
    });

    test('同じプランでも、練習から外れていると評価が下がり崩壊が増える', () {
      // ff 中心のプラン
      const plan = ConductingPlan([
        (90, 70),
        (85, 70),
        (90, 75),
        (95, 80),
        (90, 70),
      ]);
      final loud = ConductingEvaluator.evaluate(
        piece,
        params,
        plan,
        rehearsal: practiced(80, 70, 30),
      );
      final soft = ConductingEvaluator.evaluate(
        piece,
        params,
        plan,
        rehearsal: practiced(25, 25, 30),
      );
      expect(soft.totalPermille, lessThan(loud.totalPermille));
      expect(soft.collapses, greaterThan(loud.collapses));
      expect(soft.phrases.any((p) => p.offRehearsal), isTrue);
      expect(soft.summary().join(), contains('練習と違いすぎて'));
    });
  });
}
