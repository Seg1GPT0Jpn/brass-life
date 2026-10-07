// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'memory_tag.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MemoryTag _$MemoryTagFromJson(Map<String, dynamic> json) => _MemoryTag(
  id: json['id'] as String,
  date: GameDate.fromJson(json['date'] as Map<String, dynamic>),
  category: $enumDecode(_$MemoryCategoryEnumMap, json['category']),
  subjectId: json['subjectId'] as String,
  objectIds:
      (json['objectIds'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
  reasonKey: json['reasonKey'] as String,
  params:
      (json['params'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ) ??
      const <String, String>{},
  delta: json['delta'] == null
      ? null
      : RelationshipVector.fromJson(json['delta'] as Map<String, dynamic>),
  importance: (json['importance'] as num).toInt(),
  visibility: $enumDecode(_$MemoryVisibilityEnumMap, json['visibility']),
);

Map<String, dynamic> _$MemoryTagToJson(_MemoryTag instance) =>
    <String, dynamic>{
      'id': instance.id,
      'date': instance.date.toJson(),
      'category': _$MemoryCategoryEnumMap[instance.category]!,
      'subjectId': instance.subjectId,
      'objectIds': instance.objectIds,
      'reasonKey': instance.reasonKey,
      'params': instance.params,
      'delta': ?instance.delta?.toJson(),
      'importance': instance.importance,
      'visibility': _$MemoryVisibilityEnumMap[instance.visibility]!,
    };

const _$MemoryCategoryEnumMap = {
  MemoryCategory.joinedClub: 'joinedClub',
  MemoryCategory.contestResult: 'contestResult',
  MemoryCategory.appointment: 'appointment',
  MemoryCategory.practice: 'practice',
  MemoryCategory.conflict: 'conflict',
  MemoryCategory.reconciliation: 'reconciliation',
  MemoryCategory.audition: 'audition',
  MemoryCategory.academic: 'academic',
  MemoryCategory.life: 'life',
  MemoryCategory.rumor: 'rumor',
};

const _$MemoryVisibilityEnumMap = {
  MemoryVisibility.selfOnly: 'selfOnly',
  MemoryVisibility.involved: 'involved',
  MemoryVisibility.rumored: 'rumored',
  MemoryVisibility.public: 'public',
};
