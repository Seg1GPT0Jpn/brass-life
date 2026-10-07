/// 学校・部活に関する列挙型群。表示名は架空設定に基づく。
library;

enum SchoolLevel {
  middle('中学校'),
  high('高等学校');

  const SchoolLevel(this.label);
  final String label;
}

enum SchoolOwnership {
  publicSchool('公立'),
  privateSchool('私立');

  const SchoolOwnership(this.label);
  final String label;
}

/// 校風タグ。[group] が同じタグは同一校に共存しない。
enum SchoolCulture {
  free('自由', '服装や校則が緩く、生徒の自主性を重んじる', 'discipline'),
  strict('厳格', '校則・上下関係が厳しく、規律を重んじる', 'discipline'),
  academic('進学重視', '難関大学への進学実績を最重視する', null),
  balanced('文武両道', '学業と部活動の両立を掲げる', null),
  traditional('伝統校', '創立が古く、OB・OGの影響力が強い', 'age'),
  newSchool('新興校', '創立が新しく、伝統やしがらみが少ない', 'age'),
  clubFocused('部活動が盛ん', '部活動への加入率・熱量が高い', null),
  community('地域密着', '地域行事への参加が多く、地元とのつながりが強い', null),
  international('国際教育', '語学・留学プログラムに力を入れる', null),
  arts('芸術教育に熱心', '音楽・美術の授業や行事が充実している', null);

  const SchoolCulture(this.label, this.description, this.group);
  final String label;
  final String description;
  final String? group;
}

/// 部の強さ帯。
enum ClubTier {
  national('全国常連', 5),
  block('支部大会級', 4),
  prefectural('県大会級', 3),
  district('地区大会級', 2),
  weak('弱小', 1);

  const ClubTier(this.label, this.rank);
  final String label;

  /// 数値的な強さ（大きいほど強い）。
  final int rank;
}

/// 幹部制度（役職の構造）。
enum ExecutiveSystem {
  a('制度A：中央集権型', '部長・副部長・学生指揮・会計。部長の権限が大きい'),
  b('制度B：合議型', '学年代表とパートリーダーによる会議制。権限が分散'),
  c('制度C：顧問主導型', '役職は名目的で、実質的な決定権は顧問にある');

  const ExecutiveSystem(this.label, this.description);
  final String label;
  final String description;
}

/// 幹部の選出文化（決め方）。
enum SelectionCulture {
  vote('部員投票', '全部員の投票で選ぶ'),
  nomination('前任者指名', '現幹部が後任を指名する'),
  advisorAppointment('顧問任命', '顧問が適任者を任命する'),
  discussion('話し合い', '同学年の話し合いで決める');

  const SelectionCulture(this.label, this.description);
  final String label;
  final String description;
}

/// 部の雰囲気。
enum ClubMood {
  strict('ピリピリ', '上下関係と規律が厳しい'),
  competitive('切磋琢磨', '実力主義で競争意識が高い'),
  harmonious('和気あいあい', '仲が良く、楽しむことを重視'),
  relaxed('ゆるい', '練習も人間関係も緩め'),
  factional('派閥あり', '部内にグループ対立がある');

  const ClubMood(this.label, this.description);
  final String label;
  final String description;
}

enum BudgetBand {
  low('少ない'),
  mid('普通'),
  high('潤沢');

  const BudgetBand(this.label);
  final String label;
}

/// コンクールの出場部門。
enum BandDivision {
  large('大編成の部'),
  small('小編成の部');

  const BandDivision(this.label);
  final String label;
}

/// コンクールの到達段階（架空の管楽合奏コンクール）。
enum ContestStage {
  none('不出場', 0),
  district('地区大会', 1),
  prefectural('県大会', 2),
  block('支部大会', 3),
  national('全国大会', 4);

  const ContestStage(this.label, this.level);
  final String label;
  final int level;
}

enum ContestAward {
  none('－'),
  gold('金賞'),
  silver('銀賞'),
  bronze('銅賞');

  const ContestAward(this.label);
  final String label;
}
