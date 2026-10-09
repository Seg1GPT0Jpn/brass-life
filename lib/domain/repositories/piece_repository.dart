import '../game/models/piece.dart';

/// アプリ内で再生する音源の場所。同梱音源があればそれを、なければネット配信を使う。
sealed class PieceAudio {
  const PieceAudio();
}

/// アプリに同梱した音源（オフラインで再生できる）。
class AssetPieceAudio extends PieceAudio {
  const AssetPieceAudio(this.assetPath);
  final String assetPath;
}

/// ネット経由でアプリ内再生する音声ファイル（要インターネット接続）。
class StreamPieceAudio extends PieceAudio {
  const StreamPieceAudio(this.url);
  final Uri url;
}

/// 課題曲のマスターデータ。
abstract interface class PieceRepository {
  /// 全 24 曲（年・番号順）。
  List<Piece> all();

  /// [year] 年目（1..6）の課題曲 I〜IV。
  List<Piece> byYear(int year);

  Piece? byId(String id);

  /// アプリ内で再生する音源。同梱音源（assets/audio/）が見つかればそれを優先する。
  PieceAudio audioOf(Piece piece);

  /// 曲のページ（ブラウザで開く用）。
  Uri pageOf(Piece piece);
}
