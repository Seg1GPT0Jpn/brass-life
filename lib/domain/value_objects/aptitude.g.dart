// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'aptitude.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AptitudeStats _$AptitudeStatsFromJson(Map<String, dynamic> json) =>
    _AptitudeStats(
      pitch: (json['pitch'] as num).toInt(),
      rhythm: (json['rhythm'] as num).toInt(),
      breath: (json['breath'] as num).toInt(),
      dexterity: (json['dexterity'] as num).toInt(),
      expression: (json['expression'] as num).toInt(),
      reading: (json['reading'] as num).toInt(),
    );

Map<String, dynamic> _$AptitudeStatsToJson(_AptitudeStats instance) =>
    <String, dynamic>{
      'pitch': instance.pitch,
      'rhythm': instance.rhythm,
      'breath': instance.breath,
      'dexterity': instance.dexterity,
      'expression': instance.expression,
      'reading': instance.reading,
    };
