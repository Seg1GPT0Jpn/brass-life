import '../game/engine/ending_analyzer.dart';
import '../game/engine/game_context.dart';
import '../game/engine/relations.dart';
import '../game/models/game_state.dart';
import 'game_mode.dart';
import 'mode_states.dart';

/// 大人編の任期の終わりに、称号とエピローグを作る。
class CareerEndingAnalyzer {
  const CareerEndingAnalyzer(this.ctx);

  final GameContext ctx;

  EndingResult analyze(GameState s) {
    final career = s.career!;
    final school = ctx.school(s);
    final contests =
        s.achievements.where((a) => a.kind == 'contest_career').toList()
          ..sort((a, b) => b.weight.compareTo(a.weight));
    final best = contests.isEmpty ? 0 : contests.first.weight;
    final quits = s.memories
        .where((m) => m.reasonKey == 'quit_club' && m.date.turn >= 0)
        .length;
    final members = ctx.activeMembers(s);
    final trust = members.isEmpty
        ? 0
        : members.fold(
                0,
                (a, m) => a + Relations.get(s, m.id, Relations.player).trust,
              ) ~/
              members.length;
    final avgMot = members.isEmpty
        ? 0
        : members.fold(0, (a, m) => a + m.motivation) ~/ members.length;
    final unfair = s.memories
        .where((m) => m.reasonKey == 'teacher_unfair_audition')
        .length;
    int count(String reasonKey) =>
        s.memories.where((m) => m.reasonKey == reasonKey).length;
    final commands = <CareerCommand, int>{};
    for (final c in s.choices) {
      final parts = c.split(':');
      if (parts.length >= 3 && parts[1] == 'cmd') {
        final cmd = CareerCommand.values
            .where((x) => x.name == parts[2])
            .firstOrNull;
        if (cmd != null) commands[cmd] = (commands[cmd] ?? 0) + 1;
      }
    }

    final candidates = <(String, int, String)>[
      ...switch (s.mode) {
        GameMode.teacher => [
          ('全国へ導いた名顧問', best >= 80 ? 90 : 0, '教え子たちを全国の舞台へ導いた。'),
          (
            '生徒に慕われた先生',
            trust >= 15 && quits <= 3 ? 60 + trust : 0,
            '面談 ${count('career_counseling')} 回。生徒たちは心から先生を信頼していた。',
          ),
          (
            '鬼の名指導者',
            best >= 55 && (quits >= 5 || unfair >= 3) ? 70 : 0,
            '厳しい指導で結果を出したが、去っていった生徒もいた。',
          ),
          (
            '部を育てた顧問',
            40 + best ~/ 3,
            '${GameMode.termYears}年間、${school.name}の吹奏楽部を率いた。',
          ),
        ],
        GameMode.instructor => [
          (
            '伝説の外部講師',
            career.reputation >= 85 ? 85 : 0,
            '評判 ${career.reputation}。各校から指導の依頼が絶えない。',
          ),
          (
            'パートの魔術師',
            (commands[CareerCommand.intensiveCoaching] ?? 0) >= 30 ? 70 : 0,
            '集中レッスン ${commands[CareerCommand.intensiveCoaching] ?? 0} 回。どのパートも見違えるように育った。',
          ),
          (
            '渡り鳥の講師',
            (commands[CareerCommand.travelLesson] ?? 0) >= 20 ? 65 : 0,
            '出張レッスン ${commands[CareerCommand.travelLesson] ?? 0} 回。多くの学校に音楽を届けた。',
          ),
          (
            '頼れる外部講師',
            40 + best ~/ 3,
            '${school.name}を拠点に、${GameMode.termYears}年間指導した。',
          ),
        ],
        _ => [
          (
            '母校の守り神',
            career.bond >= 85 ? 85 : 0,
            '部との絆 ${career.bond}。後輩たちにとって、いつでも頼れる先輩だった。',
          ),
          (
            '太っ腹な OB/OG',
            count('alumni_donation') >= 3 ? 70 : 0,
            '寄付 ${count('alumni_donation')} 回。部室の楽器は見違えるほど新しくなった。',
          ),
          (
            '悩み相談の名人',
            count('alumni_consultation') >= 15 ? 65 : 0,
            '後輩の悩みを ${count('alumni_consultation')} 回聞いた。',
          ),
          (
            '母校を支えた先輩',
            40 + best ~/ 3,
            '${GameMode.termYears}年間、${school.name}の吹奏楽部を見守った。',
          ),
        ],
      },
    ]..sort((a, b) => b.$2.compareTo(a.$2));
    final (title, _, reason) = candidates.first;

    final epilogue = [
      switch (s.mode) {
        GameMode.teacher =>
          '${s.player.fullName}は${school.name}の顧問として${GameMode.termYears}年間を過ごした。',
        GameMode.instructor =>
          '${s.player.fullName}は外部講師として${GameMode.termYears}年間、いくつもの学校を渡り歩いた。',
        _ => '${s.player.fullName}は OB/OG として、${GameMode.termYears}年間母校を支え続けた。',
      },
      contests.isEmpty
          ? 'コンクールの記録はまだ残っていないが、日々の練習の音は確かに変わった。'
          : '最高の結果は「${contests.first.label}」。',
      quits == 0 ? '任期中、部を去った生徒はひとりもいなかった。' : '任期中、$quits 人の生徒が部を去った。',
      if (career.originTitle != null)
        'かつて「${career.originTitle}」と呼ばれたあの日々が、今の自分をつくっている。',
      '称号「$title」── $reason',
    ];

    return EndingResult(
      title: title,
      titleReason: reason,
      epilogue: epilogue,
      highlights: [for (final a in contests.take(5)) a.label],
      stats: [
        ('モード', s.mode.label),
        ('学校', school.name),
        ('最高のコンクール', contests.isEmpty ? '－' : contests.first.label),
        ('部を去った生徒', '$quits 人'),
        ('部員のやる気（平均）', '$avgMot'),
        ('部員からの信頼（平均）', '$trust'),
        if (s.mode == GameMode.instructor) ('評判', '${career.reputation}'),
        if (s.mode == GameMode.alumni) ...[
          ('所持金', '${career.money} 円'),
          ('部との絆', '${career.bond}'),
        ],
        if (s.mode == GameMode.teacher) ('不公平な選考', '$unfair 回'),
      ],
      otherTitles: [for (final c in candidates.skip(1).take(3)) c.$1],
    );
  }
}
