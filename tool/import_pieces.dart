// Suno から手動でダウンロードした課題曲・自由曲の音源を、曲名から振り分けて assets/audio/ に取り込む。
//
//   dart run tool/import_pieces.dart <フォルダ>
//   例: dart run tool/import_pieces.dart C:\Users\kzmse\Downloads
//
// フォルダ内の .mp3 / .wav / .m4a のうち、ファイル名に曲名を含むものを
// assets/audio/y{年}_{番号}.{拡張子}（自由曲は free_{番号}.{拡張子}）としてコピーする（元のファイルはそのまま）。
// ignore_for_file: avoid_print
import 'dart:io';

import 'package:brass_life/domain/game/master/piece_file_matcher.dart';
import 'package:brass_life/domain/game/master/free_pieces.dart';
import 'package:brass_life/domain/game/master/set_pieces.dart';

void main(List<String> args) {
  if (args.isEmpty) {
    print('使い方: dart run tool/import_pieces.dart <音源を保存したフォルダ>');
    exitCode = 64;
    return;
  }
  final src = Directory(args.first);
  if (!src.existsSync()) {
    print('フォルダが見つかりません: ${src.path}');
    exitCode = 66;
    return;
  }
  final files = {
    for (final f in src.listSync().whereType<File>())
      f.uri.pathSegments.last: f,
  };
  final matched = PieceFileMatcher.match(files.keys, _pieces);
  final out = Directory('assets/audio')..createSync(recursive: true);
  for (final piece in _pieces) {
    final name = piece.heading;
    final fileName = matched[piece];
    if (fileName == null) {
      print('--  $name: 見つかりません');
      continue;
    }
    final ext = fileName.substring(fileName.lastIndexOf('.') + 1).toLowerCase();
    final dest = '${out.path}/${piece.assetStem}.$ext';
    // 拡張子違いの古い取り込みは消す（どちらを使うか迷わないように）
    for (final e in PieceFileMatcher.audioExtensions) {
      final old = File('${out.path}/${piece.assetStem}.$e');
      if (e != ext && old.existsSync()) old.deleteSync();
    }
    files[fileName]!.copySync(dest);
    print('OK  $name ← $fileName');
  }
  print('');
  print('取り込み ${matched.length} 曲 / 全 ${_pieces.length} 曲');
  if (matched.isNotEmpty) {
    print('flutter run をやり直すと、取り込んだ曲がアプリ内で鳴ります。');
  }
}

const _pieces = [...SetPieces.all, ...FreePieces.all];
