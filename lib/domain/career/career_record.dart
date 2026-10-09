/// 6 年間を終えた記録（キャリアモード解放の判定に使う）。
///
/// セーブデータとは別に、周回をまたいで残す。
class CareerRecord {
  const CareerRecord({
    required this.worldSeed,
    required this.playerName,
    required this.title,
    required this.pathKind,
    required this.pathLabel,
    required this.finalSkill,
    required this.finalMusicality,
    required this.roles,
    required this.bestContest,
    required this.quitAtEnd,
    required this.clearedAt,
  });

  final int worldSeed;
  final String playerName;

  /// エンディングの称号。
  final String title;

  /// 最終進路の種類: 'univ' / 'univ_music' / 'ronin' / 'none'。
  final String pathKind;

  /// 最終進路の表示名（例: 〇〇大学 進学）。
  final String pathLabel;
  final int finalSkill;
  final int finalMusicality;

  /// 6 年間に就いた役職（ClubRole.name）。
  final List<String> roles;

  /// いちばん良かったコンクールの結果（なければ空）。
  final String bestContest;

  /// 退部したまま卒業した。
  final bool quitAtEnd;

  /// 記録した日時（ISO 8601）。
  final String clearedAt;

  Map<String, Object?> toJson() => {
    'worldSeed': worldSeed,
    'playerName': playerName,
    'title': title,
    'pathKind': pathKind,
    'pathLabel': pathLabel,
    'finalSkill': finalSkill,
    'finalMusicality': finalMusicality,
    'roles': roles,
    'bestContest': bestContest,
    'quitAtEnd': quitAtEnd,
    'clearedAt': clearedAt,
  };

  factory CareerRecord.fromJson(Map<String, Object?> j) => CareerRecord(
    worldSeed: j['worldSeed']! as int,
    playerName: j['playerName']! as String,
    title: j['title']! as String,
    pathKind: j['pathKind']! as String,
    pathLabel: j['pathLabel']! as String,
    finalSkill: j['finalSkill']! as int,
    finalMusicality: j['finalMusicality']! as int,
    roles: [for (final r in j['roles']! as List<Object?>) r! as String],
    bestContest: j['bestContest']! as String,
    quitAtEnd: j['quitAtEnd']! as bool,
    clearedAt: j['clearedAt']! as String,
  );
}
