// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_date.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GameDate _$GameDateFromJson(Map<String, dynamic> json) => _GameDate(
  turn: (json['turn'] as num).toInt(),
  year: (json['year'] as num).toInt(),
  month: (json['month'] as num).toInt(),
  day: (json['day'] as num).toInt(),
  weekOfMonth: (json['weekOfMonth'] as num).toInt(),
  weeksInMonth: (json['weeksInMonth'] as num).toInt(),
  academicYearIndex: (json['academicYearIndex'] as num).toInt(),
  weekOfAcademicYear: (json['weekOfAcademicYear'] as num).toInt(),
);

Map<String, dynamic> _$GameDateToJson(_GameDate instance) => <String, dynamic>{
  'turn': instance.turn,
  'year': instance.year,
  'month': instance.month,
  'day': instance.day,
  'weekOfMonth': instance.weekOfMonth,
  'weeksInMonth': instance.weeksInMonth,
  'academicYearIndex': instance.academicYearIndex,
  'weekOfAcademicYear': instance.weekOfAcademicYear,
};
