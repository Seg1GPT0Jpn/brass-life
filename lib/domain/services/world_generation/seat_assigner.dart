import '../../../core/rng/rng_stream.dart';
import '../../entities/club.dart';
import '../../entities/npc.dart';
import '../../value_objects/instrument.dart';
import 'allocation.dart';

/// 担当楽器の決まっている上級生への楽器割当。ストリーム: `world/club/{id}/seats`。
///
/// 1. 標準編成比に揺らぎを加えた重みで、上級生の人数分の「席」を楽器ごとに配分する。
/// 2. 各席を、学校所有の使用可能な楽器 → 私物（私物率で判定）→ 空きのある別楽器へ振替
///    の順で解決する。どこにも空きがなければ私物を持ちやすい楽器を私物で担当する。
/// 3. 席をシャッフルし、各席に「楽器適性の二乗」を重みとして部員を割り当てる。
abstract final class SeatAssigner {
  static List<(InstrumentType, bool)> resolveSeats(
    RngStream rng, {
    required int seatCount,
    required Club club,
  }) {
    final types = InstrumentType.values;
    final weights = [
      for (final t in types) t.standardRatio * 100 + rng.range(-30, 30),
    ];
    final alloc = allocateLargestRemainder(seatCount, weights);
    final used = List.filled(types.length, 0);
    final usable = [for (final t in types) club.usableCount(t)];

    final seats = <(InstrumentType, bool)>[];
    for (var i = 0; i < types.length; i++) {
      for (var k = 0; k < alloc[i]; k++) {
        final personalRoll = rng.chance(types[i].personalPermyriad);
        if (used[i] < usable[i]) {
          used[i]++;
          seats.add((types[i], false));
        } else if (personalRoll) {
          seats.add((types[i], true));
        } else {
          final open = [
            for (var j = 0; j < types.length; j++)
              if (used[j] < usable[j]) j,
          ];
          if (open.isNotEmpty) {
            final j = rng.weighted(open, [
              for (final j in open) types[j].standardRatio + 1,
            ]);
            used[j]++;
            seats.add((types[j], false));
          } else {
            final t = rng.weighted(types, [
              for (final t in types) t.personalPermyriad,
            ]);
            seats.add((t, true));
          }
        }
      }
    }
    return seats;
  }

  /// [members] に席を割り当て、楽器・私物フラグ付きの NPC を返す（入力順を維持）。
  static List<Npc> assign(
    RngStream rng, {
    required List<Npc> members,
    required List<(InstrumentType, bool)> seats,
  }) {
    final order = rng.shuffled(seats);
    final remaining = List.of(members);
    final result = <String, Npc>{};
    for (final (type, personal) in order) {
      if (remaining.isEmpty) break;
      final w = [
        for (final m in remaining)
          () {
            final fit = m.aptitude.fitFor(type);
            return fit * fit ~/ 50 + 1;
          }(),
      ];
      final idx = rng.weightedIndex(w);
      final m = remaining.removeAt(idx);
      result[m.id] = m.copyWith(
        instrument: type,
        ownsPersonalInstrument: personal,
      );
    }
    return [for (final m in members) result[m.id] ?? m];
  }
}
