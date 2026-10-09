import '../models/game_enums.dart';
import '../models/game_state.dart';
import 'game_context.dart';
import 'relations.dart';

/// 引退ショック: 3 年生が抜けた直後、部の技術とテンションが一時的に落ち込む。
///
/// - 技術の落ち込み = 抜けた人の熟練度の合計 ÷ 残る部員数 ÷ 12（抜けた人がいれば 3 以上）
/// - テンションの落ち込み = 3 + 抜けた人数 × 8 ÷ 残る部員数 + 抜けた幹部（パートリーダー以外）× 2
///   + 残る部員から抜けた人への信頼の合計 ÷ 残る部員数 ÷ 4
/// - どちらも最大 [max]。毎週テンションは 1、技術は 2 週に 1 ずつ戻る（[recover]）。
abstract final class RetirementShock {
  static const int max = 20;

  static ClubCondition of(
    GameState s,
    List<String> retirees, {
    required int Function(String id) skillOf,
  }) {
    if (retirees.isEmpty) return const ClubCondition();
    final remaining = [
      for (final id in [...s.roster]..sort())
        if (s.npcs[id] != null &&
            s.npcs[id]!.active &&
            !s.npcs[id]!.retired &&
            !retirees.contains(id))
          id,
    ];
    final n = remaining.isEmpty ? 1 : remaining.length;
    var skill = 0;
    for (final id in retirees) {
      skill += skillOf(id);
    }
    var trust = 0;
    for (final m in remaining) {
      for (final r in retirees) {
        trust += Relations.get(s, m, r).trust.clamp(0, 100);
      }
    }
    // 幹部（パートリーダーは除く）
    final officers = retirees
        .where(
          (id) => s.roles[id] != null && s.roles[id] != ClubRole.partLeader,
        )
        .length;
    return ClubCondition(
      techniqueShock: (skill ~/ n ~/ 12).clamp(3, max),
      tensionShock:
          (3 + retirees.length * 8 ~/ n + officers * 2 + trust ~/ n ~/ 4).clamp(
            3,
            max,
          ),
    );
  }

  /// 1 週間ぶんの回復。
  static ClubCondition recover(ClubCondition c, int turn) => ClubCondition(
    techniqueShock: turn.isEven && c.techniqueShock > 0
        ? c.techniqueShock - 1
        : c.techniqueShock,
    tensionShock: c.tensionShock > 0 ? c.tensionShock - 1 : 0,
  );

  /// 調子を部の指標に反映する（熟練度は 1 につき 5、やる気は 1 につき 1 下がる）。
  static ({int avgSkill, int avgMotivation}) applyTo(
    GameContext ctx,
    ClubCondition c,
    int avgSkill,
    int avgMotivation,
  ) => (
    avgSkill: (avgSkill - c.techniqueShock * 5).clamp(0, 1000),
    avgMotivation: (avgMotivation - c.tensionShock).clamp(0, 100),
  );
}
