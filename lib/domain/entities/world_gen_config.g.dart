// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'world_gen_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WorldGenConfig _$WorldGenConfigFromJson(Map<String, dynamic> json) =>
    _WorldGenConfig(
      middleSchoolCount: (json['middleSchoolCount'] as num?)?.toInt() ?? 40,
      highSchoolCount: (json['highSchoolCount'] as num?)?.toInt() ?? 24,
      districtCount: (json['districtCount'] as num?)?.toInt() ?? 5,
      startYear: (json['startYear'] as num?)?.toInt() ?? 2026,
      minNpcCount: (json['minNpcCount'] as num?)?.toInt() ?? 1000,
      maxNpcCount: (json['maxNpcCount'] as num?)?.toInt() ?? 2000,
      historyYears: (json['historyYears'] as num?)?.toInt() ?? 5,
    );

Map<String, dynamic> _$WorldGenConfigToJson(_WorldGenConfig instance) =>
    <String, dynamic>{
      'middleSchoolCount': instance.middleSchoolCount,
      'highSchoolCount': instance.highSchoolCount,
      'districtCount': instance.districtCount,
      'startYear': instance.startYear,
      'minNpcCount': instance.minNpcCount,
      'maxNpcCount': instance.maxNpcCount,
      'historyYears': instance.historyYears,
    };
