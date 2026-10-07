import '../../entities/memory_tag.dart';
import '../models/game_enums.dart';
import '../models/game_state.dart';
import 'game_context.dart';
import 'memory_writer.dart';
import 'school_calendar.dart';

/// 通常週の行動の解決（パラメータ変動・定期テスト）。
///
/// 乱数: SimulationRng(turn, 'player_action', choice: 行動名)。
/// 同じ週に同じ行動を選べば、必ず同じ結果になる。
class ActionEngine {
  const ActionEngine(this.ctx);

  final GameContext ctx;

  /// 行動ごとの熟練度の基礎上昇量（部活への通常参加分を含まない）。
  static int _baseSkill(WeeklyAction a) => switch (a) {
    WeeklyAction.individualPractice => 5,
    WeeklyAction.partPractice => 4,
    WeeklyAction.basics => 2,
    WeeklyAction.extraPractice => 8,
    WeeklyAction.ensemble => 3,
    WeeklyAction.maintenance => 1,
    WeeklyAction.practiceWith => 5,
    WeeklyAction.learnFrom => 4,
    WeeklyAction.teach => 2,
    _ => 0,
  };

  static int _baseMusicality(WeeklyAction a) => switch (a) {
    WeeklyAction.basics => 7,
    WeeklyAction.partPractice => 3,
    WeeklyAction.individualPractice => 2,
    WeeklyAction.extraPractice => 3,
    WeeklyAction.ensemble => 6,
    WeeklyAction.teach => 5,
    WeeklyAction.maintenance => 2,
    WeeklyAction.practiceWith => 3,
    WeeklyAction.learnFrom => 3,
    _ => 1,
  };

  static int _fatigueDelta(WeeklyAction a) => switch (a) {
    WeeklyAction.individualPractice => 3,
    WeeklyAction.partPractice => 3,
    WeeklyAction.basics => 1,
    WeeklyAction.extraPractice => 13,
    WeeklyAction.study => 4,
    WeeklyAction.hangOut => -6,
    WeeklyAction.rest => -25,
    WeeklyAction.ensemble => 3,
    WeeklyAction.maintenance => 0,
    WeeklyAction.breather => -12,
    WeeklyAction.practiceWith => 3,
    WeeklyAction.learnFrom => 2,
    WeeklyAction.teach => 2,
    WeeklyAction.chat => -3,
  };

  static int _stressDelta(WeeklyAction a) => switch (a) {
    WeeklyAction.individualPractice => 2,
    WeeklyAction.partPractice => 1,
    WeeklyAction.basics => 2,
    WeeklyAction.extraPractice => 4,
    WeeklyAction.study => 4,
    WeeklyAction.hangOut => -16,
    WeeklyAction.rest => -10,
    WeeklyAction.ensemble => 1,
    WeeklyAction.maintenance => -3,
    WeeklyAction.breather => -8,
    WeeklyAction.practiceWith => 0,
    WeeklyAction.learnFrom => 1,
    WeeklyAction.teach => 2,
    WeeklyAction.chat => -10,
  };

  /// 乱数の選択キー。相手を指定する行動は相手ごとに結果が変わる。
  static String choiceKey(WeeklyAction action, String? targetId) =>
      targetId == null ? action.name : '${action.name}:$targetId';

