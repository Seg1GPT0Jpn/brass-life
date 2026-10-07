import 'prng_core.dart';
import 'seed_hasher.dart';

/// 1 本の決定論的乱数ストリームと、その上に構築された分布関数群。
///
/// 決定性を保つための規約:
/// - 確率は浮動小数ではなく万分率 (permyriad, 0..10000) の整数で表す。
/// - 正規分布は超越関数(log/sin)を使わず Irwin–Hall 近似で生成する。
/// - 候補リストは呼び出し側で安定ソート済みであることを前提とする。
class RngStream {
  RngStream(this.seed)
    : _core = Xoshiro128StarStar.fromState(SeedHasher.expandState(seed));

  /// このストリームを生成した Seed（デバッグ表示用）。
  final int seed;
  final Xoshiro128StarStar _core;
  int _draws = 0;

  /// これまでに消費した 32bit 値の個数（デバッグ・テスト用）。
  int get draws => _draws;

  static const int _two32 = 0x100000000;

  /// 次の 32bit 符号なし整数。
  int nextUint32() {
    _draws++;
    return _core.nextUint32();
  }

  /// [0, n) の一様整数。棄却サンプリングにより剰余バイアスを除去する。
  int nextInt(int n) {
    if (n <= 0) {
      throw ArgumentError.value(n, 'n', 'must be positive');
    }
    if (n > _two32) {
      throw ArgumentError.value(n, 'n', 'must be <= 2^32');
    }
    final limit = _two32 - (_two32 % n);
    while (true) {
      final r = nextUint32();
      if (r < limit) return r % n;
    }
  }

  /// [min, max] の一様整数（両端を含む）。
  int range(int min, int max) {
    if (max < min) {
      throw ArgumentError('range: max($max) < min($min)');
    }
    return min + nextInt(max - min + 1);
  }

  /// [0, 1) の一様実数。53bit 精度で、Web でも VM と同値になる。
  double nextDouble() {
    final a = nextUint32() >>> 5; // 27bit
    final b = nextUint32() >>> 6; // 26bit
    return (a * 67108864 + b) / 9007199254740992;
  }

  /// 万分率 [permyriad] (0..10000) で true を返す。
  bool chance(int permyriad) {
    if (permyriad <= 0) return false;
    if (permyriad >= 10000) return true;
    return nextInt(10000) < permyriad;
  }

  /// 標準正規分布の近似値（Irwin–Hall: 一様乱数 12 個の和 - 6）。
  /// 値域は [-6, 6]。加減算のみなのでプラットフォーム差が生じない。
  double standardNormal() {
    var sum = 0.0;
    for (var i = 0; i < 12; i++) {
      sum += nextDouble();
    }
    return sum - 6.0;
  }

  /// 平均 [mean]・標準偏差 [sd] の正規分布近似を整数に丸め、[min]..[max] に収める。
  int normalInt({
    required int mean,
    required int sd,
    required int min,
    required int max,
  }) {
    final v = mean + standardNormal() * sd;
    final rounded = v.round();
    if (rounded < min) return min;
    if (rounded > max) return max;
    return rounded;
  }

  /// 整数重みによる抽選。戻り値は選ばれたインデックス。
  /// 重みが全て 0 以下の場合は一様抽選にフォールバックする。
  int weightedIndex(List<int> weights) {
    if (weights.isEmpty) {
      throw ArgumentError('weightedIndex: empty weights');
    }
    var total = 0;
    for (final w in weights) {
      if (w > 0) total += w;
    }
    if (total <= 0) return nextInt(weights.length);
    var r = nextInt(total);
    for (var i = 0; i < weights.length; i++) {
      final w = weights[i];
      if (w <= 0) continue;
      if (r < w) return i;
      r -= w;
    }
    return weights.length - 1; // 到達しない
  }

  /// 候補と重みのペアから 1 つ選ぶ。
  T weighted<T>(List<T> items, List<int> weights) {
    if (items.length != weights.length) {
      throw ArgumentError('weighted: length mismatch');
    }
    return items[weightedIndex(weights)];
  }

  /// リストから一様に 1 つ選ぶ。
  T pick<T>(List<T> items) {
    if (items.isEmpty) throw ArgumentError('pick: empty list');
    return items[nextInt(items.length)];
  }

  /// Fisher–Yates シャッフル（新しいリストを返す。元のリストは変更しない）。
  List<T> shuffled<T>(List<T> items) {
    final list = List<T>.of(items);
    for (var i = list.length - 1; i > 0; i--) {
      final j = nextInt(i + 1);
      final tmp = list[i];
      list[i] = list[j];
      list[j] = tmp;
    }
    return list;
  }

  /// 非復元抽出で [count] 個選ぶ（順序は抽選順）。
  List<T> sample<T>(List<T> items, int count) {
    final n = count > items.length ? items.length : count;
    final list = List<T>.of(items);
    for (var i = 0; i < n; i++) {
      final j = i + nextInt(list.length - i);
      final tmp = list[i];
      list[i] = list[j];
      list[j] = tmp;
    }
    return list.sublist(0, n);
  }

  /// 重み付き非復元抽出で [count] 個選ぶ。
  List<T> weightedSample<T>(List<T> items, List<int> weights, int count) {
    final pool = List<T>.of(items);
    final w = List<int>.of(weights);
    final out = <T>[];
    while (out.length < count && pool.isNotEmpty) {
      final idx = weightedIndex(w);
      out.add(pool.removeAt(idx));
      w.removeAt(idx);
    }
    return out;
  }

  /// このストリームから独立した子ストリームを派生させる。
  /// 子ストリームの消費は親の数列に影響しない（ラベルで決まる）。
  RngStream fork(String label, [List<int> ints = const []]) =>
      RngStream(SeedHasher.derive(seed, label, ints));
}
