import 'package:brass_life/core/rng/seed_code.dart';
import 'package:brass_life/domain/entities/world.dart';
import 'package:brass_life/domain/game/engine/executive_engine.dart';
import 'package:brass_life/domain/game/engine/game_context.dart';
import 'package:brass_life/domain/game/engine/relations.dart';
import 'package:brass_life/domain/game/engine/time_manager.dart';
import 'package:brass_life/domain/game/models/candidacy.dart';
import 'package:brass_life/domain/game/models/game_enums.dart';
import 'package:brass_life/domain/game/models/game_state.dart';
import 'package:brass_life/domain/services/world_generation/world_generator.dart';
import 'package:brass_life/domain/value_objects/instrument.dart';
import 'package:flutter_test/flutter_test.dart';

/// 役職への立候補と、選ばれなかったときの心の傷。
void main() {
  late World world;
  late GameContext ctx;
  late TimeManager tm;
  late GameState atSelection;

  setUpAll(() {
    world = const WorldGenerator().generate(SeedCode.seedFromInput('TEST'));
    ctx = GameContext(world);
    tm = TimeManager(ctx);
    var s = tm.newGame(world);
    while (!(s.pending?.type == PendingEventType.executiveSelection &&
        s.player.grade == 2)) {
      s = s.pending != null
          ? tm.autoResolve(s, defaultWishes: [InstrumentType.trumpet])
          : tm.submitAction(s, WeeklyAction.partPractice);
    }
    atSelection = s;
  });

  GameState resolve(GameState s, Candidacy c) =>
      tm.resolveExecutive(s, c).state;

  test('学生指揮・セクションリーダー・パートリーダーに立候補できる', () {
    final roles = ExecutiveEngine(ctx).runnableRoles(atSelection);
    expect(roles, contains(ClubRole.conductor));
    expect(roles, contains(ClubRole.partLeader));
    if (ExecutiveEngine.sections.contains(
      atSelection.player.instrument!.family,
    )) {
      expect(roles, contains(ClubRole.sectionLeader));
    }
  });

  test('この部にない役職には立候補できない', () {
    final roles = ExecutiveEngine(ctx).runnableRoles(atSelection);
    final missing = ClubRole.values.firstWhere((r) => !roles.contains(r));
    expect(
      () => resolve(atSelection, Candidacy.run(missing, 3)),
      throwsArgumentError,
    );
  });

  test('立候補の結果: 狙った役職に就くか、気持ちに応じた心の傷を負う', () {
    for (final role in ExecutiveEngine(ctx).runnableRoles(atSelection)) {
      for (var d = Candidacy.minDesire; d <= Candidacy.maxDesire; d++) {
        final out = resolve(atSelection, Candidacy.run(role, d));
        if (out.roles[Relations.player] == role) {
          expect(out.player.heartache, 0, reason: '$role/$d');
        } else {
          expect(
            out.player.heartache,
            ExecutiveEngine.heartacheOf(role, d),
            reason: '$role/$d',
          );
          expect(
            out.memories.any(
              (m) =>
                  m.reasonKey ==
                  (d >= 4 ? 'lost_role_heartbreak' : 'lost_role'),
            ),
            isTrue,
          );
        }
      }
    }
  });

  test('気持ちが強いほど選ばれやすい（学生指揮は実力順なので単調）', () {
    final wins = [
      for (var d = Candidacy.minDesire; d <= Candidacy.maxDesire; d++)
        resolve(
              atSelection,
              Candidacy.run(ClubRole.conductor, d),
            ).roles[Relations.player] ==
            ClubRole.conductor,
    ];
    // 一度選ばれる強さに達したら、それ以上の強さでも選ばれる
    final first = wins.indexOf(true);
    if (first >= 0) expect(wins.skip(first).every((w) => w), isTrue);
  });

  test('気持ちが強いほど、選ばれなかったときのダメージが大きい', () {
    // 実力を 0 にして学生指揮に立候補 → まず選ばれない
    final weak = atSelection.copyWith(
      player: atSelection.player.copyWith(skill: 0, musicality: 0),
    );
    final low = resolve(weak, Candidacy.run(ClubRole.conductor, 1));
    final high = resolve(weak, Candidacy.run(ClubRole.conductor, 5));
    expect(low.roles[Relations.player], isNot(ClubRole.conductor));
    expect(high.roles[Relations.player], isNot(ClubRole.conductor));
    expect(high.player.heartache, greaterThan(low.player.heartache));
    expect(high.player.motivation, lessThan(low.player.motivation));
    expect(high.player.stress, greaterThan(low.player.stress));
    for (var d = 1; d < Candidacy.maxDesire; d++) {
      for (final r in ClubRole.values) {
        expect(
          ExecutiveEngine.heartacheOf(r, d + 1),
          greaterThan(ExecutiveEngine.heartacheOf(r, d)),
        );
      }
    }
  });

  group('心の傷はなかなか消えない', () {
    GameState hurt(int h) => tm
        .resolveExecutive(atSelection, const Candidacy.neutral())
        .state
        .let((s) => s.copyWith(player: s.player.copyWith(heartache: h)));

    test('週に 1 ずつしか癒えない（話す・遊ぶと少し早い）', () {
      var s = hurt(60);
      while (s.pending != null) {
        s = tm.autoResolve(s);
      }
      var a = s;
      for (var i = 0; i < 8; i++) {
        a = tm.submitAction(a, WeeklyAction.partPractice);
        while (a.pending != null) {
          a = tm.autoResolve(a);
        }
      }
      expect(a.player.heartache, 52);
      final m = ctx.activeMembers(s).first;
      final b = tm.submitAction(s, WeeklyAction.chat, targetId: m.id);
      expect(b.player.heartache, 58);
    });

    test('傷があるとストレスが下がりきらず、やる気も戻りにくい', () {
      var healthy = hurt(0);
      var wounded = hurt(80);
      while (healthy.pending != null) {
        healthy = tm.autoResolve(healthy);
      }
      while (wounded.pending != null) {
        wounded = tm.autoResolve(wounded);
      }
      for (var i = 0; i < 6; i++) {
        healthy = tm.submitAction(healthy, WeeklyAction.rest);
        wounded = tm.submitAction(wounded, WeeklyAction.rest);
        while (healthy.pending != null) {
          healthy = tm.autoResolve(healthy);
        }
        while (wounded.pending != null) {
          wounded = tm.autoResolve(wounded);
        }
      }
      expect(
        wounded.player.stress,
        greaterThanOrEqualTo(wounded.player.heartache ~/ 2),
      );
      expect(wounded.player.stress, greaterThan(healthy.player.stress));
      expect(wounded.player.motivation, lessThan(healthy.player.motivation));
    });
  });
}

extension<T> on T {
  R let<R>(R Function(T) f) => f(this);
}
