import 'uint32.dart';

/// xoshiro128** (Blackman & Vigna) の 32bit 演算のみによる実装。
///
/// 周期 2^128-1。全ての演算は [mul32] / [rotl32] / [shl32] を経由し、
/// VM と Web で同一の数列を生成する。
class Xoshiro128StarStar {
  Xoshiro128StarStar.fromState(List<int> state)
    : assert(state.length == 4),
      _s0 = u32(state[0]),
      _s1 = u32(state[1]),
      _s2 = u32(state[2]),
      _s3 = u32(state[3]) {
    if ((_s0 | _s1 | _s2 | _s3) == 0) _s0 = 1;
  }

  int _s0;
  int _s1;
  int _s2;
  int _s3;

  /// 次の 32bit 符号なし整数 (0..2^32-1)。
  int nextUint32() {
    final result = mul32(rotl32(mul32(_s1, 5), 7), 9);
    final t = shl32(_s1, 9);

    _s2 ^= _s0;
    _s3 ^= _s1;
    _s1 ^= _s2;
    _s0 ^= _s3;
    _s2 ^= t;
    _s3 = rotl32(_s3, 11);

    return result;
  }

  /// デバッグ・テスト用に現在の内部状態を返す。
  List<int> get state => [_s0, _s1, _s2, _s3];
}
