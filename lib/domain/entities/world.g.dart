// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'world.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_World _$WorldFromJson(Map<String, dynamic> json) => _World(
  seed: (json['seed'] as num).toInt(),
  seedCode: json['seedCode'] as String,
  generatorVersion: (json['generatorVersion'] as num).toInt(),
  config: WorldGenConfig.fromJson(json['config'] as Map<String, dynamic>),
  region: Region.fromJson(json['region'] as Map<String, dynamic>),
  schools: (json['schools'] as List<dynamic>)
      .map((e) => School.fromJson(e as Map<String, dynamic>))
      .toList(),
  clubs: (json['clubs'] as List<dynamic>)
      .map((e) => Club.fromJson(e as Map<String, dynamic>))
      .toList(),
  npcs: (json['npcs'] as List<dynamic>)
      .map((e) => Npc.fromJson(e as Map<String, dynamic>))
      .toList(),
  player: Player.fromJson(json['player'] as Map<String, dynamic>),
  memories: (json['memories'] as List<dynamic>)
      .map((e) => MemoryTag.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$WorldToJson(_World instance) => <String, dynamic>{
  'seed': instance.seed,
  'seedCode': instance.seedCode,
  'generatorVersion': instance.generatorVersion,
  'config': instance.config.toJson(),
  'region': instance.region.toJson(),
  'schools': instance.schools.map((e) => e.toJson()).toList(),
  'clubs': instance.clubs.map((e) => e.toJson()).toList(),
  'npcs': instance.npcs.map((e) => e.toJson()).toList(),
  'player': instance.player.toJson(),
  'memories': instance.memories.map((e) => e.toJson()).toList(),
};
