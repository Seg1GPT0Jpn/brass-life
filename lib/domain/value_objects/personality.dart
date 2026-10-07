import 'package:freezed_annotation/freezed_annotation.dart';

part 'personality.freezed.dart';
part 'personality.g.dart';

/// 性格の隠し軸。各軸 -100..100 の整数。
/// 性格タグはこの軸から導出されるため、タグ同士が矛盾しにくい。
@freezed
abstract class PersonalityAxes with _$PersonalityAxes {
  const factory PersonalityAxes({
    /// 外向性
    required int extraversion,

    /// 協調性
    required int agreeableness,

    /// 勤勉性
    required int conscientiousness,

    /// 情緒不安定性（高いほど不安定）
    required int neuroticism,

    /// 野心・上昇志向
    required int ambition,
  }) = _PersonalityAxes;

  factory PersonalityAxes.fromJson(Map<String, dynamic> json) =>
      _$PersonalityAxesFromJson(json);
}

/// 付与された性格タグ。[intensity] は 1〜3。
@freezed
abstract class TraitTag with _$TraitTag {
  const factory TraitTag({required String traitId, required int intensity}) =
      _TraitTag;

  factory TraitTag.fromJson(Map<String, dynamic> json) =>
      _$TraitTagFromJson(json);
}
