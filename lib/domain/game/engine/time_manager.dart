import '../../entities/memory_tag.dart';
import '../../entities/world.dart';
import '../../value_objects/instrument.dart';
import '../models/game_enums.dart';
import '../models/game_state.dart';
import 'action_engine.dart';
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
    final pending = s.pending;
    if (pending == null ||
        pending.type != PendingEventType.instrumentDecision) {
      throw StateError('楽器決定イベントではありません');
    }
    if (wishes.isEmpty) throw ArgumentError('希望を 1 つ以上指定してください');
    final out = InstrumentDecision(ctx).decide(s, playerWishes: wishes);
    var next = out.state.copyWith(
      pending: null,
      choices: [
        ...out.state.choices,
        '${s.turn}:instrument:${wishes.map((w) => w.name).join(',')}',
      ],
    );
    next = _log(next, '楽器決定', out.playerLines);
    return (state: next, lines: out.playerLines);
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

  /// 新しいターンの開始時処理（年度更新・自動イベント・入力待ちイベントの設定）。
  GameState _prepareTurn(GameState s) {
    var cur = s;
    final d = ctx.calendar.dateOf(cur.turn);
    if (d.weekOfAcademicYear == 1 && d.academicYearIndex > 0) {
      cur = _newFiscalYear(cur, d.fiscalYear);
      if (cur.stage == GameStage.finished) return cur;
    }
    if (cur.turn == school.instrumentDecisionTurn(d.fiscalYear)) {
      if (cur.player.instrument == null) {
        cur = cur.copyWith(
          pending: PendingEvent(
            type: PendingEventType.instrumentDecision,
            turn: cur.turn,
          ),
        );
      } else {
        final out = InstrumentDecision(ctx).decide(cur);
        cur = _log(out.state, null, ['新入生の担当楽器が決まった。']);
      }
    }
    return cur;
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
