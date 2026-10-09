import '../../value_objects/relationship_vector.dart';
import '../models/game_enums.dart';
import '../models/game_state.dart';
import 'relations.dart';

/// やる気の伝播: 幹部や人望のある部員のやる気の変化が、同じパート（楽器）の部員に波及する。
///
/// - 発信者: 役職（パートリーダーを含む）がある部員、人望のある性格（リーダー気質・ムードメーカー・
///   面倒見がいい）の部員、または同じパートの仲間からの信頼の平均が [popularTrust] 以上の部員。
/// - その週の発信者のやる気の変化が [minDelta] 以上なら、同じパートの部員に伝わる。
///   伝わる量 = 変化 × (30 + 受け手から発信者への信頼(0..60)×2)% × (幹部 1.0 / 人望 0.7)（±4 まで）。
/// - 受け手ごとに合計してから一度に反映するので、処理の順番に結果が左右されない。
///   ループは ID 順で、乱数は使わない（決定論）。
abstract final class MotivationSpread {
  static const int popularTrust = 10;
  static const int minDelta = 3;
  static const int maxPerSource = 4;

  /// 伝播後の NPC 状態と、伝わった量（受け手 ID → 変化）を返す。
  static ({Map<String, NpcState> npcs, Map<String, int> received}) apply({
    required Map<String, NpcState> before,
    required Map<String, NpcState> after,
    required Map<String, RelationshipVector> relations,
    required Map<String, ClubRole> roles,
    bool Function(String id)? isPopular,
  }) {
    final ids = [
      for (final e in after.entries)
        if (e.value.active && !e.value.retired && e.value.instrument != null)
          e.key,
    ]..sort();
    // パート（楽器）ごとの部員
    final parts = <String, List<String>>{};
    for (final id in ids) {
      (parts[after[id]!.instrument!.name] ??= []).add(id);
    }
    final received = <String, int>{};
    for (final src in ids) {
      final prev = before[src];
      if (prev == null) continue;
      final delta = after[src]!.motivation - prev.motivation;
      if (delta.abs() < minDelta) continue;
      final mates = parts[after[src]!.instrument!.name]!
          .where((id) => id != src)
          .toList();
      if (mates.isEmpty) continue;
      final leader = roles.containsKey(src);
      var trustSum = 0;
      for (final m in mates) {
        trustSum += Relations.of(relations, m, src).trust;
      }
      final popular =
          (isPopular?.call(src) ?? false) ||
          trustSum ~/ mates.length >= popularTrust;
      if (!leader && !popular) continue;
      final weight = leader ? 100 : 70;
      for (final m in mates) {
        final trust = Relations.of(relations, m, src).trust.clamp(0, 60);
        final amount = (delta * (30 + trust * 2) * weight ~/ 10000).clamp(
          -maxPerSource,
          maxPerSource,
        );
        if (amount != 0) received[m] = (received[m] ?? 0) + amount;
      }
    }
    if (received.isEmpty) return (npcs: after, received: received);
    final out = Map.of(after);
    for (final e in received.entries) {
      final st = out[e.key]!;
      out[e.key] = st.copyWith(
        motivation: (st.motivation + e.value).clamp(0, 100),
      );
    }
    return (npcs: out, received: received);
  }
}
