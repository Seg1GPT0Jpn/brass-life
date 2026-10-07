import 'package:freezed_annotation/freezed_annotation.dart';

import '../value_objects/aptitude.dart';
import '../value_objects/person_enums.dart';
import '../value_objects/personality.dart';

part 'player.freezed.dart';
part 'player.g.dart';

/// プレイヤー。能力構造は [Npc] と共通にし、高校進学時の引き継ぎを容易にする。
/// 所属中学は World Seed から自動決定される。
@freezed
abstract class Player with _$Player {
  const factory Player({
    required String id,
    required String familyName,
    required String givenName,
    required Gender gender,
    required String schoolId,
    required int grade,
    required PersonalityAxes personality,
    required List<TraitTag> traits,
    required AptitudeStats aptitude,
    required int academic,
    required int stamina,
    required MusicBackground background,
  }) = _Player;

  const Player._();

  factory Player.fromJson(Map<String, dynamic> json) => _$PlayerFromJson(json);

  String get fullName => '$familyName $givenName';
}
