// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'personality.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PersonalityAxes _$PersonalityAxesFromJson(Map<String, dynamic> json) =>
    _PersonalityAxes(
      extraversion: (json['extraversion'] as num).toInt(),
      agreeableness: (json['agreeableness'] as num).toInt(),
      conscientiousness: (json['conscientiousness'] as num).toInt(),
      neuroticism: (json['neuroticism'] as num).toInt(),
      ambition: (json['ambition'] as num).toInt(),
    );

Map<String, dynamic> _$PersonalityAxesToJson(_PersonalityAxes instance) =>
    <String, dynamic>{
      'extraversion': instance.extraversion,
      'agreeableness': instance.agreeableness,
      'conscientiousness': instance.conscientiousness,
      'neuroticism': instance.neuroticism,
      'ambition': instance.ambition,
    };

_TraitTag _$TraitTagFromJson(Map<String, dynamic> json) => _TraitTag(
  traitId: json['traitId'] as String,
  intensity: (json['intensity'] as num).toInt(),
);

Map<String, dynamic> _$TraitTagToJson(_TraitTag instance) => <String, dynamic>{
  'traitId': instance.traitId,
  'intensity': instance.intensity,
};
