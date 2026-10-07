import '../../entities/memory_tag.dart';
import '../../value_objects/school_enums.dart';
import '../models/game_enums.dart';
import 'university_catalog.dart';
import '../models/game_state.dart';
import 'game_context.dart';
import 'memory_writer.dart';
import 'relations.dart';

/// 受験先の候補（高校・大学で共用）。
class ExamTarget {
  const ExamTarget({
    required this.id,
    required this.name,
    required this.deviation,
    required this.isPrivate,
    this.clubTier,
    this.isMusic = false,
    this.note = '',
  });

  final String id;
  final String name;
  final int deviation;
  final bool isPrivate;

  /// 吹奏楽部の強さ（高校のみ）。
  final ClubTier? clubTier;

  /// 音楽大学か（実技試験あり）。
  final bool isMusic;
  final String note;
}

/// 高校受験。
///
/// 受験の実力 = 学力×0.7 + 内申×0.3 + 部活実績ボーナス（最大 +7）。
/// 合格に必要な点 = 20 + (偏差値 − 35) × 1.6（私立の併願は −4）。
/// 当日の出来は SimulationRng(turn, 'exam', actor: 学校 ID) の揺らぎ（標準偏差 5）。
///
/// 部活推薦: 強豪の私立高校が、熟練度・コンクール実績・役職・内申から
/// 「スカウト点」を計算し、基準を超えると 11 月に打診してくる。受ければ合格が内定する。
class EntranceExamEngine {
  const EntranceExamEngine(this.ctx);

  final GameContext ctx;

  /// 高校の受験先候補（偏差値の高い順）。
  List<ExamTarget> highSchools() {
    final list =
        [
          for (final s in ctx.world.schools)
            if (s.level == SchoolLevel.high)
              ExamTarget(
                id: s.id,
                name: s.name,
                deviation: s.deviation!,
                isPrivate: s.isPrivate,
                clubTier: ctx.index.clubOfSchool(s.id).tier,
                note: s.cultures.map((c) => c.label).join('・'),
              ),
        ]..sort((a, b) {
          final c = b.deviation.compareTo(a.deviation);
          return c != 0 ? c : a.id.compareTo(b.id);
        });
    return list;
  }

  /// 大学の受験先候補（偏差値の高い順）。
  List<ExamTarget> universities() => UniversityCatalog.generate(
    ctx.world.seed,
    ctx.world.region.prefectureName,
  );

  /// 内申点（1.0〜5.0 を 10 倍した整数。最終学年の評定を 2 倍で重み付け）。
  /// [high] が true なら高校の評定（評定平均）、false なら中学の評定。
  static int naishin10(PlayerState p, {bool high = false}) {
    var sum = 0;
    var weight = 0;
    final (from, to) = high ? (3, 5) : (0, 2);
    for (final g in p.termGrades) {
      if (g.academicYearIndex < from || g.academicYearIndex > to) continue;
      final w = g.academicYearIndex == to ? 2 : 1;
      sum += g.grade * w * 10;
      weight += w;
    }
    return weight == 0 ? 30 : sum ~/ weight;
  }

  /// 部活実績ボーナス（0〜7）。
  static int clubBonus(GameState s) {
    var best = 0;
    for (final a in s.achievements) {
      if (a.kind == 'contest' && a.weight > best) best = a.weight;
    }
    final role = s.achievements.any(
      (a) => a.kind == 'role:captain' || a.kind == 'role:gradeRep',
    );
    return (best ~/ 20 + (role ? 2 : 0)).clamp(0, 7);
  }

  /// 受験の実力（0〜100 前後）。
  /// - 高校: 学力×0.7 + 内申×0.3 + 部活実績
  /// - 大学: 学力×0.85 + 評定平均×0.15 + 部活実績/2
  /// - 音楽大学: 実技（熟練度×0.7 + 音楽性×0.3）+ 部活実績
  int strength(GameState s, [ExamTarget? target]) {
    final p = s.player;
    final academic = p.academic ~/ 10;
    if (target != null && target.isMusic) {
      return p.skill * 7 ~/ 100 + p.musicality * 3 ~/ 100 + clubBonus(s);
    }
    if (s.stage == GameStage.high) {
      final naishin = (naishin10(p, high: true) - 10) * 100 ~/ 40;
      return academic * 85 ~/ 100 + naishin * 15 ~/ 100 + clubBonus(s) ~/ 2;
    }
    final naishin = (naishin10(p) - 10) * 100 ~/ 40;
    return academic * 7 ~/ 10 + naishin * 3 ~/ 10 + clubBonus(s);
  }

