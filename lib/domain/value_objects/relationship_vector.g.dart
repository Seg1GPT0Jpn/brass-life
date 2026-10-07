// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'relationship_vector.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RelationshipVector _$RelationshipVectorFromJson(Map<String, dynamic> json) =>
    _RelationshipVector(
      affection: (json['affection'] as num?)?.toInt() ?? 0,
      trust: (json['trust'] as num?)?.toInt() ?? 0,
      rivalry: (json['rivalry'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$RelationshipVectorToJson(_RelationshipVector instance) =>
    <String, dynamic>{
      'affection': instance.affection,
      'trust': instance.trust,
      'rivalry': instance.rivalry,
    };
