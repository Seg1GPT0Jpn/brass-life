import 'dart:convert';

import 'package:brass_life/core/rng/seed_code.dart';
import 'package:brass_life/core/rng/seed_hasher.dart';
import 'package:brass_life/domain/entities/world.dart';
import 'package:brass_life/domain/game/engine/ending_analyzer.dart';
import 'package:brass_life/domain/game/engine/entrance_exam_engine.dart';
import 'package:brass_life/domain/game/engine/game_context.dart';
import 'package:brass_life/domain/game/engine/time_manager.dart';
import 'package:brass_life/domain/game/engine/university_catalog.dart';
import 'package:brass_life/domain/game/models/game_enums.dart';
import 'package:brass_life/domain/game/models/game_state.dart';
import 'package:brass_life/domain/services/world_generation/world_generator.dart';
import 'package:flutter_test/flutter_test.dart';

/// 6 年間プレイ後の状態のハッシュ（回帰検知・VM と Web の一致確認用）。
const goldenLife = '4f345d59';

void main() {
  late World world;
  late GameContext ctx;
  late TimeManager tm;

  /// 6 年間を方針どおりに最後まで遊ぶ（イベントは既定の選択で解決）。
  GameState playLife(MonthlyPolicy policy) {
    var s = tm.newGame(world).copyWith(policy: policy);
    for (var i = 0; i < 2000 && s.stage != GameStage.finished; i++) {
      s = s.pending != null
          ? tm.autoResolve(s)
          : tm.submitAction(s, tm.actionForPolicy(s));
    }
    while (s.pending != null) {
      s = tm.autoResolve(s);
    }
    return s;
  }

  late GameState practiceLife;
  late GameState studyLife;

  setUpAll(() {
    world = const WorldGenerator().generate(SeedCode.seedFromInput('TEST'));
    ctx = GameContext(world);
    tm = TimeManager(ctx);
    practiceLife = playLife(MonthlyPolicy.practiceFocus);
    studyLife = playLife(MonthlyPolicy.studyFocus);
  });

  test('6 年間を完走し、進路（大学・音大・浪人のいずれか）が実績に残る', () {
    for (final s in [practiceLife, studyLife]) {
      expect(s.stage, GameStage.finished);
      expect(s.schoolHistory.length, 2);
      expect(
        s.achievements.where(
          (a) => a.kind.startsWith('univ') || a.kind == 'ronin',
        ),
        hasLength(1),
      );
      expect(s.memories.any((m) => m.reasonKey == 'graduated_high'), isTrue);
      // 6 年分の定期テストと評定
      expect(s.player.termGrades.length, 18);
    }
  });

  test('エンディング: 称号・エピローグ・思い出・まとめが生成される', () {
    final e = EndingAnalyzer(ctx).analyze(practiceLife);
    expect(e.title, isNotEmpty);
    expect(e.titleReason, isNotEmpty);
    expect(e.epilogue.length, greaterThanOrEqualTo(4));
    expect(e.epilogue.join(), contains(practiceLife.player.fullName));
    expect(e.highlights, isNotEmpty);
    expect(e.stats.map((x) => x.$1), contains('最高成績'));
  });

  test('プレイスタイルが違えばエンディングの中身（数値・称号候補）が変わる', () {
    final a = EndingAnalyzer(ctx).analyze(practiceLife);
    final b = EndingAnalyzer(ctx).analyze(studyLife);
    expect(practiceLife.player.skill, greaterThan(studyLife.player.skill));
    expect(
      studyLife.player.academic,
      greaterThan(practiceLife.player.academic),
    );
    expect(
      a.title != b.title || a.stats.toString() != b.stats.toString(),
      isTrue,
    );
  });

  test('決定論: 同じ方針なら 6 年後のエンディングまで完全一致', () {
    final again = playLife(MonthlyPolicy.practiceFocus);
    expect(again, practiceLife);
    expect(
      EndingAnalyzer(ctx).analyze(again).epilogue,
      EndingAnalyzer(ctx).analyze(practiceLife).epilogue,
    );
  });

  test('大学の一覧は Seed から決定論的に生成され、音大を 2 校含む', () {
    final a = UniversityCatalog.generate(
      world.seed,
      world.region.prefectureName,
    );
    final b = UniversityCatalog.generate(
      world.seed,
      world.region.prefectureName,
    );
    expect(a.map((u) => u.name), b.map((u) => u.name));
    expect(a.length, 14);
    expect(a.where((u) => u.isMusic).length, 2);
    expect({for (final u in a) u.id}.length, 14);
  });

  test('大学の出願は 3 校まで', () {
    final unis = EntranceExamEngine(ctx).universities();
    expect(
      EntranceExamEngine.validateUniversityApplications(unis.take(4).toList()),
      isNotNull,
    );
    expect(
      EntranceExamEngine.validateUniversityApplications(unis.take(3).toList()),
      isNull,
    );
    expect(
      EntranceExamEngine.validateUniversityApplications(const []),
      isNotNull,
    );
  });

  test('ゴールデン: 6 年間（練習漬け）の最終状態のフィンガープリントが VM と Web で一致する', () {
    final json = jsonEncode(practiceLife.toJson());
    final fp = SeedHasher.fnv1a32(json).toRadixString(16);
    // ignore: avoid_print
    print('life fingerprint(TEST, practiceFocus) = $fp (${json.length} chars)');
    expect(fp, goldenLife);
  });
}
