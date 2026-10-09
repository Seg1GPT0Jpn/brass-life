import 'package:brass_life/core/rng/seed_code.dart';
import 'package:brass_life/data/repositories/hive_career_repository.dart';
import 'package:brass_life/domain/career/career_flow.dart';
import 'package:brass_life/domain/career/career_record.dart';
import 'package:brass_life/domain/career/career_recorder.dart';
import 'package:brass_life/domain/career/game_mode.dart';
import 'package:brass_life/domain/career/mode_states.dart';
import 'package:brass_life/domain/game/engine/ending_analyzer.dart';
import 'package:brass_life/domain/game/engine/game_context.dart';
import 'package:brass_life/domain/game/engine/time_manager.dart';
import 'package:brass_life/domain/game/models/game_enums.dart';
import 'package:brass_life/domain/services/world_generation/world_generator.dart';
import 'package:flutter_test/flutter_test.dart';

CareerRecord rec({
  String path = 'univ',
  List<String> roles = const [],
  int skill = 400,
}) => CareerRecord(
  worldSeed: 1,
  playerName: '音羽 奏',
  title: '自分らしく',
  pathKind: path,
  pathLabel: '',
  finalSkill: skill,
  finalMusicality: 300,
  roles: roles,
  bestContest: '',
  quitAtEnd: false,
  clearedAt: '2026-10-09T00:00:00',
);

void main() {
  group('解放条件', () {
    test('記録がなければ本編のみ', () {
      expect(CareerUnlocks.unlocked(const []), {GameMode.student});
    });

    test('どんな進路でも卒業すれば OB/OG モード', () {
      expect(CareerUnlocks.unlocked([rec(path: 'ronin')]), {
        GameMode.student,
        GameMode.alumni,
      });
    });

    test('大学進学 + 幹部経験で顧問モード、音大か熟練度 700 で外部講師モード', () {
      expect(
        CareerUnlocks.unlocked([
          rec(roles: ['conductor']),
        ]),
        contains(GameMode.teacher),
      );
      expect(
        CareerUnlocks.unlocked([
          rec(path: 'ronin', roles: ['captain']),
        ]),
        isNot(contains(GameMode.teacher)),
      );
      expect(
        CareerUnlocks.unlocked([rec(path: 'univ_music')]),
        contains(GameMode.instructor),
      );
      expect(
        CareerUnlocks.unlocked([rec(skill: 720)]),
        contains(GameMode.instructor),
      );
      expect(
        CareerUnlocks.unlocked([rec(skill: 699)]),
        isNot(contains(GameMode.instructor)),
      );
    });
  });

  group('状態遷移', () {
    test('解放されていないモードは選べない', () {
      final t = CareerFlow.chooseMode(
        const AtTitle({GameMode.student}),
        GameMode.teacher,
      );
      expect(t, isA<Rejected>());
    });

    test('解放済みの大人編は、選んで始められる', () {
      final chosen = CareerFlow.chooseMode(
        const AtTitle({GameMode.student, GameMode.alumni}),
        GameMode.alumni,
      );
      expect(chosen, isA<Moved>());
      final phase = (chosen as Moved).to;
      expect(
        CareerFlow.start(phase, const ModeSession(GameMode.alumni, 'auto')),
        isA<Moved>(),
      );
      // 別のモードのセッションでは始められない
      expect(
        CareerFlow.start(phase, const ModeSession(GameMode.teacher, 'auto')),
        isA<Rejected>(),
      );
      expect(CareerFlow.backToTitle(phase, const []), isA<Moved>());
    });

    test('本編: 選ぶ → 始める → 終える → タイトルで解放が増える', () {
      var t = CareerFlow.chooseMode(
        const AtTitle({GameMode.student}),
        GameMode.student,
      );
      t = CareerFlow.start(
        (t as Moved).to,
        const ModeSession(GameMode.student, 'auto'),
      );
      expect((t as Moved).to, isA<Playing>());
      final r = rec(roles: ['captain']);
      t = CareerFlow.finish(t.to, r);
      expect((t as Moved).to, isA<Finished>());
      t = CareerFlow.backToTitle(t.to, [r]);
      expect(
        ((t as Moved).to as AtTitle).unlocked,
        containsAll([GameMode.teacher, GameMode.alumni]),
      );
    });

    test('コマンドはモードごとに分かれている', () {
      expect(CareerCommand.of(GameMode.teacher), hasLength(4));
      expect(CareerCommand.of(GameMode.instructor), hasLength(4));
      expect(CareerCommand.of(GameMode.alumni), hasLength(4));
      expect(CareerCommand.of(GameMode.student), isEmpty);
    });
  });

  test('6 年間の終わりから記録を作り、JSON で往復し、保存できる', () async {
    final world = const WorldGenerator().generate(
      SeedCode.seedFromInput('TEST'),
    );
    final ctx = GameContext(world);
    final tm = TimeManager(ctx);
    var s = tm.newGame(world);
    for (var i = 0; i < 2000 && s.stage != GameStage.finished; i++) {
      s = s.pending != null
          ? tm.autoResolve(s)
          : tm.submitAction(s, tm.actionForPolicy(s));
    }
    while (s.pending != null) {
      s = tm.autoResolve(s);
    }
    final ending = EndingAnalyzer(ctx).analyze(s);
    final r = CareerRecorder.record(s, ending, clearedAt: 'x');
    expect(r.title, ending.title);
    expect(r.worldSeed, s.worldSeed);
    expect(r.finalSkill, s.player.skill);
    expect([
      'univ',
      'univ_music',
      'ronin',
      'none',
    ], contains(r.pathKind.startsWith('univ') ? r.pathKind : r.pathKind));
    final back = CareerRecord.fromJson(r.toJson());
    expect(back.toJson(), r.toJson());
    final repo = InMemoryCareerRepository();
    await repo.add(r);
    expect((await repo.all()).single.title, r.title);
    expect(CareerUnlocks.unlocked(await repo.all()), contains(GameMode.alumni));
  });
}
