import 'package:brass_life/core/rng/seed_code.dart';
import 'package:brass_life/domain/entities/world.dart';
import 'package:brass_life/domain/game/engine/game_context.dart';
import 'package:brass_life/domain/game/engine/player_setup_service.dart';
import 'package:brass_life/domain/game/engine/time_manager.dart';
import 'package:brass_life/domain/game/models/game_enums.dart';
import 'package:brass_life/domain/game/models/game_state.dart';
import 'package:brass_life/domain/game/models/player_setup.dart';
import 'package:brass_life/domain/services/world_generation/world_generator.dart';
import 'package:brass_life/domain/value_objects/aptitude.dart';
import 'package:brass_life/domain/value_objects/person_enums.dart';
import 'package:brass_life/domain/value_objects/personality.dart';
import 'package:brass_life/domain/value_objects/school_enums.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late World world;
  late GameContext ctx;
  late TimeManager tm;
  late PlayerSetupService service;

  setUpAll(() {
    world = const WorldGenerator().generate(SeedCode.seedFromInput('TEST'));
    ctx = GameContext(world);
    tm = TimeManager(ctx);
    service = PlayerSetupService(world);
  });

  PlayerSetup custom() {
    final d = service.defaults();
    final otherSchool = service
        .selectableSchools(Gender.male)
        .firstWhere((id) => id != d.schoolId);
    return d.copyWith(
      familyName: '音羽',
      givenName: '奏',
      gender: Gender.male,
      schoolId: otherSchool,
      background: MusicBackground.piano,
      personality: testAxes,
    );
  }

  test('おまかせ（Seed のまま）の設定は検証を通る', () {
    expect(service.validate(service.defaults()), isNull);
    expect(service.defaults().pointsUsed, lessThanOrEqualTo(service.budget));
  });

  test('検証: 名前なし・上限超過・女子校への男子の入学は不可', () {
    final d = service.defaults();
    expect(service.validate(d.copyWith(givenName: ' ')), isNotNull);
    final maxed = d.copyWith(
      academic: 100,
      stamina: 100,
      aptitude: const AptitudeStats(
        pitch: 100,
        rhythm: 100,
        breath: 100,
        dexterity: 100,
        expression: 100,
        reading: 100,
      ),
    );
    expect(service.validate(maxed), contains('上限'));
    final girls = world.schools.where(
      (s) => s.level == SchoolLevel.middle && s.girlsOnly,
    );
    for (final g in girls) {
      expect(
        service.validate(d.copyWith(gender: Gender.male, schoolId: g.id)),
        isNotNull,
      );
    }
    expect(
      service.validate(d.copyWith(schoolId: 'sch_h00')),
      isNotNull,
      reason: '高校には入学できない',
    );
  });

  test('設定した主人公で人生が始まる（名前・学校・経験・性格・能力）', () {
    final setup = custom();
    final s = tm.newGame(world, setup: setup);
    expect(s.player.fullName, '音羽 奏');
    expect(s.player.gender, Gender.male);
    expect(s.schoolId, setup.schoolId);
    expect(s.schoolHistory, [setup.schoolId]);
    expect(s.player.background, MusicBackground.piano);
    expect(s.player.personality, setup.personality);
    expect(s.player.traits, service.traitsFor(setup.personality));
    // ピアノ経験の補正（読譜力 +12、上限 100）
    expect(
      s.player.aptitude.reading,
      (setup.aptitude.reading + 12).clamp(0, 100),
    );
    expect(s.player.academic, setup.academic * 10);
    // 名簿は選んだ中学校の吹奏楽部
    final club = ctx.index.clubOfSchool(setup.schoolId);
    expect(s.roster, club.memberIds);
    expect(s.setup, setup);
  });

  test('決定論: 同じ Seed・同じ設定・同じ選択なら同じ人生、設定が違えば別の人生', () {
    GameState play(PlayerSetup? setup) {
      var s = tm.newGame(world, setup: setup);
      for (var i = 0; i < 80; i++) {
        s = s.pending != null
            ? tm.autoResolve(s)
            : tm.submitAction(s, tm.actionForPolicy(s));
      }
      return s;
    }

    expect(play(custom()), play(custom()));
    expect(play(custom()).player, isNot(play(null).player));
  });

  test('設定なしの開始は従来どおり（Seed が決めた主人公）', () {
    final s = tm.newGame(world);
    expect(s.player.fullName, world.player.fullName);
    expect(s.schoolId, world.player.schoolId);
    expect(s.setup, isNull);
  });

  test('性格タグは性格軸から決定論的に決まる', () {
    const axes = testAxes;
    expect(service.traitsFor(axes), service.traitsFor(axes));
    expect(service.traitsFor(world.player.personality), world.player.traits);
  });

  test('ゲーム開始後も性格に応じた練習効率などが働く（勤勉なほど勉強の伸びが大きい）', () {
    final d = service.defaults();
    GameState studyWeek(int consc) {
      var s = tm.newGame(
        world,
        setup: d.copyWith(
          personality: d.personality.copyWith(conscientiousness: consc),
        ),
      );
      s = tm.submitAction(s, WeeklyAction.study);
      return s;
    }

    expect(
      studyWeek(100).player.academic,
      greaterThan(studyWeek(-100).player.academic),
    );
  });
}

/// テスト用の性格軸（外向的で野心的）。
const testAxes = PersonalityAxes(
  extraversion: 70,
  agreeableness: 10,
  conscientiousness: 40,
  neuroticism: -20,
  ambition: 80,
);
