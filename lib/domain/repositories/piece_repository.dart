import '../game/models/piece.dart';

/// 曲の音源の場所。同梱音源があればそれを、なければ Web のリンクを使う。
sealed class PieceAudio {
  const PieceAudio();
}

/// アプリに同梱した音源（オフラインで再生できる）。
class AssetPieceAudio extends PieceAudio {
  const AssetPieceAudio(this.assetPath);
  final String assetPath;
}

/// Web 上の試聴ページ（一時的。ブラウザで開く）。
class WebPieceAudio extends PieceAudio {
  const WebPieceAudio(this.url);
  final Uri url;
}

/// 課題曲のマスターデータ。
abstract interface class PieceRepository {
  /// 全 24 曲（年・番号順）。
  List<Piece> all();

  /// [year] 年目（1..6）の課題曲 I〜IV。
  List<Piece> byYear(int year);

  Piece? byId(String id);

  /// 曲の音源。同梱音源（assets/audio/）が見つかればそれを優先する。
  PieceAudio audioOf(Piece piece);
}
