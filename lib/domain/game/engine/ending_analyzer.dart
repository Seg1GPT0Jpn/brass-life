import '../../career/career_ending.dart';
import '../../entities/memory_tag.dart';
import '../../master/memory_templates.dart';
import '../models/game_state.dart';
import 'game_context.dart';
import 'relations.dart';

/// エンディングの内容。
class EndingResult {
  const EndingResult({
    required this.title,
    required this.titleReason,
    required this.epilogue,
    required this.highlights,
    required this.stats,
    required this.otherTitles,
  });

  /// プレイヤー固有の称号。
  final String title;

  /// 称号が選ばれた理由。
  final String titleReason;

  /// エピローグ（段落）。
  final List<String> epilogue;

  /// 思い出ベスト（重要度の高い記憶）。
  final List<String> highlights;

  /// 6 年間の数値のまとめ（ラベル, 値）。
  final List<(String, String)> stats;

  /// 次点の称号。
  final List<String> otherTitles;
}

/// 6 年間の解析で使う特徴量。
class _Features {
  _Features(this.s, this.ctx);

  final GameState s;
  final GameContext ctx;

  int count(String action) => s.player.actionCounts[action] ?? 0;
  int get total => s.player.actionCounts.values.fold(0, (a, b) => a + b);
  int pct(int n) => total == 0 ? 0 : n * 100 ~/ total;

  int get practicePct => pct(
    count('individualPractice') +
        count('partPractice') +
        count('basics') +
        count('extraPractice'),
  );
  int get extraPct => pct(count('extraPractice'));

  /// 退部した回数・再入部した回数（6 年間の記憶から）。
  int _playerMemories(String key) => s.memories
      .where((m) => m.reasonKey == key && m.subjectId == 'player')
      .length;
  int get quits => _playerMemories('player_quit_club');
  int get studyPct => pct(count('study'));
  int get hangOutPct => pct(count('hangOut'));
  int get restPct => pct(count('rest'));

  Iterable<Achievement> get contests =>
      s.achievements.where((a) => a.kind == 'contest');
  int get bestContestWeight =>
      contests.fold(0, (m, a) => a.weight > m ? a.weight : m);
  Achievement? get bestContest {
    Achievement? best;
    for (final a in contests) {
      if (best == null || a.weight > best.weight) best = a;
    }
    return best;
  }

  bool get reachedNational => contests.any((a) => a.label.contains('全国大会'));
  bool get nationalGold => contests.any((a) => a.label.contains('全国大会 金賞'));
  int get supportYears =>
      s.achievements.where((a) => a.kind == 'contest_support').length;
  bool role(String r) => s.achievements.any((a) => a.kind == 'role:$r');
  bool get captain => role('captain') || role('gradeRep');
  int get solos => s.memories
      .where(
        (m) => m.reasonKey == 'solo_chosen' && m.subjectId == Relations.player,
      )
      .length;
  int get auditionFails => s.memories
      .where(
        (m) =>
            m.reasonKey == 'audition_failed' && m.subjectId == Relations.player,
      )
      .length;

  Achievement? get university => s.achievements
      .where((a) => a.kind.startsWith('univ') || a.kind == 'ronin')
      .lastOrNull;
  bool get musicCollege => university?.kind == 'univ_music';
  bool get ronin => university?.kind == 'ronin';

  /// 相手から見た好感 + 自分から見た好感。
  int bond(String id) =>
      Relations.get(s, id, Relations.player).affection +
      Relations.get(s, Relations.player, id).affection;
  int rivalry(String id) =>
      Relations.get(s, id, Relations.player).rivalry +
      Relations.get(s, Relations.player, id).rivalry;

  List<String> get knownPeople {
    final ids = <String>{};
    for (final k in s.relations.keys) {
      final parts = k.split('>');
      if (parts[0] == Relations.player && ctx.npcOrNull(s, parts[1]) != null) {
        ids.add(parts[1]);
      }
      if (parts[1] == Relations.player && ctx.npcOrNull(s, parts[0]) != null) {
        ids.add(parts[0]);
      }
    }
    return ids.toList()..sort();
  }

  String? get bestFriend {
    String? best;
    var score = 20;
    for (final id in knownPeople) {
      if (bond(id) > score) {
        best = id;
        score = bond(id);
      }
    }
    return best;
  }

  String? get rival {
    String? best;
    var score = 15;
    for (final id in knownPeople) {
      if (rivalry(id) > score) {
        best = id;
        score = rivalry(id);
      }
    }
    return best;
  }

  int get friends => knownPeople.where((id) => bond(id) >= 40).length;
  int get enemies => knownPeople.where((id) => bond(id) <= -30).length;

