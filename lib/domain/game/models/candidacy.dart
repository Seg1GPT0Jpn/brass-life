import 'game_enums.dart';

/// 幹部選出でのプレイヤーの意思。
///
/// [choice] が「立候補」のときは、狙う役職 [role] と、なりたい気持ちの強さ
/// [desire]（1..5）を持つ。気持ちが強いほど選ばれやすくなるが、
/// 選ばれなかったときの心の傷も深く、長く残る。
class Candidacy {
  const Candidacy._(this.choice, this.role, this.desire);

  const Candidacy.neutral() : this._(CandidacyChoice.neutral, null, 0);

  const Candidacy.decline() : this._(CandidacyChoice.decline, null, 0);

  Candidacy.run(ClubRole role, int desire)
    : this._(CandidacyChoice.run, role, desire.clamp(minDesire, maxDesire));

  static const int minDesire = 1;
  static const int maxDesire = 5;

  final CandidacyChoice choice;
  final ClubRole? role;
  final int desire;

  bool get isRun => choice == CandidacyChoice.run;

  /// 選択ログ・乱数の選択キー。
  String get key => isRun ? 'run:${role!.name}:$desire' : choice.name;

  static String desireLabel(int d) => switch (d) {
    1 => 'できれば',
    2 => 'なってみたい',
    3 => 'なりたい',
    4 => '絶対になりたい',
    _ => 'すべてを懸けてなりたい',
  };

  @override
  bool operator ==(Object other) =>
      other is Candidacy &&
      other.choice == choice &&
      other.role == role &&
      other.desire == desire;

  @override
  int get hashCode => Object.hash(choice, role, desire);
}
