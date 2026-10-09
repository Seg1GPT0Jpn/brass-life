/// 大人編（キャリアモード）のコマンドと練習メニュー。
library;

import 'game_mode.dart';

/// コマンドの相手。
enum CommandTarget { none, member, school }

/// 大人編の週の行動。モードごとに使えるものが決まっている。
enum CareerCommand {
  // ── 顧問 ──
  watch(GameMode.teacher, '見守る', '練習メニューどおりに任せる。', CommandTarget.none),
  encourage(GameMode.teacher, '全体を激励', '部全体のやる気を上げる。', CommandTarget.none),
  counseling(
    GameMode.teacher,
    '面談',
    '生徒ひとりと話す。ストレスが下がり、やる気と信頼が上がる。',
    CommandTarget.member,
  ),
  privateLesson(
    GameMode.teacher,
    '個別指導',
    '生徒ひとりを指導して伸ばす。',
    CommandTarget.member,
  ),

  // ── 外部講師 ──
  intensiveCoaching(
    GameMode.instructor,
    '集中レッスン',
    '選んだ部員のパート（同じ楽器）全員を劇的に伸ばす。少し疲れさせる。',
    CommandTarget.member,
  ),
  masterclass(GameMode.instructor, '公開講座', '部全体を少し伸ばす。', CommandTarget.none),
  travelLesson(
    GameMode.instructor,
    '出張レッスン',
    '契約している別の学校を鍛える（その学校のコンクールの評価が上がる）。拠点校には顔を出せない。',
    CommandTarget.school,
  ),
  restDay(GameMode.instructor, '休む', '何もしない。', CommandTarget.none),

  // ── OB/OG ──
  snackGift(
    GameMode.alumni,
    '差し入れ（5,000円）',
    '部員のストレスが下がり、やる気が上がる。部との絆が深まる。',
    CommandTarget.none,
    cost: 5000,
  ),
  consultation(
    GameMode.alumni,
    '悩み相談',
    '後輩ひとりの悩みを聞く。絆が深いほどよく効く。',
    CommandTarget.member,
  ),
  donation(
    GameMode.alumni,
    '寄付（30,000円）',
    '楽器や備品を寄付する。部全体が少し伸び、やる気が上がる。',
    CommandTarget.none,
    cost: 30000,
  ),
  work(
    GameMode.alumni,
    '仕事に打ち込む',
    '資金を稼ぐ（12,000円）。母校には顔を出せない。',
    CommandTarget.none,
  );

  const CareerCommand(
    this.mode,
    this.label,
    this.description,
    this.target, {
    this.cost = 0,
  });

  final GameMode mode;
  final String label;
  final String description;
  final CommandTarget target;

  /// 必要な資金（OB/OG）。
  final int cost;

  static List<CareerCommand> of(GameMode mode) => [
    for (final c in values)
      if (c.mode == mode) c,
  ];
}

/// 顧問の練習メニュー（毎週、部全体にかかる）。
enum PracticeMenuPreset {
  balanced('バランス', '基礎・パート・合奏をまんべんなく。', 3, 0, 0),
  basics('基礎重視', 'ロングトーンと音階中心。伸びは控えめだが、心は落ち着く。', 2, -2, 0),
  part('パート重視', 'パート練習中心。よく伸びるが、疲れがたまる。', 5, 3, 0),
  ensemble('合奏重視', '合奏中心。部のまとまりが育つ。', 3, 1, 1),
  rest('休養多め', '練習を軽めにして休ませる。伸びないが、ストレスが大きく下がる。', 0, -7, 0);

  const PracticeMenuPreset(
    this.label,
    this.description,
    this.skillGain,
    this.stressDelta,
    this.cohesion,
  );

  final String label;
  final String description;

  /// 毎週の熟練度の伸び（基準値）。
  final int skillGain;

  /// 毎週のストレスの変化。
  final int stressDelta;

  /// 1 なら部員どうしの好感が少しずつ育つ。
  final int cohesion;
}
