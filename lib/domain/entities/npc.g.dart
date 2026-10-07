// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'npc.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Npc _$NpcFromJson(Map<String, dynamic> json) => _Npc(
  id: json['id'] as String,
  familyName: json['familyName'] as String,
  givenName: json['givenName'] as String,
  gender: $enumDecode(_$GenderEnumMap, json['gender']),
  role: $enumDecode(_$NpcRoleEnumMap, json['role']),
  schoolId: json['schoolId'] as String,
  grade: (json['grade'] as num?)?.toInt(),
  age: (json['age'] as num?)?.toInt(),
  personality: PersonalityAxes.fromJson(
    json['personality'] as Map<String, dynamic>,
  ),
  traits: (json['traits'] as List<dynamic>)
      .map((e) => TraitTag.fromJson(e as Map<String, dynamic>))
      .toList(),
  aptitude: AptitudeStats.fromJson(json['aptitude'] as Map<String, dynamic>),
  academic: (json['academic'] as num).toInt(),
  stamina: (json['stamina'] as num).toInt(),
  background: $enumDecode(_$MusicBackgroundEnumMap, json['background']),
  instrument: $enumDecodeNullable(_$InstrumentTypeEnumMap, json['instrument']),
  instrumentSkill: (json['instrumentSkill'] as num?)?.toInt() ?? 0,
  ownsPersonalInstrument: json['ownsPersonalInstrument'] as bool? ?? false,
  wishInstrument: $enumDecodeNullable(
    _$InstrumentTypeEnumMap,
    json['wishInstrument'],
  ),
  previousInstrument: $enumDecodeNullable(
    _$InstrumentTypeEnumMap,
    json['previousInstrument'],
  ),
  previousSkill: (json['previousSkill'] as num?)?.toInt() ?? 0,
  advisorProfile: json['advisorProfile'] == null
      ? null
      : AdvisorProfile.fromJson(json['advisorProfile'] as Map<String, dynamic>),
);

Map<String, dynamic> _$NpcToJson(_Npc instance) => <String, dynamic>{
  'id': instance.id,
  'familyName': instance.familyName,
  'givenName': instance.givenName,
  'gender': _$GenderEnumMap[instance.gender]!,
  'role': _$NpcRoleEnumMap[instance.role]!,
  'schoolId': instance.schoolId,
  'grade': ?instance.grade,
  'age': ?instance.age,
  'personality': instance.personality.toJson(),
  'traits': instance.traits.map((e) => e.toJson()).toList(),
  'aptitude': instance.aptitude.toJson(),
  'academic': instance.academic,
  'stamina': instance.stamina,
  'background': _$MusicBackgroundEnumMap[instance.background]!,
  'instrument': ?_$InstrumentTypeEnumMap[instance.instrument],
  'instrumentSkill': instance.instrumentSkill,
  'ownsPersonalInstrument': instance.ownsPersonalInstrument,
  'wishInstrument': ?_$InstrumentTypeEnumMap[instance.wishInstrument],
  'previousInstrument': ?_$InstrumentTypeEnumMap[instance.previousInstrument],
  'previousSkill': instance.previousSkill,
  'advisorProfile': ?instance.advisorProfile?.toJson(),
};

const _$GenderEnumMap = {Gender.female: 'female', Gender.male: 'male'};

const _$NpcRoleEnumMap = {
  NpcRole.student: 'student',
  NpcRole.advisor: 'advisor',
  NpcRole.coach: 'coach',
};

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

_AdvisorProfile _$AdvisorProfileFromJson(Map<String, dynamic> json) =>
    _AdvisorProfile(
      style: $enumDecode(_$AdvisorStyleEnumMap, json['style']),
      teachingSkill: (json['teachingSkill'] as num).toInt(),
      passion: (json['passion'] as num).toInt(),
      careerYears: (json['careerYears'] as num).toInt(),
      yearsAtSchool: (json['yearsAtSchool'] as num).toInt(),
      specialty: $enumDecode(_$InstrumentFamilyEnumMap, json['specialty']),
    );

Map<String, dynamic> _$AdvisorProfileToJson(_AdvisorProfile instance) =>
    <String, dynamic>{
      'style': _$AdvisorStyleEnumMap[instance.style]!,
      'teachingSkill': instance.teachingSkill,
      'passion': instance.passion,
      'careerYears': instance.careerYears,
      'yearsAtSchool': instance.yearsAtSchool,
      'specialty': _$InstrumentFamilyEnumMap[instance.specialty]!,
    };

const _$AdvisorStyleEnumMap = {
  AdvisorStyle.passionate: 'passionate',
  AdvisorStyle.theoretical: 'theoretical',
  AdvisorStyle.handsOff: 'handsOff',
  AdvisorStyle.strict: 'strict',
  AdvisorStyle.gentle: 'gentle',
  AdvisorStyle.charismatic: 'charismatic',
};

const _$InstrumentFamilyEnumMap = {
  InstrumentFamily.woodwind: 'woodwind',
  InstrumentFamily.brass: 'brass',
  InstrumentFamily.percussion: 'percussion',
  InstrumentFamily.strings: 'strings',
};
