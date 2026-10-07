import 'package:freezed_annotation/freezed_annotation.dart';

import '../value_objects/aptitude.dart';
import '../value_objects/instrument.dart';
import '../value_objects/person_enums.dart';
import '../value_objects/personality.dart';

part 'npc.freezed.dart';
part 'npc.g.dart';

@freezed
abstract class Npc with _$Npc {
  const factory Npc({
    required String id,
    required String familyName,
    required String givenName,
    required Gender gender,
    required NpcRole role,
    required String schoolId,

    /// 学年（部員のみ 1..3）。
    int? grade,

    /// 年齢（大人のみ）。
    int? age,
    required PersonalityAxes personality,
    required List<TraitTag> traits,
    required AptitudeStats aptitude,

    /// 学力（0..100）。
    required int academic,

    /// 体力（0..100）。
    required int stamina,
    required MusicBackground background,

    /// 担当楽器（新 1 年生は未決定で null）。
    InstrumentType? instrument,

    /// 担当楽器の熟練度（0..1000）。
    @Default(0) int instrumentSkill,

    /// 担当楽器が私物か。
    @Default(false) bool ownsPersonalInstrument,

    /// 希望楽器（新 1 年生のみ）。
    InstrumentType? wishInstrument,

    /// 入学前に担当していた楽器（経験者のみ）。
    InstrumentType? previousInstrument,
    @Default(0) int previousSkill,

    /// 顧問・外部講師の指導者プロフィール。
    AdvisorProfile? advisorProfile,
  }) = _Npc;

  const Npc._();

  factory Npc.fromJson(Map<String, dynamic> json) => _$NpcFromJson(json);

  String get fullName => '$familyName $givenName';

  bool hasTrait(String traitId) => traits.any((t) => t.traitId == traitId);
}

@freezed
abstract class AdvisorProfile with _$AdvisorProfile {
  const factory AdvisorProfile({
    required AdvisorStyle style,

    /// 指導力（0..100）。
    required int teachingSkill,

    /// 熱意（0..100）。
    required int passion,

    /// 指導歴（年）。
    required int careerYears,

    /// 現任校での在任年数（1 = 今年度着任）。
    required int yearsAtSchool,

    /// 専門の楽器系統。
    required InstrumentFamily specialty,
  }) = _AdvisorProfile;

  const AdvisorProfile._();

  factory AdvisorProfile.fromJson(Map<String, dynamic> json) =>
      _$AdvisorProfileFromJson(json);

  bool get isNewlyTransferred => yearsAtSchool == 1;
}