  /// [targetId] は相手を指定する行動（一緒に練習・教わる・指導する・雑談）の相手。
  ({GameState state, List<String> lines}) resolve(
    GameState s,
    WeeklyAction action, {
    String? targetId,
  }) {
    final rng = ctx.sim.stream(
      turn: s.turn,
      domain: 'player_action',
      choice: choiceKey(action, targetId),
    );
    // 教わる: 相手が上手いほど伸びる（最大 +8）。
    final targetSkill = targetId == null ? null : s.npcs[targetId]?.skill;
    final learnBonus = action == WeeklyAction.learnFrom && targetSkill != null
        ? ((targetSkill - s.player.skill) ~/ 40).clamp(0, 8)
        : 0;
    final club = ctx.club(s);
    final teaching = ctx.advisor(s).advisorProfile!.teachingSkill;
    var p = s.player;
    final lines = <String>[];
    final mem = MemoryWriter(ctx, s);
    final attends = action != WeeklyAction.rest;
    // 引退後は部活の合奏・通常練習がない（自主的な練習のみ）。
    final inClub = attends && !p.retired;
    final role = s.roles['player'];
    final leads = role == ClubRole.captain || role == ClubRole.gradeRep;

    // 体調不良: 疲労が極端に高いと一定確率で寝込む。
    final illRoll = rng.nextInt(100);
    final ill = p.fatigue >= 90 && illRoll < 35;

    // 効率（％）: 疲労・やる気・顧問の指導力・練習強度。
    final fatigueEff = 50 + (100 - p.fatigue) ~/ 2;
    final motivationEff = 50 + p.motivation ~/ 2;
    final teachEff = 60 + teaching * 6 ~/ 10;
    final noise = rng.range(85, 115);

    if (ill) {
      lines.add('体調を崩して一週間寝込んでしまった……。');
      p = p.copyWith(
        fatigue: (p.fatigue - 30).clamp(0, 100),
        stress: (p.stress + 5).clamp(0, 100),
        motivation: (p.motivation - 5).clamp(0, 100),
        advisorTrust: (p.advisorTrust - 2).clamp(0, 100),
      );
      mem.add(
        category: MemoryCategory.life,
        subjectId: 'player',
        reasonKey: 'player_fell_ill',
        importance: 20,
        visibility: MemoryVisibility.selfOnly,
      );
    } else {
      // 熟練度
      if (p.instrument != null && attends && (inClub || action.isPractice)) {
        final fit =
            (p.aptitude.fitFor(p.instrument!) + (p.hasTrait('genius') ? 15 : 0))
                .clamp(0, 115);
        final base =
            _baseSkill(action) +
            learnBonus +
            (inClub ? 1 + club.practiceIntensity ~/ 2 : 0);
        // 各係数は % 表記なので 100^5 で割る（中間値は 2^53 未満に収まる）。
        var gain =
            base *
            (fit + 50) *
            fatigueEff *
            motivationEff *
            teachEff *
            noise ~/
            10000000000;
        gain = gain * (1200 - p.skill) ~/ 1200;
        if (p.hasTrait('lazy') && action != WeeklyAction.extraPractice) {
          gain = gain * 8 ~/ 10;
        }
        if (p.hasTrait('hardworking')) gain = gain * 11 ~/ 10;
        // 心の傷があると練習に身が入らない（最大で半減）。
        gain = gain * (200 - p.heartache) ~/ 200;
        gain = gain < 0 ? 0 : gain;
        final musGain =
            (_baseMusicality(action) +
                (role == ClubRole.conductor && inClub ? 2 : 0)) *
            fatigueEff *
            (1100 - p.musicality) ~/
            (100 * 1100);
        p = p.copyWith(
          skill: (p.skill + gain).clamp(0, 1000),
          musicality: (p.musicality + musGain).clamp(0, 1000),
        );
        if (gain > 0) {
          lines.add('${p.instrument!.label}の熟練度 +$gain（${p.skill}）');
        }
        if (musGain > 0 &&
            (action == WeeklyAction.basics ||
                action == WeeklyAction.ensemble ||
                action == WeeklyAction.teach)) {
          lines.add('音楽性 +$musGain（${p.musicality}）');
        }
      }

      // 学力
      if (action == WeeklyAction.study) {
        final eff = 100 + p.personality.conscientiousness ~/ 2;
        final gain = 14 * eff * fatigueEff * noise ~/ (100 * 100 * 100) + 1;
        final capped = gain * (1100 - p.academic) ~/ 1100;
        p = p.copyWith(academic: (p.academic + capped).clamp(0, 1000));
        lines.add('学力 +$capped（${p.academic}）');
      } else if (p.academic > 300 && rng.chance(3000)) {
        p = p.copyWith(academic: p.academic - 1);
      }

      // 疲労・ストレス・やる気・社交・顧問評価。
      // 疲労とストレスは高いほど自然に回復しやすく（平衡点を持つ）、
      // やる気は性格で決まる基準値へ少しずつ戻る。
      final clubLoad = inClub ? club.practiceIntensity * 3 : 0;
      final recovery = 4 + p.stamina ~/ 10 + p.fatigue ~/ 5;
      final fatigue = (p.fatigue + clubLoad + _fatigueDelta(action) - recovery)
          .clamp(0, 100);
      var stress =
          p.stress +
          _stressDelta(action) -
          p.stress ~/ 6 +
          (fatigue > 70 ? 4 : 0);
      if (p.hasTrait('sensitive')) stress += 1;
      // 部長・代表は気苦労が多いが、顧問の信頼を得やすい。
      if (leads && inClub) stress += 2;
      if (p.hasTrait('optimistic')) stress -= 1;
      // 心の傷が残っている間は、ストレスが下がりきらない。
      if (stress < p.heartache ~/ 2) stress = p.heartache ~/ 2;
      // 心の傷はやる気の戻る先そのものを下げる。
      final baseline =
          (60 + p.personality.conscientiousness ~/ 5 - p.heartache ~/ 2).clamp(
            10,
            90,
          );
      var motivation = p.motivation + (baseline - p.motivation) ~/ 8;
      if (action == WeeklyAction.hangOut) motivation += 2;
      if (action.isPractice && rng.chance(4000)) motivation += 1;
      if (stress > 70) motivation -= 3;
      if (fatigue > 85) motivation -= 3;
      if (action == WeeklyAction.rest) motivation -= 1;
      if (action == WeeklyAction.maintenance || action == WeeklyAction.chat) {
        motivation += 1;
      }
      final social =
          p.social +
          (action == WeeklyAction.hangOut ? 3 : 0) +
          (action == WeeklyAction.chat ? 2 : 0) +
          (action == WeeklyAction.partPractice ||
                  action == WeeklyAction.practiceWith
              ? 1
              : 0);
      final trust =
          p.advisorTrust +
          switch (action) {
            WeeklyAction.extraPractice => 2,
            WeeklyAction.rest => -3,
            WeeklyAction.breather => -1,
            _ when action.isPractice => 1,
            _ => 0,
          } +
          (leads && inClub ? 1 : 0);
      lines.add(
        '疲労 ${_signed(fatigue - p.fatigue)}（$fatigue） ／ '
        'ストレス ${_signed(stress.clamp(0, 100) - p.stress)}（${stress.clamp(0, 100)}）',
      );
      p = p.copyWith(
        fatigue: fatigue,
        stress: stress.clamp(0, 100),
        motivation: motivation.clamp(0, 100),
        social: social.clamp(0, 100),
        advisorTrust: trust.clamp(0, 100),
      );
    }

    // 心の傷はゆっくりとしか癒えない（週に 1。誰かと話す・遊ぶ・一息つくと少し早まる）。
    if (p.heartache > 0) {
      final comforted =
          action == WeeklyAction.chat ||
          action == WeeklyAction.hangOut ||
          action == WeeklyAction.breather;
      final healed = (p.heartache - 1 - (comforted ? 1 : 0)).clamp(0, 100);
      if (healed == 0) {
        lines.add('あの日の悔しさが、ようやく思い出に変わった。');
      } else if (p.heartache >= 20 && s.turn % 4 == 0) {
        lines.add('あの日の悔しさが、ふとした瞬間によみがえる。（心の傷 $healed）');
      }
      p = p.copyWith(heartache: healed);
    }

    // 定期テスト
    final date = ctx.calendar.dateOf(s.turn);
    final exam = SchoolCalendar(ctx.calendar).examAt(date);
    if (exam != null) {
      // 学力 0 → 20 点、500 → 55 点、1000 → 90 点 を中心に揺らぐ。
      final score =
          (20 +
                  p.academic * 7 ~/ 100 +
                  rng.normalInt(mean: 0, sd: 6, min: -20, max: 20) -
                  (p.fatigue > 60 ? (p.fatigue - 60) ~/ 4 : 0) +
                  (action == WeeklyAction.study ? 4 : 0) -
                  (ill ? 15 : 0))
              .clamp(0, 100);
      final record = ExamRecord(
        turn: s.turn,
        academicYearIndex: date.academicYearIndex,
        name: exam.name,
        score: score,
      );
      final exams = [...p.exams, record];
      var termGrades = p.termGrades;
      lines.add('${exam.name}：$score 点');
      if (exam.endsTerm) {
        final termScores = [
          for (final e in exams)
            if (e.academicYearIndex == date.academicYearIndex &&
                _termOf(e.name) == exam.term)
              e.score,
        ];
        final avg = termScores.fold(0, (a, b) => a + b) ~/ termScores.length;
        final grade = avg >= 80
            ? 5
            : avg >= 65
            ? 4
            : avg >= 45
            ? 3
            : avg >= 30
            ? 2
            : 1;
        termGrades = [
          ...termGrades,
          TermGrade(
            academicYearIndex: date.academicYearIndex,
            term: exam.term,
            grade: grade,
          ),
        ];
        lines.add('${exam.term}学期の評定：$grade');
      }
      p = p.copyWith(exams: exams, termGrades: termGrades);
      mem.add(
        category: MemoryCategory.academic,
        subjectId: 'player',
        reasonKey: 'exam_result',
        params: {'exam': exam.name, 'score': '$score'},
        importance: score >= 90 || score < 30 ? 30 : 10,
        visibility: MemoryVisibility.selfOnly,
      );
    }

    final counts = Map.of(p.actionCounts);
    counts[action.name] = (counts[action.name] ?? 0) + 1;
    p = p.copyWith(actionCounts: counts);

    return (state: mem.apply(s.copyWith(player: p)), lines: lines);
  }

  static int _termOf(String examName) {
    for (final e in SchoolCalendar.exams) {
      if (e.$1 == examName) return e.$4;
    }
    return 0;
  }

  static String _signed(int v) => v >= 0 ? '+$v' : '$v';
}
