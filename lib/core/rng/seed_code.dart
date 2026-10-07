import 'seed_hasher.dart';
import 'uint32.dart';

/// World Seed（32bit）と共有用 8 文字コードの相互変換。
///
/// コードは Crockford Base32 の 7 文字（35bit 分、上位 3bit は 0）＋チェック文字 1 文字。
/// 表示時は `XXXX-XXXX` 形式。I/L→1, O→0 の読み替えとハイフン・空白の除去を行う。
abstract final class SeedCode {
  static const String _alphabet = '0123456789ABCDEFGHJKMNPQRSTVWXYZ';

  /// Seed → 8 文字コード（ハイフンなし）。
  static String encode(int seed) {
    final v = u32(seed);
    final chars = <String>[];
    var rest = v;
    for (var i = 0; i < 7; i++) {
      chars.add(_alphabet[rest % 32]);
      rest = rest ~/ 32;
    }
    final body = chars.reversed.join();
    return body + _alphabet[_checksum(v)];
  }

  /// 表示用 `XXXX-XXXX`。
  static String format(int seed) {
    final code = encode(seed);
    return '${code.substring(0, 4)}-${code.substring(4)}';
  }

  /// 文字列を正規化（大文字化・ハイフン/空白除去・紛らわしい文字の読み替え）。
  static String normalize(String input) {
    final buf = StringBuffer();
    for (final ch in input.toUpperCase().split('')) {
      if (ch == '-' || ch == ' ' || ch == '　') continue;
      if (ch == 'I' || ch == 'L') {
        buf.write('1');
      } else if (ch == 'O') {
        buf.write('0');
      } else {
        buf.write(ch);
      }
    }
    return buf.toString();
  }

  /// 有効なコードなら Seed を返す。チェック文字不一致・不正文字なら null。
  static int? tryDecode(String input) {
    final code = normalize(input);
    if (code.length != 8) return null;
    var v = 0;
    for (var i = 0; i < 7; i++) {
      final idx = _alphabet.indexOf(code[i]);
      if (idx < 0) return null;
      v = v * 32 + idx;
    }
    if (v > kMask32) return null;
    final check = _alphabet.indexOf(code[7]);
    if (check < 0 || check != _checksum(v)) return null;
    return v;
  }

  /// 任意のユーザー入力から World Seed を得る。
  ///
  /// 1. 有効なシードコードであればそれをデコードする（共有コードの再入力）。
  /// 2. それ以外は前後空白を除いた文字列を FNV-1a + fmix32 でハッシュする。
  static int seedFromInput(String input) {
    final decoded = tryDecode(input);
    if (decoded != null) return decoded;
    final trimmed = input.trim();
    return SeedHasher.fmix32(SeedHasher.fnv1a32(trimmed));
  }

  static int _checksum(int v) => SeedHasher.fmix32(v ^ 0x5EED5EED) % 32;
}
