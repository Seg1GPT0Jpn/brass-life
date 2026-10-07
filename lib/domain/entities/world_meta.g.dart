// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'world_meta.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WorldMeta _$WorldMetaFromJson(Map<String, dynamic> json) => _WorldMeta(
  input: json['input'] as String,
  seed: (json['seed'] as num).toInt(),
  seedCode: json['seedCode'] as String,
  generatorVersion: (json['generatorVersion'] as num).toInt(),
  fingerprint: json['fingerprint'] as String,
);

Map<String, dynamic> _$WorldMetaToJson(_WorldMeta instance) =>
    <String, dynamic>{
      'input': instance.input,
      'seed': instance.seed,
      'seedCode': instance.seedCode,
      'generatorVersion': instance.generatorVersion,
      'fingerprint': instance.fingerprint,
    };
