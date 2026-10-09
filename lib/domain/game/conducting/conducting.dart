/// 指揮者ミニゲーム（Phase 7: Tactical Conducting）のデータモデルと判定。
///
/// 音ゲーではなく「資源管理」: 本番の曲の流れに合わせて、プレイヤーは
/// ダイナミクス（音量）と表現力の 2 本のスライダーを動かす。極端な値ほど
/// 決まれば大きく加点されるが、部の地力（スタミナ・技術・団結）が足りないと
/// 音が割れて（崩壊）減点される。判定は入力と部の状態だけで決まる（乱数なし）。
library;

import '../models/game_state.dart';
import '../models/piece.dart';
import 'rehearsal.dart';

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

// ───────────── 曲の構成（フレーズ）と、本番の指揮プラン ─────────────

/// 曲の 1 区間。理想のダイナミクス・表現力に近いほど「曲に合った指揮」になる。
class ConductingPhrase {
  const ConductingPhrase(this.label, this.idealDynamics, this.idealExpression);

  final String label;
  final int idealDynamics;
  final int idealExpression;

  /// 強弱記号での目安。
  String get dynamicsMark => dynamicsMarkOf(idealDynamics);
}

String dynamicsMarkOf(int d) => switch (d) {
  < 12 => 'ppp',
  < 25 => 'pp',
  < 38 => 'p',
  < 50 => 'mp',
  < 62 => 'mf',
  < 75 => 'f',
  < 88 => 'ff',
  _ => 'fff',
};

/// 曲の構成。番号（I〜IV）ごとの性格で決まる（乱数なし）。
abstract final class PieceStructure {
  static List<ConductingPhrase> of(Piece piece) => switch (piece.category) {
    'I' => const [
      ConductingPhrase('ファンファーレ', 72, 45),
      ConductingPhrase('行進', 62, 40),
      ConductingPhrase('中間部（トリオ）', 35, 65),
      ConductingPhrase('再現', 70, 50),
      ConductingPhrase('コーダ', 85, 60),
    ],
    'II' => const [
      ConductingPhrase('静かな序奏', 22, 55),
      ConductingPhrase('歌い出し', 40, 70),
      ConductingPhrase('高まり', 60, 80),
      ConductingPhrase('クライマックス', 85, 90),
      ConductingPhrase('余韻', 15, 65),
    ],
    'III' => const [
      ConductingPhrase('つかみ', 70, 60),
      ConductingPhrase('ブレイク', 40, 50),
      ConductingPhrase('ソロ回し', 55, 85),
      ConductingPhrase('盛り上がり', 82, 75),
      ConductingPhrase('キメ', 75, 65),
    ],
    _ => const [
      ConductingPhrase('不穏な導入', 18, 60),
      ConductingPhrase('嵐', 88, 70),
      ConductingPhrase('静寂', 8, 75),
      ConductingPhrase('再燃', 75, 80),
      ConductingPhrase('終結', 95, 85),
    ],
  };
}

/// 本番の指揮プラン（フレーズごとのスライダーの位置）。
class ConductingPlan {
  const ConductingPlan(this.steps);

  /// フレーズ順の (ダイナミクス, 表現力)。
  final List<(int, int)> steps;

  /// 選択ログ用の文字列（例: "60.50-80.70"）。
  String encode() => steps.map((e) => '${e.$1}.${e.$2}').join('-');

  static ConductingPlan? decode(String? s) {
    if (s == null || s.isEmpty) return null;
    final steps = <(int, int)>[];
    for (final part in s.split('-')) {
      final xy = part.split('.');
      if (xy.length != 2) return null;
      final d = int.tryParse(xy[0]);
      final e = int.tryParse(xy[1]);
      if (d == null || e == null) return null;
      steps.add((d.clamp(0, 100), e.clamp(0, 100)));
    }
    return ConductingPlan(steps);
  }
}

/// 1 フレーズの評価（地力の判定 × 曲に合っているか）。
class PhraseResult {
  const PhraseResult({
    required this.phrase,
    required this.dynamics,
    required this.expression,
    required this.judgement,
    required this.fitPermille,
    this.rehearsalPenalty = 0,
    this.offRehearsal = false,
  });