  Iterable<MemoryTag> get mine => s.memories.where(
    (m) =>
        m.subjectId == Relations.player ||
        m.objectIds.contains(Relations.player),
  );
  int get conflicts =>
      mine.where((m) => m.category == MemoryCategory.conflict).length;
  int get reconciliations =>
      mine.where((m) => m.category == MemoryCategory.reconciliation).length;
  int get rumorsAboutMe => s.memories
      .where(
        (m) =>
            m.reasonKey == 'spread_rumor' &&
            m.params['victim'] == s.player.fullName,
      )
      .length;
  bool get reunited => s.memories.any((m) => m.reasonKey == 'reunited');
  bool get wishDenied => s.memories.any(
    (m) =>
        m.subjectId == Relations.player &&
        m.reasonKey == 'instrument_wish_denied',
  );
  int get avgGrade {
    final g = s.player.termGrades;
    return g.isEmpty ? 30 : g.fold(0, (a, b) => a + b.grade) * 10 ~/ g.length;
  }
}

/// 6 年間の MemoryTag・実績・最終ステータスを解析し、称号とエピローグを生成する。
///
/// 称号は候補ごとに「条件を満たす度合い」をスコア化し、最も高いものを選ぶ。
/// エピローグは中学・高校・人間関係・進路の 4 段落を、実際の記憶と実績から組み立てる。
class EndingAnalyzer {
  const EndingAnalyzer(this.ctx);

  final GameContext ctx;

