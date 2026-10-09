/// 指揮者ミニゲーム（Phase 7: Tactical Conducting）のデータモデルと判定。
///
/// 音ゲーではなく「資源管理」: 本番の曲の流れに合わせて、プレイヤーは
/// ダイナミクス（音量）と表現力の 2 本のスライダーを動かす。極端な値ほど
/// 決まれば大きく加点されるが、部の地力（スタミナ・技術・団結）が足りないと
/// 音が割れて（崩壊）減点される。判定は入力と部の状態だけで決まる（乱数なし）。
library;

import '../models/piece.dart';

/// 判定に使う部の地力（0..100。PieceFit.bandStats から作る）。
class ConductingParams {
  const ConductingParams({
    required this.stamina,
    required this.technique,
    required this.cohesion,
  });

  /// 課題曲の相性計算と同じ部の見積もりから作る。
  factory ConductingParams.fromBandStats(Map<PieceStat, int> stats) =>
      ConductingParams(
        stamina: stats[PieceStat.stamina] ?? 50,
        technique: stats[PieceStat.technique] ?? 50,
        cohesion: stats[PieceStat.ensemble] ?? 50,
      );

  final int stamina;
  final int technique;
  final int cohesion;
}

/// ある時点のスライダーの位置。
class ConductingInput {
  const ConductingInput({
    required this.atMs,
    required this.dynamics,
    required this.expression,
  });

  /// 曲の頭からの時刻（ミリ秒）。
  final int atMs;

  /// 音量 0（ppp）..100（fff）。50 が mf。
  final int dynamics;

  /// 表現の振れ幅 0（淡々と）..100（大胆に）。
  final int expression;
}

enum ConductingVerdict {
  /// 無理のない範囲（倍率 1.0 前後）。
  steady('安定'),

  /// 攻めた指示が決まった（プラス倍率）。
  brilliant('会心'),

  /// 地力が足りず音が割れた（マイナス倍率）。
  collapse('崩壊');

  const ConductingVerdict(this.label);
  final String label;
}

class ConductingJudgement {
  const ConductingJudgement({
    required this.multiplierPermille,
    required this.verdict,
    required this.reason,
  });

  /// 倍率（千分率。1000 = 1.0 倍）。
  final int multiplierPermille;
  final ConductingVerdict verdict;
  final String reason;
}

/// 1 回の入力を判定する。
///
/// - フォルテ側（ダイナミクス 70 超）はスタミナを、ピアノ側（30 未満）は技術を要求する。
///   要求量 = 40 + 中央からの振れ（fff・ppp で 90）。
/// - 表現力 70 超は団結（呼吸を合わせる力）を要求する。要求量 = 50 + (表現力 − 70) × 4/3（最大 90）。
/// - すべての要求を満たしていれば、攻めた分（振れの大きさ）だけ倍率が上がる（最大 1.3 倍）。
/// - 足りなければ不足分だけ倍率が下がり、不足が 10 を超えると「崩壊」（最低 0.5 倍）。
abstract final class ConductingJudge {
  static ConductingJudgement judge(ConductingParams p, ConductingInput i) {
    final dyn = i.dynamics.clamp(0, 100);
    final expr = i.expression.clamp(0, 100);
    final shortfalls = <(int, String)>[];
    var boldness = 0;

    if (dyn > 70) {
      final need = 40 + (dyn - 50);
      boldness += dyn - 70;
      if (p.stamina < need) shortfalls.add((need - p.stamina, 'スタミナ'));
    } else if (dyn < 30) {
      final need = 40 + (50 - dyn);
      boldness += 30 - dyn;
      if (p.technique < need) shortfalls.add((need - p.technique, '技術'));
    }
    if (expr > 70) {
      final need = 50 + (expr - 70) * 4 ~/ 3;
      boldness += expr - 70;
      if (p.cohesion < need) shortfalls.add((need - p.cohesion, '団結'));
    }

    if (shortfalls.isEmpty) {
      final bonus = (boldness * 5).clamp(0, 300);
      return ConductingJudgement(
        multiplierPermille: 1000 + bonus,
        verdict: bonus > 0
            ? ConductingVerdict.brilliant
            : ConductingVerdict.steady,
        reason: bonus > 0 ? '攻めた指示に部が応えた' : '無理のない指示',
      );
    }
    final worst = shortfalls.reduce((a, b) => a.$1 >= b.$1 ? a : b);
    final total = shortfalls.fold(0, (a, s) => a + s.$1);
    final collapsed = worst.$1 > 10;
    return ConductingJudgement(
      multiplierPermille: (1000 - total * 15).clamp(500, 1000),
      verdict: collapsed
          ? ConductingVerdict.collapse
          : ConductingVerdict.steady,
      reason: collapsed ? '${worst.$2}が足りず、音が割れた' : '${worst.$2}が少し足りず、粗が出た',
    );
  }
}

/// 1 曲ぶんの指揮（入力の列と判定の列）。
class ConductingSession {
  const ConductingSession({
    required this.piece,
    required this.params,
    this.judgements = const [],
  });

  final Piece piece;
  final ConductingParams params;
  final List<(ConductingInput, ConductingJudgement)> judgements;

  /// 入力を 1 つ足した新しいセッション。
  ConductingSession record(ConductingInput input) => ConductingSession(
    piece: piece,
    params: params,
    judgements: [...judgements, (input, ConductingJudge.judge(params, input))],
  );

  /// 曲全体の倍率（千分率。判定の平均）。
  int get totalPermille => judgements.isEmpty
      ? 1000
      : judgements.fold(0, (a, j) => a + j.$2.multiplierPermille) ~/
            judgements.length;

  int get collapses => judgements
      .where((j) => j.$2.verdict == ConductingVerdict.collapse)
      .length;

  /// コンクールの演奏評価への補正（予定: 倍率 1.0 → 0、1.3 → +6、0.5 → -10）。
  int get contestBonus => totalPermille >= 1000
      ? (totalPermille - 1000) ~/ 50
      : -((1000 - totalPermille) ~/ 50);
}