  static int required(ExamTarget t) => t.isMusic
      ? 25 + (t.deviation - 35) * 14 ~/ 10
      : 20 + (t.deviation - 35) * 16 ~/ 10 - (t.isPrivate ? 4 : 0);

  /// 合格可能性の判定（A〜E）。
  String estimate(GameState s, ExamTarget t) {
    final d = strength(s, t) - required(t);
    return d >= 8
        ? 'A'
        : (d >= 3 ? 'B' : (d >= -2 ? 'C' : (d >= -7 ? 'D' : 'E')));
  }

  /// 部活推薦の打診先。
  List<ExamTarget> recommendationOffers(GameState s) {
    var bestContest = 0;
    for (final a in s.achievements) {
      if (a.kind == 'contest' && a.weight > bestContest) bestContest = a.weight;
    }
    final captain = s.achievements.any(
      (a) => a.kind == 'role:captain' || a.kind == 'role:gradeRep',
    );
    final scout =
        s.player.skill ~/ 10 +
        bestContest ~/ 2 +
        (captain ? 10 : 0) +
        naishin10(s.player) ~/ 5;
    return [
      for (final t in highSchools())
        if (t.isPrivate &&
            switch (t.clubTier) {
              ClubTier.national => scout >= 75,
              ClubTier.block => scout >= 62,
              ClubTier.prefectural => scout >= 52,
              _ => false,
            })
          t,
    ];
  }

  /// 合否判定（出願した学校のうち、[privateOnly] で私立・公立を分けて発表する）。
  ({GameState state, List<String> lines}) announce(
    GameState s, {
    required bool privateOnly,
  }) {
    final exam = s.exam!;
    final targets = {for (final t in _targetsFor(exam.kind)) t.id: t};
    final results = Map.of(exam.results);
    final lines = <String>[];
    final mem = MemoryWriter(ctx, s);
    for (final id in exam.applications) {
      final t = targets[id]!;
      if (t.isPrivate != privateOnly || results.containsKey(id)) continue;
      final rng = ctx.sim.stream(turn: s.turn, domain: 'exam', actor: id);
      final score =
          strength(s, t) +
          rng.normalInt(mean: 0, sd: 5, min: -15, max: 15) -
          (s.player.hasTrait('stage_fright') ? 2 : 0);
      final pass = score >= required(t);
      results[id] = pass;
      lines.add('${t.name}：${pass ? '合格！' : '不合格……'}');
      mem.add(
        category: MemoryCategory.academic,
        subjectId: Relations.player,
        reasonKey: pass ? 'exam_passed' : 'exam_failed',
        params: {'school': t.name},
        importance: pass ? 45 : 40,
      );
    }
    return (
      state: mem.apply(s.copyWith(exam: exam.copyWith(results: results))),
      lines: lines,
    );
  }

  /// 進学先の確定: 推薦 > 公立（第一志望）> 合格した私立の中で偏差値が最も高い学校 > 二次募集。
  ({GameState state, List<String> lines}) decideEnrollment(GameState s) {
    final exam = s.exam!;
    final targets = {for (final t in _targetsFor(exam.kind)) t.id: t};
    String? enrolled = exam.recommended;
    final lines = <String>[];
    if (enrolled == null) {
      final passedPublic = [
        for (final id in exam.applications)
          if (exam.results[id] == true && !targets[id]!.isPrivate) id,
      ];
      final passedPrivate = [
        for (final id in exam.applications)
          if (exam.results[id] == true && targets[id]!.isPrivate) id,
      ]..sort((a, b) => targets[b]!.deviation.compareTo(targets[a]!.deviation));
      enrolled = passedPublic.isNotEmpty
          ? passedPublic.first
          : (passedPrivate.isNotEmpty ? passedPrivate.first : null);
    }
    if (enrolled == null && exam.kind == 'university') {
      lines.add('どの大学にも合格できなかった。浪人して来年もう一度挑戦することにした。');
      return (
        state: s.copyWith(exam: exam.copyWith(enrolled: ronin)),
        lines: lines,
      );
    }
    if (enrolled == null) {
      // 二次募集: 出願していない公立のうち偏差値が最も低い学校。
      final fallback =
          targets.values
              .where((t) => !t.isPrivate && !exam.applications.contains(t.id))
              .toList()
            ..sort((a, b) {
              final c = a.deviation.compareTo(b.deviation);
              return c != 0 ? c : a.id.compareTo(b.id);
            });
      enrolled =
          (fallback.isNotEmpty ? fallback.first : targets.values.last).id;
      lines.add('どこにも合格できなかったが、二次募集で${targets[enrolled]!.name}に合格した。');
    }
    lines.add('進学先：${targets[enrolled]!.name}');
    return (
      state: s.copyWith(exam: exam.copyWith(enrolled: enrolled)),
      lines: lines,
    );
  }

