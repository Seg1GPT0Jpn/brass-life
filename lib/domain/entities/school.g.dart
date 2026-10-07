// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'school.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_School _$SchoolFromJson(Map<String, dynamic> json) => _School(
  id: json['id'] as String,
  name: json['name'] as String,
  level: $enumDecode(_$SchoolLevelEnumMap, json['level']),
  ownership: $enumDecode(_$SchoolOwnershipEnumMap, json['ownership']),
  districtId: json['districtId'] as String,
  town: json['town'] as String,
  foundedYear: (json['foundedYear'] as num).toInt(),
  studentCount: (json['studentCount'] as num).toInt(),
  deviation: (json['deviation'] as num?)?.toInt(),
  academicLevel: (json['academicLevel'] as num).toInt(),
  cultures: (json['cultures'] as List<dynamic>)
      .map((e) => $enumDecode(_$SchoolCultureEnumMap, e))
      .toList(),
  clubId: json['clubId'] as String,
  girlsOnly: json['girlsOnly'] as bool? ?? false,
  affiliatedSchoolId: json['affiliatedSchoolId'] as String?,
);

Map<String, dynamic> _$SchoolToJson(_School instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'level': _$SchoolLevelEnumMap[instance.level]!,
  'ownership': _$SchoolOwnershipEnumMap[instance.ownership]!,
  'districtId': instance.districtId,
  'town': instance.town,
  'foundedYear': instance.foundedYear,
  'studentCount': instance.studentCount,
  'deviation': ?instance.deviation,
  'academicLevel': instance.academicLevel,
  'cultures': instance.cultures.map((e) => _$SchoolCultureEnumMap[e]!).toList(),
  'clubId': instance.clubId,
  'girlsOnly': instance.girlsOnly,
  'affiliatedSchoolId': ?instance.affiliatedSchoolId,
};

const _$SchoolLevelEnumMap = {
  SchoolLevel.middle: 'middle',
  SchoolLevel.high: 'high',
};

const _$SchoolOwnershipEnumMap = {
  SchoolOwnership.publicSchool: 'publicSchool',
  SchoolOwnership.privateSchool: 'privateSchool',
};

const _$SchoolCultureEnumMap = {
  SchoolCulture.free: 'free',
  SchoolCulture.strict: 'strict',
  SchoolCulture.academic: 'academic',
  SchoolCulture.balanced: 'balanced',
  SchoolCulture.traditional: 'traditional',
  SchoolCulture.newSchool: 'newSchool',
  SchoolCulture.clubFocused: 'clubFocused',
  SchoolCulture.community: 'community',
  SchoolCulture.international: 'international',
  SchoolCulture.arts: 'arts',
};
