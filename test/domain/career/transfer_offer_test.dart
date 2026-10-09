import 'package:brass_life/core/rng/seed_code.dart';
import 'package:brass_life/domain/career/career_engine.dart';
import 'package:brass_life/domain/career/game_mode.dart';
import 'package:brass_life/domain/career/transfer_offer.dart';
import 'package:brass_life/domain/entities/world.dart';
import 'package:brass_life/domain/game/engine/game_context.dart';
import 'package:brass_life/domain/game/engine/time_manager.dart';
import 'package:brass_life/domain/game/models/game_enums.dart';
import 'package:brass_life/domain/game/models/game_state.dart';
import 'package:brass_life/domain/services/world_generation/world_generator.dart';
import 'package:flutter_test/flutter_test.dart';

/// 顧問の異動オファー。
void main() {
  late World world;
  late GameContext ctx;
  late TimeManager tm;
  late GameState ended;

  GameState playTerm(GameState s) {
    var cur = s;
    for (var i = 0; i < 400 && cur.stage != GameStage.finished; i++) {
      cur = cur.pending != null
          ? tm.autoResolve(cur)
          : tm.submitCareerCommand(cur, CareerEngine(ctx).autoCommand(cur));
    }
    return cur;
  }

  setUpAll(() {
    world = const WorldGenerator().generate(SeedCode.seedFromInput('TEST'));
    ctx = GameContext(world);
    tm = TimeManager(ctx);
    ended = playTerm(
      tm.newCareerGame(
        world,
        GameMode.teacher,
        schoolId: world.player.schoolId,
        familyName: '音羽',
        givenName: '奏',
      ),
    );
  });

  test('任期の終わりにオファーが届き、今の学校・務めた学校は含まれない', () {
    final offers = ended.career!.transferOffers;
    expect(offers, isNotEmpty);
    for (final o in offers) {
      expect(o.schoolId, isNot(ended.schoolId));
      expect(['promotion', 'rebuild'], contains(o.kind));
      expect(o.reason, isNotEmpty);
    }
    expect(offers.map((o) => o.schoolId).toSet(), hasLength(offers.length));
  });

  test('栄転はより強い部、立て直しはより弱い部（最上位・最下位は同格も可）', () {
    final engine = TransferOfferEngine(ctx);
    final rank = ctx.club(ended).tier.rank;
    for (final o in engine.offers(ended)) {
      final r = ctx.index.clubOfSchool(o.schoolId).tier.rank;
      if (o.kind == 'promotion') {
        expect(r, greaterThanOrEqualTo(rank));
      } else {
        expect(r, lessThanOrEqualTo(rank));
      }
    }
  });

  test('実績が高いほど栄転が多い', () {
    final engine = TransferOfferEngine(ctx);
    // 実績を高く/低くした状態を作る
    final good = ended.copyWith(
      achievements: [
        ...ended.achievements,
        Achievement(
          fiscalYear: ctx.calendar.dateOf(ended.turn).fiscalYear - 1,
          schoolId: ended.schoolId,
          kind: 'contest_career',
          label: '全国大会 金賞',
          weight: 95,
        ),
      ],
    );
    final bad = ended.copyWith(
      achievements: [
        for (final a in ended.achievements)
          if (a.kind != 'contest_career') a,
      ],
    );
    int promos(GameState s) =>
        engine.offers(s).where((o) => o.kind == 'promotion').length;
    expect(engine.score(good), greaterThan(engine.score(bad)));
    expect(promos(good), greaterThanOrEqualTo(promos(bad)));
  });

  test('決定論: 同じ状態なら同じオファー', () {
    final a = TransferOfferEngine(ctx).offers(ended);
    final b = TransferOfferEngine(ctx).offers(ended);
    expect(a, b);
  });

  test('オファーを受けると、暦の続きから新しい学校で次の任期が始まり、最後まで遊べる', () {
    final offer = ended.career!.transferOffers.first;
    final next = tm.acceptTransfer(ended, offer.schoolId);
    expect(next.stage, isNot(GameStage.finished));
    expect(next.schoolId, offer.schoolId);
    expect(next.turn, ended.turn);
    expect(next.career!.servedSchoolIds, [ended.schoolId, offer.schoolId]);
    expect(next.roster, isNotEmpty);
    expect(
      ctx.activeMembers(next).every((m) => next.roster.contains(m.id)),
      isTrue,
    );
    // オファーにない学校は選べない
    expect(() => tm.acceptTransfer(ended, ended.schoolId), throwsArgumentError);

    final second = playTerm(next);
    expect(second.stage, GameStage.finished);
    expect(ctx.calendar.dateOf(second.turn).academicYearIndex, 6);
    // 暦（6 年度）を使い切ったので、それ以上のオファーはない
    expect(second.career!.transferOffers, isEmpty);
  });

  test('顧問以外にはオファーはない', () {
    final alumni = tm.newCareerGame(
      world,
      GameMode.alumni,
      schoolId: world.player.schoolId,
      familyName: 'a',
      givenName: 'b',
    );
    expect(TransferOfferEngine(ctx).offers(alumni), isEmpty);
  });
}
