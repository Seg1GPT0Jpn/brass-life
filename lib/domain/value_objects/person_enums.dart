/// 人物に関する列挙型群。
library;

enum Gender {
  female('女'),
  male('男');

  const Gender(this.label);
  final String label;
}

enum NpcRole {
  student('部員'),
  advisor('顧問'),
  coach('外部講師');

  const NpcRole(this.label);
  final String label;
}

/// 入部前の音楽経験。
enum MusicBackground {
  none('未経験'),
  piano('ピアノ経験'),
  elementaryBand('小学校金管バンド'),
  middleSchoolBand('中学吹奏楽部');

  const MusicBackground(this.label);
  final String label;
}

/// 顧問の指導スタイル。
enum AdvisorStyle {
  passionate('熱血', '感情と熱量で部員を引っ張る'),
  theoretical('理論派', '分析的で緻密な合奏指導を行う'),
  handsOff('放任', '部員の自主性に任せ、あまり口を出さない'),
  strict('厳格', '規律と結果に厳しい'),
  gentle('温和', '部員に寄り添い、楽しさを重視する'),
  charismatic('カリスマ', '圧倒的な実績と求心力を持つ');

  const AdvisorStyle(this.label, this.description);
  final String label;
  final String description;
}
