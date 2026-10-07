import 'package:brass_life/core/rng/seed_code.dart';
import 'package:brass_life/domain/entities/world.dart';
import 'package:brass_life/domain/game/engine/entrance_exam_engine.dart';
import 'package:brass_life/domain/game/engine/game_context.dart';
import 'package:brass_life/domain/game/engine/relations.dart';
import 'package:brass_life/domain/game/engine/school_transition.dart';
import 'package:brass_life/domain/game/engine/time_manager.dart';
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
  late GameState atApplication;

  GameState until(GameState s, bool Function(GameState) done, {int max = 400}) {
    var cur = s;
    for (var i = 0; i < max * 3; i++) {
      if (done(cur)) return cur;
      cur = cur.pending != null
          ? tm.autoResolve(cur, defaultWishes: [InstrumentType.trumpet])
          : tm.submitAction(cur, tm.actionForPolicy(cur));
    }
    fail('条件を満たさなかった');
  }

  setUpAll(() {
    world = const WorldGenerator().generate(SeedCode.seedFromInput('TEST'));
    ctx = GameContext(world);
    tm = TimeManager(ctx);
    var s = tm.newGame(world).copyWith(policy: MonthlyPolicy.studyFocus);
    // 推薦は断り、一般入試の出願まで進める
    s = until(
      s,
      (s) =>
          s.pending?.type == PendingEventType.examApplication ||
          s.pending?.type == PendingEventType.recommendation,
    );
    if (s.pending?.type == PendingEventType.recommendation) {
      s = tm.resolveRecommendation(s, null).state;
      s = until(s, (s) => s.pending?.type == PendingEventType.examApplication);
    }
    atApplication = s;
  });

  test('中3の1月に出願イベントが発生する', () {
    final d = ctx.calendar.dateOf(atApplication.turn);
    expect(atApplication.player.grade, 3);
    expect((d.month, d.weekOfMonth), (1, 2));
    expect(atApplication.player.retired, isTrue);
  });

  test('出願の制約（私立 2 校・公立 1 校まで）', () {
    final engine = EntranceExamEngine(ctx);
    final privates = engine
        .highSchools()
        .where((t) => t.isPrivate)
        .take(3)
        .map((t) => t.id)
        .toList();
    expect(
      () => tm.resolveApplication(atApplication, privates),
      throwsArgumentError,
    );
    expect(
      () => tm.resolveApplication(atApplication, const []),
      throwsArgumentError,
    );
  });

  test('合格発表 → 卒業 → 高校入学で環境が再構築される', () {
    final engine = EntranceExamEngine(ctx);
    final apps = engine.autoApplications(atApplication);
    var s = tm.resolveApplication(atApplication, apps).state;
    final middleInstrument = s.player.instrument;
    final middleSchool = s.schoolId;
    final relationsBefore = s.relations;
    s = until(s, (s) => s.stage == GameStage.high);

    expect(s.schoolId, isNot(middleSchool));
    expect(ctx.index.schoolById[s.schoolId]!.level, SchoolLevel.high);
    expect(s.schoolHistory, [middleSchool, s.schoolId]);
    expect(s.exam, isNull);
    expect(s.player.grade, 1);
    expect(s.player.instrument, isNull);
    expect(s.player.previousInstrument, middleInstrument);
    expect(s.roles, isEmpty);
    expect(s.clubHistory, isEmpty);
    expect(s.achievements, isNotEmpty, reason: '実績は引き継ぐ');
    // 名簿は新しい学校の部員（と再会した中学の仲間）
    for (final id in s.roster) {
      final st = s.npcs[id]!;
      expect(st.active, isTrue);
      expect(st.grade, inInclusiveRange(1, 3));
    }
    // 中学時代の関係性は引き継がれる
    for (final e in relationsBefore.entries) {
      if (e.key.startsWith('${Relations.player}>')) {
        expect(
          s.relations.containsKey(e.key) || e.value.affection.abs() < 10,
          isTrue,
        );
      }
    }
    expect(s.memories.any((m) => m.reasonKey == 'entered_high'), isTrue);

    // 再会: 進学先がこの高校の中学の仲間は名簿に含まれる（在籍学年の範囲内なら）
    for (final e in s.npcDestinations.entries) {
      final (dest, year) = SchoolTransition.parseDestination(e.value);
      final grade = ctx.calendar.dateOf(s.turn).fiscalYear - year + 1;
      if (dest == s.schoolId &&
          grade >= 1 &&
          grade <= 3 &&
          !(s.npcs[e.key]?.quit ?? false)) {
        expect(s.roster, contains(e.key));
      }
    }

    // 高校でも楽器決定・ターン進行が続く
    s = until(s, (s) => s.pending?.type == PendingEventType.instrumentDecision);
    s = tm.resolveInstrumentDecision(s, [middleInstrument!]).state;
    expect(s.player.instrument, isNotNull);
    s = until(s, (s) => s.contest != null && s.contest!.nextStage == null);
    expect(s.clubHistory.length, 1);
  });

  test('決定論: 受験〜進学も同じ選択なら同じ結果', () {
    final apps = EntranceExamEngine(ctx).autoApplications(atApplication);
    GameState run() => until(
      tm.resolveApplication(atApplication, apps).state,
      (s) => s.stage == GameStage.high,
    );
    expect(run(), run());
  });

  test('部活推薦: 実績が十分なら強豪私立から打診があり、受ければ内定する', () {
    final engine = EntranceExamEngine(ctx);
    final strong = atApplication.copyWith(
      player: atApplication.player.copyWith(skill: 900),
      achievements: [
        ...atApplication.achievements,
        const Achievement(
          fiscalYear: 2028,
          schoolId: 'x',
          kind: 'contest',
          label: '全国大会 金賞',
          weight: 95,
        ),
      ],
    );
    final offers = engine.recommendationOffers(strong);
    final hasStrongPrivate = engine.highSchools().any(
      (t) =>
          t.isPrivate &&
          (t.clubTier == ClubTier.national || t.clubTier == ClubTier.block),
    );
    if (!hasStrongPrivate) return;
    expect(offers, isNotEmpty);
    var s = strong.copyWith(
      exam: EntranceExamState(
        kind: 'high',
        offers: [for (final o in offers) o.id],
      ),
      pending: PendingEvent(
        type: PendingEventType.recommendation,
        turn: strong.turn,
      ),
    );
    s = tm.resolveRecommendation(s, offers.first.id).state;
    expect(s.exam!.enrolled, offers.first.id);
    s = until(s, (s) => s.stage == GameStage.high);
    expect(s.schoolId, offers.first.id);
  });
}
