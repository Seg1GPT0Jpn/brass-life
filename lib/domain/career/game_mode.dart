import 'career_record.dart';

/// ゲームモード。生徒モード（本編）をクリアすると、進路に応じて大人編が解放される。
enum GameMode {
  student('生徒', '中学・高校の 6 年間を吹奏楽部員として過ごす（本編）。'),
  teacher(
    '顧問',
    '顧問として部を率いる。練習メニューの指示・オーディションの合否・選曲を決め、'
        '生徒の育成とメンタルを管理する。',
  ),
  instructor('外部講師', '複数の学校を渡り歩く外部講師。動ける回数は少ないが、特定のパートを劇的に伸ばせる。'),
  alumni('OB/OG', '卒業生として母校を支える。資金を使った差し入れや、後輩の悩み相談で間接的に部を後押しする。');

  const GameMode(this.label, this.description);

  final String label;
  final String description;

  /// 大人編か。
  bool get isCareer => this != student;

  /// 大人編の任期（年）。
  static const int termYears = 3;
}

/// 解放条件。
abstract final class CareerUnlocks {
  /// 各モードの解放条件の説明。
  static String conditionOf(GameMode mode) => switch (mode) {
    GameMode.student => '最初から遊べる',
    GameMode.teacher => '大学に進学し、部長（代表）・副部長・学生指揮・セクションリーダーのいずれかを経験して卒業する',
    GameMode.instructor => '音楽大学に進学するか、熟練度 700 以上で卒業する',
    GameMode.alumni => '6 年間を最後まで遊ぶ（どんな進路でもよい）',
  };

  /// [record] がそのモードの解放条件を満たすか。
  static bool satisfies(GameMode mode, CareerRecord record) => switch (mode) {
    GameMode.student => true,
    GameMode.teacher =>
      record.pathKind.startsWith('univ') &&
          record.roles.any(_leaderRoles.contains),
    GameMode.instructor =>
      record.pathKind == 'univ_music' || record.finalSkill >= 700,
    GameMode.alumni => true,
  };

  static const _leaderRoles = {
    'captain',
    'gradeRep',
    'viceCaptain',
    'viceRep',
    'conductor',
    'sectionLeader',
  };

  /// これまでの記録で解放されているモード（記録 1 件でも満たせば解放）。
  static Set<GameMode> unlocked(Iterable<CareerRecord> records) => {
    GameMode.student,
    for (final m in GameMode.values)
      if (records.any((r) => satisfies(m, r))) m,
  };
}
