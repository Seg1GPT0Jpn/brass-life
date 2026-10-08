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
  contestMembers:
      (json['contestMembers'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const <String>[],
  soloistId: json['soloistId'] as String?,
  contest: json['contest'] == null
      ? null
      : ContestProgress.fromJson(json['contest'] as Map<String, dynamic>),
  clubHistory:
      (json['clubHistory'] as List<dynamic>?)
          ?.map((e) => ContestRecord.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <ContestRecord>[],
  achievements:
      (json['achievements'] as List<dynamic>?)
          ?.map((e) => Achievement.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <Achievement>[],
  setPieces:
      (json['setPieces'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ) ??
      const <String, String>{},
  roles:
      (json['roles'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, $enumDecode(_$ClubRoleEnumMap, e)),
      ) ??
      const <String, ClubRole>{},
  executiveSelectionTurn: (json['executiveSelectionTurn'] as num?)?.toInt(),
  lastConcertYear: (json['lastConcertYear'] as num?)?.toInt(),
  preparedTurn: (json['preparedTurn'] as num?)?.toInt() ?? -1,
  exam: json['exam'] == null
      ? null
      : EntranceExamState.fromJson(json['exam'] as Map<String, dynamic>),
  npcDestinations:
      (json['npcDestinations'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ) ??
      const <String, String>{},
  schoolHistory:
      (json['schoolHistory'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const <String>[],
  setup: json['setup'] == null
      ? null
      : PlayerSetup.fromJson(json['setup'] as Map<String, dynamic>),
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
      'contestMembers': instance.contestMembers,
      'soloistId': ?instance.soloistId,
      'contest': ?instance.contest?.toJson(),
      'clubHistory': instance.clubHistory.map((e) => e.toJson()).toList(),
      'achievements': instance.achievements.map((e) => e.toJson()).toList(),
      'setPieces': instance.setPieces,
      'roles': instance.roles.map((k, e) => MapEntry(k, _$ClubRoleEnumMap[e]!)),
      'executiveSelectionTurn': ?instance.executiveSelectionTurn,
      'lastConcertYear': ?instance.lastConcertYear,
      'preparedTurn': instance.preparedTurn,
      'exam': ?instance.exam?.toJson(),
      'npcDestinations': instance.npcDestinations,
      'schoolHistory': instance.schoolHistory,
      'setup': ?instance.setup?.toJson(),
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

const _$ClubRoleEnumMap = {
  ClubRole.captain: 'captain',
  ClubRole.viceCaptain: 'viceCaptain',
  ClubRole.conductor: 'conductor',
  ClubRole.treasurer: 'treasurer',
  ClubRole.gradeRep: 'gradeRep',
  ClubRole.viceRep: 'viceRep',
  ClubRole.sectionLeader: 'sectionLeader',
  ClubRole.partLeader: 'partLeader',
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
  retired: json['retired'] as bool? ?? false,
  heartache: (json['heartache'] as num?)?.toInt() ?? 0,
  quitClub: json['quitClub'] as bool? ?? false,
  quitCount: (json['quitCount'] as num?)?.toInt() ?? 0,
  quitTurn: (json['quitTurn'] as num?)?.toInt(),
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
  'retired': instance.retired,
  'heartache': instance.heartache,
  'quitClub': instance.quitClub,
  'quitCount': instance.quitCount,
  'quitTurn': ?instance.quitTurn,
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
  retired: json['retired'] as bool? ?? false,
  lastBehavior: json['lastBehavior'] as String?,
  lastTargetId: json['lastTargetId'] as String?,
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
  'retired': instance.retired,
  'lastBehavior': ?instance.lastBehavior,
  'lastTargetId': ?instance.lastTargetId,
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
  PendingEventType.pieceSelection: 'pieceSelection',
  PendingEventType.audition: 'audition',
  PendingEventType.contest: 'contest',
  PendingEventType.executiveSelection: 'executiveSelection',
  PendingEventType.concert: 'concert',
  PendingEventType.recommendation: 'recommendation',
  PendingEventType.examApplication: 'examApplication',
  PendingEventType.notice: 'notice',
};

_ContestProgress _$ContestProgressFromJson(Map<String, dynamic> json) =>
    _ContestProgress(
      fiscalYear: (json['fiscalYear'] as num).toInt(),
      division: $enumDecode(_$BandDivisionEnumMap, json['division']),
      nextStage: $enumDecodeNullable(_$ContestStageEnumMap, json['nextStage']),
      results:
          (json['results'] as List<dynamic>?)
              ?.map(
                (e) => ContestStageResult.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const <ContestStageResult>[],
      finishedTurn: (json['finishedTurn'] as num?)?.toInt(),
      retirementDone: json['retirementDone'] as bool? ?? false,
    );

Map<String, dynamic> _$ContestProgressToJson(_ContestProgress instance) =>
    <String, dynamic>{
      'fiscalYear': instance.fiscalYear,
      'division': _$BandDivisionEnumMap[instance.division]!,
      'nextStage': ?_$ContestStageEnumMap[instance.nextStage],
      'results': instance.results.map((e) => e.toJson()).toList(),
      'finishedTurn': ?instance.finishedTurn,
      'retirementDone': instance.retirementDone,
    };

const _$BandDivisionEnumMap = {
  BandDivision.large: 'large',
  BandDivision.small: 'small',
};

const _$ContestStageEnumMap = {
  ContestStage.none: 'none',
  ContestStage.district: 'district',
  ContestStage.prefectural: 'prefectural',
  ContestStage.block: 'block',
  ContestStage.national: 'national',
};

_ContestStageResult _$ContestStageResultFromJson(Map<String, dynamic> json) =>
    _ContestStageResult(
      stage: $enumDecode(_$ContestStageEnumMap, json['stage']),
      award: $enumDecode(_$ContestAwardEnumMap, json['award']),
      advanced: json['advanced'] as bool,
      score: (json['score'] as num).toInt(),
      rank: (json['rank'] as num).toInt(),
      entrants: (json['entrants'] as num).toInt(),
      board:
          (json['board'] as List<dynamic>?)?.map((e) => e as String).toList() ??
          const <String>[],
    );

Map<String, dynamic> _$ContestStageResultToJson(_ContestStageResult instance) =>
    <String, dynamic>{
      'stage': _$ContestStageEnumMap[instance.stage]!,
      'award': _$ContestAwardEnumMap[instance.award]!,
      'advanced': instance.advanced,
      'score': instance.score,
      'rank': instance.rank,
      'entrants': instance.entrants,
      'board': instance.board,
    };

const _$ContestAwardEnumMap = {
  ContestAward.none: 'none',
  ContestAward.gold: 'gold',
  ContestAward.silver: 'silver',
  ContestAward.bronze: 'bronze',
};

_EntranceExamState _$EntranceExamStateFromJson(Map<String, dynamic> json) =>
    _EntranceExamState(
      kind: json['kind'] as String,
      offers:
          (json['offers'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      recommended: json['recommended'] as String?,
      applications:
          (json['applications'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
      results:
          (json['results'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as bool),
          ) ??
          const <String, bool>{},
      enrolled: json['enrolled'] as String?,
    );

Map<String, dynamic> _$EntranceExamStateToJson(_EntranceExamState instance) =>
    <String, dynamic>{
      'kind': instance.kind,
      'offers': instance.offers,
      'recommended': ?instance.recommended,
      'applications': instance.applications,
      'results': instance.results,
      'enrolled': ?instance.enrolled,
    };

_Achievement _$AchievementFromJson(Map<String, dynamic> json) => _Achievement(
  fiscalYear: (json['fiscalYear'] as num).toInt(),
  schoolId: json['schoolId'] as String,
  kind: json['kind'] as String,
  label: json['label'] as String,
  weight: (json['weight'] as num).toInt(),
);

Map<String, dynamic> _$AchievementToJson(_Achievement instance) =>
    <String, dynamic>{
      'fiscalYear': instance.fiscalYear,
      'schoolId': instance.schoolId,
      'kind': instance.kind,
      'label': instance.label,
      'weight': instance.weight,
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
