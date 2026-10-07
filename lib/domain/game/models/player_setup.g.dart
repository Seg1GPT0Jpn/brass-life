// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_setup.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PlayerSetup _$PlayerSetupFromJson(Map<String, dynamic> json) => _PlayerSetup(
  familyName: json['familyName'] as String,
  givenName: json['givenName'] as String,
  gender: $enumDecode(_$GenderEnumMap, json['gender']),
  schoolId: json['schoolId'] as String,
  background: $enumDecode(_$MusicBackgroundEnumMap, json['background']),
  personality: PersonalityAxes.fromJson(
    json['personality'] as Map<String, dynamic>,
  ),
  aptitude: AptitudeStats.fromJson(json['aptitude'] as Map<String, dynamic>),
  academic: (json['academic'] as num).toInt(),
  stamina: (json['stamina'] as num).toInt(),
);

Map<String, dynamic> _$PlayerSetupToJson(_PlayerSetup instance) =>
    <String, dynamic>{
      'familyName': instance.familyName,
      'givenName': instance.givenName,
      'gender': _$GenderEnumMap[instance.gender]!,
      'schoolId': instance.schoolId,
      'background': _$MusicBackgroundEnumMap[instance.background]!,
      'personality': instance.personality.toJson(),
      'aptitude': instance.aptitude.toJson(),
      'academic': instance.academic,
      'stamina': instance.stamina,
    };

const _$GenderEnumMap = {Gender.female: 'female', Gender.male: 'male'};

const _$MusicBackgroundEnumMap = {
  MusicBackground.none: 'none',
  MusicBackground.piano: 'piano',
  MusicBackground.elementaryBand: 'elementaryBand',
  MusicBackground.middleSchoolBand: 'middleSchoolBand',
};
