/// ゲーム進行に関する列挙型。
library;

/// 人生の段階。
enum GameStage {
  middle('中学生'),
  high('高校生'),
  finished('卒業');

  const GameStage(this.label);
  final String label;
}

/// 通常週の行動。
///
/// 前半 7 つは場所・自分に対する行動（月の方針でも使う）。
/// 後半はホーム画面の空間（場所・部員）から選ぶ細分化された行動で、
/// [needsTarget] のものは相手の部員を指定して行う。
enum WeeklyAction {
  individualPractice('曲練', '担当楽器で曲をさらう。上達しやすい。'),
  partPractice('パート練習', '同じパートの仲間と合わせる。上達と仲間との関係づくり。'),
  basics('基礎練', 'ロングトーンや音階。地味だが音楽性が育つ。'),
  extraPractice('居残り練習', '部活後も残って練習。大きく上達するが疲れる。'),
  study('勉強', '図書室で学力を上げる。テスト前には特に大事。'),
  hangOut('遊びに行く', '放課後に友達と出かける。ストレス発散と交友。'),
  rest('休養', '部活を休んで体を休める。疲労が大きく回復するが顧問の印象は少し下がる。'),
  ensemble('合奏練習', '音楽室で全体合奏に集中する。音楽性が育ち、部の一体感に関わる。'),
  maintenance('楽器メンテ', '楽器庫で楽器を手入れする。疲れにくく、気持ちが整う。'),
  breather('一息つく', '中庭で少し休む。部活には出るので休養ほど評価は下がらない。'),
  practiceWith('一緒に練習', '相手と並んで練習する。お互いに上達し、信頼が深まる。'),
  learnFrom('教わる', '自分より上手い相手にコツを教わる。相手が上手いほど伸びる。'),
  teach('指導する', '自分より経験の浅い相手を指導する。相手が伸び、自分の音楽性も育つ。'),
  chat('雑談', '相手とおしゃべりする。仲が深まり、ストレスが減る。');

  const WeeklyAction(this.label, this.description);
  final String label;
  final String description;

  bool get isPractice =>
      this == individualPractice ||
      this == partPractice ||
      this == basics ||
      this == extraPractice ||
      this == ensemble ||
      this == maintenance ||
      this == practiceWith ||
      this == learnFrom ||
      this == teach;

  /// 相手の部員を指定する行動か。
  bool get needsTarget =>
      this == practiceWith ||
      this == learnFrom ||
      this == teach ||
      this == chat;
}

/// 月の方針（複数週スキップ時の行動パターン）。
enum MonthlyPolicy {
  practiceFocus('練習漬け', [
    WeeklyAction.individualPractice,
    WeeklyAction.partPractice,
    WeeklyAction.extraPractice,
    WeeklyAction.individualPractice,
    WeeklyAction.basics,
  ]),
  balanced('バランス', [
    WeeklyAction.individualPractice,
    WeeklyAction.study,
    WeeklyAction.partPractice,
    WeeklyAction.hangOut,
    WeeklyAction.basics,
  ]),
  studyFocus('勉強重視', [
    WeeklyAction.study,
    WeeklyAction.study,
    WeeklyAction.partPractice,
    WeeklyAction.study,
    WeeklyAction.rest,
  ]),
  health('体調管理', [
    WeeklyAction.rest,
    WeeklyAction.basics,
    WeeklyAction.hangOut,
    WeeklyAction.individualPractice,
    WeeklyAction.rest,
  ]);

  const MonthlyPolicy(this.label, this.pattern);
  final String label;

  /// 月内の第 n 週（1 始まり）に行う行動。
  final List<WeeklyAction> pattern;
}

/// プレイヤーの入力を待つイベントの種類。
enum PendingEventType {
  instrumentDecision('楽器決定'),
  audition('オーディション'),
  contest('コンクール'),
  executiveSelection('幹部選出'),
  concert('定期演奏会'),
  recommendation('推薦の打診'),
  examApplication('出願'),
  notice('お知らせ');

  const PendingEventType(this.label);
  final String label;
}

/// 部内の役職。
enum ClubRole {
  captain('部長'),
  viceCaptain('副部長'),
  conductor('学生指揮'),
  treasurer('会計'),
  gradeRep('学年代表'),
  viceRep('副代表'),
  partLeader('パートリーダー');

  const ClubRole(this.label);
  final String label;
}

/// 幹部選出でのプレイヤーの意思。
enum CandidacyChoice {
  run('立候補する', '自分から部長（代表）に名乗り出る。'),
  neutral('流れに任せる', '推されたら引き受ける。'),
  decline('辞退する', '役職には就かない。');

  const CandidacyChoice(this.label, this.description);
  final String label;
  final String description;
}
