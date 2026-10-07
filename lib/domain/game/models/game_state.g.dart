// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GameState _$GameStateFromJson(Map<String, dynamic> json) => _GameState(
  schemaVersion: (json['schemaVersion'] as num?)?.toInt() ?? 1,
  worldSeed: (json['worldSeed'] as num).toInt(),
  generatorVersion: (json['generatorVersion'] as num).toInt(),
  turn: (json['turn'] as num).toInt(),
  stage: $enumDecode(_$GameStageEnumMap, json['stage']),
  player: PlayerState.fromJson(json['player'] as Map<String, dynamic>),
  schoolId: json['schoolId'] as String,
  roster: (json['roster'] as List<dynamic>).map((e) => e as String).toList(),
  npcs: (json['npcs'] as Map<String, dynamic>).map(
    (k, e) => MapEntry(k, NpcState.fromJson(e as Map<String, dynamic>)),
  ),
  extraNpcs:
      (json['extraNpcs'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, Npc.fromJson(e as Map<String, dynamic>)),
      ) ??
      const <String, Npc>{},
  relations:
      (json['relations'] as Map<String, dynamic>?)?.map(
        (k, e) =>
            MapEntry(k, RelationshipVector.fromJson(e as Map<String, dynamic>)),
      ) ??
      const <String, RelationshipVector>{},
  memories:
      (json['memories'] as List<dynamic>?)
          ?.map((e) => MemoryTag.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <MemoryTag>[],
  memorySeq: (json['memorySeq'] as num?)?.toInt() ?? 0,
  logs:
      (json['logs'] as List<dynamic>?)
          ?.map((e) => WeekLog.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <WeekLog>[],
  choices:
      (json['choices'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const <String>[],
  pending: json['pending'] == null
      ? null
      : PendingEvent.fromJson(json['pending'] as Map<String, dynamic>),
  policy:
      $enumDecodeNullable(_$MonthlyPolicyEnumMap, json['policy']) ??
      MonthlyPolicy.balanced,
  studyBeforeExams: json['studyBeforeExams'] as bool? ?? true,
);

Map<String, dynamic> _$GameStateToJson(_GameState instance) =>
    <String, dynamic>{
      'schemaVersion': instance.schemaVersion,
      'worldSeed': instance.worldSeed,
      'generatorVersion': instance.generatorVersion,
      'turn': instance.turn,
      'stage': _$GameStageEnumMap[instance.stage]!,
      'player': instance.player.toJson(),
      'schoolId': instance.schoolId,
      'roster': instance.roster,
      'npcs': instance.npcs.map((k, e) => MapEntry(k, e.toJson())),
      'extraNpcs': instance.extraNpcs.map((k, e) => MapEntry(k, e.toJson())),
      'relations': instance.relations.map((k, e) => MapEntry(k, e.toJson())),
      'memories': instance.memories.map((e) => e.toJson()).toList(),
      'memorySeq': instance.memorySeq,
      'logs': instance.logs.map((e) => e.toJson()).toList(),
      'choices': instance.choices,
      'pending': ?instance.pending?.toJson(),
      'policy': _$MonthlyPolicyEnumMap[instance.policy]!,
      'studyBeforeExams': instance.studyBeforeExams,
    };

const _$GameStageEnumMap = {
  GameStage.middle: 'middle',
  GameStage.high: 'high',
  GameStage.finished: 'finished',
};

const _$MonthlyPolicyEnumMap = {
  MonthlyPolicy.practiceFocus: 'practiceFocus',
  MonthlyPolicy.balanced: 'balanced',
  MonthlyPolicy.studyFocus: 'studyFocus',
  MonthlyPolicy.health: 'health',
};

_PlayerState _$PlayerStateFromJson(Map<String, dynamic> json) => _PlayerState(
  familyName: json['familyName'] as String,
  givenName: json['givenName'] as String,
  gender: $enumDecode(_$GenderEnumMap, json['gender']),
  personality: PersonalityAxes.fromJson(
    json['personality'] as Map<String, dynamic>,
  ),
  traits: (json['traits'] as List<dynamic>)
      .map((e) => TraitTag.fromJson(e as Map<String, dynamic>))
      .toList(),
  aptitude: AptitudeStats.fromJson(json['aptitude'] as Map<String, dynamic>),
  background: $enumDecode(_$MusicBackgroundEnumMap, json['background']),
  grade: (json['grade'] as num).toInt(),
  instrument: $enumDecodeNullable(_$InstrumentTypeEnumMap, json['instrument']),
  skill: (json['skill'] as num?)?.toInt() ?? 0,
  musicality: (json['musicality'] as num?)?.toInt() ?? 100,
  academic: (json['academic'] as num).toInt(),
  stamina: (json['stamina'] as num).toInt(),
  fatigue: (json['fatigue'] as num?)?.toInt() ?? 10,
  stress: (json['stress'] as num?)?.toInt() ?? 10,
  motivation: (json['motivation'] as num?)?.toInt() ?? 60,
  social: (json['social'] as num?)?.toInt() ?? 30,
  advisorTrust: (json['advisorTrust'] as num?)?.toInt() ?? 50,
  wishes:
      (json['wishes'] as List<dynamic>?)
          ?.map((e) => $enumDecode(_$InstrumentTypeEnumMap, e))
          .toList() ??
      const <InstrumentType>[],
  previousInstrument: $enumDecodeNullable(
    _$InstrumentTypeEnumMap,
    json['previousInstrument'],
  ),
  exams:
      (json['exams'] as List<dynamic>?)
          ?.map((e) => ExamRecord.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <ExamRecord>[],
  termGrades:
      (json['termGrades'] as List<dynamic>?)
          ?.map((e) => TermGrade.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <TermGrade>[],
  actionCounts:
      (json['actionCounts'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, (e as num).toInt()),
      ) ??
      const <String, int>{},
);

Map<String, dynamic> _$PlayerStateToJson(
  _PlayerState instance,
) => <String, dynamic>{
  'familyName': instance.familyName,
  'givenName': instance.givenName,
  'gender': _$GenderEnumMap[instance.gender]!,
  'personality': instance.personality.toJson(),
  'traits': instance.traits.map((e) => e.toJson()).toList(),
  'aptitude': instance.aptitude.toJson(),
  'background': _$MusicBackgroundEnumMap[instance.background]!,
  'grade': instance.grade,
  'instrument': ?_$InstrumentTypeEnumMap[instance.instrument],
  'skill': instance.skill,
  'musicality': instance.musicality,
  'academic': instance.academic,
  'stamina': instance.stamina,
  'fatigue': instance.fatigue,
  'stress': instance.stress,
  'motivation': instance.motivation,
  'social': instance.social,
  'advisorTrust': instance.advisorTrust,
  'wishes': instance.wishes.map((e) => _$InstrumentTypeEnumMap[e]!).toList(),
  'previousInstrument': ?_$InstrumentTypeEnumMap[instance.previousInstrument],
  'exams': instance.exams.map((e) => e.toJson()).toList(),
  'termGrades': instance.termGrades.map((e) => e.toJson()).toList(),
  'actionCounts': instance.actionCounts,
};

const _$GenderEnumMap = {Gender.female: 'female', Gender.male: 'male'};

const _$MusicBackgroundEnumMap = {
  MusicBackground.none: 'none',
  MusicBackground.piano: 'piano',
  MusicBackground.elementaryBand: 'elementaryBand',
  MusicBackground.middleSchoolBand: 'middleSchoolBand',
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

_NpcState _$NpcStateFromJson(Map<String, dynamic> json) => _NpcState(
  id: json['id'] as String,
  grade: (json['grade'] as num).toInt(),
  instrument: $enumDecodeNullable(_$InstrumentTypeEnumMap, json['instrument']),
  skill: (json['skill'] as num?)?.toInt() ?? 0,
  motivation: (json['motivation'] as num?)?.toInt() ?? 60,
  stress: (json['stress'] as num?)?.toInt() ?? 20,
  lowMotivationWeeks: (json['lowMotivationWeeks'] as num?)?.toInt() ?? 0,
  active: json['active'] as bool? ?? true,
  quit: json['quit'] as bool? ?? false,
  wish: $enumDecodeNullable(_$InstrumentTypeEnumMap, json['wish']),
);

Map<String, dynamic> _$NpcStateToJson(_NpcState instance) => <String, dynamic>{
  'id': instance.id,
  'grade': instance.grade,
  'instrument': ?_$InstrumentTypeEnumMap[instance.instrument],
  'skill': instance.skill,
  'motivation': instance.motivation,
  'stress': instance.stress,
  'lowMotivationWeeks': instance.lowMotivationWeeks,
  'active': instance.active,
  'quit': instance.quit,
  'wish': ?_$InstrumentTypeEnumMap[instance.wish],
};

_ExamRecord _$ExamRecordFromJson(Map<String, dynamic> json) => _ExamRecord(
  turn: (json['turn'] as num).toInt(),
  academicYearIndex: (json['academicYearIndex'] as num).toInt(),
  name: json['name'] as String,
  score: (json['score'] as num).toInt(),
);

Map<String, dynamic> _$ExamRecordToJson(_ExamRecord instance) =>
    <String, dynamic>{
      'turn': instance.turn,
      'academicYearIndex': instance.academicYearIndex,
      'name': instance.name,
      'score': instance.score,
    };

_TermGrade _$TermGradeFromJson(Map<String, dynamic> json) => _TermGrade(
  academicYearIndex: (json['academicYearIndex'] as num).toInt(),
  term: (json['term'] as num).toInt(),
  grade: (json['grade'] as num).toInt(),
);

Map<String, dynamic> _$TermGradeToJson(_TermGrade instance) =>
    <String, dynamic>{
      'academicYearIndex': instance.academicYearIndex,
      'term': instance.term,
      'grade': instance.grade,
    };

_PendingEvent _$PendingEventFromJson(Map<String, dynamic> json) =>
    _PendingEvent(
      type: $enumDecode(_$PendingEventTypeEnumMap, json['type']),
      turn: (json['turn'] as num).toInt(),
      data:
          (json['data'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as String),
          ) ??
          const <String, String>{},
    );

Map<String, dynamic> _$PendingEventToJson(_PendingEvent instance) =>
    <String, dynamic>{
      'type': _$PendingEventTypeEnumMap[instance.type]!,
      'turn': instance.turn,
      'data': instance.data,
    };

const _$PendingEventTypeEnumMap = {
  PendingEventType.instrumentDecision: 'instrumentDecision',
};

_WeekLog _$WeekLogFromJson(Map<String, dynamic> json) => _WeekLog(
  turn: (json['turn'] as num).toInt(),
  dateLabel: json['dateLabel'] as String,
  actionLabel: json['actionLabel'] as String?,
  lines: (json['lines'] as List<dynamic>).map((e) => e as String).toList(),
);

Map<String, dynamic> _$WeekLogToJson(_WeekLog instance) => <String, dynamic>{
  'turn': instance.turn,
  'dateLabel': instance.dateLabel,
  'actionLabel': ?instance.actionLabel,
  'lines': instance.lines,
};
