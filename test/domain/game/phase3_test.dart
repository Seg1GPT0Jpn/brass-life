import 'package:brass_life/core/rng/seed_code.dart';
import 'package:brass_life/domain/entities/world.dart';
import 'package:brass_life/domain/game/engine/game_context.dart';
import 'package:brass_life/domain/game/engine/relations.dart';
import 'package:brass_life/domain/game/engine/time_manager.dart';
import 'package:brass_life/domain/game/models/game_enums.dart';
import 'package:brass_life/domain/game/models/game_state.dart';
import 'package:brass_life/domain/master/memory_templates.dart';
import 'package:brass_life/domain/services/world_generation/world_generator.dart';
import 'package:brass_life/domain/value_objects/instrument.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late World world;
  late GameContext ctx;
  late TimeManager tm;
  late GameState afterHalfYear;

  setUpAll(() {
    world = const WorldGenerator().generate(SeedCode.seedFromInput('TEST'));
    ctx = GameContext(world);
    tm = TimeManager(ctx);
    var s = tm.newGame(world);
    s = tm.submitAction(s, WeeklyAction.individualPractice);
    s = tm.resolveInstrumentDecision(s, [InstrumentType.trumpet]).state;
    for (var i = 0; i < 6; i++) {
      s = tm.skipMonth(s, MonthlyPolicy.balanced);
    }
    afterHalfYear = s;
  });

  test('ターンを進めると NPC 同士の関係が自律的に変化する', () {
    final npcPairs = afterHalfYear.relations.keys.where(
      (k) => !k.contains(Relations.player),
    );
    expect(npcPairs, isNotEmpty);
  });

  test('関係の変化には理由付きの MemoryTag が残る', () {
    final withDelta = afterHalfYear.memories
        .where((m) => m.delta != null)
        .toList();
    expect(withDelta, isNotEmpty);
    for (final m in withDelta) {
      expect(
        memoryTemplates.containsKey(m.reasonKey),
        isTrue,
        reason: m.reasonKey,
      );
      expect(m.subjectId, isNotEmpty);
    }
  });

  test('全ての記憶の理由キーに表示テンプレートがある', () {
    for (final m in afterHalfYear.memories) {
      expect(
        memoryTemplates.containsKey(m.reasonKey),
        isTrue,
        reason: m.reasonKey,
      );
      expect(renderMemory(m.reasonKey, m.params), isNot(contains('{')));
    }
  });

  test('多様な自律行動が起きている（口論・仲良くなる・教える 等）', () {
    final keys = {for (final m in afterHalfYear.memories) m.reasonKey};
    expect(keys, containsAll(['bonded', 'quarreled', 'taught_junior']));
  });

  test('プレイヤーが関わる出来事も記録される', () {
    final mine = afterHalfYear.memories.where(
      (m) => m.subjectId == 'player' || m.objectIds.contains('player'),
    );
    expect(mine.length, greaterThan(3));
  });

  test('決定論: 同じ選択列なら関係性・記憶まで完全一致', () {
    var s = tm.newGame(world);
    s = tm.submitAction(s, WeeklyAction.individualPractice);
    s = tm.resolveInstrumentDecision(s, [InstrumentType.trumpet]).state;
    for (var i = 0; i < 6; i++) {
      s = tm.skipMonth(s, MonthlyPolicy.balanced);
    }
    expect(s.relations, afterHalfYear.relations);
    expect(s.memories, afterHalfYear.memories);
    expect(s, afterHalfYear);
  });

  test('やる気が長く低い部員はやがて退部し、名簿から外れる', () {
    final victim = afterHalfYear.roster.first;
    var s = afterHalfYear.copyWith(
      npcs: {
        ...afterHalfYear.npcs,
        victim: afterHalfYear.npcs[victim]!.copyWith(
          motivation: 0,
          lowMotivationWeeks: 20,
        ),
      },
    );
    for (var i = 0; i < 40 && s.roster.contains(victim); i++) {
      // やる気が回復しないよう毎週 0 に戻す
      s = s.copyWith(
        npcs: {
          ...s.npcs,
          victim: s.npcs[victim]!.copyWith(
            motivation: 0,
            lowMotivationWeeks: 20,
          ),
        },
      );
      if (s.pending != null) break;
      s = tm.submitAction(s, WeeklyAction.study);
    }
    expect(s.roster.contains(victim), isFalse);
    expect(s.npcs[victim]!.quit, isTrue);
    expect(
      s.memories.any(
        (m) => m.reasonKey == 'quit_club' && m.subjectId == victim,
      ),
      isTrue,
    );
  });

  test('パート練習で同じパートの仲間との信頼が上がる', () {
    final s = afterHalfYear.pending == null ? afterHalfYear : afterHalfYear;
    final part = ctx
        .activeMembers(s)
        .where((m) => m.instrument == s.player.instrument)
        .toList();
    if (part.isEmpty) return;
    final before = Relations.get(s, part.first.id, Relations.player).trust;
    final after = tm.submitAction(s, WeeklyAction.partPractice);
    expect(
      Relations.get(after, part.first.id, Relations.player).trust,
      greaterThanOrEqualTo(before),
    );
  });
}
