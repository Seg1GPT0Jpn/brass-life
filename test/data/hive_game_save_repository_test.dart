@TestOn('vm')
library;

import 'dart:io';

import 'package:brass_life/core/rng/seed_code.dart';
import 'package:brass_life/data/repositories/hive_game_save_repository.dart';
import 'package:brass_life/domain/game/engine/game_context.dart';
import 'package:brass_life/domain/game/engine/time_manager.dart';
import 'package:brass_life/domain/game/models/game_enums.dart';
import 'package:brass_life/domain/game/models/game_state.dart';
import 'package:brass_life/domain/game/models/save_summary.dart';
import 'package:brass_life/domain/services/world_generation/world_generator.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive_ce.dart';

void main() {
  late GameState practiceLife;
  late GameState studyLife;

  setUpAll(() {
    final world = const WorldGenerator().generate(
      SeedCode.seedFromInput('TEST'),
    );
    final tm = TimeManager(GameContext(world));
    GameState play(MonthlyPolicy policy) {
      var s = tm.newGame(world).copyWith(policy: policy);
      for (var i = 0; i < 2000 && s.stage != GameStage.finished; i++) {
        s = s.pending != null
            ? tm.autoResolve(s)
            : tm.submitAction(s, tm.actionForPolicy(s));
      }
      return s;
    }

    practiceLife = play(MonthlyPolicy.practiceFocus);
    studyLife = play(MonthlyPolicy.studyFocus);
  });

  test('セーブスロット（Hive）: 6 年分の状態を保存・読込・一覧・削除できる', () async {
    final dir = await Directory.systemTemp.createTemp('brass_life_test');
    Hive.init(dir.path);
    final box = await Hive.openBox<String>('saves_test');
    final repo = HiveGameSaveRepository(box);
    SaveSummary summary(String slot) => SaveSummary(
      slot: slot,
      worldSeed: practiceLife.worldSeed,
      seedCode: SeedCode.format(practiceLife.worldSeed),
      playerName: practiceLife.player.fullName,
      dateLabel: 'x',
      schoolName: 'y',
      savedAt: 'z',
    );
    await repo.save('1', practiceLife, summary('1'));
    await repo.save('2', studyLife, summary('2'));
    expect(await repo.load('1'), practiceLife);
    expect(await repo.load('2'), studyLife);
    expect((await repo.list()).map((s) => s.slot), ['1', '2']);
    await repo.delete('1');
    expect(await repo.load('1'), isNull);
    expect((await repo.list()).map((s) => s.slot), ['2']);
    await box.close();
    await dir.delete(recursive: true);
  });
}
