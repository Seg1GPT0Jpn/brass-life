import 'package:brass_life/core/rng/seed_code.dart';
import 'package:brass_life/domain/entities/world.dart';
import 'package:brass_life/domain/master/name_pools.dart';
import 'package:brass_life/domain/master/trait_definitions.dart';
import 'package:brass_life/domain/services/world_fingerprint.dart';
import 'package:brass_life/domain/services/world_generation/world_generator.dart';
import 'package:brass_life/domain/services/world_generation/world_validator.dart';
import 'package:brass_life/domain/value_objects/person_enums.dart';
import 'package:brass_life/domain/value_objects/school_enums.dart';
import 'package:flutter_test/flutter_test.dart';

/// Seed "TEST" から生成した世界のフィンガープリント（回帰検知用）。
///
/// VM と Web(Chrome) の両方で同じ値になることが決定性の証明になる。
/// 生成ロジックを意図的に変更した場合は generatorVersion を上げ、この値を更新する。
const goldenSeedInput = 'TEST';
const goldenFingerprint = '9EBA95EBDA15DF00';

void main() {
  const gen = WorldGenerator();
  late World world;

  setUpAll(() {
    world = gen.generate(SeedCode.seedFromInput(goldenSeedInput));
  });

  test('ゴールデン: Seed "TEST" のフィンガープリントが固定値と一致する', () {
    final fp = WorldFingerprint.compute(world);
    // ignore: avoid_print
    print('fingerprint(TEST) = $fp');
    expect(fp, goldenFingerprint);
  });

  test('同じ Seed からは完全に同一の世界が生成される', () {
    final again = gen.generate(world.seed);
    expect(again, world);
    expect(WorldFingerprint.compute(again), WorldFingerprint.compute(world));
  });

  test('異なる Seed からは異なる世界が生成される', () {
    final other = gen.generate(world.seed ^ 1);
    expect(
      WorldFingerprint.compute(other),
      isNot(WorldFingerprint.compute(world)),
    );
  });

  test('JSON 往復で同一になる', () {
    expect(World.fromJson(world.toJson()), world);
  });

  test('構成: 中学 40 校・高校 24 校、NPC 1000〜2000 人', () {
    expect(
      world.schools.where((s) => s.level == SchoolLevel.middle).length,
      40,
    );
    expect(world.schools.where((s) => s.level == SchoolLevel.high).length, 24);
    expect(world.npcs.length, inInclusiveRange(1000, 2000));
    expect(WorldValidator.validate(world), isEmpty);
  });

  test('多数の Seed で検証を通過し、NPC 数が範囲内', () {
    for (var s = 0; s < 40; s++) {
      final w = gen.generate(SeedCode.seedFromInput('seed-$s'));
      expect(WorldValidator.validate(w), isEmpty, reason: 'seed-$s');
      expect(w.npcs.length, inInclusiveRange(1000, 2000));
    }
  });

  test('高校の偏差値は層化抽選により全帯（35〜74）を網羅する', () {
    final devs = [
      for (final s in world.schools)
        if (s.deviation != null) s.deviation!,
    ];
    for (var band = 35; band < 75; band += 5) {
      expect(
        devs.any((d) => d >= band && d < band + 5),
        isTrue,
        reason: '$band 帯',
      );
    }
  });

  test('強さ帯は構成比どおり（高校: 全国2/支部3/県6/地区8/弱小5）', () {
    final highClubs = [
      for (final c in world.clubs)
        if (c.schoolId.startsWith('sch_h')) c,
    ];
    int count(ClubTier t) => highClubs.where((c) => c.tier == t).length;
    expect(count(ClubTier.national), 2);
    expect(count(ClubTier.block), 3);
    expect(count(ClubTier.prefectural), 6);
    expect(count(ClubTier.district), 8);
    expect(count(ClubTier.weak), 5);
  });

  test('NPC: 上級生は担当楽器、新入生は希望楽器を持ち、性格タグが 1 個以上', () {
    for (final n in world.npcs) {
      expect(n.traits, isNotEmpty);
      for (final t in n.traits) {
        expect(traitById.containsKey(t.traitId), isTrue);
        expect(t.intensity, inInclusiveRange(1, 3));
      }
      if (n.role != NpcRole.student) {
        expect(n.advisorProfile, isNotNull);
        continue;
      }
      if (n.grade! >= 2) {
        expect(n.instrument, isNotNull);
        expect(n.instrumentSkill, inInclusiveRange(0, 1000));
      } else {
        expect(n.instrument, isNull);
        expect(n.wishInstrument, isNotNull);
      }
    }
  });

  test('排他グループの性格タグは共存しない', () {
    for (final n in world.npcs) {
      final groups = <String>{};
      for (final t in n.traits) {
        final g = traitById[t.traitId]!.group;
        if (g == null) continue;
        expect(groups.add(g), isTrue, reason: '${n.id} の $g が重複');
      }
    }
  });

  test('女子校の部員は全員女性', () {
    for (final s in world.schools.where((s) => s.girlsOnly)) {
      for (final n in world.npcs.where(
        (n) => n.schoolId == s.id && n.role == NpcRole.student,
      )) {
        expect(n.gender, Gender.female);
      }
    }
  });

  test('地名・校名に実在名称ブロックリストの語を使っていない', () {
    for (final d in world.region.districts) {
      for (final t in d.towns) {
        expect(realNameBlocklist.contains(t), isFalse, reason: t);
      }
    }
  });

  test('プレイヤーは中学校に所属し、Seed から決定される', () {
    final school = world.schools.firstWhere(
      (s) => s.id == world.player.schoolId,
    );
    expect(school.level, SchoolLevel.middle);
    final again = gen.generate(world.seed);
    expect(again.player, world.player);
  });

  test('記憶（MemoryTag）は全て開始前の日付で、主体が存在する', () {
    final ids = {for (final n in world.npcs) n.id};
    expect(world.memories, isNotEmpty);
    for (final m in world.memories) {
      expect(ids.contains(m.subjectId), isTrue);
      expect(m.date.turn, lessThanOrEqualTo(0));
    }
  });
}
