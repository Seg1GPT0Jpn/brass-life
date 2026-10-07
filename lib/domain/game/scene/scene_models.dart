import '../../value_objects/instrument.dart';
import '../models/game_enums.dart';

/// ホーム画面（ジオラマ）の場所。
///
/// [left]/[top]/[width]/[height] は見取り図全体を 1000×1000 とした座標。
/// 表示側はこの比率で拡大縮小して描くだけでよく、リッチな絵に差し替えても
/// 場所の意味（どこで何ができるか）は変わらない。
enum SceneLocation {
  musicRoom('音楽室', 20, 20, 560, 420, [WeeklyAction.ensemble]),
  woodwindRoom('木管パート室', 600, 20, 380, 200, [WeeklyAction.partPractice]),
  brassRoom('金管パート室', 600, 240, 380, 200, [WeeklyAction.partPractice]),
  storage('楽器庫', 20, 460, 260, 160, [WeeklyAction.maintenance]),
  hallway('廊下', 300, 460, 680, 160, []),
  library('図書室', 20, 640, 300, 180, [WeeklyAction.study]),
  courtyard('中庭', 340, 640, 360, 180, [WeeklyAction.breather]),
  gate('校門', 720, 640, 260, 180, [WeeklyAction.hangOut, WeeklyAction.rest]);

  const SceneLocation(
    this.label,
    this.left,
    this.top,
    this.width,
    this.height,
    this.actions,
  );

  final String label;
  final int left;
  final int top;
  final int width;
  final int height;

  /// この場所をタップしたときに選べる行動。
  final List<WeeklyAction> actions;
}

/// 人物の状態（見た目の表現に使う）。
enum ActorActivity {
  practicing('練習中'),
  ensemble('合奏中'),
  teaching('指導中'),
  learning('教わり中'),
  chatting('談笑中'),
  arguing('口論中'),
  slacking('サボり中'),
  maintaining('メンテ中'),
  studying('勉強中'),
  resting('休憩中'),
  conducting('指揮'),
  waiting('見学中');

  const ActorActivity(this.label);
  final String label;
}

/// 人物の表情（アイコン枠の色などに使う）。
enum ActorMood { happy, normal, tired, down, angry }

/// 季節（背景色・環境音の切り替えに使う）。
enum Season {
  spring('春'),
  summer('夏'),
  autumn('秋'),
  winter('冬');

  const Season(this.label);
  final String label;

  static Season ofMonth(int month) => switch (month) {
    3 || 4 || 5 => Season.spring,
    6 || 7 || 8 => Season.summer,
    9 || 10 || 11 => Season.autumn,
    _ => Season.winter,
  };
}

/// 時間帯。
enum DayPhase {
  afterSchool('放課後'),
  dusk('夕暮れ'),
  night('夜');

  const DayPhase(this.label);
  final String label;
}

/// 環境音の設計。表示側は [id] に対応する音源を鳴らす（音源がなければ無音）。
class Ambience {
  const Ambience(this.id, this.label);

  final String id;
  final String label;

  static Ambience of(Season season, DayPhase time) {
    final base = switch (season) {
      Season.spring => ('spring', '春風と、遠くの運動部の声'),
      Season.summer => ('summer', 'セミの声'),
      Season.autumn => ('autumn', '虫の声と落ち葉の音'),
      Season.winter => ('winter', '木枯らし'),
    };
    final t = switch (time) {
      DayPhase.afterSchool => ('', '・各パートの音出し'),
      DayPhase.dusk => ('_dusk', '・下校のチャイム'),
      DayPhase.night => ('_night', ''),
    };
    return Ambience('${base.$1}${t.$1}', '${base.$2}${t.$2}');
  }
}

/// ジオラマに置かれる人物 1 人分。
class SceneActor {
  const SceneActor({
    required this.id,
    required this.name,
    required this.location,
    required this.activity,
    required this.mood,
    required this.x,
    required this.y,
    this.partnerId,
    this.isPlayer = false,
    this.isAdvisor = false,
    this.grade,
    this.instrumentLabel,
    this.family,
    this.towardPlayer = false,
  });

  final String id;
  final String name;
  final SceneLocation location;
  final ActorActivity activity;
  final ActorMood mood;

  /// 見取り図上の中心座標（0..1000）。
  final int x;
  final int y;

  /// 一緒に行動している相手。
  final String? partnerId;
  final bool isPlayer;
  final bool isAdvisor;
  final int? grade;
  final String? instrumentLabel;

  /// 楽器の系統（色分けなどに使う）。
  final InstrumentFamily? family;

  /// この人の今週の行動の相手がプレイヤーだった（話しかけてきた等）。
  final bool towardPlayer;
}

/// ジオラマ全体。
class ClubScene {
  const ClubScene({
    required this.season,
    required this.time,
    required this.ambience,
    required this.actors,
  });

  final Season season;
  final DayPhase time;
  final Ambience ambience;
  final List<SceneActor> actors;

  List<SceneActor> at(SceneLocation l) => [
    for (final a in actors)
      if (a.location == l) a,
  ];
}
