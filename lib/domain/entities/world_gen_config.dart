import 'package:freezed_annotation/freezed_annotation.dart';

part 'world_gen_config.freezed.dart';
part 'world_gen_config.g.dart';

/// 世界生成のパラメータ。
@freezed
abstract class WorldGenConfig with _$WorldGenConfig {
  const factory WorldGenConfig({
    @Default(40) int middleSchoolCount,
    @Default(24) int highSchoolCount,
    @Default(5) int districtCount,

    /// プレイヤーが中学 1 年になる年度（西暦）。
    @Default(2026) int startYear,

    /// NPC 総数の下限・上限。部員数の計画値がこの範囲外になった場合、
    /// 全部の部員数を比例的に補正して範囲内に収める。
    @Default(1000) int minNpcCount,
    @Default(2000) int maxNpcCount,

    /// 遡って生成するコンクール成績の年数。
    @Default(5) int historyYears,
  }) = _WorldGenConfig;

  factory WorldGenConfig.fromJson(Map<String, dynamic> json) =>
      _$WorldGenConfigFromJson(json);
}
