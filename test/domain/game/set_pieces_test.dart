import 'package:brass_life/core/rng/seed_code.dart';
import 'package:brass_life/data/repositories/master_piece_repository.dart';
import 'package:brass_life/domain/entities/world.dart';
import 'package:brass_life/domain/game/engine/game_context.dart';
import 'package:brass_life/domain/game/engine/piece_fit.dart';
import 'package:brass_life/domain/game/engine/piece_selection.dart';
import 'package:brass_life/domain/game/engine/time_manager.dart';
import 'package:brass_life/domain/game/master/free_pieces.dart';
import 'package:brass_life/domain/game/master/set_pieces.dart';
import 'package:brass_life/domain/game/models/game_enums.dart';
import 'package:brass_life/domain/game/models/game_state.dart';
import 'package:brass_life/domain/game/models/piece.dart';
import 'package:brass_life/domain/repositories/piece_repository.dart';
import 'package:brass_life/domain/services/world_generation/world_generator.dart';
import 'package:brass_life/domain/value_objects/instrument.dart';
import 'package:flutter_test/flutter_test.dart';

/// 課題曲 24 曲・自由曲 10 曲のマスターデータと、選曲・コンクールへの反映。
void main() {
  group('マスターデータ', () {
    test('6 年 × I〜IV の 24 曲がそろい、ID は一意', () {
      expect(SetPieces.all, hasLength(24));
      expect(SetPieces.all.map((p) => p.id).toSet(), hasLength(24));
      for (var y = 1; y <= 6; y++) {
        expect(SetPieces.byYear(y).map((p) => p.category), [
          'I',
          'II',
          'III',
          'IV',
        ]);
      }
      for (final p in SetPieces.all) {
        expect(p.type, '課題曲');
        expect(p.url, startsWith('https://suno.com/song/${p.id}'));
        expect(p.requiredStats, isNotEmpty);
        for (final e in p.requiredStats.entries) {
          expect(PieceStat.byKey(e.key), isNotNull, reason: e.key);
          expect(e.value, inInclusiveRange(1, 100));
        }
        expect(SetPieces.byId(p.id), same(p));
      }
    });

    test('年を追うごとに難しくなり、6 年目 IV が最難関', () {
      int yearAvg(int y) =>
          SetPieces.byYear(y).fold(0, (a, p) => a + p.difficulty) ~/ 4;
      for (var y = 1; y < 6; y++) {
        expect(yearAvg(y + 1), greaterThanOrEqualTo(yearAvg(y)));
      }
      final hardest = SetPieces.all.reduce(
        (a, b) => a.difficulty >= b.difficulty ? a : b,
      );
      expect(hardest.title, '吹奏楽のための交響的断章');
      expect(hardest.requiredStats.length, greaterThanOrEqualTo(8));
    });

    test('同梱音源の命名規則', () {
      expect(
        SetPieces.byYear(1).first.conventionalAssetPath,
        'assets/audio/y1_I.mp3',
      );
      expect(
        FreePieces.all.first.conventionalAssetPath,
        'assets/audio/free_1.mp3',
      );
    });
  });

  group('自由曲', () {
    test('10 曲がそろい、ID は一意で URL の曲 ID と一致する', () {
      expect(FreePieces.all, hasLength(10));
      expect(FreePieces.all.map((p) => p.id).toSet(), hasLength(10));
      expect(FreePieces.all.map((p) => p.category), [
        for (var i = 1; i <= 10; i++) '$i',
      ]);
      for (final p in FreePieces.all) {
        expect(p.type, Piece.freeType);
        expect(p.isFree, isTrue);
        expect(p.year, 0);
        expect(p.url, startsWith('https://suno.com/song/${p.id}?sh='));
        expect(FreePieces.grades, contains(p.grade));
        expect(p.requiredStats, isNotEmpty);
        for (final e in p.requiredStats.entries) {
          expect(PieceStat.byKey(e.key), isNotNull, reason: e.key);
          expect(e.value, inInclusiveRange(1, 100));
        }
        expect(FreePieces.byId(p.id), same(p));
      }
      // 課題曲と ID が重ならない
      final setIds = SetPieces.all.map((p) => p.id).toSet();
      expect(FreePieces.all.where((p) => setIds.contains(p.id)), isEmpty);
    });

    test('難易度ランクの内訳と、ランクが上がるほど難しい', () {
      expect(
        {for (final g in FreePieces.grades) g: FreePieces.byGrade(g).length},
        {'B': 2, 'A': 4, 'S': 2, 'SS': 2},
      );
      int avg(String g) {
        final ps = FreePieces.byGrade(g);
        return ps.fold(0, (a, p) => a + p.difficulty) ~/ ps.length;
      }

      for (var i = 0; i < FreePieces.grades.length - 1; i++) {
        final g = FreePieces.grades[i];
        final next = FreePieces.grades[i + 1];
        for (final easy in FreePieces.byGrade(g)) {
          for (final hard in FreePieces.byGrade(next)) {
            expect(hard.difficulty, greaterThan(easy.difficulty));
          }
        }
        expect(avg(next), greaterThan(avg(g)));
      }
      // SS は課題曲の最難関より難しい
      final hardestSet = SetPieces.all
          .map((p) => p.difficulty)
          .reduce((a, b) => a > b ? a : b);
      for (final p in FreePieces.byGrade('SS')) {
        expect(p.difficulty, greaterThan(hardestSet));
      }
    });

    test('表示名と、リポジトリからの取得', () {
      final p = FreePieces.byId('e6cfa493-cb95-488e-8ab6-992e6ee690be')!;
      expect(p.title, '天馬の飛翔');
      expect(p.label, '自由曲「天馬の飛翔」');
      expect(p.heading, '自由曲 A「天馬の飛翔」');
      expect(SetPieces.all.first.heading, '1年目 I「青空とファンファーレ」');
      final repo = MasterPieceRepository();
      expect(repo.all(), hasLength(34));
      expect(repo.freePieces(), same(FreePieces.all));
      expect(repo.byId(p.id), same(p));
      expect(repo.byYear(1), hasLength(4));
      expect(repo.pageOf(p).toString(), p.url);
      expect(
        repo.audioOf(p),
        isA<StreamPieceAudio>().having(
          (a) => a.url.toString(),
          'url',
          'https://cdn1.suno.ai/${p.id}.mp3',
        ),
      );
      final bundled = MasterPieceRepository(
        bundledAssets: {'assets/audio/free_5.wav'},
      );
      expect(
        bundled.audioOf(p),
        isA<AssetPieceAudio>().having(
          (a) => a.assetPath,
          'path',
          'assets/audio/free_5.wav',
        ),
      );
    });
  });

  group('選曲とコンクール', () {
    late World world;
    late GameContext ctx;
    late TimeManager tm;
    late GameState atSelection;

    setUpAll(() {
      world = const WorldGenerator().generate(SeedCode.seedFromInput('TEST'));
      ctx = GameContext(world);
      tm = TimeManager(ctx);
      var s = tm.newGame(world);
      while (s.pending?.type != PendingEventType.pieceSelection) {
        s = s.pending != null
            ? tm.autoResolve(s, defaultWishes: [InstrumentType.trumpet])
            : tm.submitAction(s, WeeklyAction.partPractice);
      }
      atSelection = s;
    });

    test('5 月に、その年の 4 曲から選曲するイベントが来る', () {
      final d = ctx.calendar.dateOf(atSelection.turn);
      expect(d.month, 5);
      final options = PieceSelection(ctx).optionsFor(atSelection);
      expect(options.map((p) => p.year).toSet(), {1});
    });

    test('顧問に任せると部に最も合う曲になる', () {
      final s = tm.resolvePieceSelection(atSelection, null).state;
      final fy = ctx.calendar.dateOf(atSelection.turn).fiscalYear;
      final best = PieceFit(ctx)
          .bestFor(atSelection, PieceSelection(ctx).optionsFor(atSelection));
      expect(s.setPieces['$fy'], best.id);
    });

    test('発言力があれば推した曲が採用される', () {
      final strong = atSelection.copyWith(
        player: atSelection.player.copyWith(advisorTrust: 90),
      );
      for (final p in PieceSelection(ctx).optionsFor(strong)) {
        final s = tm.resolvePieceSelection(strong, p.id).state;
        expect(PieceSelection(ctx).currentOf(s), same(p));
        expect(
          s.memories.any((m) => m.reasonKey == 'piece_proposal_adopted'),
          isTrue,
        );
      }
    });

    test('発言力がなく相性の悪い曲を推すと、顧問の判断になる', () {
      final weak = atSelection.copyWith(
        player: atSelection.player.copyWith(advisorTrust: 10),
      );
      final options = PieceSelection(ctx).optionsFor(weak);
      final fit = PieceFit(ctx);
      final stats = fit.bandStats(weak, fit.candidates(weak));
      final best = fit.bestFor(weak, options);
      final worst = options.reduce(
        (a, b) =>
            PieceFit.margin(a, stats) <= PieceFit.margin(b, stats) ? a : b,
      );
      if (worst == best) return;
      final s = tm.resolvePieceSelection(weak, worst.id).state;
      expect(PieceSelection(ctx).currentOf(s), same(best));
    });

    test('今年以外の曲は推せない', () {
      expect(
        () =>
            tm.resolvePieceSelection(atSelection, SetPieces.byYear(6).last.id),
        throwsArgumentError,
      );
    });

    test('部の実力が要求を上回るほど相性（余裕）が良い', () {
      final piece = SetPieces.byYear(1).first;
      final low = {for (final s in PieceStat.values) s: 30};
      final high = {for (final s in PieceStat.values) s: 80};
      expect(PieceFit.margin(piece, high), greaterThan(0));
      expect(PieceFit.margin(piece, low), lessThan(0));
      expect(
        PieceFit.contestBonus(PieceFit.margin(piece, high)),
        greaterThan(PieceFit.contestBonus(PieceFit.margin(piece, low))),
      );
    });

    test('コンクールで課題曲が演奏され、毎年の曲が記録される', () {
      var s = atSelection;
      final years = <String>{};
      for (var i = 0; i < 400 && s.stage != GameStage.finished; i++) {
        if (s.pending?.type == PendingEventType.contest) {
          final r = tm.resolveContest(s, tm.cardsOf(s).first);
          expect(r.lines.any((l) => l.startsWith('課題曲')), isTrue);
          s = r.state;
          continue;
        }
        s = s.pending != null
            ? tm.autoResolve(s, defaultWishes: [InstrumentType.trumpet])
            : tm.submitAction(s, tm.actionForPolicy(s));
        years.addAll(s.setPieces.keys);
        if (years.length >= 3) break;
      }
      expect(years.length, greaterThanOrEqualTo(3));
      for (final e in s.setPieces.entries) {
        final p = SetPieces.byId(e.value)!;
        expect(p.year, int.parse(e.key) - ctx.startYear + 1);
      }
    });
  });
}
