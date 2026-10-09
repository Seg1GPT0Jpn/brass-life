import 'package:brass_life/core/rng/seed_code.dart';
import 'package:brass_life/core/rng/seed_hasher.dart';
import 'package:brass_life/domain/game/engine/game_context.dart';
import 'package:brass_life/domain/game/engine/piece_fit.dart';
import 'package:brass_life/domain/game/engine/time_manager.dart';
import 'package:brass_life/domain/game/models/game_enums.dart';
import 'package:brass_life/domain/game/models/game_state.dart';
import 'package:brass_life/domain/game/models/piece.dart';
import 'package:brass_life/domain/services/world_generation/world_generator.dart';
import 'package:brass_life/domain/value_objects/instrument.dart';
import 'package:flutter_test/flutter_test.dart';

/// 決定論的状態テスト（Deterministic State Test）。
///
/// 固定の WorldSeed（"TEST"）でゲームを始め、
/// 1 週目: 曲練 → 楽器決定（トランペット希望）→ 2 週目: パート練習
/// を行った後の部（Club）のパラメータと NPC のステータスを、具体的な値で固定する。
/// 値が変わったら、ゲームの挙動が変わったということ（意図した変更なら、ここを更新する）。
void main() {
  /// 毎回、世界の生成から独立にやり直す。
  ({GameContext ctx, GameState state}) play() {
    final world = const WorldGenerator().generate(
      SeedCode.seedFromInput('TEST'),
    );
    final ctx = GameContext(world);
    final tm = TimeManager(ctx);
    var s = tm.newGame(world);
    s = tm.submitAction(s, WeeklyAction.individualPractice);
    s = tm.resolveInstrumentDecision(s, [InstrumentType.trumpet]).state;
    s = tm.submitAction(s, WeeklyAction.partPractice);
    return (ctx: ctx, state: s);
  }

  /// NPC 全員のステータスを ID 順に並べた文字列のハッシュ。
  int npcHash(GameContext ctx, GameState s) {
    final ms = ctx.activeMembers(s).toList()
      ..sort((a, b) => a.id.compareTo(b.id));
    return SeedHasher.fnv1a32(
      ms
          .map(
            (m) =>
                '${m.id}|${m.grade}|${m.instrument?.name}|${m.skill}|'
                '${m.motivation}|${m.stress}|${m.lowMotivationWeeks}|'
                '${m.lastBehavior}|${m.lastTargetId}',
          )
          .join(';'),
    );
  }

  test('部（Club）のパラメータが毎回まったく同じ値になる', () {
    final (:ctx, state: s) = play();
    expect(s.turn, 2);
    expect(s.pending, isNull);
    final fit = PieceFit(ctx);
    final stats = fit.bandStats(s, fit.candidates(s));
    expect(stats, {
      PieceStat.technique: 45,
      PieceStat.fundamentals: 52,
      PieceStat.expression: 50,
      PieceStat.rhythm: 56,
      PieceStat.groove: 57,
      PieceStat.pitch: 53,
      PieceStat.stamina: 50,
      PieceStat.tension: 59,
      PieceStat.charisma: 80,
      PieceStat.ensemble: 50,
      PieceStat.conductorSync: 67,
      PieceStat.brass: 51,
      PieceStat.woodwind: 43,
      PieceStat.woodwindTech: 47,
      PieceStat.highWoodwind: 40,
      PieceStat.percussion: 34,
      PieceStat.midLow: 49,
      PieceStat.lowRange: 67,
    });
    expect(
      s.rehearsal,
      const RehearsalMemory(
        fiscalYear: 2026,
        dynamicsSum: 227,
        expressionSum: 215,
        sessions: 4,
      ),
    );
    expect(s.condition, const ClubCondition());
  });

  test('NPC とプレイヤーのステータスが毎回まったく同じ値になる', () {
    final (:ctx, state: s) = play();
    final ms = ctx.activeMembers(s).toList()
      ..sort((a, b) => a.id.compareTo(b.id));
    expect(ms, hasLength(60));
    String row(NpcState m) =>
        '${m.instrument?.name} skill=${m.skill} mot=${m.motivation} '
        'str=${m.stress} beh=${m.lastBehavior} tgt=${m.lastTargetId}';
    expect(
      row(ms[0]),
      'clarinet skill=54 mot=42 str=17 beh=compete tgt=npc_m22_g3_09',
    );
    expect(row(ms[1]), 'clarinet skill=55 mot=47 str=18 beh=idle tgt=null');
    expect(
      row(ms[2]),
      'percussion skill=64 mot=71 str=9 beh=practiceHard tgt=null',
    );
    expect(row(ms[3]), 'flute skill=63 mot=63 str=21 beh=idle tgt=null');
    expect(ms.fold(0, (a, m) => a + m.skill), 13842);
    expect(ms.fold(0, (a, m) => a + m.motivation), 3573);
    expect(ms.fold(0, (a, m) => a + m.stress), 768);
    expect(npcHash(ctx, s), kNpcHash);
    final p = s.player;
    expect(
      (p.instrument, p.skill, p.musicality, p.fatigue, p.stress, p.motivation),
      (InstrumentType.trumpet, 66, 102, 25, 11, 58),
    );
  });

  test('何度やり直しても、状態全体（GameState）が完全に一致する', () {
    final a = play().state;
    for (var i = 0; i < 3; i++) {
      final b = play().state;
      expect(b, a);
      expect(b.toJson(), a.toJson());
    }
  });

  test('選択が 1 つ違えば、状態は変わる（固定値が意味を持つことの確認）', () {
    final world = const WorldGenerator().generate(
      SeedCode.seedFromInput('TEST'),
    );
    final ctx = GameContext(world);
    final tm = TimeManager(ctx);
    var s = tm.newGame(world);
    s = tm.submitAction(s, WeeklyAction.individualPractice);
    s = tm.resolveInstrumentDecision(s, [InstrumentType.trumpet]).state;
    final other = tm.submitAction(s, WeeklyAction.basics);
    expect(other, isNot(play().state));
    expect(other.rehearsal.dynamicsSum, isNot(227));
  });
}

/// NPC 全員のステータス（ID 順の文字列）の FNV-1a ハッシュ。
const kNpcHash = 3003308181;
