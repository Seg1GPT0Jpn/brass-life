import '../models/piece.dart';

/// ダウンロードした音源ファイルの名前から、どの課題曲かを当てる。
///
/// Suno からダウンロードしたファイルは「曲名.mp3」のような名前になるので、
/// 空白・記号・全角半角の違いをならしたうえで、ファイル名に曲名が含まれるかで判定する。
/// 1 つのファイルが複数の曲名を含む場合は、いちばん長い曲名を採る。
abstract final class PieceFileMatcher {
  static const audioExtensions = {'mp3', 'wav', 'm4a'};

  /// 比較用に文字列をならす（小文字化・全角英数→半角・空白と記号を除去）。
  static String normalize(String s) {
    final b = StringBuffer();
    for (final rune in s.toLowerCase().runes) {
      var c = rune;
      // 全角英数・記号（！〜～）を半角へ
      if (c >= 0xFF01 && c <= 0xFF5E) c -= 0xFEE0;
      final ch = String.fromCharCode(c);
      if (_ignored.contains(ch)) continue;
      b.write(ch.toLowerCase());
    }
    return b.toString();
  }

  static const _ignored = {
    ' ',
    '\u3000',
    '\t',
    '「',
    '」',
    '『',
    '』',
    '（',
    '）',
    '(',
    ')',
    '[',
    ']',
    '【',
    '】',
    '・',
    '、',
    '。',
    ',',
    '.',
    '!',
    '?',
    '-',
    '_',
    '~',
    '〜',
    '～',
    "'",
    '"',
    '“',
    '”',
    '’',
    ':',
    '：',
    '/',
    '&',
    '+',
  };

  /// ファイル名（拡張子つき）→ 曲。音源でない・どの曲にも当たらないファイルは含まない。
  /// 同じ曲に複数のファイルが当たったら、名前順で先のものを採る。
  static Map<Piece, String> match(
    Iterable<String> fileNames,
    List<Piece> pieces,
  ) {
    final titles = [for (final p in pieces) (p, normalize(p.title))]
      ..sort((a, b) => b.$2.length.compareTo(a.$2.length));
    final out = <Piece, String>{};
    for (final name in [...fileNames]..sort()) {
      final dot = name.lastIndexOf('.');
      if (dot <= 0) continue;
      final ext = name.substring(dot + 1).toLowerCase();
      if (!audioExtensions.contains(ext)) continue;
      final base = normalize(name.substring(0, dot));
      for (final (piece, title) in titles) {
        if (title.isNotEmpty && base.contains(title)) {
          out.putIfAbsent(piece, () => name);
          break;
        }
      }
    }
    return out;
  }
}
