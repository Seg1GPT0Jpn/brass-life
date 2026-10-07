import '../../entities/memory_tag.dart';
import '../../entities/npc.dart';
import '../../value_objects/instrument.dart';
import '../../value_objects/person_enums.dart';
import '../models/game_state.dart';
import 'game_context.dart';
import 'memory_writer.dart';
import 'roster_service.dart';

/// 楽器決定イベントの結果。
class InstrumentDecisionOutcome {
  const InstrumentDecisionOutcome({
    required this.state,
    required this.playerLines,
  });

  final GameState state;

  /// プレイヤー向けの経緯説明（プレイヤーが対象でなければ空）。
  final List<String> playerLines;
}

/// 体験入部での手応え（隠し適性の粗い表示）。
String fitHint(int fit) => fit >= 65 ? '◎' : (fit >= 52 ? '○' : '△');

/// 楽器決定ロジック。
///
/// 1. 枠: 標準編成比で部全体の目標人数を求め、上級生の人数を引いた数。
///    さらに「使用可能な学校所有楽器の空き + 私物を持ちやすい楽器なら 1」で上限をかける。
/// 2. 評価: 新入生×楽器ごとに
///    適性×重みA + 希望順位ボーナス×重みB + 経験者ボーナス + 乱数（体験入部の出来）。
///    重み A/B は顧問の指導スタイルと、その楽器のパートリーダー（最上手の上級生）の性格で決まる。
/// 3. 割当: 評価の高い組から貪欲に確定。あぶれた新入生は空き枠のうち最も適性の高い楽器へ。
class InstrumentDecision {
  const InstrumentDecision(this.ctx);

  final GameContext ctx;

  static const _wishBonus = [60, 35, 20];

  /// プレイヤー用の枠・競争状況の見込み（イベント画面で表示）。
  Map<InstrumentType, ({int capacity, int wishers, int available})> preview(
    GameState s,
  ) {
    final cap = _capacities(s, includePlayer: true);
    final freshmen = _freshmen(s);
    final result =
        <InstrumentType, ({int capacity, int wishers, int available})>{};
    for (final t in InstrumentType.values) {
      final wishers = freshmen.where((f) => f.wish == t).length;
      result[t] = (
        capacity: cap.capacity[t.index],
        wishers: wishers,
        available: cap.available[t.index],
      );
    }
    return result;
  }

  List<NpcState> _freshmen(GameState s) => [
    for (final m in ctx.activeMembers(s))
      if (m.grade == 1 && m.instrument == null) m,
  ];

  ({List<int> capacity, List<int> available}) _capacities(
    GameState s, {
    required bool includePlayer,
  }) {
    final club = ctx.club(s);
    final types = InstrumentType.values;
    final active = ctx.activeMembers(s);
    final upper = List.filled(types.length, 0);
    for (final m in active) {
      if (m.instrument != null) upper[m.instrument!.index]++;
    }
    final freshmenCount =
        _freshmen(s).length +
        (includePlayer && s.player.instrument == null ? 1 : 0);
    final total =
        active.where((m) => m.instrument != null).length + freshmenCount;
    final target = RosterService.targetSeats(total);
    final capacity = <int>[];
    final available = <int>[];
    for (var i = 0; i < types.length; i++) {
      final avail = (club.usableCount(types[i]) - upper[i]).clamp(0, 99);
      available.add(avail);
      final soft = types[i].personalPermyriad >= 2500 ? 1 : 0;
      final byBalance = (target[i] - upper[i]).clamp(0, 99);
      capacity.add(byBalance < avail + soft ? byBalance : avail + soft);
    }
    // 全員が何かを担当できるまで枠を足す（空き楽器の多い順 → クラリネット）。
    var sum = capacity.fold(0, (a, b) => a + b);
    while (sum < freshmenCount) {
      var best = -1;
      var bestSpare = 0;
      for (var i = 0; i < types.length; i++) {
        final spare = available[i] - capacity[i];
        if (spare > bestSpare) {
          bestSpare = spare;
          best = i;
        }
      }
      capacity[best >= 0 ? best : InstrumentType.clarinet.index]++;
      sum++;
    }
    return (capacity: capacity, available: available);
  }

