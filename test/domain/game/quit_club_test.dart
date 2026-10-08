import 'package:brass_life/core/rng/seed_code.dart';
import 'package:brass_life/domain/entities/world.dart';
import 'package:brass_life/domain/game/engine/club_membership.dart';
import 'package:brass_life/domain/game/engine/ending_analyzer.dart';
import 'package:brass_life/domain/game/engine/game_context.dart';
import 'package:brass_life/domain/game/engine/relations.dart';
import 'package:brass_life/domain/game/engine/time_manager.dart';
import 'package:brass_life/domain/game/models/game_enums.dart';
import 'package:brass_life/domain/game/models/game_state.dart';
import 'package:brass_life/domain/services/world_generation/world_generator.dart';
import 'package:brass_life/domain/value_objects/instrument.dart';
import 'package:flutter_test/flutter_test.dart';

/// 退部と再入部。
void main() {
  late World world;
  late GameContext ctx;
  late TimeManager tm;
  late GameState inClub;

  setUpAll(() {
    world = const WorldGenerator().generate(SeedCode.seedFromInput('TEST'));
    ctx = GameContext(world);
    tm = TimeManager(ctx);
    var s = tm.newGame(world);
    s = tm.submitAction(s, WeeklyAction.individualPractice);
    s = tm.resolveInstrumentDecision(s, [InstrumentType.trumpet]).state;
    for (var i = 0; i < 4; i++) {
      s = tm.submitAction(s, WeeklyAction.partPractice);
      while (s.pending != null) {
        s = tm.autoResolve(s);
      }
    }
    inClub = s;
  });

  GameState settle(GameState s) {
    var cur = s;
    while (cur.pending != null) {
      cur = tm.autoResolve(cur);
    }
    return cur;
  }

  test('楽器が決まる前やイベント中は退部できない', () {
    final start = tm.newGame(world);
    expect(ClubMembership(ctx).quitUnavailableReason(start), isNotNull);
    expect(() => tm.quitClub(start, QuitReason.study), throwsStateError);
  });

  test('退部: 部活から外れ、信頼が下がり、ストレスは軽くなる（週は進まない）', () {
    final r = tm.quitClub(inClub, QuitReason.burnout);
    final s = r.state;
    expect(s.turn, inClub.turn);
    expect(s.player.quitClub, isTrue);
    expect(s.player.inClub, isFalse);
    expect(s.player.quitCount, 1);
    expect(s.player.stress, lessThanOrEqualTo(inClub.player.stress));
    expect(s.player.advisorTrust, lessThan(inClub.player.advisorTrust));
    expect(s.player.heartache, greaterThan(inClub.player.heartache));
    expect(s.roles.containsKey(Relations.player), isFalse);
    expect(s.contestMembers, isNot(contains(Relations.player)));
    final m = ctx.activeMembers(inClub).first;
    expect(
      Relations.get(s, m.id, Relations.player).trust,
      lessThan(Relations.get(inClub, m.id, Relations.player).trust),
    );
    expect(s.memories.any((x) => x.reasonKey == 'player_quit_club'), isTrue);
    // 同じ選択は同じ結果
    expect(tm.quitClub(inClub, QuitReason.burnout).state, s);
  });

  test('退部中は部の練習ができず、方針で進めても自主練になる', () {
    final s = tm.quitClub(inClub, QuitReason.study).state;
    expect(
      () => tm.submitAction(s, WeeklyAction.partPractice),
      throwsArgumentError,
    );
    expect(
      () => tm.submitAction(s, WeeklyAction.ensemble),
      throwsArgumentError,
    );
    final m = ctx.activeMembers(s).first;
    // 雑談は学校の友達としてできる
    tm.submitAction(s, WeeklyAction.chat, targetId: m.id);
    // 月の方針（練習漬け）でも止まらずに進む
    final later = tm.skipMonth(
      s.copyWith(policy: MonthlyPolicy.practiceFocus),
      MonthlyPolicy.practiceFocus,
    );
    expect(later.turn, greaterThan(s.turn));
    expect(later.player.quitClub, isTrue);
  });

  test('退部中はオーディション・コンクールに出ない', () {
    var s = tm.quitClub(inClub, QuitReason.otherPath).state;
    // 夏まで進める（オーディションは入力待ちにならない）
    for (var i = 0; i < 30; i++) {
      s = settle(s);
      expect(s.pending?.type, isNot(PendingEventType.audition));
      expect(s.pending?.type, isNot(PendingEventType.contest));
      s = tm.submitAction(s, WeeklyAction.study);
    }
    expect(s.contestMembers, isNot(contains(Relations.player)));
  });

  test('練習しない週は腕が鈍る', () {
    var s = tm.quitClub(inClub, QuitReason.study).state;
    s = s.copyWith(player: s.player.copyWith(skill: 400));
    final skill = s.player.skill;
    for (var i = 0; i < 4; i++) {
      s = settle(tm.submitAction(s, WeeklyAction.study));
    }
    expect(s.player.skill, lessThan(skill));
  });

  test('再入部: 部に戻れる。2 回目以降は周りの目が冷たい', () {
    final quit1 = tm.quitClub(inClub, QuitReason.burnout).state;
    final back1 = tm.rejoinClub(quit1).state;
    expect(back1.player.inClub, isTrue);
    expect(back1.memories.any((m) => m.reasonKey == 'rejoined_club'), isTrue);
    tm.submitAction(back1, WeeklyAction.partPractice);

    final quit2 = tm.quitClub(back1, QuitReason.burnout).state;
    final m = ctx.activeMembers(inClub).first;
    final drop1 =
        Relations.get(inClub, m.id, Relations.player).trust -
        Relations.get(quit1, m.id, Relations.player).trust;
    final drop2 =
        Relations.get(back1, m.id, Relations.player).trust -
        Relations.get(quit2, m.id, Relations.player).trust;
    expect(drop2, greaterThan(drop1));
    expect(quit2.player.quitCount, 2);
    expect(() => tm.rejoinClub(inClub), throwsStateError);
  });

  test('退部したまま 6 年間を終えると、それに応じた称号の候補になる', () {
    var s = tm.quitClub(inClub, QuitReason.otherPath).state;
    for (var i = 0; i < 2000 && s.stage != GameStage.finished; i++) {
      s = s.pending != null
          ? tm.autoResolve(s)
          : tm.submitAction(s, tm.actionForPolicy(s));
      // 高校に進むと新しい部に入るので、高校でも辞める
      if (s.pending == null &&
          s.stage == GameStage.high &&
          !s.player.quitClub &&
          ClubMembership(ctx).quitUnavailableReason(s) == null) {
        s = tm.quitClub(s, QuitReason.otherPath).state;
      }
    }
    s = settle(s);
    expect(s.player.quitClub, isTrue);
    final ending = EndingAnalyzer(ctx).analyze(s);
    expect([ending.title, ...ending.otherTitles], contains('もうひとつの青春'));
  });
}
