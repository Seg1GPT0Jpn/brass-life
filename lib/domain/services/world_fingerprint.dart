import 'dart:convert';

import '../../core/rng/seed_hasher.dart';
import '../entities/world.dart';

/// 世界全体の正規化 JSON に対するハッシュ。
/// 同じ Seed から再生成した世界が完全一致しているかの確認に用いる。
abstract final class WorldFingerprint {
  static String compute(World world) {
    final json = jsonEncode(world.toJson());
    final h1 = SeedHasher.fnv1a32(json);
    final h2 = SeedHasher.fmix32(h1 ^ json.length);
    return '${_hex(h1)}${_hex(h2)}';
  }

  static String _hex(int v) =>
      v.toRadixString(16).padLeft(8, '0').toUpperCase();
}
