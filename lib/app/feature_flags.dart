/// 開発中の機能の切り替え。Phase 1〜6 の完成を優先し、Phase 7・8 は器だけ用意して閉じておく。
abstract final class FeatureFlags {
  /// Phase 7: パート練習・合奏をしたとき、今年の課題曲を練習 BGM として流す。
  static const practiceBgm = false;

  /// Phase 7: コンクール本番で指揮者ミニゲームを遊ぶ（UI は未実装）。
  static const conductingMiniGame = false;

  /// Phase 8: タイトルにキャリアモード（大人編）の一覧を出す（遊べるのは本編のみ）。
  static const careerModes = true;
}
