import 'package:flutter/services.dart';

import '../../domain/game/master/set_pieces.dart';
import '../../domain/game/models/piece.dart';
import '../../domain/repositories/piece_repository.dart';

/// コードに埋め込んだ課題曲マスター（[SetPieces]）を返すリポジトリ。
///
/// 音源は次の順で探す:
/// 1. 曲データの [Piece.audioAsset]
/// 2. 命名規則 `assets/audio/y{年}_{番号}.mp3`（または .wav / .m4a）で同梱されたファイル
/// 3. どちらもなければ Suno の配信用 MP3 をネット経由で再生
///
/// 2 を使うには [loadBundledAudio] を一度呼んで、同梱アセットの一覧を読み込む。
class MasterPieceRepository implements PieceRepository {
  MasterPieceRepository({Set<String> bundledAssets = const {}})
    : _bundled = {...bundledAssets};

  final Set<String> _bundled;

  static const _extensions = ['mp3', 'wav', 'm4a'];

  /// アプリに同梱された assets/audio/ 以下のファイルを調べる。
  Future<void> loadBundledAudio([AssetBundle? bundle]) async {
    try {
      final manifest = await AssetManifest.loadFromAssetBundle(
        bundle ?? rootBundle,
      );
      _bundled
        ..clear()
        ..addAll(
          manifest.listAssets().where((a) => a.startsWith('assets/audio/')),
        );
    } on Exception {
      // 一覧が読めなければネット配信のまま
    }
  }

  @override
  List<Piece> all() => SetPieces.all;

  @override
  List<Piece> byYear(int year) => SetPieces.byYear(year);

  @override
  Piece? byId(String id) => SetPieces.byId(id);

  @override
  PieceAudio audioOf(Piece piece) {
    final explicit = piece.audioAsset;
    if (explicit != null && _bundled.contains(explicit)) {
      return AssetPieceAudio(explicit);
    }
    final base = piece.conventionalAssetPath.replaceAll(RegExp(r'\.mp3$'), '');
    for (final ext in _extensions) {
      final path = '$base.$ext';
      if (_bundled.contains(path)) return AssetPieceAudio(path);
    }
    return StreamPieceAudio(Uri.parse(piece.streamUrl));
  }

  @override
  Uri pageOf(Piece piece) => Uri.parse(piece.url);
}
