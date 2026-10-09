import '../../../core/rng/rng_stream.dart';
import '../../value_objects/instrument.dart';
import '../../value_objects/school_enums.dart';
import '../master/approach_cards.dart';
import '../models/game_state.dart';
import 'game_context.dart';
import 'relations.dart';
import 'retirement_shock.dart';

/// 演奏の評価に使う部の状態。
class BandMetrics {
  const BandMetrics({
    required this.avgSkill,
    required this.cohesion,
    required this.avgMotivation,
    required this.teaching,
    required this.size,
  });

  /// メンバーの平均熟練度（0..1000）。
  final int avgSkill;

  /// メンバー間の平均好感度（-100..100）。
  final int cohesion;
  final int avgMotivation;
  final int teaching;
  final int size;
}

/// 演奏シミュレーションの共通処理（バンドの指標・アプローチカード）。
class Performance {
  const Performance(this.ctx);

  final GameContext ctx;

  /// メンバー（'player' を含みうる）の指標。
  BandMetrics metrics(GameState s, List<String> members) {
    var skill = 0;
    var mot = 0;
    var n = 0;
    for (final id in members) {
      if (id == Relations.player) {
        skill += s.player.skill;
        mot += s.player.motivation;
      } else {
        final st = s.npcs[id];
        if (st == null) continue;
        skill += st.skill;
        mot += st.motivation;
      }
      n++;
    }
    // 結束: メンバー同士の好感の平均（関係のない組は 0 とみなす）を 4 倍して強調する。
    var aff = 0;
    final set = members.toSet();
    for (final e in s.relations.entries) {
      final parts = e.key.split('>');
      if (set.contains(parts[0]) && set.contains(parts[1])) {
        aff += e.value.affection;
      }
    }
    final possible = n * (n - 1);
    // 引退ショックなど、部全体の一時的な調子を反映する
    final adjusted = RetirementShock.applyTo(
      ctx,
      s.condition,
      n == 0 ? 0 : skill ~/ n,
      n == 0 ? 50 : mot ~/ n,
    );
    return BandMetrics(
      avgSkill: adjusted.avgSkill,
      cohesion: possible <= 0 ? 0 : (aff * 4 ~/ possible).clamp(-100, 100),
      avgMotivation: adjusted.avgMotivation,
      teaching: ctx.advisor(s).advisorProfile!.teachingSkill,
      size: n,
    );
  }

  /// 選べるカード 3 枚（決定論的に引く）。
  List<ApproachCard> drawCards(
    GameState s,
    String occasion, {
    bool soloist = false,
  }) {
    final rng = ctx.sim.stream(
      turn: s.turn,
      domain: 'cards',
      actor: Relations.player,
      choice: occasion,
    );
    final eligible = [
      for (final c in ApproachCard.values)
        if (c != ApproachCard.soloShine || soloist) c,
    ];
    final drawn = rng.sample(eligible, 3);
    // ソリストなら必ずソロのカードを手札に入れる。
    if (soloist && !drawn.contains(ApproachCard.soloShine)) {
      drawn[2] = ApproachCard.soloShine;
    }
    drawn.sort((a, b) => a.index.compareTo(b.index));
    return drawn;
  }

  /// カードの効果（演奏評価のポイント）と、ぶれ（標準偏差）。プレイヤーの疲労も変化しうる。
  ({int bonus, int sd, int fatigueDelta, String note}) cardEffect(
    GameState s,
    ApproachCard card,
    BandMetrics m,
    RngStream rng,
  ) {
    final p = s.player;
    final stageFright = p.hasTrait('stage_fright');
    switch (card) {
      case ApproachCard.steady:
        return (bonus: 1, sd: 2, fatigueDelta: 0, note: '落ち着いて堅実に吹き切った。');
      case ApproachCard.bold:
        final b = (p.aptitude.expression - 50) ~/ 10 + rng.range(-4, 6);
        return (
          bonus: b,
          sd: 5,
          fatigueDelta: 0,
          note: b >= 3
              ? '攻めた表現が会場を惹きつけた！'
              : (b < 0 ? '攻めすぎて空回りしてしまった。' : '思い切った表現に挑んだ。'),
        );
      case ApproachCard.trustFriends:
        final b = m.cohesion ~/ 6 + 1;
        return (
          bonus: b,
          sd: 4,
          fatigueDelta: 0,
          note: b >= 3 ? '仲間との一体感がそのまま音になった。' : 'まとまりはいまひとつだった。',
        );
      case ApproachCard.watchConductor:
        final b = (p.advisorTrust - 50) ~/ 15 + m.teaching ~/ 40;
        return (bonus: b, sd: 4, fatigueDelta: 0, note: '指揮に集中し、合奏が引き締まった。');
      case ApproachCard.soloShine:
        final b = (p.skill - 500) ~/ 60 + rng.range(-5, 8);
        return (
          bonus: b,
          sd: 4,
          fatigueDelta: 0,
          note: b >= 3
              ? 'ソロが見事に決まった！'
              : (b < 0 ? 'ソロで音が裏返ってしまった……。' : 'ソロを無難にこなした。'),
        );
      case ApproachCard.breatheTogether:
        final part = _partTrust(s);
        final b = part ~/ 8 + 1;
        return (bonus: b, sd: 4, fatigueDelta: 0, note: 'パートの呼吸がぴたりと合った。');
      case ApproachCard.lastPush:
        final tired = p.fatigue > 70;
        return (
          bonus: tired ? -4 : 3,
          sd: 4,
          fatigueDelta: 15,
          note: tired ? '追い込みすぎて本番で力が出なかった……。' : '直前の追い込みが実を結んだ。',
        );
      case ApproachCard.calmMind:
        return (
          bonus: stageFright ? 5 : 2,
          sd: 3,
          fatigueDelta: 0,
          note: stageFright ? '深呼吸で緊張を抑え、いつもの音が出せた。' : '平常心で臨めた。',
        );
    }
  }

  /// プレイヤーのパート（同じ楽器、いなければ同系統）の仲間からの平均信頼。
  int _partTrust(GameState s) {
    final inst = s.player.instrument;
    if (inst == null) return 0;
    final members = ctx.activeMembers(s);
    var group = members.where((m) => m.instrument == inst).toList();
    if (group.isEmpty) {
      group = members
          .where((m) => m.instrument?.family == inst.family)
          .toList();
    }
    if (group.isEmpty) return 0;
    var sum = 0;
    for (final m in group) {
      sum += Relations.get(s, m.id, Relations.player).trust;
    }
    return sum ~/ group.length;
  }

  /// コンクールの出場人数の上限。
  static int memberLimit(BandDivision division, SchoolLevel level) =>
      division == BandDivision.small
      ? 30
      : (level == SchoolLevel.high ? 55 : 50);

  /// ソロを担当しうる楽器。
  static const soloInstruments = {
    InstrumentType.trumpet,
    InstrumentType.altoSax,
    InstrumentType.flute,
    InstrumentType.oboe,
    InstrumentType.clarinet,
    InstrumentType.horn,
    InstrumentType.euphonium,
  };
}
