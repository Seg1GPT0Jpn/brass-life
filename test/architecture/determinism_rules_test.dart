@TestOn('vm')
library;

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// 決定性を壊すコードの混入を防ぐアーキテクチャテスト。
void main() {
  List<File> dartFiles(String dir) => Directory(dir)
      .listSync(recursive: true)
      .whereType<File>()
      .where((f) => f.path.endsWith('.dart'))
      .where(
        (f) => !f.path.endsWith('.g.dart') && !f.path.endsWith('.freezed.dart'),
      )
      .toList();

  test('lib/ で dart:math の Random を直接使用していない', () {
    final pattern = RegExp(r'\bRandom\s*[.(]');
    for (final f in dartFiles('lib')) {
      final src = f.readAsStringSync();
      expect(pattern.hasMatch(src), isFalse, reason: f.path);
    }
  });

  test('domain/ と core/rng, core/time は Flutter・時刻・ハッシュ順序に依存しない', () {
    final forbidden = {
      'package:flutter/': 'Flutter への依存',
      'DateTime.now': '現在時刻への依存',
      'HashMap': '順序不定のコレクション',
      'HashSet': '順序不定のコレクション',
      '.hashCode %': 'hashCode による分岐',
    };
    for (final dir in ['lib/domain', 'lib/core/rng', 'lib/core/time']) {
      for (final f in dartFiles(dir)) {
        final src = f.readAsStringSync();
        forbidden.forEach((needle, why) {
          expect(src.contains(needle), isFalse, reason: '${f.path}: $why');
        });
      }
    }
  });

  test('domain/ でビットシフトを使っていない（Web では負数のシフトが符号なしになる）', () {
    // 32bit 演算は core/rng/uint32.dart に集約し、そこ以外では使わない。
    // ジェネリクスの閉じ括弧（List<List<int>>）と区別するため、前後に空白がある演算子のみ検出。
    final shift = RegExp(r'\s(<<|>>>?)=?\s');
    for (final f in dartFiles('lib/domain')) {
      final src = f.readAsStringSync();
      expect(shift.hasMatch(src), isFalse, reason: f.path);
    }
  });
}