  EndingResult analyze(GameState s) {
    if (s.mode.isCareer) return CareerEndingAnalyzer(ctx).analyze(s);
    final f = _Features(s, ctx);
    final p = s.player;
    String name(String? id) => id == null ? '' : ctx.npc(s, id).fullName;

    // ── 称号の候補とスコア ──
    final candidates = <(String, int, String)>[
      (
        '全国の舞台に立った奏者',
        f.reachedNational ? 80 + (f.nationalGold ? 15 : 0) : 0,
        '全国大会の舞台で演奏した。',
      ),
      (
        '黄金のソリスト',
        f.solos >= 2 ? 60 + f.solos * 8 + f.bestContestWeight ~/ 5 : 0,
        'ソリストに${f.solos}度選ばれ、本番で音楽を背負った。',
      ),
      (
        '部をまとめた部長',
        f.captain ? 70 + f.bestContestWeight ~/ 4 : 0,
        '部長（代表）として部をまとめた。',
      ),
      ('名タクト', f.role('conductor') ? 72 : 0, '学生指揮として合奏を導いた。'),
      ('音楽の道へ', f.musicCollege ? 90 : 0, '音楽大学への進学を決めた。'),
      (
        '文武両道の秀才',
        !f.ronin &&
                (f.university?.weight ?? 0) >= 30 &&
                f.bestContestWeight >= 40
            ? 65 + (f.university?.weight ?? 0) ~/ 3
            : 0,
        '吹奏楽と勉強を両立し、難関大学に進んだ。',
      ),
      (
        '努力の人',
        f.practicePct >= 50 && p.skill >= 600 ? 55 + f.extraPct : 0,
        '練習を重ね（行動の${f.practicePct}%が練習）、熟練度 ${p.skill} に到達した。',
      ),
      (
        '仲間に愛された人',
        f.friends >= 5 ? 50 + f.friends * 4 : 0,
        '心を許せる仲間が${f.friends}人いた。',
      ),
      (
        '孤高の天才',
        p.skill >= 650 && f.friends <= 1 ? 68 : 0,
        '誰ともつるまず、ひとり技を磨き続けた。',
      ),
      (
        'ムードメーカー',
        f.hangOutPct >= 18 && f.friends >= 3 ? 50 + f.hangOutPct : 0,
        'いつも仲間と笑い合い、部を明るくした。',
      ),
      (
        '波乱万丈',
        f.conflicts >= 6 ? 45 + f.conflicts * 3 + f.reconciliations * 2 : 0,
        '衝突${f.conflicts}回、仲直り${f.reconciliations}回。ぶつかり合いながら進んだ。',
      ),
      (
        '縁の下の力持ち',
        f.supportYears >= 2 ? 48 + f.supportYears * 6 : 0,
        'コンクールメンバーになれない年も、部を支え続けた。',
      ),
      (
        '学業の星',
        f.avgGrade >= 42 && f.studyPct >= 30 ? 50 + f.studyPct ~/ 2 : 0,
        '評定平均 ${(f.avgGrade / 10).toStringAsFixed(1)}。勉強を大切にした。',
      ),
      ('もうひとつの青春', p.quitClub ? 62 : 0, '吹奏楽部を途中で離れ、部活の外に自分の居場所を見つけた。'),
      (
        '戻ってきた奏者',
        f.quits > 0 && !p.quitClub ? 58 + f.bestContestWeight ~/ 5 : 0,
        '一度は部を離れたが、もう一度楽器を手に取った。',
      ),
      ('自分らしく', 30, '自分のペースで6年間を駆け抜けた。'),
    ]..sort((a, b) => b.$2.compareTo(a.$2));
    final (title, _, reason) = candidates.first;

    // ── エピローグ ──
    final schools = [
      for (final id in s.schoolHistory) ctx.index.schoolById[id]?.name ?? id,
    ];
    final middle = schools.isNotEmpty ? schools.first : '中学校';
    final high = schools.length > 1 ? schools[1] : '高校';
    String bestOf(bool Function(Achievement) where) {
      Achievement? best;
      for (final a in s.achievements.where(where)) {
        if (a.kind != 'contest' && a.kind != 'contest_support') continue;
        if (best == null || a.weight > best.weight) best = a;
      }
      return best?.label ?? '';
    }

    final middleBest = bestOf((a) => a.label.startsWith('中'));
    final highBest = bestOf((a) => a.label.startsWith('高'));
    final roles = [
      for (final a in s.achievements)
        if (a.kind.startsWith('role:') && a.kind != 'role:partLeader') a.label,
    ];
    final firstInstrument = s.memories
        .where(
          (m) =>
              m.subjectId == Relations.player &&
              m.reasonKey.startsWith('instrument_wish'),
        )
        .firstOrNull;

    final paragraphs = <String>[
      '$middleで吹奏楽部に入った${p.fullName}。'
          '${firstInstrument == null ? '' : (f.wishDenied ? '希望の楽器は叶わず、${firstInstrument.params['instrument']}を担当することになった。' : '希望どおり${firstInstrument.params['instrument']}を手にした。')}'
          '${middleBest.isEmpty ? '仲間と音を重ねる日々が始まった。' : '中学時代の最高成績は「$middleBest」。'}',
      '$highでは${p.instrument?.label ?? '楽器'}を担当。'
          '${f.reunited ? '中学時代の仲間との再会もあった。' : ''}'
          '${highBest.isEmpty ? '' : '高校での最高成績は「$highBest」。'}'
          '${roles.isEmpty ? '' : '「${roles.last}」も務めた。'}'
          '${f.auditionFails > 0 ? 'オーディションに落ちた悔しさも${f.auditionFails}度味わった。' : ''}',
      [
        if (f.bestFriend != null) '一番の友は${name(f.bestFriend)}。',
        if (f.rival != null && f.rival != f.bestFriend)
          '${name(f.rival)}とは互いを高め合うライバルだった。',
        if (f.rumorsAboutMe > 0) '噂に悩まされたこともあった。',
        if (f.conflicts > 0 && f.reconciliations > 0)
          'ぶつかり、そして仲直りした日々も、今では大切な思い出だ。',
        if (f.bestFriend == null && f.rival == null) '多くを語らずとも、同じ譜面を見つめた仲間がいた。',
      ].join(),
      switch (f.university) {
        null => '卒業後の道はまだ決まっていない。',
        final u when u.kind == 'ronin' =>
          '大学受験は思うようにいかず、浪人を選んだ。それでも、あの6年間で培った粘り強さがある。',
        final u when u.kind == 'univ_music' =>
          '${u.label.replaceAll(' 進学', '')}に進み、音楽を生涯の道として選んだ。',
        final u =>
          '${u.label.replaceAll(' 進学', '')}に進学した。楽器ケースは、これからもきっと手元にある。',
      },
      '称号「$title」── $reason',
    ];

    // ── 思い出ベスト ──
    // 入学・卒業などの節目は除き、その人ならではの出来事を選ぶ。
    const milestones = {
      'player_joined_club',
      'entered_high',
      'graduated_middle',
      'graduated_high',
      'retired',
      'exam_result',
    };
    final best =
        [
          for (final m in f.mine)
            if (!milestones.contains(m.reasonKey)) m,
        ]..sort((a, b) {
          final c = b.importance.compareTo(a.importance);
          return c != 0 ? c : a.date.turn.compareTo(b.date.turn);
        });
    final highlights = [
      for (final m in best.take(7))
        '${m.date.stageLabel} ${renderMemory(m.reasonKey, m.params)}',
    ];

    final stats = <(String, String)>[
      ('最終熟練度', '${p.skill}（${p.instrument?.label ?? '－'}）'),
      ('音楽性', '${p.musicality}'),
      ('学力', '${p.academic}'),
      ('評定平均', (f.avgGrade / 10).toStringAsFixed(1)),
      ('最高成績', f.bestContest?.label ?? '－'),
      ('役職', roles.isEmpty ? '－' : roles.join('、')),
      ('親しい仲間', '${f.friends}人'),
      (
        '行動の割合',
        '練習${f.practicePct}% 勉強${f.studyPct}% 遊び${f.hangOutPct}% 休養${f.restPct}%',
      ),
      ('進路', f.university?.label ?? '－'),
    ];

    return EndingResult(
      title: title,
      titleReason: reason,
      epilogue: paragraphs.where((x) => x.isNotEmpty).toList(),
      highlights: highlights,
      stats: stats,
      otherTitles: [
        for (final c in candidates.skip(1).take(3))
          if (c.$2 > 30) c.$1,
      ],
    );
  }
}