  /// 顧問のスタイルによる重み（適性%, 希望%）。
  (int, int) _baseWeights(GameState s) {
    final style = ctx.advisor(s).advisorProfile!.style;
    return switch (style) {
      AdvisorStyle.theoretical || AdvisorStyle.strict => (130, 70),
      AdvisorStyle.charismatic => (125, 75),
      AdvisorStyle.gentle || AdvisorStyle.handsOff => (70, 130),
      AdvisorStyle.passionate => (100, 100),
    };
  }

  /// 楽器を決定する。[playerWishes] はプレイヤーが対象の場合のみ指定する。
  InstrumentDecisionOutcome decide(
    GameState s, {
    List<InstrumentType>? playerWishes,
  }) {
    final types = InstrumentType.values;
    final freshmen = _freshmen(s);
    final includePlayer = playerWishes != null && s.player.instrument == null;
    final caps = _capacities(s, includePlayer: includePlayer);
    final capacity = List.of(caps.capacity);
    final (baseFit, baseWish) = _baseWeights(s);
    final active = ctx.activeMembers(s);

    // パートリーダー（各楽器で最も上手い上級生）の性格による補正。
    final leaderAdj = <int, (int, int)>{};
    for (var i = 0; i < types.length; i++) {
      NpcState? leader;
      for (final m in active) {
        if (m.instrument == types[i] &&
            (leader == null || m.skill > leader.skill)) {
          leader = m;
        }
      }
      if (leader == null) continue;
      final n = ctx.npc(s, leader.id);
      var f = 0;
      var w = 0;
      if (n.hasTrait('perfectionist') || n.hasTrait('competitive')) f += 20;
      if (n.hasTrait('caring') ||
          n.hasTrait('harmony') ||
          n.hasTrait('gentle')) {
        w += 20;
      }
      leaderAdj[i] = (f, w);
    }

    final choiceKey = playerWishes?.map((t) => t.name).join(',') ?? '';
    final candidates = <({String id, int instrument, int score})>[];
    final scoreOf = <String, Map<int, int>>{};

    void addCandidate(
      String id,
      List<InstrumentType> wishes,
      int Function(InstrumentType) fit,
      InstrumentType? prev,
    ) {
      final rng = ctx.sim.stream(
        turn: s.turn,
        domain: 'instrument_decision',
        actor: id,
        choice: id == 'player' ? choiceKey : '',
      );
      for (var i = 0; i < types.length; i++) {
        final t = types[i];
        final adj = leaderAdj[i] ?? (0, 0);
        final rank = wishes.indexOf(t);
        final wishBonus = rank >= 0 && rank < 3 ? _wishBonus[rank] : 0;
        final score =
            fit(t) * (baseFit + adj.$1) ~/ 100 +
            wishBonus * (baseWish + adj.$2) ~/ 100 +
            (prev == t ? 40 : 0) +
            rng.range(0, 20);
        candidates.add((id: id, instrument: i, score: score));
        (scoreOf[id] ??= {})[i] = score;
      }
    }

    for (final f in freshmen) {
      final n = ctx.npc(s, f.id);
      addCandidate(
        f.id,
        [?f.wish],
        (t) => n.aptitude.fitFor(t) + (n.hasTrait('genius') ? 10 : 0),
        n.previousInstrument,
      );
    }
    if (includePlayer) {
      final p = s.player;
      addCandidate(
        'player',
        playerWishes,
        (t) => p.aptitude.fitFor(t) + (p.hasTrait('genius') ? 10 : 0),
        p.previousInstrument,
      );
    }

    candidates.sort((a, b) {
      final c = b.score.compareTo(a.score);
      if (c != 0) return c;
      final d = a.id.compareTo(b.id);
      return d != 0 ? d : a.instrument.compareTo(b.instrument);
    });

    final assigned = <String, int>{};
    for (final c in candidates) {
      if (assigned.containsKey(c.id) || capacity[c.instrument] <= 0) continue;
      assigned[c.id] = c.instrument;
      capacity[c.instrument]--;
    }
    // あぶれた人: 空き枠のうち評価が最も高い楽器、枠がなければクラリネット。
    final everyone = [
      for (final f in freshmen) f.id,
      if (includePlayer) 'player',
    ];
    for (final id in everyone) {
      if (assigned.containsKey(id)) continue;
      var best = InstrumentType.clarinet.index;
      var bestScore = -1;
      for (var i = 0; i < types.length; i++) {
        if (capacity[i] > 0 && scoreOf[id]![i]! > bestScore) {
          best = i;
          bestScore = scoreOf[id]![i]!;
        }
      }
      assigned[id] = best;
      if (capacity[best] > 0) capacity[best]--;
    }

    // 状態へ反映・記憶の生成。
    final mem = MemoryWriter(ctx, s);
    final npcs = Map.of(s.npcs);
    final club = ctx.club(s);
    for (final f in freshmen) {
      final t = types[assigned[f.id]!];
      final n = ctx.npc(s, f.id);
      final gotWish = f.wish == t;
      final startSkill = n.previousInstrument == t
          ? n.previousSkill
          : (n.background == MusicBackground.elementaryBand &&
                    t.family == InstrumentFamily.brass
                ? 120
                : 30 + n.aptitude.fitFor(t) ~/ 2);
      npcs[f.id] = f.copyWith(
        instrument: t,
        skill: startSkill,
        motivation: (f.motivation + (gotWish ? 8 : -8)).clamp(0, 100),
      );
      mem.add(
        category: MemoryCategory.life,
        subjectId: f.id,
        objectIds: [club.id],
        reasonKey: gotWish
            ? 'instrument_wish_granted'
            : 'instrument_wish_denied',
        params: {'instrument': t.label, 'wish': f.wish?.label ?? '－'},
        importance: gotWish ? 25 : 35,
      );
    }

    var player = s.player;
    final lines = <String>[];
    if (includePlayer) {
      final t = types[assigned['player']!];
      final rank = playerWishes.indexOf(t);
      final startSkill = player.previousInstrument == t
          ? player.skill
          : (player.background == MusicBackground.elementaryBand &&
                    t.family == InstrumentFamily.brass
                ? 120
                : 30 + player.aptitude.fitFor(t) ~/ 2);
      player = player.copyWith(
        instrument: t,
        skill: startSkill,
        wishes: playerWishes,
        motivation:
            (player.motivation +
                    switch (rank) {
                      0 => 12,
                      1 => 4,
                      2 => 0,
                      _ => -10,
                    })
                .clamp(0, 100),
      );
      // 経緯の説明。
      lines.add('担当楽器は「${t.label}」に決まった。');
      for (var r = 0; r < playerWishes.length; r++) {
        final w = playerWishes[r];
        final wishers = freshmen.where((f) => f.wish == w).length + 1;
        final ranked = [
          for (final c in candidates)
            if (c.instrument == w.index) c.id,
        ];
        final place = ranked.indexOf('player') + 1;
        final note = w == t
            ? '→ 決定'
            : '（枠 ${caps.capacity[w.index]}、希望者 $wishers 人中、評価 $place 位）';
        lines.add('第${r + 1}希望 ${w.label} $note');
      }
      final leader = leaderAdj[t.index];
      final style = ctx.advisor(s).advisorProfile!.style;
      lines.add(
        '顧問（${style.label}）は'
        '${baseFit > baseWish ? '適性' : (baseFit < baseWish ? '本人の希望' : '適性と希望の両方')}'
        'を重視して決めたようだ。'
        '${leader != null && leader.$1 > 0 ? ' パートの先輩は実力を厳しく見ていた。' : ''}'
        '${leader != null && leader.$2 > 0 ? ' パートの先輩は希望を汲んでくれた。' : ''}',
      );
      mem.add(
        category: MemoryCategory.life,
        subjectId: 'player',
        objectIds: [club.id],
        reasonKey: rank == 0
            ? 'instrument_wish_granted'
            : 'instrument_wish_denied',
        params: {'instrument': t.label, 'wish': playerWishes.first.label},
        importance: rank == 0 ? 40 : 55,
      );
    }

    final next = mem.apply(s.copyWith(npcs: npcs, player: player));
    return InstrumentDecisionOutcome(state: next, playerLines: lines);
  }

  /// NPC 名を含む表示用の補助。
  String nameOf(GameState s, String id) {
    if (id == 'player') return s.player.fullName;
    final Npc n = ctx.npc(s, id);
    return n.fullName;
  }
}
