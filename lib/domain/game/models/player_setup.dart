import 'package:freezed_annotation/freezed_annotation.dart';

import '../../value_objects/aptitude.dart';
import '../../value_objects/person_enums.dart';
import '../../value_objects/personality.dart';

part 'player_setup.freezed.dart';
part 'player_setup.g.dart';

/// ゲーム開始前にプレイヤーが決める主人公の設定。
///
/// 能力（音楽適性 6 種 + 学力 + 体力）は、Seed が決めた主人公の合計値を上限とする
/// ポイント配分で決める（設定で強くなりすぎないようにするため）。
/// 音楽経験による補正は配分した値の上に加算される。
@freezed
abstract class PlayerSetup with _$PlayerSetup {
  const factory PlayerSetup({
    required String familyName,
    required String givenName,
    required Gender gender,

    /// 入学する中学校。
    required String schoolId,
    required MusicBackground background,
    required PersonalityAxes personality,

    /// 音楽適性（経験による補正を含まない基礎値）。
    required AptitudeStats aptitude,

    /// 学力（0..100）。
    required int academic,

    /// 体力（0..100）。
    required int stamina,
  }) = _PlayerSetup;

  const PlayerSetup._();

  factory PlayerSetup.fromJson(Map<String, dynamic> json) =>
      _$PlayerSetupFromJson(json);

  /// 配分に使ったポイントの合計。
  int get pointsUsed =>
      aptitude.pitch +
      aptitude.rhythm +
      aptitude.breath +
      aptitude.dexterity +
      aptitude.expression +
      aptitude.reading +
      academic +
      stamina;
}