  /// 自動進行用の出願: 判定 B 以上で最も偏差値の高い公立 + 判定 A の私立 1 校。
  List<String> autoApplications(GameState s) {
    final all = highSchools();
    final public = all
        .where((t) => !t.isPrivate && 'AB'.contains(estimate(s, t)))
        .toList();
    final private = all
        .where((t) => t.isPrivate && estimate(s, t) == 'A')
        .toList();
    return [
      if (public.isNotEmpty) public.first.id,
      if (private.isNotEmpty) private.first.id,
      if (public.isEmpty && private.isEmpty) all.last.id,
    ];
  }

  /// 浪人を表す進学先 ID。
  static const String ronin = 'ronin';

  List<ExamTarget> targetsFor(String kind) =>
      kind == 'high' ? highSchools() : universities();

  List<ExamTarget> _targetsFor(String kind) => targetsFor(kind);

  /// 大学の推薦: 音楽大学（熟練度とコンクール実績）と指定校推薦（評定平均 4.2 以上）。
  List<ExamTarget> universityOffers(GameState s) {
    var bestContest = 0;
    for (final a in s.achievements) {
      if (a.kind == 'contest' && a.weight > bestContest) bestContest = a.weight;
    }
    final unis = universities();
    final offers = <ExamTarget>[];
    if (s.player.skill >= 650 && bestContest >= 55) {
      offers.addAll(unis.where((u) => u.isMusic && u.isPrivate));
    }
    final schoolDev = ctx.school(s).deviation ?? 50;
    if (naishin10(s.player, high: true) >= 42) {
      final designated = unis
          .where(
            (u) => u.isPrivate && !u.isMusic && u.deviation <= schoolDev + 5,
          )
          .toList();
      if (designated.isNotEmpty) offers.add(designated.first);
    }
    return offers;
  }

  /// 自動進行用の大学の出願: 判定 B 以上の国公立 + 判定 A の私立 + 判定 B 以上の音大。
  List<String> autoUniversityApplications(GameState s) {
    final all = universities();
    final public = all
        .where(
          (t) => !t.isPrivate && !t.isMusic && 'AB'.contains(estimate(s, t)),
        )
        .toList();
    final private = all
        .where((t) => t.isPrivate && !t.isMusic && estimate(s, t) == 'A')
        .toList();
    final music = all
        .where((t) => t.isMusic && 'AB'.contains(estimate(s, t)))
        .toList();
    final chosen = [
      if (public.isNotEmpty) public.first.id,
      if (private.isNotEmpty) private.first.id,
      if (music.isNotEmpty) music.first.id,
    ];
    return chosen.isEmpty ? [all.where((t) => !t.isMusic).last.id] : chosen;
  }

  static String? validateUniversityApplications(List<ExamTarget> chosen) {
    if (chosen.isEmpty) return '1校以上選んでください';
    if (chosen.length > 3) return '3校まで';
    return null;
  }

  /// プレイヤーの選択に関する検証（高校: 私立 2 校まで + 公立 1 校まで、1 校以上）。
  static String? validateHighApplications(List<ExamTarget> chosen) {
    if (chosen.isEmpty) return '1校以上選んでください';
    if (chosen.where((t) => t.isPrivate).length > 2) return '私立は2校まで';
    if (chosen.where((t) => !t.isPrivate).length > 1) return '公立は1校まで';
    return null;
  }

  static const PendingEventType noticeType = PendingEventType.notice;
}
