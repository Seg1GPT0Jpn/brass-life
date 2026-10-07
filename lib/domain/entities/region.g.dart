// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'region.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Region _$RegionFromJson(Map<String, dynamic> json) => _Region(
  prefectureName: json['prefectureName'] as String,
  federationName: json['federationName'] as String,
  contestName: json['contestName'] as String,
  blockName: json['blockName'] as String,
  districts: (json['districts'] as List<dynamic>)
      .map((e) => District.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$RegionToJson(_Region instance) => <String, dynamic>{
  'prefectureName': instance.prefectureName,
  'federationName': instance.federationName,
  'contestName': instance.contestName,
  'blockName': instance.blockName,
  'districts': instance.districts.map((e) => e.toJson()).toList(),
};

_District _$DistrictFromJson(Map<String, dynamic> json) => _District(
  id: json['id'] as String,
  name: json['name'] as String,
  towns: (json['towns'] as List<dynamic>).map((e) => e as String).toList(),
);

Map<String, dynamic> _$DistrictToJson(_District instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'towns': instance.towns,
};
