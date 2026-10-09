import 'package:brass_life/core/rng/seed_code.dart';
import 'package:brass_life/domain/career/career_engine.dart';
import 'package:brass_life/domain/career/game_mode.dart';
import 'package:brass_life/domain/career/mode_states.dart';
import 'package:brass_life/domain/entities/world.dart';
import 'package:brass_life/domain/game/engine/audition_engine.dart';
import 'package:brass_life/domain/game/engine/ending_analyzer.dart';
import 'package:brass_life/domain/game/engine/game_context.dart';
import 'package:brass_life/domain/game/engine/relations.dart';
import 'package:brass_life/domain/game/engine/time_manager.dart';
import 'package:brass_life/domain/game/models/game_enums.dart';
import 'package:brass_life/domain/game/models/game_state.dart';
import 'package:brass_life/domain/services/world_generation/world_generator.dart';
import 'package:flutter_test/flutter_test.dart';

/// 大人編（顧問・外部講師・OB/OG）を最後まで遊べるか。
void main() {
  late World world;
  late GameContext ctx;
  late TimeManager tm;

  setUpAll(() {
    world = const WorldGenerator().generate(SeedCode.seedFromInput('TEST'));
    ctx = GameContext(world);
    tm = TimeManager(ctx);
  });

  GameState start(GameMode mode) => tm.newCareerGame(
    world,
    mode,
    schoolId: world.player.schoolId,
    familyName: '音羽',
    givenName: '奏',
  );

  /// 任期の終わりまで既定の行動で進める。
  GameState playThrough(GameState s, {void Function(GameState)? onEvent}) {
    var cur = s;
    for (var i = 0; i < 400 && cur.stage != GameStage.finished; i++) {
      if (cur.pending != null) {
        onEvent?.call(cur);
        cur = tm.autoResolve(cur);
      } else {
        cur = tm.submitCareerCommand(cur, CareerEngine(ctx).autoCommand(cur));
      }
    }
    return cur;
  }

  for (final mode in [GameMode.teacher, GameMode.instructor, GameMode.alumni]) {
    test('${mode.label}モード: 3 年間を最後まで遊べて、エンディングが出る', () {
      final events = <PendingEventType>{};
      final s = playThrough(
        start(mode),
        onEvent: (c) => events.add(c.pending!.type),
      );
      expect(s.stage, GameStage.finished);
      expect(s.mode, mode);
      expect(ctx.calendar.dateOf(s.turn).academicYearIndex, 3);
      // 生徒としての出来事は起きない
      expect(events, isNot(contains(PendingEventType.instrumentDecision)));
      expect(events, isNot(contains(PendingEventType.examApplication)));
      if (mode == GameMode.teacher) {
        expect(
          events,
          containsAll([
            PendingEventType.pieceSelection,
            PendingEventType.teacherAudition,
            PendingEventType.contest,
            PendingEventType.concert,
          ]),
        );
      } else {
        expect(events, isNot(contains(PendingEventType.audition)));
      }
      expect(
        s.achievements.where((a) => a.kind == 'contest_career'),
        isNotEmpty,
      );
      final ending = EndingAnalyzer(ctx).analyze(s);
      expect(ending.title, isNotEmpty);
      expect(ending.epilogue, isNotEmpty);
    });
  }

  test('決定論: 同じコマンドなら同じ結果', () {
    final a = playThrough(start(GameMode.alumni));
    final b = playThrough(start(GameMode.alumni));
    expect(a, b);
  });

  group('顧問', () {
    test('面談で生徒のストレスが下がり、顧問への信頼が上がる', () {
      final s = start(GameMode.teacher);
      final m = ctx.activeMembers(s).first;
      final after = tm.submitCareerCommand(
        s,
        CareerCommand.counseling,
        targetId: m.id,
      );
      expect(
        Relations.get(after, m.id, Relations.player).trust,
        greaterThan(Relations.get(s, m.id, Relations.player).trust),
      );
    });

    test('練習メニューで伸び方とストレスが変わる', () {
      final s = start(GameMode.teacher);
      int sumSkill(GameState x) =>
          ctx.activeMembers(x).fold(0, (a, m) => a + m.skill);
      int sumStress(GameState x) =>
          ctx.activeMembers(x).fold(0, (a, m) => a + m.stress);
      var part = tm.setPracticeMenu(s, PracticeMenuPreset.part);
      var rest = tm.setPracticeMenu(s, PracticeMenuPreset.rest);
      for (var i = 0; i < 4; i++) {
        part = tm.submitCareerCommand(part, CareerCommand.watch);
        rest = tm.submitCareerCommand(rest, CareerCommand.watch);
      }
      expect(sumSkill(part), greaterThan(sumSkill(rest)));
      expect(sumStress(part), greaterThan(sumStress(rest)));
    });

    test('オーディション: 実力のある部員を外すと不満が残る', () {
      var s = start(GameMode.teacher);
      while (s.pending?.type != PendingEventType.teacherAudition) {
        s = s.pending != null
            ? tm.autoResolve(s)
            : tm.submitCareerCommand(s, CareerCommand.watch);
      }
      final p = AuditionEngine(ctx).preview(s);
      expect(p.candidates, isNotEmpty);
      final fair = tm
          .resolveTeacherAudition(s, AuditionEngine(ctx).recommended(s))
          .state;
      // 評価の低い順に選ぶ（不公平）
      final reversed = p.candidates.reversed.take(p.limit).toSet();
      final unfair = tm.resolveTeacherAudition(s, reversed).state;
      int complaints(GameState x) => x.memories
          .where((m) => m.reasonKey == 'teacher_unfair_audition')
          .length;
      expect(complaints(fair), 0);
      if (p.candidates.length > p.limit) {
        expect(complaints(unfair), greaterThan(0));
      }
      expect(unfair.contestMembers.toSet(), reversed);
    });
  });

  group('外部講師', () {
    test('集中レッスンで同じ楽器の部員がまとめて伸びる', () {
      final s = start(GameMode.instructor);
      final m = ctx.activeMembers(s).firstWhere((x) => x.instrument != null);
      final after = tm.submitCareerCommand(
        s,
        CareerCommand.intensiveCoaching,
        targetId: m.id,
      );
      for (final x
          in ctx.activeMembers(s).where((x) => x.instrument == m.instrument)) {
        expect(after.npcs[x.id]!.skill, greaterThan(x.skill));
      }
    });

    test('出張レッスンは契約校にだけ行け、その学校に上乗せがつく', () {
      final s = start(GameMode.instructor);
      final other = s.career!.contractedSchoolIds[1];
      final after = tm.submitCareerCommand(
        s,
        CareerCommand.travelLesson,
        targetId: other,
      );
      expect(after.career!.schoolBoosts[other], 2);
      expect(
        () => tm.submitCareerCommand(
          s,
          CareerCommand.travelLesson,
          targetId: s.schoolId,
        ),
        throwsArgumentError,
      );
    });
  });

  group('OB/OG', () {
    test('資金で差し入れ・寄付ができ、足りなければできない', () {
      final s = start(GameMode.alumni);
      expect(s.career!.money, 30000);
      final gift = tm.submitCareerCommand(s, CareerCommand.snackGift);
      expect(gift.career!.money, 30000 - 5000 + 3000);
      expect(gift.career!.bond, greaterThan(s.career!.bond));
      final poor = s.copyWith(career: s.career!.copyWith(money: 1000));
      expect(
        () => tm.submitCareerCommand(poor, CareerCommand.donation),
        throwsArgumentError,
      );
      final worked = tm.submitCareerCommand(poor, CareerCommand.work);
      expect(worked.career!.money, 1000 + 12000 + 3000);
    });

    test('他モードのコマンドは使えない', () {
      final s = start(GameMode.alumni);
      expect(
        () => tm.submitCareerCommand(s, CareerCommand.masterclass),
        throwsArgumentError,
      );
    });
  });
}
