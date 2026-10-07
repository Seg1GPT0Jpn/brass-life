// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Player _$PlayerFromJson(Map<String, dynamic> json) => _Player(
  id: json['id'] as String,
  familyName: json['familyName'] as String,
  givenName: json['givenName'] as String,
  gender: $enumDecode(_$GenderEnumMap, json['gender']),
  schoolId: json['schoolId'] as String,
  grade: (json['grade'] as num).toInt(),
  personality: PersonalityAxes.fromJson(
    json['personality'] as Map<String, dynamic>,
  ),
  traits: (json['traits'] as List<dynamic>)
      .map((e) => TraitTag.fromJson(e as Map<String, dynamic>))
      .toList(),
  aptitude: AptitudeStats.fromJson(json['aptitude'] as Map<String, dynamic>),
  academic: (json['academic'] as num).toInt(),
  stamina: (json['stamina'] as num).toInt(),
  background: $enumDecode(_$MusicBackgroundEnumMap, json['background']),
);

Map<String, dynamic> _$PlayerToJson(_Player instance) => <String, dynamic>{
  'id': instance.id,
  'familyName': instance.familyName,
  'givenName': instance.givenName,
  'gender': _$GenderEnumMap[instance.gender]!,
  'schoolId': instance.schoolId,
  'grade': instance.grade,
  'personality': instance.personality.toJson(),
  'traits': instance.traits.map((e) => e.toJson()).toList(),
  'aptitude': instance.aptitude.toJson(),
  'academic': instance.academic,
  'stamina': instance.stamina,
  'background': _$MusicBackgroundEnumMap[instance.background]!,
};

const _$GenderEnumMap = {Gender.female: 'female', Gender.male: 'male'};

const _$MusicBackgroundEnumMap = {
  MusicBackground.none: 'none',
  MusicBackground.piano: 'piano',
  MusicBackground.elementaryBand: 'elementaryBand',
  MusicBackground.middleSchoolBand: 'middleSchoolBand',
};