  final ConductingPhrase phrase;
  final int dynamics;
  final int expression;
  final ConductingJudgement judgement;

  /// 曲の性格に合っているか（千分率。理想どおりで 1100、大きく外すと 850）。
  final int fitPermille;

  /// 日頃の練習から外れた分の減点（千分率）。
  final int rehearsalPenalty;

  /// 練習と違いすぎて合奏が崩れた。
  final bool offRehearsal;

  int get permille =>
      judgement.multiplierPermille *
      fitPermille ~/
      1000 *
      (1000 - rehearsalPenalty) ~/
      1000;
}

/// 指揮プラン全体の評価。
class ConductingResult {
  const ConductingResult(this.phrases);

  final List<PhraseResult> phrases;

  int get totalPermille => phrases.isEmpty
      ? 1000
      : phrases.fold(0, (a, p) => a + p.permille) ~/ phrases.length;

  int get collapses => phrases
      .where((p) => p.judgement.verdict == ConductingVerdict.collapse)
      .length;

  int get brilliants => phrases
      .where((p) => p.judgement.verdict == ConductingVerdict.brilliant)
      .length;

  /// 演奏評価への補正（倍率 1.0 → 0、1.3 → +6、0.5 → −10）。
  int get bonus => totalPermille >= 1000
      ? (totalPermille - 1000) ~/ 50
      : -((1000 - totalPermille) ~/ 50);

  /// 結果の要約（ログ用）。
  List<String> summary() {
    final lines = <String>[];
    for (final p in phrases) {
      if (p.judgement.verdict == ConductingVerdict.collapse) {
        lines.add('「${p.phrase.label}」で${p.judgement.reason}。');
      } else if (p.judgement.verdict == ConductingVerdict.brilliant &&
          p.fitPermille >= 1050) {
        lines.add('「${p.phrase.label}」の攻めた指揮が決まった！');
      }
    }
    lines.add(
      '指揮の出来：${(totalPermille / 1000).toStringAsFixed(2)} 倍'
      '（会心 $brilliants・崩壊 $collapses）',
    );
    return lines;
  }
}

abstract final class ConductingEvaluator {
  /// フレーズの性格に合っているか（理想との距離で 850〜1100）。
  static int fit(ConductingPhrase p, int dynamics, int expression) {
    final diff =
        (dynamics - p.idealDynamics).abs() +
        (expression - p.idealExpression).abs();
    return (1100 - diff * 3).clamp(850, 1100);
  }

  /// プランを評価する。フレーズより短いプランは「指示なし（50, 50）」で補う。
  ///
  /// [rehearsal] を渡すと、日頃の練習から大きく外れた指示に減点（と崩壊）を加える。
  static ConductingResult evaluate(
    Piece piece,
    ConductingParams params,
    ConductingPlan plan, {
    RehearsalMemory? rehearsal,
  }) {
    final phrases = PieceStructure.of(piece);
    return ConductingResult([
      for (var i = 0; i < phrases.length; i++)
        () {
          final (d, e) = i < plan.steps.length ? plan.steps[i] : (50, 50);
          var j = ConductingJudge.judge(
            params,
            ConductingInput(atMs: i, dynamics: d, expression: e),
          );
          final r = rehearsal ?? const RehearsalMemory();
          final off = RehearsalPenalty.collapses(r, d, e);
          if (off) {
            j = ConductingJudgement(
              multiplierPermille: j.multiplierPermille,
              verdict: ConductingVerdict.collapse,
              reason: '練習と違いすぎて、合奏が崩れた',
            );
          }
          return PhraseResult(
            phrase: phrases[i],
            dynamics: d,
            expression: e,
            judgement: j,
            fitPermille: fit(phrases[i], d, e),
            rehearsalPenalty: RehearsalPenalty.penaltyPermille(r, d, e),
            offRehearsal: off,
          );
        }(),
    ]);
  }
}
