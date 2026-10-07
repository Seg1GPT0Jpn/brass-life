import 'package:brass_life/core/rng/seed_code.dart';
import 'package:brass_life/domain/entities/memory_tag.dart';
import 'package:brass_life/domain/entities/world.dart';
import 'package:brass_life/domain/game/engine/game_context.dart';
import 'package:brass_life/domain/game/engine/performance.dart';
import 'package:brass_life/domain/game/engine/relations.dart';
import 'package:brass_life/domain/game/engine/time_manager.dart';
import 'package:brass_life/domain/game/master/approach_cards.dart';
import 'package:brass_life/domain/game/models/candidacy.dart';
import 'package:brass_life/domain/game/models/game_enums.dart';
import 'package:brass_life/domain/game/models/game_state.dart';
import 'package:brass_life/domain/services/world_generation/world_generator.dart';
import 'package:brass_life/domain/value_objects/instrument.dart';
import 'package:brass_life/domain/value_objects/school_enums.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late World world;
  late GameContext ctx;
  late TimeManager tm;

  /// 指定の種類のイベントで止まるまで進める（他のイベントは既定の選択で解決）。
  GameState until(GameState s, PendingEventType type, {int maxWeeks = 160}) {
    var cur = s;
    for (var i = 0; i < maxWeeks * 3; i++) {
      if (cur.pending?.type == type) return cur;
      cur = cur.pending != null
          ? tm.autoResolve(cur, defaultWishes: [InstrumentType.trumpet])
          : tm.submitAction(cur, WeeklyAction.individualPractice);
    }
    fail('$type が発生しなかった');
  }

  // 部員数の多い学校（オーディションあり）と少ない学校の両方を試すため複数 Seed を使う。
  for (final seed in ['TEST', 'hello']) {
    group('Seed $seed', () {
      setUpAll(() {
        world = const WorldGenerator().generate(SeedCode.seedFromInput(seed));
        ctx = GameContext(world);
        tm = TimeManager(ctx);
      });

      test('6月にオーディション → メンバーは上限以内・ソリストはメンバーの中から', () {
        var s = until(tm.newGame(world), PendingEventType.audition);
        final d = ctx.calendar.dateOf(s.turn);
        expect((d.month, d.weekOfMonth), (6, 2));
        expect(tm.cardsOf(s).length, 3);
        s = tm.resolveAudition(s, tm.cardsOf(s).first).state;
        final limit = Performance.memberLimit(
          ctx.club(s).division,
          ctx.school(s).level,
        );
        expect(s.contestMembers.length, lessThanOrEqualTo(limit));
        expect(s.contestMembers, isNotEmpty);
        if (s.soloistId != null) {
          expect(s.contestMembers, contains(s.soloistId));
        }
        expect(s.contest?.nextStage, ContestStage.district);
      });

      test('コンクール → 結果が記憶・成績に残り、引退と幹部選出が行われる', () {
        var s = tm.newGame(world);
        // 1 年目を最後まで自動で進める
        while (ctx.calendar.dateOf(s.turn).academicYearIndex == 0) {
          s = s.pending != null
              ? tm.autoResolve(s, defaultWishes: [InstrumentType.trumpet])
              : tm.submitAction(s, WeeklyAction.individualPractice);
        }
        expect(s.clubHistory.length, 1);
        expect(s.achievements.any((a) => a.kind.startsWith('contest')), isTrue);
        expect(
          s.memories.any((m) => m.category == MemoryCategory.contestResult),
          isTrue,
        );
        // 3 年生は引退・卒業し、新しい代の役職が決まっている
        expect(s.roles.values, isNotEmpty);
        expect(s.memories.any((m) => m.reasonKey == 'appointed_role'), isTrue);
        expect(s.lastConcertYear, ctx.startYear);
      });

      test('2 年生の秋は幹部選出イベントでプレイヤーの意思を問われる', () {
        var s = tm.newGame(world);
        while (!(s.pending?.type == PendingEventType.executiveSelection &&
            s.player.grade == 2)) {
          s = s.pending != null
              ? tm.autoResolve(s, defaultWishes: [InstrumentType.trumpet])
              : tm.submitAction(s, WeeklyAction.partPractice);
          expect(s.player.grade, lessThanOrEqualTo(2));
        }
        final runFor = Candidacy.run(ClubRole.conductor, 3);
        final run = tm.resolveExecutive(s, runFor).state;
        final decline = tm.resolveExecutive(s, const Candidacy.decline()).state;
        // 辞退すれば幹部（パートリーダー以外）にはならない
        final declined = decline.roles[Relations.player];
        expect(declined == null || declined == ClubRole.partLeader, isTrue);
        // 立候補した場合は、役職に就くか「落選」の記憶が残る
        final role = run.roles[Relations.player];
        final lost = run.memories.any((m) => m.reasonKey == 'lost_role');
        expect(role != null || lost, isTrue);
        // 同じ選択は同じ結果
        expect(tm.resolveExecutive(s, runFor).state, run);
      });
    });
  }

  test('カードの選択で本番の結果（得点）が変わりうる', () {
    world = const WorldGenerator().generate(SeedCode.seedFromInput('hello'));
    ctx = GameContext(world);
    tm = TimeManager(ctx);
    final s = until(tm.newGame(world), PendingEventType.contest);
    final scores = {
      for (final c in tm.cardsOf(s))
        c: tm.resolveContest(s, c).state.contest!.results.last.score,
    };
    expect(scores.length, 3);
    // 同じカードなら同じ得点（決定論）
    final c = tm.cardsOf(s).first;
    expect(
      tm.resolveContest(s, c).state.contest!.results.last.score,
      scores[c],
    );
    expect(ApproachCard.values, containsAll(scores.keys));
  });
}
