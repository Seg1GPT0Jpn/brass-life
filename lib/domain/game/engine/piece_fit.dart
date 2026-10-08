import '../../value_objects/instrument.dart';
import '../models/game_state.dart';
import '../models/piece.dart';
import 'game_context.dart';
import 'performance.dart';
import 'relations.dart';

/// 部の実力と課題曲の相性。
///
/// 部の各要素（[PieceStat]）を 0..100 で見積もる（平均的な部で 50 前後）。
/// 熟練度に関わる要素は「同じ学校段階・強さ帯の部の平均」を 50 とした相対値、
/// 適性に関わる要素はメンバーの適性の平均。
class PieceFit {
  const PieceFit(this.ctx);

  final GameContext ctx;

  static const _highWoodwind = {
    InstrumentType.piccolo,
    InstrumentType.flute,
    InstrumentType.oboe,
    InstrumentType.ebClarinet,
    InstrumentType.clarinet,
  };
  static const _midLow = {
    InstrumentType.horn,
    InstrumentType.trombone,
    InstrumentType.euphonium,
    InstrumentType.tenorSax,
    InstrumentType.bassoon,
  };
  static const _lowRange = {
    InstrumentType.tuba,
    InstrumentType.bassTrombone,
    InstrumentType.bassClarinet,
    InstrumentType.baritoneSax,
    InstrumentType.stringBass,
  };

  /// 選曲時点の候補メンバー（引退していない部員と、部にいればプレイヤー）。
  List<String> candidates(GameState s) => [
    for (final m in ctx.activeMembers(s))
      if (m.instrument != null) m.id,
    if (s.player.inClub && s.player.instrument != null) Relations.player,
  ];

  /// 部の各要素の見積もり（0..100）。
  Map<PieceStat, int> bandStats(GameState s, List<String> members) {
    final club = ctx.club(s);
    final school = ctx.school(s);
    final m = Performance(ctx).metrics(s, members);
    final expected =
        ctx.expectedContestSkill[(school.level, club.tier)] ?? m.avgSkill;
    int rel(int skill) => (50 + (skill - expected) ~/ 6).clamp(0, 100);

    var n = 0;
    var expr = 0, rhythm = 0, pitch = 0, breath = 0, dex = 0;
    final exprs = <int>[];
    final bySet = <String, List<int>>{};
    var trustToAdvisor = 0;
    for (final id in members) {
      final isPlayer = id == Relations.player;
      final inst = isPlayer ? s.player.instrument : s.npcs[id]?.instrument;
      final skill = isPlayer ? s.player.skill : (s.npcs[id]?.skill ?? 0);
      final apt = isPlayer ? s.player.aptitude : ctx.npc(s, id).aptitude;
      final e = isPlayer
          ? (apt.expression + s.player.musicality ~/ 10) ~/ 2
          : apt.expression;
      n++;
      expr += e;
      exprs.add(e);
      rhythm += apt.rhythm;
      pitch += apt.pitch;
      breath += apt.breath;
      if (!isPlayer) {
        trustToAdvisor += Relations.get(s, id, club.advisorId).trust;
      }
      void put(String key) => (bySet[key] ??= []).add(skill);
      if (inst != null) {
        put(inst.family.name);
        if (inst.family == InstrumentFamily.woodwind) dex += apt.dexterity;
        if (_highWoodwind.contains(inst)) put('high');
        if (_midLow.contains(inst)) put('midLow');
        if (_lowRange.contains(inst)) put('low');
      }
    }
    int avg(int sum) => n == 0 ? 0 : sum ~/ n;
    int section(String key) {
      final list = bySet[key];
      if (list == null || list.isEmpty) return 20; // いない
      return rel(list.fold(0, (a, b) => a + b) ~/ list.length);
    }

    final woodwinds = bySet[InstrumentFamily.woodwind.name]?.length ?? 0;
    exprs.sort((a, b) => b.compareTo(a));
    final top = exprs.take(3).toList();
    final technique = rel(m.avgSkill);
    final rhythmAvg = avg(rhythm);
    return {
      PieceStat.technique: technique,
      PieceStat.fundamentals: (technique + (m.teaching - 50) ~/ 5).clamp(
        0,
        100,
      ),
      PieceStat.expression: avg(expr),
      PieceStat.rhythm: rhythmAvg,
      PieceStat.groove: ((rhythmAvg + m.avgMotivation) ~/ 2).clamp(0, 100),
      PieceStat.pitch: avg(pitch),
      PieceStat.stamina: avg(breath),
      PieceStat.tension: m.avgMotivation.clamp(0, 100),
      PieceStat.charisma: top.isEmpty
          ? 0
          : top.fold(0, (a, b) => a + b) ~/ top.length,
      PieceStat.ensemble: (50 + m.cohesion ~/ 2).clamp(0, 100),
      PieceStat.conductorSync:
          ((m.teaching +
                      (50 + (n == 0 ? 0 : trustToAdvisor ~/ n)).clamp(
                        0,
                        100,
                      )) ~/
                  2)
              .clamp(0, 100),
      PieceStat.brass: section(InstrumentFamily.brass.name),
      PieceStat.woodwind: section(InstrumentFamily.woodwind.name),
      PieceStat.woodwindTech: woodwinds == 0
          ? 20
          : (section(InstrumentFamily.woodwind.name) + dex ~/ woodwinds) ~/ 2,
      PieceStat.highWoodwind: section('high'),
      PieceStat.percussion: section(InstrumentFamily.percussion.name),
      PieceStat.midLow: section('midLow'),
      PieceStat.lowRange: section('low'),
    };
  }

  /// 要求値（比重）から、その要素に必要な部の実力（0..100）。
  /// 要求 45 → 45、要求 60 → 50、要求 85 → 58（平均的な部が 50）。
  static int requiredLevel(int weight) => 30 + weight ~/ 3;

  /// 曲との相性（余裕）: 要求値を比重とした「部の実力 − 必要な実力」の加重平均。
  /// プラスなら余裕があり、マイナスなら背伸び。
  static int margin(Piece piece, Map<PieceStat, int> stats) {
    var num = 0;
    var den = 0;
    for (final (stat, w) in piece.demands) {
      num += w * ((stats[stat] ?? 0) - requiredLevel(w));
      den += w;
    }
    return den == 0 ? 0 : num ~/ den;
  }

  /// コンクールの演奏評価への補正。
  static int contestBonus(int margin) => (margin ~/ 4).clamp(-6, 5);

  static String fitLabel(int margin) => switch (margin) {
    >= 8 => '得意な曲',
    >= 0 => '合っている',
    >= -8 => '少し背伸び',
    _ => 'かなり難しい',
  };

  /// 部にとって最も相性の良い曲（顧問が選ぶときの基準）。
  Piece bestFor(GameState s, List<Piece> pieces) {
    final stats = bandStats(s, candidates(s));
    var best = pieces.first;
    var bestMargin = PieceFit.margin(best, stats);
    for (final p in pieces.skip(1)) {
      final mg = PieceFit.margin(p, stats);
      if (mg > bestMargin) {
        best = p;
        bestMargin = mg;
      }
    }
    return best;
  }
}
