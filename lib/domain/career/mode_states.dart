/// 大人編（Phase 8）の各モードの状態とコマンド。
///
/// いまは器（データの形）だけを定義している。週の進行・判定は本編の
/// TimeManager / DramaEngine を流用し、モードごとに「プレイヤーが選べる行動」と
/// 「プレイヤーが持つ資源」を差し替える設計にする。
library;

// ───────────── 顧問モード ─────────────

/// 顧問の週の指示。
enum TeacherCommand {
  practiceMenu('練習メニューの指示', '基礎・パート・合奏・休養の配分を決める。部全体の熟練度と疲労が動く。'),
  auditionDecision('オーディションの合否', '誰をコンクールメンバーにするかを決める。選ばれなかった生徒のメンタルに響く。'),
  pieceDecision('選曲', '課題曲を決める（生徒の意見を聞くかどうかも選べる）。'),
  counseling('面談', '生徒ひとりと話す。ストレスと心の傷を和らげる。');

  const TeacherCommand(this.label, this.description);
  final String label;
  final String description;
}

/// 練習メニューの配分（合計 100）。
class PracticeMenu {
  const PracticeMenu({
    this.basics = 30,
    this.part = 30,
    this.ensemble = 30,
    this.rest = 10,
  }) : assert(basics + part + ensemble + rest == 100);

  final int basics;
  final int part;
  final int ensemble;
  final int rest;
}

class TeacherModeState {
  const TeacherModeState({
    required this.schoolId,
    required this.advisorNpcId,
    this.menu = const PracticeMenu(),
    this.commandsLeft = 2,
  });

  /// 赴任先の学校。
  final String schoolId;

  /// プレイヤーが演じる顧問（世界の NPC を引き継ぐか、新規に作る）。
  final String advisorNpcId;
  final PracticeMenu menu;

  /// 今週まだ出せる指示の数。
  final int commandsLeft;
}

// ───────────── 外部講師モード ─────────────

enum InstructorCommand {
  intensiveCoaching('集中レッスン', '1 つのパートを劇的に伸ばす（週に 1 回）。'),
  masterclass('公開講座', '学校全体の音楽性を少し上げる。'),
  travel('移動', '別の学校へ向かう（その週は他に何もできない）。');

  const InstructorCommand(this.label, this.description);
  final String label;
  final String description;
}

class InstructorModeState {
  const InstructorModeState({
    required this.contractedSchoolIds,
    required this.currentSchoolId,
    this.actionPoints = 1,
    this.reputation = 50,
  });

  /// 契約している学校（複数校を渡り歩く）。
  final List<String> contractedSchoolIds;
  final String currentSchoolId;

  /// 1 週間に使える行動回数（少ない代わりに効果が大きい）。
  final int actionPoints;

  /// 講師としての評判（0..100）。契約の増減に関わる。
  final int reputation;
}

// ───────────── OB/OG モード ─────────────

enum AlumniCommand {
  snackGift('差し入れ', '資金を使って部員のストレスを下げ、やる気を上げる。'),
  consultation('悩み相談', '後輩ひとりの悩みを聞く。心の傷が癒え、信頼が深まる。'),
  donation('寄付', '楽器や備品の購入資金を寄付する（楽器の状態が良くなる）。'),
  work('アルバイト・仕事', '資金を稼ぐ（その週は母校に顔を出せない）。');

  const AlumniCommand(this.label, this.description);
  final String label;
  final String description;
}

class AlumniModeState {
  const AlumniModeState({
    required this.almaMaterSchoolId,
    this.money = 30000,
    this.weeklyIncome = 10000,
    this.bondWithClub = 50,
  });

  /// 支援する母校。
  final String almaMaterSchoolId;

  /// 所持金（円）。
  final int money;
  final int weeklyIncome;

  /// 部との絆（0..100）。高いほど相談を持ちかけられる。
  final int bondWithClub;
}
