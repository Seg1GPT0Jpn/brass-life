import 'package:brass_life/core/rng/seed_code.dart';
import 'package:brass_life/domain/entities/world.dart';
import 'package:brass_life/domain/game/engine/game_context.dart';
import 'package:brass_life/domain/game/engine/motivation_spread.dart';
import 'package:brass_life/domain/game/engine/performance.dart';
import 'package:brass_life/domain/game/engine/relations.dart';
import 'package:brass_life/domain/game/engine/retirement_shock.dart';
import 'package:brass_life/domain/game/engine/time_manager.dart';
import 'package:brass_life/domain/game/models/game_enums.dart';
import 'package:brass_life/domain/game/models/game_state.dart';
import 'package:brass_life/domain/services/world_generation/world_generator.dart';
import 'package:brass_life/domain/value_objects/instrument.dart';
import 'package:brass_life/domain/value_objects/relationship_vector.dart';
import 'package:flutter_test/flutter_test.dart';

/// やる気の伝播と引退ショック。
void main() {
  NpcState npc(String id, int motivation, {InstrumentType? inst}) => NpcState(
    id: id,
    grade: 2,
    instrument: inst ?? InstrumentType.trumpet,
    motivation: motivation,
  );

  group('やる気の伝播', () {
    final before = {
      'a': npc('a', 50),
      'b': npc('b', 50),
      'c': npc('c', 50),
      'd': npc('d', 50, inst: InstrumentType.flute),
    };

    test('幹部のやる気の上昇が、同じパートにだけ伝わる', () {
      final after = {...before, 'a': npc('a', 58)};
      final r = MotivationSpread.apply(
        before: before,
        after: after,
        relations: const {},
        roles: const {'a': ClubRole.captain},
      );
      expect(r.received.keys, unorderedEquals(['b', 'c']));
      expect(r.npcs['b']!.motivation, greaterThan(50));
      expect(r.npcs['d']!.motivation, 50); // 別のパート
      expect(r.npcs['a']!.motivation, 58); // 本人は変わらない
    });

    test('信頼している相手からは強く伝わる。下がる変化も伝わる', () {
      final after = {...before, 'a': npc('a', 44)};
      final rel = <String, RelationshipVector>{};
      Relations.add(rel, 'b', 'a', const RelationshipVector(trust: 50));
      final r = MotivationSpread.apply(
        before: before,
        after: after,
        relations: rel,
        roles: const {'a': ClubRole.partLeader},
      );
      expect(r.received['b'], lessThan(r.received['c']!)); // より大きく下がる
      expect(r.received['c'], lessThan(0));
    });

    test('役職も人望もない部員の変化、小さな変化は伝わらない', () {
      final r1 = MotivationSpread.apply(
        before: before,
        after: {...before, 'a': npc('a', 60)},
        relations: const {},
        roles: const {},
      );
      expect(r1.received, isEmpty);
      final r2 = MotivationSpread.apply(
        before: before,
        after: {...before, 'a': npc('a', 52)},
        relations: const {},
        roles: const {'a': ClubRole.captain},
      );
      expect(r2.received, isEmpty);
      // 人望（性格）があれば役職がなくても伝わる
      final r3 = MotivationSpread.apply(
        before: before,
        after: {...before, 'a': npc('a', 60)},
        relations: const {},
        roles: const {},
        isPopular: (id) => id == 'a',
      );
      expect(r3.received, isNotEmpty);
    });

    test('結果は処理の順番によらない（マップの並びを変えても同じ）', () {
      final after = {...before, 'a': npc('a', 60), 'b': npc('b', 40)};
      final reversed = Map.fromEntries(after.entries.toList().reversed);
      final roles = {'a': ClubRole.captain, 'b': ClubRole.viceCaptain};
      final r1 = MotivationSpread.apply(
        before: before,
        after: after,
        relations: const {},
        roles: roles,
      );
      final r2 = MotivationSpread.apply(
        before: before,
        after: reversed,
        relations: const {},
        roles: roles,
      );
      for (final id in after.keys) {
        expect(r1.npcs[id], r2.npcs[id]);
      }
    });
  });

  group('引退ショック', () {
    late World world;
    late GameContext ctx;
    late TimeManager tm;

    setUpAll(() {
      world = const WorldGenerator().generate(SeedCode.seedFromInput('TEST'));
      ctx = GameContext(world);
      tm = TimeManager(ctx);
    });

    test('3 年生の引退で技術とテンションが落ち込み、演奏の指標が下がる。毎週少しずつ戻る', () {
      var s = tm.newGame(world);
      var shocked = false;
      for (var i = 0; i < 80 && !shocked; i++) {
        final before = s.condition;
        s = s.pending != null
            ? tm.autoResolve(s, defaultWishes: [InstrumentType.trumpet])
            : tm.submitAction(s, WeeklyAction.partPractice);
        shocked = s.condition.techniqueShock > before.techniqueShock;
      }
      expect(shocked, isTrue);
      expect(
        s.condition.techniqueShock,
        inInclusiveRange(3, RetirementShock.max),
      );
      expect(
        s.condition.tensionShock,
        inInclusiveRange(3, RetirementShock.max),
      );
      expect(
        s.logs.any((l) => l.lines.any((x) => x.startsWith('引退ショック'))),
        isTrue,
      );
      // 同じ部員でも、ショックがあると演奏の指標が下がる
      final members = [for (final m in ctx.activeMembers(s)) m.id];
      final calm = Performance(ctx)
          .metrics(s.copyWith(condition: const ClubCondition()), members);
      final now = Performance(ctx).metrics(s, members);
      expect(now.avgSkill, lessThan(calm.avgSkill));
      expect(now.avgMotivation, lessThanOrEqualTo(calm.avgMotivation));
      // 回復
      final start = s.condition;
      for (var i = 0; i < 4; i++) {
        s = s.pending != null
            ? tm.autoResolve(s)
            : tm.submitAction(s, WeeklyAction.partPractice);
      }
      expect(s.condition.tensionShock, lessThan(start.tensionShock));
      expect(s.condition.techniqueShock, lessThan(start.techniqueShock));
    });

    test('回復: テンションは毎週、技術は 2 週に 1 ずつ', () {
      const c = ClubCondition(techniqueShock: 10, tensionShock: 10);
      expect(
        RetirementShock.recover(c, 2),
        const ClubCondition(techniqueShock: 9, tensionShock: 9),
      );
      expect(
        RetirementShock.recover(c, 3),
        const ClubCondition(techniqueShock: 10, tensionShock: 9),
      );
      expect(
        RetirementShock.recover(const ClubCondition(), 2),
        const ClubCondition(),
      );
    });
  });
}
