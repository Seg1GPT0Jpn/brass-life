/// 最大剰余法による整数配分。合計がちょうど [total] になる。
/// 剰余が同じ場合はインデックスの小さい方を優先する（決定論的）。
List<int> allocateLargestRemainder(int total, List<int> weights) {
  final sum = weights.fold(0, (a, b) => a + (b > 0 ? b : 0));
  if (total <= 0 || sum <= 0) return List.filled(weights.length, 0);

  final base = <int>[];
  final rema = <(int, int)>[]; // (剰余, index)
  var assigned = 0;
  for (var i = 0; i < weights.length; i++) {
    final w = weights[i] > 0 ? weights[i] : 0;
    final num = total * w;
    base.add(num ~/ sum);
    assigned += num ~/ sum;
    rema.add((num % sum, i));
  }
  rema.sort((a, b) {
    final c = b.$1.compareTo(a.$1);
    return c != 0 ? c : a.$2.compareTo(b.$2);
  });
  var left = total - assigned;
  for (final (_, i) in rema) {
    if (left <= 0) break;
    base[i]++;
    left--;
  }
  return base;
}
