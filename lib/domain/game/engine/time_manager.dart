import '../../entities/memory_tag.dart';
import '../../entities/world.dart';
import '../../value_objects/instrument.dart';
import '../models/game_enums.dart';
import '../models/game_state.dart';
import '../master/approach_cards.dart';
import 'action_engine.dart';
import 'audition_engine.dart';
import 'concert_engine.dart';
import 'contest_engine.dart';
import 'executive_engine.dart';
import 'performance.dart';
import 'relations.dart';
import 'game_context.dart';
import 'instrument_decision.dart';
import 'memory_writer.dart';
import 'drama_engine.dart';
import 'roster_service.dart';
import 'school_calendar.dart';

/// 1 週間 = 1 ターンの進行エンジン。
///
/// - [newGame]: 世界からゲーム開始状態を作る。
/// - [submitAction]: 通常週の行動を 1 つ選んで週を進める。
/// - [resolveInstrumentDecision]: 入力待ちイベントの解決。
/// - [skipMonth]: 月の方針に従い、月末（またはイベント発生）まで自動で進める。
///
/// いずれも純粋関数で、同じ状態と同じ入力からは必ず同じ結果を返す。
class TimeManager {
  TimeManager(this.ctx) : school = SchoolCalendar(ctx.calendar);

  final GameContext ctx;
  final SchoolCalendar school;

  static const int maxLogs = 160;

  GameState newGame(World world) {
    final p = world.player;
    final club = ctx.index.clubOfSchool(p.schoolId);
    final (roster, npcs) = RosterService(ctx).initialRoster(club);
    var s = GameState(
      worldSeed: world.seed,
      generatorVersion: world.generatorVersion,
      turn: 0,
      stage: GameStage.middle,
      schoolId: p.schoolId,
      roster: roster,
      npcs: npcs,
      player: PlayerState(
        familyName: p.familyName,
        givenName: p.givenName,
        gender: p.gender,
        personality: p.personality,
        traits: p.traits,
        aptitude: p.aptitude,
        background: p.background,
        grade: 1,
        academic: p.academic * 10,
        stamina: p.stamina,
        motivation: (60 + p.personality.conscientiousness ~/ 5).clamp(20, 95),
      ),
    );
    final mem = MemoryWriter(ctx, s);
    final schoolName = ctx.index.schoolById[p.schoolId]!.name;
    mem.add(
      category: MemoryCategory.joinedClub,
      subjectId: 'player',
      objectIds: [club.id],
      reasonKey: 'player_joined_club',
      params: {'school': schoolName},
      importance: 50,
    );
    s = mem.apply(s);
    s = _log(s, null, [
      '$schoolNameに入学した。',
      '吹奏楽部の体験入部に参加。部員は ${roster.length} 人。来週、担当楽器が決まる。',
    ]);
    return _prepareTurn(s);
  }

  /// 通常週の行動を実行し、次の週へ進める。
  GameState submitAction(GameState s, WeeklyAction action) {
    if (s.pending != null) {
      throw StateError('入力待ちのイベントがあります: ${s.pending!.type}');
    }
    if (s.stage == GameStage.finished) return s;
    final r = ActionEngine(ctx).resolve(s, action);
    var next = r.state.copyWith(
      choices: [...r.state.choices, '${s.turn}:${action.name}'],
    );
    final drama = DramaEngine(ctx).weekly(next, action);
    next = _log(drama.state, action.label, [...r.lines, ...drama.lines]);
    return _advance(next);
  }

  /// 楽器決定イベントにプレイヤーの希望を提出する。
  ({GameState state, List<String> lines}) resolveInstrumentDecision(
    GameState s,
    List<InstrumentType> wishes,
  ) {
    _expect(s, PendingEventType.instrumentDecision);
    if (wishes.isEmpty) throw ArgumentError('希望を 1 つ以上指定してください');
    final out = InstrumentDecision(ctx).decide(s, playerWishes: wishes);
    return _finishEvent(
      out.state,
      '楽器決定',
      out.playerLines,
      'instrument:${wishes.map((w) => w.name).join(',')}',
    );
  }

  /// オーディションにアプローチカードを選んで臨む。
  ({GameState state, List<String> lines}) resolveAudition(
    GameState s,
    ApproachCard card,
  ) {
    _expect(s, PendingEventType.audition);
    final r = _audition(s, card);
    return _finishEvent(r.state, 'オーディション', r.lines, 'audition:${card.name}');
  }

  /// コンクールの本番にアプローチカードを選んで臨む。
  ({GameState state, List<String> lines}) resolveContest(
    GameState s,
    ApproachCard card,
  ) {
    _expect(s, PendingEventType.contest);
    final r = ContestEngine(ctx).perform(s, card);
    return _finishEvent(r.state, 'コンクール', r.lines, 'contest:${card.name}');
  }

