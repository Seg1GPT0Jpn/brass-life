/// 楽器の定義。実在メーカー名などは一切含まない。
library;

enum InstrumentFamily {
  woodwind('木管'),
  brass('金管'),
  percussion('打楽器'),
  strings('弦楽器');

  const InstrumentFamily(this.label);
  final String label;
}

/// 適性の種類。
enum AptitudeKind {
  pitch('音感'),
  rhythm('リズム'),
  breath('肺活量'),
  dexterity('指の器用さ'),
  expression('表現力'),
  reading('読譜力');

  const AptitudeKind(this.label);
  final String label;
}

/// 楽器種別。
///
/// - [standardRatio]: 標準編成（約 53 人）における人数比。
/// - [presencePermyriad]: 予算「普通」の高校がその楽器を保有している確率（万分率）。
///   10000 は「必ず保有する基本楽器」。
/// - [personalPermyriad]: 担当者が私物を所有している確率（万分率）。
/// - [popularity]: 新入生が希望として挙げる人気度（重み）。
/// - [aptitudeWeights]: 適性の重み（合計 10）。楽器適性スコアの算出に用いる。
enum InstrumentType {
  piccolo('ピッコロ', 'Picc', InstrumentFamily.woodwind, 1, 8500, 1500, 2, {
    AptitudeKind.pitch: 3,
    AptitudeKind.dexterity: 3,
    AptitudeKind.breath: 1,
    AptitudeKind.expression: 2,
    AptitudeKind.reading: 1,
  }),
  flute('フルート', 'Fl', InstrumentFamily.woodwind, 4, 10000, 3500, 16, {
    AptitudeKind.pitch: 2,
    AptitudeKind.dexterity: 3,
    AptitudeKind.breath: 2,
    AptitudeKind.expression: 2,
    AptitudeKind.reading: 1,
  }),
  oboe('オーボエ', 'Ob', InstrumentFamily.woodwind, 2, 6500, 1500, 3, {
    AptitudeKind.pitch: 3,
    AptitudeKind.breath: 2,
    AptitudeKind.dexterity: 2,
    AptitudeKind.expression: 3,
  }),
  bassoon('ファゴット', 'Fg', InstrumentFamily.woodwind, 2, 5000, 200, 1, {
    AptitudeKind.pitch: 2,
    AptitudeKind.breath: 2,
    AptitudeKind.dexterity: 2,
    AptitudeKind.expression: 2,
    AptitudeKind.reading: 2,
  }),
  ebClarinet('E♭クラリネット', 'E♭Cl', InstrumentFamily.woodwind, 1, 3000, 500, 0, {
    AptitudeKind.pitch: 3,
    AptitudeKind.dexterity: 3,
    AptitudeKind.expression: 2,
    AptitudeKind.reading: 2,
  }),
  clarinet('クラリネット', 'Cl', InstrumentFamily.woodwind, 10, 10000, 3000, 9, {
    AptitudeKind.dexterity: 3,
    AptitudeKind.pitch: 2,
    AptitudeKind.breath: 2,
    AptitudeKind.reading: 2,
    AptitudeKind.expression: 1,
  }),
  bassClarinet('バスクラリネット', 'BCl', InstrumentFamily.woodwind, 2, 7000, 100, 1, {
    AptitudeKind.breath: 3,
    AptitudeKind.dexterity: 2,
    AptitudeKind.pitch: 2,
    AptitudeKind.rhythm: 2,
    AptitudeKind.reading: 1,
  }),
  altoSax('アルトサックス', 'ASax', InstrumentFamily.woodwind, 3, 10000, 2500, 14, {
    AptitudeKind.expression: 3,
    AptitudeKind.dexterity: 2,
    AptitudeKind.breath: 2,
    AptitudeKind.pitch: 2,
    AptitudeKind.rhythm: 1,
  }),
  tenorSax('テナーサックス', 'TSax', InstrumentFamily.woodwind, 1, 10000, 800, 5, {
    AptitudeKind.expression: 3,
    AptitudeKind.breath: 3,
    AptitudeKind.rhythm: 2,
    AptitudeKind.dexterity: 2,
  }),
  baritoneSax('バリトンサックス', 'BSax', InstrumentFamily.woodwind, 1, 8000, 50, 2, {
    AptitudeKind.breath: 4,
    AptitudeKind.rhythm: 3,
    AptitudeKind.dexterity: 2,
    AptitudeKind.reading: 1,
  }),
  trumpet('トランペット', 'Tp', InstrumentFamily.brass, 6, 10000, 4000, 14, {
    AptitudeKind.breath: 3,
    AptitudeKind.pitch: 2,
    AptitudeKind.expression: 3,
    AptitudeKind.rhythm: 2,
  }),
  horn('ホルン', 'Hr', InstrumentFamily.brass, 4, 10000, 800, 4, {
    AptitudeKind.pitch: 4,
    AptitudeKind.breath: 2,
    AptitudeKind.expression: 3,
    AptitudeKind.reading: 1,
  }),
  trombone('トロンボーン', 'Tb', InstrumentFamily.brass, 4, 10000, 1500, 6, {
    AptitudeKind.pitch: 3,
    AptitudeKind.breath: 3,
    AptitudeKind.expression: 2,
    AptitudeKind.rhythm: 2,
  }),
  bassTrombone('バストロンボーン', 'BTb', InstrumentFamily.brass, 1, 6000, 300, 1, {
    AptitudeKind.breath: 4,
    AptitudeKind.rhythm: 3,
    AptitudeKind.pitch: 2,
    AptitudeKind.reading: 1,
  }),
  euphonium('ユーフォニアム', 'Euph', InstrumentFamily.brass, 2, 10000, 300, 4, {
    AptitudeKind.expression: 3,
    AptitudeKind.breath: 3,
    AptitudeKind.pitch: 2,
    AptitudeKind.dexterity: 2,
  }),
  tuba('チューバ', 'Tuba', InstrumentFamily.brass, 3, 10000, 0, 2, {
    AptitudeKind.breath: 5,
    AptitudeKind.rhythm: 3,
    AptitudeKind.reading: 2,
  }),
  stringBass('コントラバス', 'StB', InstrumentFamily.strings, 1, 6500, 100, 2, {
    AptitudeKind.rhythm: 4,
    AptitudeKind.pitch: 3,
    AptitudeKind.dexterity: 2,
    AptitudeKind.reading: 1,
  }),
  percussion('打楽器', 'Perc', InstrumentFamily.percussion, 5, 10000, 0, 13, {
    AptitudeKind.rhythm: 5,
    AptitudeKind.reading: 3,
    AptitudeKind.dexterity: 2,
  });

  const InstrumentType(
    this.label,
    this.shortLabel,
    this.family,
    this.standardRatio,
    this.presencePermyriad,
    this.personalPermyriad,
    this.popularity,
    this.aptitudeWeights,
  );

  final String label;
  final String shortLabel;
  final InstrumentFamily family;
  final int standardRatio;
  final int presencePermyriad;
  final int personalPermyriad;
  final int popularity;
  final Map<AptitudeKind, int> aptitudeWeights;

  /// 必ず保有される基本楽器か。
  bool get isStandard => presencePermyriad >= 10000;

  /// 標準編成テンプレートの合計人数。
  static int get standardTotal =>
      values.fold(0, (sum, t) => sum + t.standardRatio);
}

/// 楽器の状態。
enum InstrumentCondition {
  excellent('良好', true),
  good('普通', true),
  worn('劣化', true),
  needsRepair('要修理', false);

  const InstrumentCondition(this.label, this.usable);
  final String label;

  /// 演奏に使用可能か。
  final bool usable;
}
