import 'package:brass_life/core/rng/seed_code.dart';
import 'package:brass_life/domain/game/conducting/conducting.dart';
import 'package:brass_life/domain/game/engine/game_context.dart';
import 'package:brass_life/domain/game/engine/practice_bgm.dart';
import 'package:brass_life/domain/game/engine/time_manager.dart';
import 'package:brass_life/domain/game/master/set_pieces.dart';
import 'package:brass_life/domain/game/models/game_enums.dart';
import 'package:brass_life/domain/game/models/piece.dart';
import 'package:brass_life/domain/services/world_generation/world_generator.dart';
import 'package:brass_life/domain/value_objects/instrument.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const strong = ConductingParams(stamina: 90, technique: 90, cohesion: 90);
  const weak = ConductingParams(stamina: 40, technique: 40, cohesion: 40);
  ConductingInput at(int dyn, int expr) =>
      ConductingInput(atMs: 0, dynamics: dyn, expression: expr);

  group('指揮者ミニゲームの判定', () {
    test('無理のない指示は倍率 1.0', () {
      final j = ConductingJudge.judge(weak, at(50, 50));
      expect(j.multiplierPermille, 1000);
      expect(j.verdict, ConductingVerdict.steady);
    });

    test('地力があれば限界突破のフォルテは会心（プラス倍率）', () {
      final j = ConductingJudge.judge(strong, at(95, 50));
      expect(j.verdict, ConductingVerdict.brilliant);
      expect(j.multiplierPermille, greaterThan(1000));
    });

    test('スタミナが足りないフォルテは崩壊（マイナス倍率）', () {
      final j = ConductingJudge.judge(weak, at(95, 50));
      expect(j.verdict, ConductingVerdict.collapse);
      expect(j.multiplierPermille, lessThan(1000));
      expect(j.reason, contains('スタミナ'));
    });

    test('ピアニッシモは技術、大胆な表現は団結を求める', () {
      expect(
        ConductingJudge.judge(
          const ConductingParams(stamina: 90, technique: 40, cohesion: 90),
          at(5, 50),
        ).reason,
        contains('技術'),
      );
      expect(
        ConductingJudge.judge(
          const ConductingParams(stamina: 90, technique: 90, cohesion: 40),
          at(50, 100),
        ).reason,
        contains('団結'),
      );
    });

    test('倍率は 0.5〜1.3 倍に収まる', () {
      for (var d = 0; d <= 100; d += 5) {
        for (var e = 0; e <= 100; e += 5) {
          for (final p in [strong, weak]) {
            final m = ConductingJudge.judge(p, at(d, e)).multiplierPermille;
            expect(m, inInclusiveRange(500, 1300));
          }
        }
      }
    });

    test('1 曲のセッション: 平均倍率・崩壊回数・コンクール補正', () {
      final piece = SetPieces.byYear(1).first;
      var s = ConductingSession(piece: piece, params: weak);
      s = s.record(at(50, 50)).record(at(100, 50)).record(at(100, 100));
      expect(s.judgements, hasLength(3));
      expect(s.collapses, 2);
      expect(s.totalPermille, lessThan(1000));
      expect(s.contestBonus, lessThan(0));
      var good = ConductingSession(piece: piece, params: strong);
      good = good.record(at(90, 80)).record(at(10, 60));
      expect(good.contestBonus, greaterThan(0));
    });

    test('部の見積もりから地力を作る', () {
      final p = ConductingParams.fromBandStats({
        PieceStat.stamina: 61,
        PieceStat.technique: 52,
        PieceStat.ensemble: 47,
      });
      expect((p.stamina, p.technique, p.cohesion), (61, 52, 47));
    });
  });

  test('練習 BGM: 合奏は頭から、パート練習は週ごとの区間を繰り返す', () {
    final world = const WorldGenerator().generate(
      SeedCode.seedFromInput('TEST'),
    );
    final ctx = GameContext(world);
    final tm = TimeManager(ctx);
    var s = tm.newGame(world);
    expect(PracticeBgm.cueFor(ctx, s, WeeklyAction.ensemble), isNull);
    while (s.setPieces.isEmpty) {
      s = s.pending != null
          ? tm.autoResolve(s, defaultWishes: [InstrumentType.trumpet])
          : tm.submitAction(s, WeeklyAction.partPractice);
    }
    final ens = PracticeBgm.cueFor(ctx, s, WeeklyAction.ensemble)!;
    expect(ens.startSeconds, 0);
    expect(ens.loop, isFalse);
    final part = PracticeBgm.cueFor(ctx, s, WeeklyAction.partPractice)!;
    expect(part.loop, isTrue);
    expect(part.startSeconds, (s.turn % 4) * 30);
    expect(part.piece.year, 1);
    expect(PracticeBgm.cueFor(ctx, s, WeeklyAction.study), isNull);
  });
}