  /// 幹部選出での意思を表明する。
  ({GameState state, List<String> lines}) resolveExecutive(
    GameState s,
    CandidacyChoice choice,
  ) {
    _expect(s, PendingEventType.executiveSelection);
    final r = ExecutiveEngine(ctx).run(s, choice);
    return _finishEvent(r.state, '幹部選出', r.lines, 'executive:${choice.name}');
  }

  /// 定期演奏会にアプローチカードを選んで臨む。
  ({GameState state, List<String> lines}) resolveConcert(
    GameState s,
    ApproachCard card,
  ) {
    _expect(s, PendingEventType.concert);
    final r = ConcertEngine(ctx).run(s, card);
    return _finishEvent(r.state, '定期演奏会', r.lines, 'concert:${card.name}');
  }

  /// 入力待ちイベントを既定の選択で解決する（テスト・自動進行用）。
  /// 楽器は [defaultWishes]、カードは手札の 1 枚目、幹部選出は「流れに任せる」。
  GameState autoResolve(
    GameState s, {
    List<InstrumentType> defaultWishes = const [InstrumentType.clarinet],
  }) {
    final p = s.pending;
    if (p == null) return s;
    return switch (p.type) {
      PendingEventType.instrumentDecision => resolveInstrumentDecision(
        s,
        defaultWishes,
      ).state,
      PendingEventType.audition => resolveAudition(s, cardsOf(s).first).state,
      PendingEventType.contest => resolveContest(s, cardsOf(s).first).state,
      PendingEventType.executiveSelection => resolveExecutive(
        s,
        CandidacyChoice.neutral,
      ).state,
      PendingEventType.concert => resolveConcert(s, cardsOf(s).first).state,
    };
  }

  /// [months] か月分、方針どおりに進める（イベントは既定の選択で自動解決）。
  GameState autoPlayMonths(GameState s, int months, MonthlyPolicy policy) {
    var cur = s;
    var count = 0;
    var lastMonth = ctx.calendar.dateOf(cur.turn).month;
    while (count < months && cur.stage != GameStage.finished) {
      cur = cur.pending != null ? autoResolve(cur) : skipMonth(cur, policy);
      final m = ctx.calendar.dateOf(cur.turn).month;
      if (m != lastMonth) {
        count++;
        lastMonth = m;
      }
    }
    return cur;
  }

  /// 入力待ちイベントで提示するカード。
  List<ApproachCard> cardsOf(GameState s) => [
    for (final name in (s.pending?.data['cards'] ?? '').split(','))
      if (name.isNotEmpty) ApproachCard.values.byName(name),
  ];

  void _expect(GameState s, PendingEventType type) {
    if (s.pending?.type != type) {
      throw StateError('${type.label}イベントではありません');
    }
  }

  ({GameState state, List<String> lines}) _finishEvent(
    GameState s,
    String label,
    List<String> lines,
    String choice,
  ) {
    var next = s.copyWith(
      pending: null,
      choices: [...s.choices, '${s.turn}:$choice'],
    );
    next = _log(next, label, lines);
    // 同じ週に続くイベントがあれば続けて処理する。
    next = _processEvents(next);
    return (state: next, lines: lines);
  }

  /// 月の方針で自動進行する。月が変わるか、入力待ちイベントが発生した時点で止まる。
  GameState skipMonth(GameState s, MonthlyPolicy policy) {
    var cur = s.copyWith(policy: policy);
    final month = ctx.calendar.dateOf(cur.turn).month;
    while (cur.pending == null && cur.stage != GameStage.finished) {
      final d = ctx.calendar.dateOf(cur.turn);
      if (d.month != month) break;
      cur = submitAction(cur, actionForPolicy(cur));
    }
    return cur;
  }

  /// 月の方針で、次の入力待ちイベントが来るまで（最大 [maxWeeks] 週）進める。
  GameState skipToNextEvent(
    GameState s,
    MonthlyPolicy policy, {
    int maxWeeks = 26,
  }) {
    var cur = s.copyWith(policy: policy);
    for (var i = 0; i < maxWeeks; i++) {
      if (cur.pending != null || cur.stage == GameStage.finished) break;
      cur = submitAction(cur, actionForPolicy(cur));
    }
    return cur;
  }

  /// 方針と状態から、その週の行動を決める。
  WeeklyAction actionForPolicy(GameState s) {
    final d = ctx.calendar.dateOf(s.turn);
    if (s.studyBeforeExams &&
        (school.isExamWeek(s.turn) || school.examNextWeek(s.turn))) {
      return WeeklyAction.study;
    }
    if (s.player.fatigue >= 80) return WeeklyAction.rest;
    if (s.player.stress >= 80) return WeeklyAction.hangOut;
    final pattern = s.policy.pattern;
    return pattern[(d.weekOfMonth - 1) % pattern.length];
  }

