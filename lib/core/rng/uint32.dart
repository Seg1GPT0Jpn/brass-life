/// 32bit 符号なし整数演算ユーティリティ。
///
/// Web(dart2js) では int が IEEE754 倍精度で表現されるため、
/// 2^53 を超える中間値が出る演算（32bit×32bit の乗算など）は精度を失う。
/// ここでは全ての演算を 2^53 未満の中間値で完結させ、
/// VM / Web / Wasm のどこで実行しても同一のビット列を返すことを保証する。
library;

const int kMask32 = 0xFFFFFFFF;

/// 32bit に正規化（常に 0..2^32-1 の非負値を返す）。
int u32(int x) => x & kMask32;

/// 32bit 乗算の下位 32bit（JavaScript の Math.imul 相当、ただし符号なし）。
///
/// a, b を 16bit ずつに分割し、各部分積が 2^33 未満に収まるようにしている。
int mul32(int a, int b) {
  final al = a & 0xFFFF;
  final ah = (a >>> 16) & 0xFFFF;
  final bl = b & 0xFFFF;
  final bh = (b >>> 16) & 0xFFFF;
  final low = al * bl; // < 2^32
  final cross = ((ah * bl + al * bh) & 0xFFFF) << 16; // < 2^32
  return (low + cross) & kMask32;
}

/// 32bit 左ローテート。
int rotl32(int x, int k) {
  final v = x & kMask32;
  return ((v << k) & kMask32) | (v >>> (32 - k));
}

/// 32bit 左シフト（はみ出したビットを捨てる）。
int shl32(int x, int k) => ((x & kMask32) << k) & kMask32;
