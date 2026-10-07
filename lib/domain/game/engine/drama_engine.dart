import '../../../core/rng/rng_stream.dart';
import '../../entities/memory_tag.dart';
import '../../value_objects/instrument.dart';
import '../../value_objects/personality.dart';
import '../../value_objects/school_enums.dart';
import '../../value_objects/relationship_vector.dart';
import '../master/behavior_table.dart';
import '../models/game_enums.dart';
import '../models/game_state.dart';
import 'game_context.dart';
import 'memory_writer.dart';
import 'relations.dart';

/// 部員 1 人分の、行動判定に必要な情報（NPC とプレイヤーを同じ形で扱う）。
class _Member {
  const _Member(
    this.id,
    this.grade,
    this.instrument,
    this.skill,
    this.motivation,
  );

  final String id;
  final int grade;
  final InstrumentType? instrument;
  final int skill;
  final int motivation;

  bool get isPlayer => id == Relations.player;
  InstrumentFamily? get family => instrument?.family;
}

/// Drama Engine: NPC の自律行動・関係性の変動・記憶の生成。
///
/// 毎週、在籍中の部員ひとりひとりについて
/// 1. 性格タグ・部の雰囲気・やる気・ストレスから行動の重みを計算し、1 つ選ぶ。
/// 2. 行動に応じて相手を選び（同パート・同学年・既存の関係を重視）、
///    関係性ベクトル（好感・信頼・ライバル）とやる気・熟練度を変化させる。
/// 3. 変化には必ず理由付きの MemoryTag を残す（「なぜ変わったか」を後から辿れる）。
///
/// 乱数: SimulationRng(turn, 'npc_autonomy', actor: NPC ID)。NPC ごとに独立。
/// プレイヤー行動の社会的効果: SimulationRng(turn, 'player_social', choice: 行動名)。
class DramaEngine {
  const DramaEngine(this.ctx);

  final GameContext ctx;