  // ───────────────────────── 内部処理 ─────────────────────────

  GameState _advance(GameState s) => _prepareTurn(s.copyWith(turn: s.turn + 1));

  /// 新しいターンの開始時処理（年度更新は 1 ターンに 1 回だけ）→ イベント処理。
  GameState _prepareTurn(GameState s) {
    var cur = s;
    if (cur.preparedTurn != cur.turn) {
      final d = ctx.calendar.dateOf(cur.turn);
      cur = cur.copyWith(preparedTurn: cur.turn);
      if (d.weekOfAcademicYear == 1 && d.academicYearIndex > 0) {
        cur = _newFiscalYear(cur, d.fiscalYear);
        if (cur.stage == GameStage.finished || cur.pending != null) return cur;
      }
    }
    return _processEvents(cur);
  }

  bool _playerPerforms(GameState s) =>
      s.player.instrument != null && !s.player.retired;

  /// その週に予定されているイベントを順に処理する。
  /// プレイヤーの入力が必要なものは pending に設定して止まり、解決後に再び呼ばれる。
  GameState _processEvents(GameState s) {
    var cur = s;
    final d = ctx.calendar.dateOf(cur.turn);
    final fy = d.fiscalYear;
    final contest = ContestEngine(ctx);
    final perf = Performance(ctx);

    // 1. 楽器決定（4 月第 2 週）
    if (cur.turn == school.instrumentDecisionTurn(fy)) {
      final waiting = ctx
          .activeMembers(cur)
          .any((m) => m.grade == 1 && m.instrument == null);
      if (cur.player.instrument == null) {
        return cur.copyWith(
          pending: PendingEvent(
            type: PendingEventType.instrumentDecision,
            turn: cur.turn,
          ),
        );
      }
      if (waiting) {
        final out = InstrumentDecision(ctx).decide(cur);
        cur = _log(out.state, null, ['新入生の担当楽器が決まった。']);
      }
    }

    // 2. オーディション（6 月第 2 週）
    if (cur.turn == school.turnOf(fy, 6, 2) && cur.contest?.fiscalYear != fy) {
      if (_playerPerforms(cur)) {
        return cur.copyWith(
          pending: PendingEvent(
            type: PendingEventType.audition,
            turn: cur.turn,
            data: {
              'cards': perf
                  .drawCards(cur, 'audition')
                  .map((c) => c.name)
                  .join(','),
              'needed': '${AuditionEngine(ctx).needed(cur)}',
            },
          ),
        );
      }
      final r = _audition(cur, null);
      cur = _log(r.state, 'オーディション', r.lines);
    }

    // 3. コンクール本番
    final next = cur.contest?.nextStage;
    if (cur.contest != null &&
        cur.contest!.fiscalYear == fy &&
        next != null &&
        cur.turn == contest.stageTurn(fy, next)) {
      if (cur.contestMembers.contains(Relations.player)) {
        return cur.copyWith(
          pending: PendingEvent(
            type: PendingEventType.contest,
            turn: cur.turn,
            data: {
              'stage': next.name,
              'cards': perf
                  .drawCards(
                    cur,
                    'contest:${next.name}',
                    soloist: cur.soloistId == Relations.player,
                  )
                  .map((c) => c.name)
                  .join(','),
            },
          ),
        );
      }
      final r = contest.perform(cur, null);
      cur = _log(r.state, 'コンクール', r.lines);
    }

    // 4. 3 年生の引退（コンクールの全日程が終わった翌週）
    final c = cur.contest;
    if (c != null &&
        c.fiscalYear == fy &&
        c.finishedTurn != null &&
        cur.turn > c.finishedTurn! &&
        !c.retirementDone) {
      cur = _retireThirdYears(cur, fy);
    }

    // 5. 幹部選出
    if (cur.executiveSelectionTurn == cur.turn) {
      if (_playerPerforms(cur) && cur.player.grade == 2) {
        return cur.copyWith(
          pending: PendingEvent(
            type: PendingEventType.executiveSelection,
            turn: cur.turn,
          ),
        );
      }
      final r = ExecutiveEngine(ctx).run(cur, null);
      cur = _log(r.state, '幹部選出', r.lines);
    }

    // 6. 定期演奏会（3 月第 3 週）
    if (cur.turn == school.turnOf(fy, 3, 3) && cur.lastConcertYear != fy) {
      if (_playerPerforms(cur)) {
        return cur.copyWith(
          pending: PendingEvent(
            type: PendingEventType.concert,
            turn: cur.turn,
            data: {
              'cards': perf
                  .drawCards(cur, 'concert')
                  .map((c) => c.name)
                  .join(','),
            },
          ),
        );
      }
      final r = ConcertEngine(ctx).run(cur, null);
      cur = _log(r.state, '定期演奏会', r.lines);
    }
    return cur;
  }

