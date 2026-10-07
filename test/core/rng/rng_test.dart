import 'package:brass_life/core/rng/prng_core.dart';
import 'package:brass_life/core/rng/rng_stream.dart';
import 'package:brass_life/core/rng/seed_code.dart';
import 'package:brass_life/core/rng/seed_hasher.dart';
import 'package:brass_life/core/rng/simulation_rng.dart';
import 'package:brass_life/core/rng/uint32.dart';
import 'package:brass_life/core/rng/world_seed_rng.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('uint32', () {
    test('mul32 は 32bit 乗算の下位 32bit と一致する', () {
      expect(mul32(0xFFFFFFFF, 0xFFFFFFFF), 1);
      expect(mul32(0x9E3779B9, 0x85EBCA6B), 3238976083);
      expect(mul32(12345, 67890), 838102050);
    });

    test('rotl32', () {
      expect(rotl32(0x80000000, 1), 1);
      expect(rotl32(0x12345678, 8), 0x34567812);
    });
  });

  group('xoshiro128**', () {
    test('参照実装と同じ数列を返す（state = 1,2,3,4）', () {
      // Python による独立実装で算出した値。
      final core = Xoshiro128StarStar.fromState([1, 2, 3, 4]);
      final out = [for (var i = 0; i < 6; i++) core.nextUint32()];
      expect(out, [11520, 0, 5927040, 70819200, 2031721883, 1637235492]);
    });
  });

  group('SeedHasher', () {
    test('FNV-1a 32bit の既知ベクトル', () {
      expect(SeedHasher.fnv1a32(''), 0x811C9DC5);
      expect(SeedHasher.fnv1a32('a'), 0xE40C292C);
      expect(SeedHasher.fnv1a32('吹奏楽'), 0xCBF6D556);
    });

    test('fmix32 の既知ベクトル', () {
      expect(SeedHasher.fmix32(1), 0x514E28B7);
      expect(SeedHasher.fmix32(0xDEADBEEF), 0x0DE5C6A9);
    });

    test('derive はラベル・整数で異なる値になり、同じ入力では同じ値になる', () {
      final a = SeedHasher.derive(42, 'world/school/1');
      final b = SeedHasher.derive(42, 'world/school/2');
      final c = SeedHasher.derive(42, 'world/school/1');
      final d = SeedHasher.derive(42, 'x', [-1]);
      final e = SeedHasher.derive(42, 'x', [0xFFFFFFFF]);
      expect(a, isNot(b));
      expect(a, c);
      expect(d, isNot(e), reason: '負数と同じ下位 32bit の正数を区別する');
    });
  });

  group('RngStream', () {
    test('同じ Seed からは同じ数列', () {
      final a = RngStream(123);
      final b = RngStream(123);
      for (var i = 0; i < 100; i++) {
        expect(a.nextUint32(), b.nextUint32());
      }
    });

    test('nextInt は範囲内で偏りが小さい', () {
      final r = RngStream(7);
      final counts = List.filled(6, 0);
      for (var i = 0; i < 60000; i++) {
        counts[r.nextInt(6)]++;
      }
      for (final c in counts) {
        expect(c, inInclusiveRange(9400, 10600));
      }
    });

    test('nextDouble は [0,1)', () {
      final r = RngStream(9);
      for (var i = 0; i < 10000; i++) {
        final v = r.nextDouble();
        expect(v >= 0 && v < 1, isTrue);
      }
    });

    test('normalInt は平均・標準偏差がおおむね指定どおり', () {
      final r = RngStream(11);
      const n = 20000;
      var sum = 0;
      var sq = 0;
      for (var i = 0; i < n; i++) {
        final v = r.normalInt(mean: 50, sd: 10, min: -1000, max: 1000);
        sum += v;
        sq += v * v;
      }
      final mean = sum / n;
      final variance = sq / n - mean * mean;
      expect(mean, closeTo(50, 0.5));
      expect(variance, closeTo(100, 6));
    });

    test('weightedIndex は重み 0 を選ばない', () {
      final r = RngStream(5);
      for (var i = 0; i < 2000; i++) {
        expect(r.weightedIndex([0, 3, 0, 1]), anyOf(1, 3));
      }
    });

    test('chance(0) と chance(10000)', () {
      final r = RngStream(3);
      for (var i = 0; i < 1000; i++) {
        expect(r.chance(0), isFalse);
        expect(r.chance(10000), isTrue);
      }
    });

    test('shuffled / sample は元リストを変更せず要素を保存する', () {
      final r = RngStream(1);
      final src = [1, 2, 3, 4, 5, 6, 7, 8];
      final sh = r.shuffled(src);
      expect(src, [1, 2, 3, 4, 5, 6, 7, 8]);
      expect(sh.toSet(), src.toSet());
      final s = r.sample(src, 3);
      expect(s.length, 3);
      expect(s.toSet().length, 3);
    });

    test('パス派生: 他のストリームの消費量に影響されない', () {
      const w = WorldSeedRng(99);
      final a1 = w.stream('world/school/3').nextUint32();
      final x = w.stream('world/school/2');
      for (var i = 0; i < 1000; i++) {
        x.nextUint32();
      }
      final a2 = w.stream('world/school/3').nextUint32();
      expect(a1, a2);
    });
  });

  group('SimulationRng', () {
    test('同じ (turn, domain, actor, choice) は同じ結果', () {
      const sim = SimulationRng(2024);
      final a = sim.stream(
        turn: 5,
        domain: 'player_action',
        choice: 'practice',
      );
      final b = sim.stream(
        turn: 5,
        domain: 'player_action',
        choice: 'practice',
      );
      expect(a.nextUint32(), b.nextUint32());
    });

    test('選択・ターン・主体が異なれば別の数列', () {
      const sim = SimulationRng(2024);
      int first(int t, String d, String a, String c) =>
          sim.stream(turn: t, domain: d, actor: a, choice: c).nextUint32();
      final base = first(5, 'player_action', '', 'practice');
      expect(first(5, 'player_action', '', 'study'), isNot(base));
      expect(first(6, 'player_action', '', 'practice'), isNot(base));
      expect(
        first(5, 'npc_autonomy', 'npc_1', ''),
        isNot(first(5, 'npc_autonomy', 'npc_2', '')),
      );
    });
  });

  group('SeedCode', () {
    test('encode → decode の往復', () {
      for (final seed in [0, 1, 31, 0x7FFFFFFF, 0xFFFFFFFF, 123456789]) {
        final code = SeedCode.encode(seed);
        expect(code.length, 8);
        expect(SeedCode.tryDecode(code), seed);
        expect(SeedCode.tryDecode(SeedCode.format(seed).toLowerCase()), seed);
      }
    });

    test('チェック文字が違えば無効', () {
      final code = SeedCode.encode(123456789);
      final last = code[7];
      final wrong = code.substring(0, 7) + (last == 'A' ? 'B' : 'A');
      expect(SeedCode.tryDecode(wrong), isNull);
    });

    test('任意文字列は前後空白を無視してハッシュされる', () {
      expect(SeedCode.seedFromInput(' 吹奏楽 '), SeedCode.seedFromInput('吹奏楽'));
      expect(SeedCode.seedFromInput('A'), isNot(SeedCode.seedFromInput('B')));
    });

    test('有効なシードコードはそのままデコードされる', () {
      final code = SeedCode.format(987654321);
      expect(SeedCode.seedFromInput(code), 987654321);
    });
  });
}