  ({GameState state, List<String> lines}) weekly(
    GameState s,
    WeeklyAction? playerAction,
  ) {
    final relations = Map.of(s.relations);
    final npcs = Map.of(s.npcs);
    var player = s.player;
    final mem = MemoryWriter(ctx, s);
    final playerLines = <String>[];
    final otherEvents = <(int, String)>[];
    final club = ctx.club(s);
    final advisorId = club.advisorId;
    final teaching = ctx.advisor(s).advisorProfile!.teachingSkill;

    String name(String id) =>
        id == Relations.player ? player.fullName : ctx.npc(s, id).fullName;

    List<_Member> members() => [
      for (final id in s.roster)
        if ((npcs[id]?.active ?? false) && !npcs[id]!.retired)
          _Member(
            id,
            npcs[id]!.grade,
            npcs[id]!.instrument,
            npcs[id]!.skill,
            npcs[id]!.motivation,
          ),
      _Member(
        Relations.player,
        player.grade,
        player.instrument,
        player.skill,
        player.motivation,
      ),
    ];

    void record({
      required String actor,
      required String? target,
      required String key,
      required int importance,
      RelationshipVector? delta,
      Map<String, String> extra = const {},
      MemoryVisibility visibility = MemoryVisibility.involved,
      MemoryCategory category = MemoryCategory.life,
    }) {
      final involvesPlayer =
          actor == Relations.player || target == Relations.player;
      mem.add(
        category: category,
        subjectId: actor,
        objectIds: [?target],
        reasonKey: key,
        params: {
          'actor': name(actor),
          if (target != null) 'target': name(target),
          ...extra,
        },
        delta: delta,
        importance: importance + (involvesPlayer ? 10 : 0),
        visibility: visibility,
      );
    }

    // ── 1. プレイヤー行動の社会的効果 ──
    if (playerAction != null) {
      final rng = ctx.sim.stream(
        turn: s.turn,
        domain: 'player_social',
        choice: playerAction.name,
      );
      final all = members().where((m) => !m.isPlayer).toList();
      switch (playerAction) {
        case WeeklyAction.partPractice when player.instrument != null:
          final part = all
              .where((m) => m.instrument == player.instrument)
              .toList();
          final group = part.isNotEmpty
              ? part
              : all
                    .where((m) => m.family == player.instrument!.family)
                    .toList();
          for (final m in group) {
            Relations.addMutual(
              relations,
              Relations.player,
              m.id,
              const RelationshipVector(affection: 1, trust: 2),
            );
          }
          if (group.isNotEmpty) {
            playerLines.add('パートの仲間（${group.length}人）との信頼が少し深まった。');
          }
        case WeeklyAction.hangOut:
          final sameGrade = all.where((m) => m.grade == player.grade).toList();
          final pool = sameGrade.isNotEmpty ? sameGrade : all;
          if (pool.isNotEmpty) {
            final friend = rng.weighted(pool, [
              for (final m in pool)
                20 +
                    Relations.of(
                      relations,
                      Relations.player,
                      m.id,
                    ).affection.clamp(0, 100),
            ]);
            final d = RelationshipVector(affection: rng.range(4, 8), trust: 2);
            Relations.addMutual(relations, Relations.player, friend.id, d);
            record(
              actor: Relations.player,
              target: friend.id,
              key: 'player_hung_out',
              importance: 12,
              delta: d,
            );
            playerLines.add('${name(friend.id)}と遊びに行った。仲が深まった。');
          }
        case WeeklyAction.rest:
          final leader = _partLeader(
            all,
            player.instrument,
            exclude: Relations.player,
          );
          if (leader != null) {
            Relations.add(
              relations,
              leader.id,
              Relations.player,
              const RelationshipVector(trust: -2),
            );
          }
        case WeeklyAction.extraPractice when player.instrument != null:
          for (final m in all) {
            if (m.instrument == player.instrument && m.skill < player.skill) {
              Relations.add(
                relations,
                m.id,
                Relations.player,
                const RelationshipVector(rivalry: 2, trust: 1),
              );
            }
          }
        default:
          break;
      }
    }

    // ── 2. NPC の自律行動 ──
    for (final id in s.roster) {
      final st = npcs[id];
      if (st == null || !st.active || st.retired) continue;
      final n = ctx.npc(s, id);
      final rng = ctx.sim.stream(
        turn: s.turn,
        domain: 'npc_autonomy',
        actor: id,
      );
      final behavior = _chooseBehavior(
        rng,
        n.traits,
        st,
        club.mood,
        s.roles[id],
      );
      final everyone = members().where((m) => m.id != id).toList();
      final self = _Member(
        id,
        st.grade,
        st.instrument,
        st.skill,
        st.motivation,
      );

      // 基礎的な上達（行動で倍率が変わる）
      final growthPct = switch (behavior) {
        NpcBehavior.practiceHard => 180,
        NpcBehavior.slackOff => 20,
        NpcBehavior.compete => 140,
        NpcBehavior.askSenior => 130,
        _ => 100,
      };
      var current = npcs[id]!;
      var motivationDelta = 0;
      var stressDelta = 0;

      _Member? pickTarget(int Function(_Member m) weight) {
        final ws = [for (final m in everyone) weight(m).clamp(0, 100000)];
        if (ws.every((w) => w <= 0)) return null;
        return everyone[rng.weightedIndex(ws)];
      }

      int proximity(_Member m) =>
          (m.instrument != null && m.instrument == self.instrument ? 40 : 0) +
          (m.family != null && m.family == self.family ? 20 : 0) +
          (m.grade == self.grade ? 20 : 0) +
          5;

      void playerEffect(_Member target, String line) {
        if (target.isPlayer) playerLines.add(line);
      }

      switch (behavior) {
        case NpcBehavior.idle:
        case NpcBehavior.practiceHard:
          if (behavior == NpcBehavior.practiceHard) motivationDelta += 1;
        case NpcBehavior.slackOff:
          motivationDelta -= 2;
          final leader = _partLeader(everyone, self.instrument, exclude: id);
          if (leader != null && leader.grade >= self.grade) {
            const d = RelationshipVector(trust: -3);
            Relations.add(relations, leader.id, id, d);
            record(
              actor: leader.id,
              target: id,
              key: 'noticed_slacking',
              importance: 12,
              delta: d,
            );
          }
        case NpcBehavior.breakthrough:
          final bonus = rng.range(30, 60);
          current = current.copyWith(
            skill: (current.skill + bonus).clamp(0, 1000),
          );
          motivationDelta += 5;
          record(
            actor: id,
            target: null,
            key: 'npc_breakthrough',
            importance: 35,
            category: MemoryCategory.practice,
            extra: {'instrument': self.instrument?.label ?? '楽器'},
            visibility: MemoryVisibility.public,
          );
          otherEvents.add((35, '${n.fullName}が壁を越え、一気に上達した。'));
        case NpcBehavior.teachJunior:
          final t = pickTarget(
            (m) => m.grade < self.grade ? proximity(m) * 2 : 0,
          );
          if (t == null) break;
          final gain = rng.range(4, 10);
          if (t.isPlayer) {
            player = player.copyWith(
              skill: (player.skill + gain).clamp(0, 1000),
            );
          } else {
            final ts = npcs[t.id]!;
            npcs[t.id] = ts.copyWith(skill: (ts.skill + gain).clamp(0, 1000));
          }
          const toTeacher = RelationshipVector(affection: 3, trust: 5);
          Relations.add(
            relations,
            id,
            t.id,
            const RelationshipVector(affection: 2, trust: 1),
          );
          Relations.add(relations, t.id, id, toTeacher);
          record(
            actor: id,
            target: t.id,
            key: 'taught_junior',
            importance: 14,
            delta: toTeacher,
            category: MemoryCategory.practice,
          );
          playerEffect(t, '${n.fullName}先輩が練習を見てくれた（熟練度 +$gain）。');
        case NpcBehavior.askSenior:
          final t = pickTarget(
            (m) => m.grade > self.grade ? proximity(m) * 2 : 0,
          );
          if (t == null) break;
          const d = RelationshipVector(trust: 4, affection: 1);
          Relations.add(relations, id, t.id, d);
          Relations.add(
            relations,
            t.id,
            id,
            const RelationshipVector(affection: 2),
          );
          record(
            actor: id,
            target: t.id,
            key: 'asked_senior',
            importance: 12,
            delta: d,
            category: MemoryCategory.practice,
          );
          playerEffect(t, '後輩の${n.fullName}に教えを請われた。');
        case NpcBehavior.bond:
          final t = pickTarget(
            (m) =>
                proximity(m) +
                Relations.of(relations, id, m.id).affection.clamp(0, 100) ~/ 2,
          );
          if (t == null) break;
          final d = RelationshipVector(affection: rng.range(4, 8), trust: 2);
          Relations.addMutual(relations, id, t.id, d);
          stressDelta -= 4;
          record(
            actor: id,
            target: t.id,
            key: 'bonded',
            importance: 14,
            delta: d,
          );
          playerEffect(t, '${n.fullName}と話が弾み、仲良くなった。');
        case NpcBehavior.quarrel:
          final t = pickTarget(
            (m) =>
                5 +
                (-Relations.of(relations, id, m.id).affection).clamp(0, 100) +
                Relations.of(relations, id, m.id).rivalry.clamp(0, 100) ~/ 2 +
                (m.instrument != null && m.instrument == self.instrument
                    ? 10
                    : 0),
          );
          if (t == null) break;
          final d = RelationshipVector(
            affection: -rng.range(6, 12),
            trust: -4,
            rivalry: 3,
          );
          Relations.addMutual(relations, id, t.id, d);
          stressDelta += 8;
          if (t.isPlayer) {
            player = player.copyWith(stress: (player.stress + 8).clamp(0, 100));
          } else {
            final ts = npcs[t.id]!;
            npcs[t.id] = ts.copyWith(stress: (ts.stress + 8).clamp(0, 100));
          }
          record(
            actor: id,
            target: t.id,
            key: 'quarreled',
            importance: 32,
            delta: d,
            category: MemoryCategory.conflict,
          );
          otherEvents.add((32, '${n.fullName}と${name(t.id)}が口論になった。'));
          playerEffect(t, '${n.fullName}と口論になってしまった……。');
        case NpcBehavior.compete:
          final t = pickTarget(
            (m) => m.instrument != null && m.family == self.family
                ? (50 - (m.skill - self.skill).abs() ~/ 10).clamp(1, 60) *
                      (m.instrument == self.instrument ? 3 : 1)
                : 0,
          );
          if (t == null) break;
          final d = RelationshipVector(rivalry: rng.range(5, 10));
          Relations.addMutual(relations, id, t.id, d);
          record(
            actor: id,
            target: t.id,
            key: 'competed',
            importance: 18,
            delta: d,
          );
          playerEffect(t, '${n.fullName}があなたに対抗心を燃やしている。');
        case NpcBehavior.gossip:
          final rumor = _recentNegative(s, mem.written, id);
          final t = pickTarget(
            (m) =>
                m.id == rumor?.subjectId ||
                    rumor?.objectIds.contains(m.id) == true
                ? 0
                : 5 + Relations.of(relations, m.id, id).affection.clamp(0, 100),
          );
          if (rumor == null || t == null) break;
          final victim = rumor.subjectId;
          const d = RelationshipVector(trust: -4, affection: -2);
          Relations.add(relations, t.id, victim, d);
          Relations.add(
            relations,
            id,
            t.id,
            const RelationshipVector(affection: 1),
          );
          record(
            actor: id,
            target: t.id,
            key: 'spread_rumor',
            importance: 20,
            delta: d,
            category: MemoryCategory.rumor,
            visibility: MemoryVisibility.rumored,
            extra: {'victim': name(victim)},
          );
          playerEffect(t, '${n.fullName}から${name(victim)}についての噂を聞いた。');
          if (victim == Relations.player) {
            playerLines.add('あなたについての噂が${name(t.id)}に広まったらしい……。');
          }
        case NpcBehavior.reconcile:
          final t = pickTarget((m) {
            final a = Relations.of(relations, id, m.id).affection;
            final b = Relations.of(relations, m.id, id).affection;
            final worst = a < b ? a : b;
            return worst < -5 ? -worst : 0;
          });
          if (t == null) break;
          final d = RelationshipVector(
            affection: rng.range(8, 14),
            trust: 3,
            rivalry: -3,
          );
          Relations.addMutual(relations, id, t.id, d);
          stressDelta -= 6;
          record(
            actor: id,
            target: t.id,
            key: 'reconciled',
            importance: 28,
            delta: d,
            category: MemoryCategory.reconciliation,
          );
          otherEvents.add((28, '${n.fullName}と${name(t.id)}が仲直りした。'));
          playerEffect(t, '${n.fullName}が歩み寄ってきて、仲直りできた。');
        case NpcBehavior.complainAdvisor:
          final t = pickTarget(
            (m) => m.grade == self.grade ? 10 + proximity(m) : 0,
          );
          motivationDelta -= 2;
          Relations.add(
            relations,
            id,
            advisorId,
            const RelationshipVector(trust: -3),
          );
          if (t == null) break;
          const d = RelationshipVector(affection: 3);
          Relations.addMutual(relations, id, t.id, d);
          record(
            actor: id,
            target: t.id,
            key: 'complained_advisor',
            importance: 12,
            delta: d,
          );
          playerEffect(t, '${n.fullName}から顧問への不満を聞かされた。');
        case NpcBehavior.encourage:
          final t = pickTarget((m) => (65 - m.motivation).clamp(0, 100));
          if (t == null) break;
          const d = RelationshipVector(affection: 4, trust: 3);
          Relations.add(relations, t.id, id, d);
          if (t.isPlayer) {
            player = player.copyWith(
              motivation: (player.motivation + 6).clamp(0, 100),
            );
          } else {
            final ts = npcs[t.id]!;
            npcs[t.id] = ts.copyWith(
              motivation: (ts.motivation + 6).clamp(0, 100),
            );
          }
          record(
            actor: id,
            target: t.id,
            key: 'encouraged',
            importance: 15,
            delta: d,
          );
          playerEffect(t, '落ち込んでいたら${n.fullName}が励ましてくれた（やる気 +6）。');
      }

      // 上達・やる気・ストレスの更新
      if (current.instrument != null) {
        final fit =
            n.aptitude.fitFor(current.instrument!) +
            (n.hasTrait('genius') ? 15 : 0);
        var pct = growthPct;
        if (n.hasTrait('hardworking')) pct = pct * 13 ~/ 10;
        if (n.hasTrait('lazy')) pct = pct * 6 ~/ 10;
        if (n.hasTrait('late_bloomer')) {
          pct = pct * (100 + (current.grade - 2) * 25) ~/ 100;
        }
        pct = pct * (50 + current.motivation) ~/ 100;
        final perYear =
            (30 + club.practiceIntensity * 12 + teaching * 6 ~/ 10) *
            (fit + 50) ~/
            100;
        var gain = perYear * pct * rng.range(70, 130) ~/ (45 * 100 * 100);
        gain = gain * (1200 - current.skill) ~/ 1200;
        current = current.copyWith(
          skill: (current.skill + gain).clamp(0, 1000),
        );
      }
      // やる気の基準値: 勤勉性・野心が高いほど高く、怠け者は低い。
      final baseline =
          (52 +
                  n.personality.conscientiousness ~/ 4 +
                  n.personality.ambition ~/ 10 -
                  (n.hasTrait('lazy') ? 10 : 0))
              .clamp(15, 90);
      final latest = npcs[id]!; // 他者の行動で変化した値を反映
      var motivation =
          latest.motivation +
          motivationDelta +
          (baseline - latest.motivation) ~/ 10;
      var stress = latest.stress + stressDelta - 3 - latest.stress ~/ 10;
      if (stress > 70) motivation -= 2;
      motivation = motivation.clamp(0, 100);
      stress = stress.clamp(0, 100);
      final low = motivation < 25 ? latest.lowMotivationWeeks + 1 : 0;
      npcs[id] = current.copyWith(
        motivation: motivation,
        stress: stress,
        lowMotivationWeeks: low,
      );
    }

    // ── 3. 退部判定 ──
    final roster = <String>[];
    for (final id in s.roster) {
      final st = npcs[id]!;
      if (!st.active) continue;
      if (st.retired) {
        roster.add(id);
        continue;
      }
      final rng = ctx.sim.stream(turn: s.turn, domain: 'npc_quit', actor: id);
      if (st.lowMotivationWeeks >= 6 && rng.chance(3000)) {
        npcs[id] = st.copyWith(active: false, quit: true);
        record(
          actor: id,
          target: null,
          key: 'quit_club',
          importance: 60,
          visibility: MemoryVisibility.public,
        );
        otherEvents.add((60, '${ctx.npc(s, id).fullName}が退部した。'));
        // 親しかった部員は落ち込む
        for (final other in s.roster) {
          if (other == id) continue;
          final o = npcs[other]!;
          if (o.active && Relations.of(relations, other, id).affection > 30) {
            npcs[other] = o.copyWith(
              motivation: (o.motivation - 4).clamp(0, 100),
            );
          }
        }
        if (Relations.of(relations, Relations.player, id).affection > 30) {
          player = player.copyWith(
            motivation: (player.motivation - 4).clamp(0, 100),
          );
          playerLines.add('仲の良かった${ctx.npc(s, id).fullName}が部を辞めてしまった……。');
        }
        continue;
      }
      roster.add(id);
    }

    // ── 4. 月初めに関係性を少し風化させる ──
    final date = ctx.calendar.dateOf(s.turn);
    final rel = date.weekOfMonth == 1 ? Relations.decay(relations) : relations;

    otherEvents.sort((a, b) => b.$1.compareTo(a.$1));
    final lines = [
      ...playerLines,
      for (final e in otherEvents.take(3)) '部内：${e.$2}',
    ];
    final next = mem.apply(
      s.copyWith(npcs: npcs, relations: rel, player: player, roster: roster),
    );
    return (state: next, lines: lines);
  }

