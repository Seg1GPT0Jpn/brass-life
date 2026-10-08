import '../../entities/memory_tag.dart';
import '../../entities/player.dart';
import '../../entities/world.dart';
import '../../value_objects/instrument.dart';
import '../models/candidacy.dart';
import 'club_membership.dart';
import 'piece_selection.dart';
import '../models/game_enums.dart';
import '../models/game_state.dart';
import '../models/player_setup.dart';
import '../master/approach_cards.dart';
import 'action_engine.dart';
import 'audition_engine.dart';
import 'concert_engine.dart';
import 'contest_engine.dart';
import 'executive_engine.dart';
import 'performance.dart';
import 'player_setup_service.dart';
import 'relations.dart';
import 'game_context.dart';
import 'instrument_decision.dart';
import 'interaction_rules.dart';
import 'memory_writer.dart';
import 'drama_engine.dart';
import 'entrance_exam_engine.dart';
import 'school_transition.dart';
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

  /// 新しい人生を始める。[setup] を省略すると Seed が決めた主人公で始める。
  GameState newGame(World world, {PlayerSetup? setup}) {
    final p = setup == null ? world.player : _playerFrom(world, setup);
    final club = ctx.index.clubOfSchool(p.schoolId);
    final (roster, npcs) = RosterService(ctx).initialRoster(club);
    var s = GameState(
      worldSeed: world.seed,
      generatorVersion: world.generatorVersion,
      turn: 0,
      stage: GameStage.middle,
      schoolId: p.schoolId,
      schoolHistory: [p.schoolId],
      roster: roster,
      npcs: npcs,
      setup: setup,
      choices: [if (setup != null) 'setup:custom'],
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

  /// 設定から主人公（世界のプレイヤーと同じ形）を作る。
  Player _playerFrom(World world, PlayerSetup setup) {
    final service = PlayerSetupService(world);
    final error = service.validate(setup);
    if (error != null) throw ArgumentError(error);
    return world.player.copyWith(
      familyName: setup.familyName.trim(),
      givenName: setup.givenName.trim(),
      gender: setup.gender,
      schoolId: setup.schoolId,
      background: setup.background,
      personality: setup.personality,
      traits: service.traitsFor(setup.personality),
      aptitude: PlayerSetupService.withBackground(
        setup.aptitude,
        setup.background,
      ),
      academic: setup.academic,
      stamina: setup.stamina,
    );
  }

  /// 通常週の行動を実行し、次の週へ進める。
  ///
  /// 相手を指定する行動（[WeeklyAction.needsTarget]）では [targetId] に部員の ID を渡す。
  /// 選べない組み合わせ（自分より下手な相手に教わる等）は [ArgumentError]。
  GameState submitAction(GameState s, WeeklyAction action, {String? targetId}) {
    if (s.pending != null) {
      throw StateError('入力待ちのイベントがあります: ${s.pending!.type}');
    }
    if (s.stage == GameStage.finished) return s;
    final reason = InteractionRules(ctx).unavailableReason(s, action, targetId);
    if (reason != null) throw ArgumentError(reason);
    final r = ActionEngine(ctx).resolve(s, action, targetId: targetId);
    var next = r.state.copyWith(
      choices: [
        ...r.state.choices,
        '${s.turn}:${ActionEngine.choiceKey(action, targetId)}',
      ],
    );
    final drama = DramaEngine(ctx).weekly(next, action, targetId: targetId);
    final label = targetId == null
        ? action.label
        : '${action.label}（${ctx.npc(s, targetId).fullName}）';
    next = _log(drama.state, label, [...r.lines, ...drama.lines]);
    return _advance(next);
  }

  /// 部を辞める。週は進まない（その週の行動は続けて選ぶ）。
  ({GameState state, List<String> lines}) quitClub(
    GameState s,
    QuitReason why,
  ) {
    final r = ClubMembership(ctx).quit(s, why);
    return (state: _log(r.state, '退部', r.lines), lines: r.lines);
  }

  /// 部に戻る。週は進まない。
  ({GameState state, List<String> lines}) rejoinClub(GameState s) {
    final r = ClubMembership(ctx).rejoin(s);
    return (state: _log(r.state, '再入部', r.lines), lines: r.lines);
  }

  /// 課題曲の選曲に答える。[pieceId] は推す曲（顧問に任せるなら null）。
  ({GameState state, List<String> lines}) resolvePieceSelection(
    GameState s,
    String? pieceId,
  ) {
    _expect(s, PendingEventType.pieceSelection);
    final r = PieceSelection(ctx).run(s, pieceId);
    return _finishEvent(
      r.state,
      '課題曲の選曲',
      r.lines,
      'piece:${pieceId ?? 'advisor'}',
    );
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
    Candidacy choice,
  ) {
    _expect(s, PendingEventType.executiveSelection);
    if (choice.isRun &&
        !ExecutiveEngine(ctx).runnableRoles(s).contains(choice.role)) {
      throw ArgumentError('この部では「${choice.role!.label}」に立候補できない');
    }
    final r = ExecutiveEngine(ctx).run(s, choice);
    return _finishEvent(r.state, '幹部選出', r.lines, 'executive:${choice.key}');
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

  /// 部活推薦の打診に答える（[schoolId] が null なら断る）。
  ({GameState state, List<String> lines}) resolveRecommendation(
    GameState s,
    String? schoolId,
  ) {
    _expect(s, PendingEventType.recommendation);
    final exam = s.exam!;
    final lines = <String>[];
    var next = s;
    if (schoolId != null) {
      if (!exam.offers.contains(schoolId)) throw ArgumentError('打診のない学校です');
      final name = EntranceExamEngine(ctx)
          .targetsFor(exam.kind)
          .firstWhere((t) => t.id == schoolId)
          .name;
      final mem = MemoryWriter(ctx, s);
      mem.add(
        category: MemoryCategory.academic,
        subjectId: Relations.player,
        reasonKey: exam.kind == 'high' ? 'recommended' : 'recommended_univ',
        params: {'school': name},
        importance: 55,
      );
      next = mem.apply(
        s.copyWith(
          exam: exam.copyWith(recommended: schoolId, enrolled: schoolId),
        ),
      );
      lines.add('$nameへの推薦を受けることにした。合格が内定した！');
    } else {
      lines.add('推薦の話は断り、一般入試で進路を決めることにした。');
    }
    return _finishEvent(
      next,
      '推薦の打診',
      lines,
      'recommend:${schoolId ?? 'none'}',
    );
  }

  /// 高校（大学）に出願する。
  ({GameState state, List<String> lines}) resolveApplication(
    GameState s,
    List<String> schoolIds,
  ) {
    _expect(s, PendingEventType.examApplication);
    final engine = EntranceExamEngine(ctx);
    final kind = s.exam!.kind;
    final targets = {for (final t in engine.targetsFor(kind)) t.id: t};
    final chosen = [for (final id in schoolIds) targets[id]!];
    final error = kind == 'high'
        ? EntranceExamEngine.validateHighApplications(chosen)
        : EntranceExamEngine.validateUniversityApplications(chosen);
    if (error != null) throw ArgumentError(error);
    final lines = [
      '出願した学校：',
      for (final t in chosen)
        '・${t.name}（${t.note.isEmpty ? (t.isPrivate ? '私立' : '公立') : t.note}／判定 ${engine.estimate(s, t)}）',
    ];
    final next = s.copyWith(exam: s.exam!.copyWith(applications: schoolIds));
    return _finishEvent(next, '出願', lines, 'apply:${schoolIds.join(',')}');
  }

  /// お知らせを確認する。
  ({GameState state, List<String> lines}) resolveNotice(GameState s) {
    _expect(s, PendingEventType.notice);
    return _finishEvent(s, null, const [], 'notice');
  }

  /// お知らせ（合格発表など）を表示する入力待ちイベントを設定する。
  GameState _notice(GameState s, String title, List<String> lines) {
    final logged = _log(s, title, lines);
    return logged.copyWith(
      pending: PendingEvent(
        type: PendingEventType.notice,
        turn: s.turn,
        data: {'title': title, 'lines': lines.join('\n')},
      ),
    );
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
      PendingEventType.pieceSelection => resolvePieceSelection(s, null).state,
      PendingEventType.audition => resolveAudition(s, cardsOf(s).first).state,
      PendingEventType.contest => resolveContest(s, cardsOf(s).first).state,
      PendingEventType.executiveSelection => resolveExecutive(
        s,
        const Candidacy.neutral(),
      ).state,
      PendingEventType.concert => resolveConcert(s, cardsOf(s).first).state,
      PendingEventType.recommendation => resolveRecommendation(
        s,
        s.exam!.offers.first,
      ).state,
      PendingEventType.examApplication => resolveApplication(
        s,
        s.exam!.kind == 'high'
            ? EntranceExamEngine(ctx).autoApplications(s)
            : EntranceExamEngine(ctx).autoUniversityApplications(s),
      ).state,
      PendingEventType.notice => resolveNotice(s).state,
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
    String? label,
    List<String> lines,
    String choice,
  ) {
    var next = s.copyWith(
      pending: null,
      choices: [...s.choices, '${s.turn}:$choice'],
    );
    if (label != null) next = _log(next, label, lines);
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
    final a = pattern[(d.weekOfMonth - 1) % pattern.length];
    // 退部中などで選べない行動は、自主練に置き換える。
    return InteractionRules(ctx).unavailableReason(s, a, null) == null
        ? a
        : WeeklyAction.individualPractice;
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
      s.player.instrument != null && s.player.inClub;

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

    // 1.5 課題曲の選曲（5 月第 1 週）
    if (cur.turn == school.turnOf(fy, 5, 1) && cur.setPieces['$fy'] == null) {
      if (_playerPerforms(cur)) {
        return cur.copyWith(
          pending: PendingEvent(
            type: PendingEventType.pieceSelection,
            turn: cur.turn,
          ),
        );
      }
      final r = PieceSelection(ctx).run(cur, null);
      cur = _log(r.state, '課題曲の選曲', r.lines);
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
    // 7. 受験（中学 3 年: 高校受験 / 高校 3 年: 大学受験）
    final examKind = switch (cur.stage) {
      GameStage.middle => 'high',
      GameStage.high => 'university',
      GameStage.finished => null,
    };
    if (examKind != null && cur.player.grade == 3) {
      final isHigh = examKind == 'high';
      final exam = EntranceExamEngine(ctx);
      final targets = {for (final t in exam.targetsFor(examKind)) t.id: t};
      if (cur.turn == school.turnOf(fy, 11, 3) && cur.exam == null) {
        final offers = isHigh
            ? exam.recommendationOffers(cur)
            : exam.universityOffers(cur);
        cur = cur.copyWith(
          exam: EntranceExamState(
            kind: examKind,
            offers: [for (final o in offers) o.id],
          ),
        );
        if (offers.isNotEmpty) {
          return cur.copyWith(
            pending: PendingEvent(
              type: PendingEventType.recommendation,
              turn: cur.turn,
            ),
          );
        }
      }
      final e = cur.exam;
      if (cur.turn == school.turnOf(fy, 1, 2) &&
          e != null &&
          e.recommended == null &&
          e.applications.isEmpty) {
        return cur.copyWith(
          pending: PendingEvent(
            type: PendingEventType.examApplication,
            turn: cur.turn,
          ),
        );
      }
      final privateTurn = isHigh
          ? school.turnOf(fy, 2, 2)
          : school.turnOf(fy, 2, 3);
      final publicTurn = isHigh
          ? school.turnOf(fy, 3, 2)
          : school.turnOf(fy, 3, 1);
      if (cur.turn == privateTurn &&
          e != null &&
          e.recommended == null &&
          e.applications.any((id) => targets[id]!.isPrivate) &&
          !e.results.keys.any((id) => targets[id]!.isPrivate)) {
        final r = exam.announce(cur, privateOnly: true);
        return _notice(r.state, isHigh ? '私立高校 合格発表' : '私立大学 合格発表', r.lines);
      }
      if (cur.turn == publicTurn && e != null && e.enrolled == null) {
        var st = cur;
        final lines = <String>[];
        if (e.recommended == null) {
          final r = exam.announce(st, privateOnly: false);
          st = r.state;
          lines.addAll(r.lines);
        }
        final d2 = exam.decideEnrollment(st);
        return _notice(
          d2.state,
          isHigh ? '公立高校 合格発表・進路決定' : '国公立大学 合格発表・進路決定',
          [...lines, ...d2.lines],
        );
      }
      final gradKey = isHigh ? 'graduated_middle' : 'graduated_high';
      if (cur.turn == school.turnOf(fy, 3, 3) &&
          !cur.memories.any((m) => m.reasonKey == gradKey)) {
        final mem = MemoryWriter(ctx, cur);
        mem.add(
          category: MemoryCategory.life,
          subjectId: Relations.player,
          reasonKey: gradKey,
          params: {'school': ctx.school(cur).name},
          importance: isHigh ? 50 : 60,
        );
        return _notice(mem.apply(cur), '卒業式', [
          '${ctx.school(cur).name}を卒業した。',
          '3年間、吹奏楽部で過ごした日々が胸をよぎる。',
        ]);
      }
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
    if (player.grade == 3 && !player.retired && player.quitClub) {
      // 退部していた場合は、同級生の引退とともに部へ戻る道もなくなる。
      player = player.copyWith(retired: true);
    } else if (player.grade == 3 && !player.retired) {
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
    final destinations = Map.of(s.npcDestinations);
    final transition = SchoolTransition(ctx);
    var graduated = 0;
    for (final id in s.roster) {
      final m = npcs[id]!;
      if (!m.active) continue;
      if (m.grade >= 3) {
        npcs[id] = m.copyWith(active: false, grade: 4);
        graduated++;
        // 中学を卒業する部員の進学先（高校で再会することがある）
        if (s.stage == GameStage.middle) {
          destinations[id] = SchoolTransition.encodeDestination(
            transition.highSchoolFor(s, id),
            fiscalYear,
          );
        }
        continue;
      }
      npcs[id] = m.copyWith(grade: m.grade + 1);
      roster.add(id);
    }
    var next = s.copyWith(
      npcs: npcs,
      roster: roster,
      npcDestinations: destinations,
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

    // 中学卒業 → 高校進学
    if (s.player.grade >= 3 && s.stage == GameStage.middle) {
      var exam = next.exam ?? const EntranceExamState(kind: 'high');
      next = next.copyWith(exam: exam);
      if (exam.enrolled == null) {
        next = EntranceExamEngine(ctx).decideEnrollment(next).state;
        exam = next.exam!;
      }
      final r = transition.enterHighSchool(next, exam.enrolled!, fiscalYear);
      return _notice(r.state, '高校入学', ['$fiscalYear年度が始まった。', ...r.lines]);
    }
    // 高校卒業 → エンディング
    if (s.player.grade >= 3 && s.stage == GameStage.high) {
      var st = next.copyWith(
        exam: next.exam ?? const EntranceExamState(kind: 'university'),
      );
      if (st.exam!.enrolled == null) {
        st = EntranceExamEngine(ctx).decideEnrollment(st).state;
      }
      final enrolled = st.exam!.enrolled!;
      final target = EntranceExamEngine(ctx)
          .universities()
          .where((u) => u.id == enrolled)
          .firstOrNull;
      final label = target == null ? '浪人' : '${target.name} 進学';
      final finished = st.copyWith(
        stage: GameStage.finished,
        player: s.player.copyWith(grade: 4),
        achievements: [
          ...st.achievements,
          Achievement(
            fiscalYear: fiscalYear,
            schoolId: enrolled,
            kind: target == null
                ? 'ronin'
                : (target.isMusic ? 'univ_music' : 'univ'),
            label: label,
            weight: target == null ? 0 : (target.deviation - 30).clamp(0, 60),
          ),
        ],
      );
      return _notice(finished, '6年間の終わり', [
        '高校を卒業し、新しい春を迎えた。',
        target == null ? '来年の再挑戦に向けて、予備校に通うことになった。' : '春から${target.name}に通う。',
        'エンディングを見よう。',
      ]);
    }

    final cohort = RosterService(ctx).cohort(club, fiscalYear);
    final extra = Map.of(s.extraNpcs);
    final roster2 = [...roster];
    for (final n in cohort) {
      extra[n.id] = n;
      roster2.add(n.id);
      npcs[n.id] = RosterService.initialState(n)
          .copyWith(grade: 1, instrument: null, skill: 0);
    }
    final player = s.player.copyWith(grade: s.player.grade + 1);
    next = next.copyWith(
      npcs: npcs,
      roster: roster2,
      extraNpcs: extra,
      player: player,
    );
    return _log(next, null, [
      '$fiscalYear年度が始まった。${player.grade}年生に進級。',
      '3年生 $graduated 人が卒業し、新入生 ${cohort.length} 人が入部した。',
    ]);
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
