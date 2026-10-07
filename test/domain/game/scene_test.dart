import 'package:brass_life/core/rng/seed_code.dart';
import 'package:brass_life/domain/entities/world.dart';
import 'package:brass_life/domain/game/engine/game_context.dart';
import 'package:brass_life/domain/game/engine/interaction_rules.dart';
import 'package:brass_life/domain/game/engine/relations.dart';
import 'package:brass_life/domain/game/engine/time_manager.dart';
import 'package:brass_life/domain/game/models/game_enums.dart';
import 'package:brass_life/domain/game/models/game_state.dart';
import 'package:brass_life/domain/game/scene/club_scene_service.dart';
import 'package:brass_life/domain/game/scene/scene_models.dart';
import 'package:brass_life/domain/services/world_generation/world_generator.dart';
import 'package:brass_life/domain/value_objects/instrument.dart';
import 'package:flutter_test/flutter_test.dart';

/// ジオラマ（場所と NPC の配置）と、空間 UI から選ぶ行動のテスト。
void main() {
  late World world;
  late GameContext ctx;
  late TimeManager tm;
  late ClubSceneService scenes;
  late InteractionRules rules;

  setUpAll(() {
    world = const WorldGenerator().generate(SeedCode.seedFromInput('TEST'));
    ctx = GameContext(world);
    tm = TimeManager(ctx);
    scenes = ClubSceneService(ctx);
    rules = InteractionRules(ctx);
  });

  GameState started() {
    var s = tm.newGame(world);
    s = tm.submitAction(s, WeeklyAction.individualPractice);
    s = tm.resolveInstrumentDecision(s, [InstrumentType.trumpet]).state;
    // 何週か過ごして NPC に自律行動の履歴をつける
    for (var i = 0; i < 6; i++) {
      s = s.pending != null
          ? tm.autoResolve(s)
          : tm.submitAction(s, WeeklyAction.partPractice);
    }
    while (s.pending != null) {
      s = tm.autoResolve(s);
    }
    return s;
  }

  group('ジオラマ', () {
    test('部員・自分・顧問がちょうど 1 回ずつ、場所の中に置かれる', () {
      final s = started();
      final scene = scenes.compose(s);
      final ids = scene.actors.map((a) => a.id).toList();
      expect(ids.toSet().length, ids.length);
      final expected = {
        for (final m in ctx.activeMembers(s)) m.id,
        Relations.player,
        ctx.club(s).advisorId,
      };
      expect(ids.toSet(), expected);
      for (final a in scene.actors) {
        final l = a.location;
        expect(a.x, inInclusiveRange(l.left, l.left + l.width), reason: a.id);
        expect(a.y, inInclusiveRange(l.top, l.top + l.height), reason: a.id);
      }
      expect(scene.actors.where((a) => a.isPlayer).length, 1);
      expect(
        scene.actors.singleWhere((a) => a.isAdvisor).activity,
        ActorActivity.conducting,
      );
    });

    test('配置は NPC の状態で決まる（サボり → 中庭、口論 → 廊下、二人組は同じ場所）', () {
      var s = started();
      final members = ctx.activeMembers(s).toList();
      final a = members[0];
      final b = members[1];
      final c = members[2];
      final npcs = {...s.npcs};
      npcs[a.id] = a.copyWith(lastBehavior: 'slackOff', lastTargetId: null);
      npcs[b.id] = b.copyWith(lastBehavior: 'quarrel', lastTargetId: c.id);
      npcs[c.id] = c.copyWith(lastBehavior: 'idle', lastTargetId: null);
      s = s.copyWith(npcs: npcs);
      final scene = scenes.compose(s);
      SceneActor of(String id) => scene.actors.singleWhere((x) => x.id == id);
      expect(of(a.id).location, SceneLocation.courtyard);
      expect(of(a.id).activity, ActorActivity.slacking);
      expect(of(b.id).location, SceneLocation.hallway);
      expect(of(b.id).activity, ActorActivity.arguing);
      expect(of(c.id).location, SceneLocation.hallway);
      expect(of(c.id).partnerId, b.id);
      expect(of(c.id).mood, ActorMood.angry);
    });

    test('やる気の高い待機中の部員はパート室、低いと廊下', () {
      var s = started();
      final m = ctx.activeMembers(s).firstWhere((m) => m.instrument != null);
      final hi = {
        ...s.npcs,
        m.id: m.copyWith(lastBehavior: 'idle', motivation: 90),
      };
      final lo = {
        ...s.npcs,
        m.id: m.copyWith(lastBehavior: 'idle', motivation: 10),
      };
      final part = ClubSceneService.partRoomOf(m.instrument);
      SceneActor of(Map<String, NpcState> npcs) => scenes
          .compose(s = s.copyWith(npcs: npcs))
          .actors
          .singleWhere((x) => x.id == m.id);
      expect(of(hi).location, part);
      expect(of(lo).location, SceneLocation.hallway);
    });

    test('自分は直近の行動の場所にいる', () {
      final s = started();
      final scene0 = scenes.compose(tm.submitAction(s, WeeklyAction.study));
      expect(
        scene0.actors.singleWhere((a) => a.isPlayer).location,
        SceneLocation.library,
      );
      final s2 = tm.submitAction(s, WeeklyAction.maintenance);
      expect(
        scenes.compose(s2).actors.singleWhere((a) => a.isPlayer).location,
        SceneLocation.storage,
      );
    });

    test('季節と時間帯: 居残りの後と冬は夕暮れ、環境音も変わる', () {
      final s = started();
      expect(
        scenes.compose(s).season,
        Season.ofMonth(ctx.calendar.dateOf(s.turn).month),
      );
      expect(scenes.compose(s).time, DayPhase.afterSchool);
      final late = tm.submitAction(s, WeeklyAction.extraPractice);
      final scene = scenes.compose(late);
      expect(scene.time, DayPhase.dusk);
      expect(scene.ambience.id, '${scene.season.name}_dusk');
      expect(Ambience.of(Season.summer, DayPhase.afterSchool).id, 'summer');
    });

    test('決定論: 同じ状態からは同じジオラマ', () {
      final s = started();
      String dump(ClubScene c) => [
        for (final a in c.actors)
          '${a.id}@${a.location.name}:${a.activity.name}:${a.x},${a.y}',
      ].join('|');
      expect(dump(scenes.compose(s)), dump(scenes.compose(s)));
      expect(dump(scenes.compose(s)), dump(scenes.compose(started())));
    });
  });

  group('空間 UI の行動', () {
    test('自分のメニューは 基礎練・曲練・メンテ・居残り', () {
      final s = started();
      expect(rules.forSelf(s).map((o) => o.action), [
        WeeklyAction.basics,
        WeeklyAction.individualPractice,
        WeeklyAction.maintenance,
        WeeklyAction.extraPractice,
      ]);
      expect(rules.forSelf(s).every((o) => o.enabled), isTrue);
    });

    test('楽器が決まる前はメンテ・相手との練習はできない', () {
      final s = tm.newGame(world);
      final m = ctx.activeMembers(s).first;
      expect(
        rules.unavailableReason(s, WeeklyAction.maintenance, null),
        isNotNull,
      );
      expect(
        rules.unavailableReason(s, WeeklyAction.practiceWith, m.id),
        isNotNull,
      );
      expect(rules.unavailableReason(s, WeeklyAction.chat, m.id), isNull);
    });

    test('「教わる」は自分より十分上手い同系統の相手、「指導する」はその逆', () {
      var s = started();
      final same = ctx
          .activeMembers(s)
          .where((m) => m.instrument?.family == InstrumentFamily.brass)
          .first;
      final npcs = {...s.npcs};
      npcs[same.id] = same.copyWith(skill: s.player.skill + 200);
      s = s.copyWith(npcs: npcs);
      expect(
        rules.unavailableReason(s, WeeklyAction.learnFrom, same.id),
        isNull,
      );
      expect(
        rules.unavailableReason(s, WeeklyAction.teach, same.id),
        isNotNull,
      );
      npcs[same.id] = same.copyWith(skill: 0);
      s = s.copyWith(
        npcs: npcs,
        player: s.player.copyWith(skill: InteractionRules.teachGap + 10),
      );
      expect(rules.unavailableReason(s, WeeklyAction.teach, same.id), isNull);
      expect(
        rules.unavailableReason(s, WeeklyAction.learnFrom, same.id),
        isNotNull,
      );
    });

    test('相手のいない／不正な相手の行動は受け付けない', () {
      final s = started();
      expect(() => tm.submitAction(s, WeeklyAction.chat), throwsArgumentError);
      expect(
        () => tm.submitAction(s, WeeklyAction.chat, targetId: 'nobody'),
        throwsArgumentError,
      );
      final m = ctx.activeMembers(s).first;
      expect(
        () => tm.submitAction(s, WeeklyAction.basics, targetId: m.id),
        throwsArgumentError,
      );
    });

    test('「一緒に練習」で相手との関係が深まり、記憶に残る', () {
      final s = started();
      final m = ctx.activeMembers(s).firstWhere((m) => m.instrument != null);
      final before = Relations.get(s, m.id, Relations.player);
      final after = tm.submitAction(
        s,
        WeeklyAction.practiceWith,
        targetId: m.id,
      );
      final rel = Relations.get(after, m.id, Relations.player);
      expect(rel.trust, greaterThan(before.trust));
      expect(after.choices.last, endsWith('practiceWith:${m.id}'));
      final scene = scenes.compose(after);
      final me = scene.actors.singleWhere((a) => a.isPlayer);
      expect(me.partnerId, m.id);
    });

    test('「雑談」の相手が違えば、その後の関係が変わる（決定論は保つ）', () {
      final s = started();
      final ms = ctx.activeMembers(s).toList();
      final a1 = tm.submitAction(s, WeeklyAction.chat, targetId: ms[0].id);
      final a2 = tm.submitAction(s, WeeklyAction.chat, targetId: ms[0].id);
      final b = tm.submitAction(s, WeeklyAction.chat, targetId: ms[1].id);
      expect(a1, a2);
      expect(a1 == b, isFalse);
      expect(
        Relations.get(a1, ms[0].id, Relations.player).affection,
        greaterThan(Relations.get(b, ms[0].id, Relations.player).affection),
      );
    });
  });
}