  NpcBehavior _chooseBehavior(
    RngStream rng,
    List<TraitTag> traitsList,
    NpcState st,
    ClubMood mood,
    ClubRole? role,
  ) {
    final weights = <int>[];
    for (final b in NpcBehavior.values) {
      var w = baseBehaviorWeights[b] ?? 0;
      for (final t in traitsList) {
        final mod = traitBehaviorModifiers[t.traitId]?[b];
        if (mod == null) continue;
        // ★1 は差分の半分、★2 は等倍、★3 は 1.5 倍
        final scaled = 100 + (mod - 100) * t.intensity ~/ 2;
        w = w * scaled.clamp(5, 1000) ~/ 100;
      }
      final moodMod = moodBehaviorModifiers[mood]?[b];
      if (moodMod != null) w = w * moodMod ~/ 100;
      if (st.motivation < 30 &&
          (b == NpcBehavior.slackOff || b == NpcBehavior.complainAdvisor)) {
        w = w * 2;
      }
      if (st.stress > 60 && b == NpcBehavior.quarrel) w = w * 2;
      // 部長・代表は部をまとめようとする。
      if (role == ClubRole.captain || role == ClubRole.gradeRep) {
        if (b == NpcBehavior.encourage || b == NpcBehavior.teachJunior) {
          w = w * 2;
        }
        if (b == NpcBehavior.quarrel || b == NpcBehavior.slackOff) {
          w = w * 6 ~/ 10;
        }
      }
      if (st.instrument == null &&
          (b == NpcBehavior.compete || b == NpcBehavior.breakthrough)) {
        w = 0;
      }
      weights.add(w);
    }
    return NpcBehavior.values[rng.weightedIndex(weights)];
  }

  /// 指定楽器のパートリーダー（最も上手い者）。
  _Member? _partLeader(
    List<_Member> all,
    InstrumentType? inst, {
    required String exclude,
  }) {
    if (inst == null) return null;
    _Member? best;
    for (final m in all) {
      if (m.id == exclude || m.instrument != inst) continue;
      if (best == null || m.skill > best.skill) best = m;
    }
    return best;
  }

  /// 直近 8 週の、噂の種になりうる出来事（口論・サボり）。
  MemoryTag? _recentNegative(
    GameState s,
    List<MemoryTag> thisWeek,
    String teller,
  ) {
    final all = [...s.memories.reversed, ...thisWeek.reversed];
    for (final m in all) {
      if (m.date.turn < s.turn - 8) break;
      if ((m.reasonKey == 'quarreled' || m.reasonKey == 'noticed_slacking') &&
          m.subjectId != teller) {
        return m;
      }
    }
    return null;
  }
}
