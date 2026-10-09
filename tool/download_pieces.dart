// 課題曲 24 曲の音源を Suno からダウンロードして assets/audio/ に保存する。
//
//   dart run tool/download_pieces.dart          # 未ダウンロードの曲だけ
//   dart run tool/download_pieces.dart --force  # すべて取り直す
//
// 保存先は assets/audio/y{年}_{番号}.mp3。置いた音源はアプリ内でオフライン再生に使われる
// （flutter run / build をやり直すと反映される）。
// ignore_for_file: avoid_print
import 'dart:io';

import 'package:brass_life/domain/game/master/set_pieces.dart';

Future<void> main(List<String> args) async {
  final force = args.contains('--force');
  final dir = Directory('assets/audio');
  if (!dir.existsSync()) dir.createSync(recursive: true);
  final client = HttpClient()..userAgent = 'brass-life piece downloader';
  var ok = 0;
  var failed = 0;
  for (final piece in SetPieces.all) {
    final file = File(piece.conventionalAssetPath);
    final name = '${piece.year}年目 ${piece.category}「${piece.title}」';
    if (file.existsSync() && file.lengthSync() > 0 && !force) {
      print('済  $name');
      ok++;
      continue;
    }
    try {
      final req = await client.getUrl(Uri.parse(piece.streamUrl));
      final res = await req.close();
      if (res.statusCode != 200) {
        await res.drain<void>();
        throw HttpException('HTTP ${res.statusCode}');
      }
      final tmp = File('${file.path}.part');
      await res.pipe(tmp.openWrite());
      tmp.renameSync(file.path);
      final mb = (file.lengthSync() / 1024 / 1024).toStringAsFixed(1);
      print('OK  $name（$mb MB）');
      ok++;
    } on Object catch (e) {
      print('NG  $name: $e');
      failed++;
    }
  }
  client.close();
  print('');
  print('完了 $ok 曲 / 失敗 $failed 曲');
  if (failed > 0) {
    print('失敗した曲は、Suno の曲ページから MP3 をダウンロードし、');
    print('assets/audio/y{年}_{番号}.mp3（例: y1_I.mp3）の名前で置いてください。');
    exitCode = 1;
  }
}