  /// オーディションを行い、コンクールの日程を開始する。
  ({GameState state, List<String> lines}) _audition(
    GameState s,
    ApproachCard? card,
  ) {
    final fy = ctx.calendar.dateOf(s.turn).fiscalYear;
    final r = AuditionEngine(ctx).run(s, card);
    final started = r.state.copyWith(
      contest: ContestEngine(ctx).start(r.state, fy),
    );
    return (state: started, lines: r.lines);
  }

  /// 3 年生の引退と、幹部選出の日程決定。
  GameState _retireThirdYears(GameState s, int fiscalYear) {
    final npcs = Map.of(s.npcs);
    final mem = MemoryWriter(ctx, s);
    var count = 0;
    for (final id in s.roster) {
      final st = npcs[id]!;
      if (st.active && st.grade == 3 && !st.retired) {
        npcs[id] = st.copyWith(retired: true);
        count++;
      }
    }
    var player = s.player;
    final lines = <String>['3年生 $count 人が引退した。'];
    if (player.grade == 3 && !player.retired) {
      player = player.copyWith(retired: true);
      mem.add(
        category: MemoryCategory.life,
        subjectId: Relations.player,
        objectIds: [ctx.club(s).id],
        reasonKey: 'retired',
        params: {'actor': player.fullName},
        importance: 50,
      );
      lines.add('あなたも部活を引退した。これからは受験に向けて頑張ろう。');
    }
    final sept = school.turnOf(fiscalYear, 9, 1);
    final execTurn = sept > s.turn ? sept : s.turn;
    final next = mem.apply(
      s.copyWith(
        npcs: npcs,
        player: player,
        contest: s.contest!.copyWith(retirementDone: true),
        executiveSelectionTurn: execTurn,
      ),
    );
    return _log(next, null, lines);
  }

  /// 年度更新: 3 年生の卒業・進級・新入生の入部。
  GameState _newFiscalYear(GameState s, int fiscalYear) {
    final club = ctx.club(s);
    final npcs = Map.of(s.npcs);
    final roster = <String>[];
    var graduated = 0;
    for (final id in s.roster) {
      final m = npcs[id]!;
      if (!m.active) continue;
      if (m.grade >= 3) {
        npcs[id] = m.copyWith(active: false, grade: 4);
        graduated++;
        continue;
      }
      npcs[id] = m.copyWith(grade: m.grade + 1);
      roster.add(id);
    }
    final cohort = RosterService(ctx).cohort(club, fiscalYear);
    final extra = Map.of(s.extraNpcs);
    for (final n in cohort) {
      extra[n.id] = n;
      roster.add(n.id);
      npcs[n.id] = RosterService.initialState(n)
          .copyWith(grade: 1, instrument: null, skill: 0);
    }
    final player = s.player.copyWith(grade: s.player.grade + 1);
    var next = s.copyWith(
      npcs: npcs,
      roster: roster,
      extraNpcs: extra,
      player: player,
      memories: compactMemories(s.memories, s.turn),
      contestMembers: const [],
      soloistId: null,
      contest: null,
      executiveSelectionTurn: null,
      // 卒業した 3 年生の役職を外す
      roles: {
        for (final e in s.roles.entries)
          if (e.key == 'player' || (npcs[e.key]?.active ?? false))
            e.key: e.value,
      },
    );
    if (player.grade > 3) {
      // Phase 5（高校受験と進学）で置き換える。
      return _log(next.copyWith(stage: GameStage.finished), null, [
        '中学校を卒業した。（高校編は今後のアップデートで追加されます）',
      ]);
    }
    next = _log(next, null, [
      '$fiscalYear年度が始まった。${player.grade}年生に進級。',
      '3年生 $graduated 人が卒業し、新入生 ${cohort.length} 人が入部した。',
    ]);
    return next;
  }

  /// 記憶の整理: 1 年以上前の、プレイヤーに関係しない重要度 20 未満の記憶を捨てる。
  /// （セーブデータの肥大化を防ぐ。重要な出来事とプレイヤーの記憶は全て残る）
  static List<MemoryTag> compactMemories(List<MemoryTag> all, int turn) => [
    for (final m in all)
      if (m.importance >= 20 ||
          m.subjectId == 'player' ||
          m.objectIds.contains('player') ||
          m.date.turn >= turn - 52)
        m,
  ];

  GameState _log(GameState s, String? action, List<String> lines) {
    final d = ctx.calendar.dateOf(s.turn);
    final logs = [
      ...s.logs,
      WeekLog(
        turn: s.turn,
        dateLabel: d.labelWithStage,
        actionLabel: action,
        lines: lines,
      ),
    ];
    return s.copyWith(
      logs: logs.length > maxLogs ? logs.sublist(logs.length - maxLogs) : logs,
    );
  }
}
