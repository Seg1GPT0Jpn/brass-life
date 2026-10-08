import '../models/game_enums.dart';
import '../models/game_state.dart';
import 'game_context.dart';

/// 空間 UI で選べる行動の候補（行動・選べるか・選べない理由）。
class InteractionOption {
  const InteractionOption(this.action, this.reason);

  final WeeklyAction action;

  /// 選べない理由（選べるなら null）。
  final String? reason;

  bool get enabled => reason == null;
}

/// 「どこで／誰に」行動できるかのルール。
///
/// ホーム画面のタップ対象（自分・部員・場所）ごとに選べる行動を返し、
/// 実行時（TimeManager.submitAction）にも同じルールで検証する。
class InteractionRules {
  const InteractionRules(this.ctx);

  final GameContext ctx;

  /// 「教わる」に必要な熟練度の差。
  static const int learnGap = 30;

  /// 「指導する」に必要な熟練度の差。
  static const int teachGap = 50;

  /// 自分をタップしたときの行動。
  List<InteractionOption> forSelf(GameState s) => [
    for (final a in const [
      WeeklyAction.basics,
      WeeklyAction.individualPractice,
      WeeklyAction.maintenance,
      WeeklyAction.extraPractice,
    ])
      InteractionOption(a, unavailableReason(s, a, null)),
  ];

  /// 部員をタップしたときの行動。
  List<InteractionOption> forMember(GameState s, String npcId) => [
    for (final a in const [
      WeeklyAction.practiceWith,
      WeeklyAction.learnFrom,
      WeeklyAction.teach,
      WeeklyAction.chat,
    ])
      InteractionOption(a, unavailableReason(s, a, npcId)),
  ];

  /// 行動を選べない理由（選べるなら null）。
  String? unavailableReason(
    GameState s,
    WeeklyAction action,
    String? targetId,
  ) {
    final p = s.player;
    // 従来の 7 行動（月の方針でも使う）は、退部中のパート練習・居残り以外は常に選べる。
    final needsInstrument =
        action == WeeklyAction.maintenance ||
        action == WeeklyAction.ensemble ||
        action == WeeklyAction.practiceWith ||
        action == WeeklyAction.learnFrom ||
        action == WeeklyAction.teach;
    if (needsInstrument && p.instrument == null) return '担当楽器が決まってから';
    if (p.quitClub &&
        (action == WeeklyAction.partPractice ||
            action == WeeklyAction.extraPractice ||
            action == WeeklyAction.ensemble ||
            action == WeeklyAction.maintenance ||
            action == WeeklyAction.practiceWith ||
            action == WeeklyAction.learnFrom ||
            action == WeeklyAction.teach)) {
      return '部を辞めている';
    }
    if (p.retired &&
        (action == WeeklyAction.ensemble ||
            action == WeeklyAction.practiceWith ||
            action == WeeklyAction.learnFrom ||
            action == WeeklyAction.teach)) {
      return '引退後は部活の練習に参加できない';
    }
    if (!action.needsTarget) {
      return targetId == null ? null : 'この行動に相手は不要';
    }
    if (targetId == null) return '相手を選んでください';
    final t = s.npcs[targetId];
    if (t == null || !t.active || t.retired || !s.roster.contains(targetId)) {
      return '今は部にいない';
    }
    switch (action) {
      case WeeklyAction.practiceWith:
        if (t.instrument == null) return '相手の楽器がまだ決まっていない';
      case WeeklyAction.learnFrom:
        if (t.instrument == null) return '相手の楽器がまだ決まっていない';
        if (t.instrument!.family != p.instrument!.family) {
          return '楽器の系統（${p.instrument!.family.label}）が違う';
        }
        if (t.skill < p.skill + learnGap) return '自分より十分に上手い相手から';
      case WeeklyAction.teach:
        if (t.instrument == null) return '相手の楽器がまだ決まっていない';
        if (t.instrument!.family != p.instrument!.family) {
          return '楽器の系統（${p.instrument!.family.label}）が違う';
        }
        if (p.skill < t.skill + teachGap) return '自分が十分に上手くないと指導できない';
      default:
        break;
    }
    return null;
  }
}
