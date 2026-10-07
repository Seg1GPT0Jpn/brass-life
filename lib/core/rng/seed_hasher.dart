import 'dart:convert';

import 'uint32.dart';

/// Seed 文字列のハッシュ化・子 Seed の導出を行う。
///
/// `String.hashCode` は実行ごと／プラットフォームごとに値が変わりうるため使用禁止。
/// 代わりに UTF-8 バイト列に対する FNV-1a(32bit) と murmur3 の fmix32 を用いる。
abstract final class SeedHasher {
  static const int _fnvOffset = 0x811C9DC5;
  static const int _fnvPrime = 0x01000193;
  static const int _golden = 0x9E3779B9;

  /// UTF-8 バイト列に対する FNV-1a 32bit。
  static int fnv1a32(String input) {
    var h = _fnvOffset;
    for (final b in utf8.encode(input)) {
      h ^= b;
      h = mul32(h, _fnvPrime);
    }
    return h;
  }

  /// FNV-1a を任意の文字列に継続適用する（大きな文字列のフィンガープリント用）。
  static int fnv1a32Continue(int h, String input) {
    var v = h;
    for (final b in utf8.encode(input)) {
      v ^= b;
      v = mul32(v, _fnvPrime);
    }
    return v;
  }

  /// murmur3 finalizer。入力ビットを十分に拡散させる。
  static int fmix32(int x) {
    var h = u32(x);
    h ^= h >>> 16;
    h = mul32(h, 0x85EBCA6B);
    h ^= h >>> 13;
    h = mul32(h, 0xC2B2AE35);
    h ^= h >>> 16;
    return h;
  }

  /// 親 Seed とラベル（パス文字列）と整数列から子 Seed を決定論的に導出する。
  ///
  /// ラベルが異なれば（たとえ 1 文字違いでも）無相関な Seed が得られる。
  static int derive(int parent, String label, [List<int> ints = const []]) {
    var h = fmix32(u32(parent) ^ _golden);
    h = fmix32(h ^ fnv1a32(label));
    for (final i in ints) {
      // 負の値も扱えるよう、上位/下位を分けて混ぜる（Web でも安全な範囲）。
      final lo = u32(i);
      final hi = u32((i - lo) ~/ 0x100000000);
      h = fmix32(mul32(h, _fnvPrime) ^ lo);
      h = fmix32(h ^ hi ^ _golden);
    }
    return h;
  }

  /// SplitMix32 で 1 つの 32bit Seed から 128bit の内部状態を展開する。
  static List<int> expandState(int seed) {
    var state = u32(seed);
    final out = <int>[];
    for (var i = 0; i < 4; i++) {
      state = u32(state + _golden);
      var z = state;
      z = mul32(z ^ (z >>> 16), 0x85EBCA6B);
      z = mul32(z ^ (z >>> 13), 0xC2B2AE35);
      z ^= z >>> 16;
      out.add(z);
    }
    // xoshiro は全ゼロ状態だと停止するため保護する。
    if (out.every((v) => v == 0)) out[0] = 1;
    return out;
  }
}
