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
  final client = HttpClient();
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
    // 配信元の候補を順に試す（ブラウザと同じ形で要求する）
    final errors = <String>[];
    var saved = false;
    for (final url in _candidates(piece.id)) {
      try {
        final req = await client.getUrl(Uri.parse(url));
        req.headers
          ..set(HttpHeaders.userAgentHeader, _browserUserAgent)
          ..set(HttpHeaders.refererHeader, 'https://suno.com/')
          ..set(HttpHeaders.acceptHeader, 'audio/*,*/*;q=0.8');
        final res = await req.close();
        final type = res.headers.contentType?.primaryType ?? '';
        if (res.statusCode != 200 || (type.isNotEmpty && type != 'audio')) {
          await res.drain<void>();
          errors.add('${Uri.parse(url).host}: HTTP ${res.statusCode}');
          continue;
        }
        final tmp = File('${file.path}.part');
        await res.pipe(tmp.openWrite());
        tmp.renameSync(file.path);
        final mb = (file.lengthSync() / 1024 / 1024).toStringAsFixed(1);
        print('OK  $name（$mb MB, ${Uri.parse(url).host}）');
        saved = true;
        break;
      } on Object catch (e) {
        errors.add('${Uri.parse(url).host}: $e');
      }
    }
    if (saved) {
      ok++;
    } else {
      print('NG  $name: ${errors.join(' / ')}');
      failed++;
    }
  }
  client.close();
  print('');
  print('完了 $ok 曲 / 失敗 $failed 曲');
  if (failed > 0) {
    print('Suno が直接のダウンロードを許可していないようです。');
    print('Suno の各曲ページの「…」→「Download」→「MP3 Audio」で保存してから、');
    print('  dart run tool/import_pieces.dart <保存したフォルダ>');
    print('を実行すると、曲名から自動で振り分けて取り込みます。');
    exitCode = 1;
  }
}

const _browserUserAgent =
    'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 '
    '(KHTML, like Gecko) Chrome/129.0.0.0 Safari/537.36';

List<String> _candidates(String id) => [
  'https://cdn1.suno.ai/$id.mp3',
  'https://cdn2.suno.ai/$id.mp3',
  'https://audiopipe.suno.ai/?item_id=$id',
];
