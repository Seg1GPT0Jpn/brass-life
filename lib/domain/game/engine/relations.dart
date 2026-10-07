import '../../value_objects/relationship_vector.dart';
import '../models/game_state.dart';

/// 関係性ベクトルの読み書き（有向: 主体から見た相手）。
abstract final class Relations {
  static const String player = 'player';

  static String key(String from, String to) => '$from>$to';

  static RelationshipVector of(
    Map<String, RelationshipVector> m,
    String from,
    String to,
  ) => m[key(from, to)] ?? const RelationshipVector();

  static RelationshipVector get(GameState s, String from, String to) =>
      of(s.relations, from, to);

  static void add(
    Map<String, RelationshipVector> m,
    String from,
    String to,
    RelationshipVector delta,
  ) {
    if (from == to || delta.isZero) return;
    m[key(from, to)] = of(m, from, to) + delta;
  }

  /// 双方向に同じ変化を加える。
  static void addMutual(
    Map<String, RelationshipVector> m,
    String a,
    String b,
    RelationshipVector delta,
  ) {
    add(m, a, b, delta);
    add(m, b, a, delta);
  }

  /// 0 へ向けて 1 ずつ戻す（感情の風化）。
  static Map<String, RelationshipVector> decay(
    Map<String, RelationshipVector> m,
  ) {
    int toward0(int v) => v > 0 ? v - 1 : (v < 0 ? v + 1 : 0);
    final out = <String, RelationshipVector>{};
    for (final e in m.entries) {
      final v = e.value;
      final n = RelationshipVector(
        affection: toward0(v.affection),
        trust: toward0(v.trust),
        rivalry: toward0(v.rivalry),
      );
      if (!n.isZero) out[e.key] = n;
    }
    return out;
  }
}
