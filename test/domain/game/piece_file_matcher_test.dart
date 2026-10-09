import 'package:brass_life/domain/game/master/piece_file_matcher.dart';
import 'package:brass_life/domain/game/master/set_pieces.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Suno のファイル名から曲を当てる（空白・記号・全角半角の違いは無視）', () {
    final m = PieceFileMatcher.match([
      '青空とファンファーレ.mp3',
      '夜明けを告げるファンファーレと祈り (1).mp3',
      '行進曲「茜空のカンバス」.mp3',
      'ディスコ キッド アゲイン.wav',
      'とびだせ!からくりマーチ.m4a',
      'カルナヴァル・ラティーノ.txt', // 音源ではない
      'まったく関係ない曲.mp3',
    ], SetPieces.all);
    String? of(String title) => m.entries
        .where((e) => e.key.title == title)
        .map((e) => e.value)
        .firstOrNull;
    expect(of('青空とファンファーレ'), '青空とファンファーレ.mp3');
    expect(of('夜明けを告げるファンファーレと祈り'), '夜明けを告げるファンファーレと祈り (1).mp3');
    expect(of('行進曲「茜空のカンバス」'), '行進曲「茜空のカンバス」.mp3');
    expect(of('ディスコ・キッド・アゲイン'), 'ディスコ キッド アゲイン.wav');
    expect(of('とびだせ！からくりマーチ'), 'とびだせ!からくりマーチ.m4a');
    expect(of('カルナヴァル・ラティーノ'), isNull);
    expect(m, hasLength(5));
  });

  test('全 24 曲の曲名どうしは、ならしても区別できる', () {
    final names = SetPieces.all
        .map((p) => PieceFileMatcher.normalize(p.title))
        .toSet();
    expect(names, hasLength(24));
    // 曲名そのままのファイル名なら全曲当たる
    final m = PieceFileMatcher.match([
      for (final p in SetPieces.all) '${p.title}.mp3',
    ], SetPieces.all);
    expect(m, hasLength(24));
    for (final e in m.entries) {
      expect(e.value, '${e.key.title}.mp3');
    }
  });
}
