/// 機能の切り替え（不具合があったときに個別に止められるようにしておく）。
abstract final class FeatureFlags {
  /// Phase 7: パート練習・合奏をしたとき、今年の課題曲を練習 BGM として流す。
  static const practiceBgm = true;

  /// Phase 7: コンクール・定期演奏会の本番で指揮者ミニゲームを遊ぶ。
  static const conductingMiniGame = true;

  /// Phase 8: タイトルにキャリアモード（大人編）を出す。
  static const careerModes = true;
}
