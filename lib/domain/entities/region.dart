import 'package:freezed_annotation/freezed_annotation.dart';

part 'region.freezed.dart';
part 'region.g.dart';

/// 架空の県。コンクールの地区大会単位となる地区を持つ。
@freezed
abstract class Region with _$Region {
  const factory Region({
    required String prefectureName,

    /// 架空の吹奏楽連盟名。
    required String federationName,

    /// 架空のコンクール名。
    required String contestName,

    /// 支部大会の支部名（架空）。
    required String blockName,
    required List<District> districts,
  }) = _Region;

  factory Region.fromJson(Map<String, dynamic> json) => _$RegionFromJson(json);
}

/// 地区（地区大会の単位）。
@freezed
abstract class District with _$District {
  const factory District({
    required String id,
    required String name,

    /// 地区内の架空の市町名。
    required List<String> towns,
  }) = _District;

  factory District.fromJson(Map<String, dynamic> json) =>
      _$DistrictFromJson(json);
}
