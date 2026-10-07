import 'package:freezed_annotation/freezed_annotation.dart';

import '../value_objects/school_enums.dart';

part 'school.freezed.dart';
part 'school.g.dart';

@freezed
abstract class School with _$School {
  const factory School({
    required String id,
    required String name,
    required SchoolLevel level,
    required SchoolOwnership ownership,
    required String districtId,
    required String town,
    required int foundedYear,
    required int studentCount,

    /// 偏差値（高校のみ。中学は null）。
    int? deviation,

    /// 学力水準（0..100、平均 50）。中学では偏差値の代わりに用いる。
    required int academicLevel,
    required List<SchoolCulture> cultures,
    required String clubId,

    /// 女子校か。
    @Default(false) bool girlsOnly,

    /// 中高一貫の相手校 ID（私立の系列校のみ）。
    String? affiliatedSchoolId,
  }) = _School;

  const School._();

  factory School.fromJson(Map<String, dynamic> json) => _$SchoolFromJson(json);

  bool hasCulture(SchoolCulture c) => cultures.contains(c);

  bool get isPrivate => ownership == SchoolOwnership.privateSchool;
}
