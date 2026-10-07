// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'club.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Club _$ClubFromJson(Map<String, dynamic> json) => _Club(
  id: json['id'] as String,
  schoolId: json['schoolId'] as String,
  tier: $enumDecode(_$ClubTierEnumMap, json['tier']),
  tradition: (json['tradition'] as num).toInt(),
  practiceIntensity: (json['practiceIntensity'] as num).toInt(),
  mood: $enumDecode(_$ClubMoodEnumMap, json['mood']),
  executiveSystem: $enumDecode(
    _$ExecutiveSystemEnumMap,
    json['executiveSystem'],
  ),
  selectionCulture: $enumDecode(
    _$SelectionCultureEnumMap,
    json['selectionCulture'],
  ),
  budget: $enumDecode(_$BudgetBandEnumMap, json['budget']),
  division: $enumDecode(_$BandDivisionEnumMap, json['division']),
  advisorId: json['advisorId'] as String,
  coachId: json['coachId'] as String?,
  inventory: (json['inventory'] as List<dynamic>)
      .map((e) => InstrumentSlot.fromJson(e as Map<String, dynamic>))
      .toList(),
  history: (json['history'] as List<dynamic>)
      .map((e) => ContestRecord.fromJson(e as Map<String, dynamic>))
      .toList(),
  memberIds: (json['memberIds'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
);

Map<String, dynamic> _$ClubToJson(_Club instance) => <String, dynamic>{
  'id': instance.id,
  'schoolId': instance.schoolId,
  'tier': _$ClubTierEnumMap[instance.tier]!,
  'tradition': instance.tradition,
  'practiceIntensity': instance.practiceIntensity,
  'mood': _$ClubMoodEnumMap[instance.mood]!,
  'executiveSystem': _$ExecutiveSystemEnumMap[instance.executiveSystem]!,
  'selectionCulture': _$SelectionCultureEnumMap[instance.selectionCulture]!,
  'budget': _$BudgetBandEnumMap[instance.budget]!,
  'division': _$BandDivisionEnumMap[instance.division]!,
  'advisorId': instance.advisorId,
  'coachId': ?instance.coachId,
  'inventory': instance.inventory.map((e) => e.toJson()).toList(),
  'history': instance.history.map((e) => e.toJson()).toList(),
  'memberIds': instance.memberIds,
};

const _$ClubTierEnumMap = {
  ClubTier.national: 'national',
  ClubTier.block: 'block',
  ClubTier.prefectural: 'prefectural',
  ClubTier.district: 'district',
  ClubTier.weak: 'weak',
};

const _$ClubMoodEnumMap = {
  ClubMood.strict: 'strict',
  ClubMood.competitive: 'competitive',
  ClubMood.harmonious: 'harmonious',
  ClubMood.relaxed: 'relaxed',
  ClubMood.factional: 'factional',
};

const _$ExecutiveSystemEnumMap = {
  ExecutiveSystem.a: 'a',
  ExecutiveSystem.b: 'b',
  ExecutiveSystem.c: 'c',
};

const _$SelectionCultureEnumMap = {
  SelectionCulture.vote: 'vote',
  SelectionCulture.nomination: 'nomination',
  SelectionCulture.advisorAppointment: 'advisorAppointment',
  SelectionCulture.discussion: 'discussion',
};

const _$BudgetBandEnumMap = {
  BudgetBand.low: 'low',
  BudgetBand.mid: 'mid',
  BudgetBand.high: 'high',
};

const _$BandDivisionEnumMap = {
  BandDivision.large: 'large',
  BandDivision.small: 'small',
};

_InstrumentSlot _$InstrumentSlotFromJson(Map<String, dynamic> json) =>
    _InstrumentSlot(
      type: $enumDecode(_$InstrumentTypeEnumMap, json['type']),
      count: (json['count'] as num).toInt(),
      condition: $enumDecode(_$InstrumentConditionEnumMap, json['condition']),
    );

Map<String, dynamic> _$InstrumentSlotToJson(_InstrumentSlot instance) =>
    <String, dynamic>{
      'type': _$InstrumentTypeEnumMap[instance.type]!,
      'count': instance.count,
      'condition': _$InstrumentConditionEnumMap[instance.condition]!,
    };

const _$InstrumentTypeEnumMap = {
  InstrumentType.piccolo: 'piccolo',
  InstrumentType.flute: 'flute',
  InstrumentType.oboe: 'oboe',
  InstrumentType.bassoon: 'bassoon',
  InstrumentType.ebClarinet: 'ebClarinet',
  InstrumentType.clarinet: 'clarinet',
  InstrumentType.bassClarinet: 'bassClarinet',
  InstrumentType.altoSax: 'altoSax',
  InstrumentType.tenorSax: 'tenorSax',
  InstrumentType.baritoneSax: 'baritoneSax',
  InstrumentType.trumpet: 'trumpet',
  InstrumentType.horn: 'horn',
  InstrumentType.trombone: 'trombone',
  InstrumentType.bassTrombone: 'bassTrombone',
  InstrumentType.euphonium: 'euphonium',
  InstrumentType.tuba: 'tuba',
  InstrumentType.stringBass: 'stringBass',
  InstrumentType.percussion: 'percussion',
};

const _$InstrumentConditionEnumMap = {
  InstrumentCondition.excellent: 'excellent',
  InstrumentCondition.good: 'good',
  InstrumentCondition.worn: 'worn',
  InstrumentCondition.needsRepair: 'needsRepair',
};

_ContestRecord _$ContestRecordFromJson(Map<String, dynamic> json) =>
    _ContestRecord(
      fiscalYear: (json['fiscalYear'] as num).toInt(),
      division: $enumDecode(_$BandDivisionEnumMap, json['division']),
      stage: $enumDecode(_$ContestStageEnumMap, json['stage']),
      award: $enumDecode(_$ContestAwardEnumMap, json['award']),
    );

Map<String, dynamic> _$ContestRecordToJson(_ContestRecord instance) =>
    <String, dynamic>{
      'fiscalYear': instance.fiscalYear,
      'division': _$BandDivisionEnumMap[instance.division]!,
      'stage': _$ContestStageEnumMap[instance.stage]!,
      'award': _$ContestAwardEnumMap[instance.award]!,
    };

const _$ContestStageEnumMap = {
  ContestStage.none: 'none',
  ContestStage.district: 'district',
  ContestStage.prefectural: 'prefectural',
  ContestStage.block: 'block',
  ContestStage.national: 'national',
};

const _$ContestAwardEnumMap = {
  ContestAward.none: 'none',
  ContestAward.gold: 'gold',
  ContestAward.silver: 'silver',
  ContestAward.bronze: 'bronze',
};
