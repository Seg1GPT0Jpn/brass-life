// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'save_summary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SaveSummary _$SaveSummaryFromJson(Map<String, dynamic> json) => _SaveSummary(
  slot: json['slot'] as String,
  worldSeed: (json['worldSeed'] as num).toInt(),
  seedCode: json['seedCode'] as String,
  playerName: json['playerName'] as String,
  dateLabel: json['dateLabel'] as String,
  schoolName: json['schoolName'] as String,
  savedAt: json['savedAt'] as String,
);

Map<String, dynamic> _$SaveSummaryToJson(_SaveSummary instance) =>
    <String, dynamic>{
      'slot': instance.slot,
      'worldSeed': instance.worldSeed,
      'seedCode': instance.seedCode,
      'playerName': instance.playerName,
      'dateLabel': instance.dateLabel,
      'schoolName': instance.schoolName,
      'savedAt': instance.savedAt,
    };
