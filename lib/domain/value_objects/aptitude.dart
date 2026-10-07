import 'package:freezed_annotation/freezed_annotation.dart';

import 'instrument.dart';

part 'aptitude.freezed.dart';
part 'aptitude.g.dart';

/// 音楽適性（各 0..100）。
@freezed
abstract class AptitudeStats with _$AptitudeStats {
  const factory AptitudeStats({
    required int pitch,
    required int rhythm,
    required int breath,
    required int dexterity,
    required int expression,
    required int reading,
  }) = _AptitudeStats;

  const AptitudeStats._();

  factory AptitudeStats.fromJson(Map<String, dynamic> json) =>
      _$AptitudeStatsFromJson(json);

  int valueOf(AptitudeKind kind) => switch (kind) {
    AptitudeKind.pitch => pitch,
    AptitudeKind.rhythm => rhythm,
    AptitudeKind.breath => breath,
    AptitudeKind.dexterity => dexterity,
    AptitudeKind.expression => expression,
    AptitudeKind.reading => reading,
  };

  /// 楽器適性スコア（0..100）。楽器ごとの適性重みによる加重平均。
  int fitFor(InstrumentType type) {
    var sum = 0;
    var total = 0;
    type.aptitudeWeights.forEach((kind, w) {
      sum += valueOf(kind) * w;
      total += w;
    });
    return total == 0 ? 0 : sum ~/ total;
  }

  /// 全楽器の適性を高い順に並べたもの（同点は楽器定義順）。
  List<(InstrumentType, int)> rankedFits() {
    final list = [for (final t in InstrumentType.values) (t, fitFor(t))];
    list.sort((a, b) {
      final c = b.$2.compareTo(a.$2);
      return c != 0 ? c : a.$1.index.compareTo(b.$1.index);
    });
    return list;
  }
}
