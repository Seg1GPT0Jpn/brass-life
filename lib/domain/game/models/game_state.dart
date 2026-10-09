import 'package:freezed_annotation/freezed_annotation.dart';

import '../../entities/memory_tag.dart';
import '../../entities/club.dart';
import '../../entities/npc.dart';
import '../../value_objects/aptitude.dart';
import '../../value_objects/instrument.dart';
import '../../value_objects/person_enums.dart';
import '../../value_objects/personality.dart';
import '../../value_objects/relationship_vector.dart';
import '../../value_objects/school_enums.dart';
import '../../career/game_mode.dart';
import 'game_enums.dart';
import 'player_setup.dart';

part 'game_state.freezed.dart';
part 'game_state.g.dart';

/// ゲームの進行状態。世界本体（World）は Seed から再生成し、ここには変化する値だけを持つ。
///
/// 全ての遷移は「状態 + プレイヤーの選択 + SimulationRng(turn, domain, actor, choice)」
/// のみから決定論的に計算される。
@freezed
abstract class GameState with _$GameState {
  const factory GameState({
    /// 保存形式のバージョン。
    @Default(1) int schemaVersion,
    required int worldSeed,
    required int generatorVersion,

    /// 次に過ごす週のターン番号。
    required int turn,
    required GameStage stage,
    required PlayerState player,

    /// 現在所属している学校。
    required String schoolId,

    /// 現在の部員（プレイヤー以外。退部・卒業した者は含まない）。
    required List<String> roster,

    /// NPC の変化する値（部員・元部員）。
    required Map<String, NpcState> npcs,

    /// ゲーム中に生成された NPC（翌年度以降の新入生など）。
    @Default(<String, Npc>{}) Map<String, Npc> extraNpcs,

    /// 関係性ベクトル。キーは「主体ID>相手ID」（主体から見た相手）。
    @Default(<String, RelationshipVector>{})
    Map<String, RelationshipVector> relations,

    /// ゲーム中に生まれた記憶。
    @Default(<MemoryTag>[]) List<MemoryTag> memories,
    @Default(0) int memorySeq,

    /// 週ごとの出来事ログ（新しいものが末尾）。
    @Default(<WeekLog>[]) List<WeekLog> logs,

    /// プレイヤーの選択履歴（リプレイ・検証用）。
    @Default(<String>[]) List<String> choices,

    /// 入力待ちのイベント。
    PendingEvent? pending,

    /// 現在の月の方針。
    @Default(MonthlyPolicy.balanced) MonthlyPolicy policy,

    /// テスト週は自動で勉強するか。
    @Default(true) bool studyBeforeExams,

    /// 今年度のコンクールメンバー（'player' を含みうる）。
    @Default(<String>[]) List<String> contestMembers,

    /// 今年度のソリスト。
    String? soloistId,

    /// 今年度のコンクールの進行状況。
    ContestProgress? contest,

    /// 現在の学校で行われた（ゲーム中の）コンクール成績。
    @Default(<ContestRecord>[]) List<ContestRecord> clubHistory,

    /// プレイヤーの実績（6 年間を通して保持）。
    @Default(<Achievement>[]) List<Achievement> achievements,

    /// 各年度のコンクールの課題曲（年度 → 曲 ID）。
    @Default(<String, String>{}) Map<String, String> setPieces,

    /// ゲームモード（本編は生徒、大人編は顧問・外部講師・OB/OG）。
    @Default(GameMode.student) GameMode mode,

    /// 大人編の状態（本編では null）。
    CareerState? career,

    /// 役職（ID → 役職）。
    @Default(<String, ClubRole>{}) Map<String, ClubRole> roles,

    /// 幹部選出を行うターン（3 年生の引退時に設定）。
    int? executiveSelectionTurn,

    /// 定期演奏会を行った最後の年度。
    int? lastConcertYear,

    /// 年度更新などのターン開始処理を済ませた最後のターン。
    @Default(-1) int preparedTurn,

    /// 進路（受験）の状況。
    EntranceExamState? exam,

    /// 卒業した NPC の進学先（NPC ID → 学校 ID）。
    @Default(<String, String>{}) Map<String, String> npcDestinations,

    /// プレイヤーが在籍した学校（古い順）。
    @Default(<String>[]) List<String> schoolHistory,

    /// 開始時の主人公の設定（Seed のままなら null）。
    PlayerSetup? setup,
  }) = _GameState;

  factory GameState.fromJson(Map<String, dynamic> json) =>
      _$GameStateFromJson(json);
}

@freezed
abstract class PlayerState with _$PlayerState {
  const factory PlayerState({
    required String familyName,
    required String givenName,
    required Gender gender,
    required PersonalityAxes personality,
    required List<TraitTag> traits,
    required AptitudeStats aptitude,
    required MusicBackground background,
    required int grade,

    /// 担当楽器（決定前は null）。
    InstrumentType? instrument,

    /// 担当楽器の熟練度（0..1000）。
    @Default(0) int skill,

    /// 音楽性（0..1000）。楽器に依らない合奏力・表現の土台。
    @Default(100) int musicality,

    /// 学力（0..1000）。
    required int academic,

    /// 体力（0..100）。疲労の回復力に影響。
    required int stamina,

    /// 疲労（0..100）。
    @Default(10) int fatigue,

    /// ストレス（0..100）。
    @Default(10) int stress,

    /// やる気（0..100）。
    @Default(60) int motivation,

    /// 社交性（0..100）。
    @Default(30) int social,

    /// 顧問からの評価（0..100）。
    @Default(50) int advisorTrust,

    /// 楽器の希望（第 1〜3 希望）。
    @Default(<InstrumentType>[]) List<InstrumentType> wishes,

    /// 以前の担当楽器（高校で楽器が変わった場合など）。
    InstrumentType? previousInstrument,

    /// 定期テストの成績。
    @Default(<ExamRecord>[]) List<ExamRecord> exams,

    /// 学期ごとの評定（1..5）。内申点の算出に用いる。
    @Default(<TermGrade>[]) List<TermGrade> termGrades,

    /// 行動の累計回数（エンディング解析に用いる）。
    @Default(<String, int>{}) Map<String, int> actionCounts,

    /// 3 年生の引退済み。
    @Default(false) bool retired,

    /// 心の傷（0..100）。役職に選ばれなかった悔しさなど。
    /// やる気の基準値を下げ、ストレスが下がりきらなくなり、上達も鈍る。
    /// 週に少しずつしか癒えない（雑談・遊び・一息つくと少し早まる）。
    @Default(0) int heartache,

    /// 部を辞めている（退部中）。
    @Default(false) bool quitClub,

    /// 退部した回数（今の学校で）。2 回目以降は戻りにくい。
    @Default(0) int quitCount,

    /// 最後に退部したターン。
    int? quitTurn,
  }) = _PlayerState;

  const PlayerState._();

  /// 部活に参加している（引退も退部もしていない）。
  bool get inClub => !retired && !quitClub;

  factory PlayerState.fromJson(Map<String, dynamic> json) =>
      _$PlayerStateFromJson(json);

  String get fullName => '$familyName $givenName';

  bool hasTrait(String id) => traits.any((t) => t.traitId == id);
}

/// NPC の変化する値。
@freezed
abstract class NpcState with _$NpcState {
  const factory NpcState({
    required String id,
    required int grade,
    InstrumentType? instrument,
    @Default(0) int skill,
    @Default(60) int motivation,
    @Default(20) int stress,

    /// 低いやる気が続いた週数（退部判定）。
    @Default(0) int lowMotivationWeeks,

    /// 部に在籍しているか（卒業・退部で false）。
    @Default(true) bool active,

    /// 退部した。
    @Default(false) bool quit,

    /// 新入生の希望楽器。
    InstrumentType? wish,

    /// 3 年生の引退済み（卒業までは在籍するが部活動には参加しない）。
    @Default(false) bool retired,

    /// 直近の週の自律行動（NpcBehavior の名前）。ホーム画面の配置・状態に使う。
    String? lastBehavior,

    /// 直近の週の行動の相手。
    String? lastTargetId,
  }) = _NpcState;

  factory NpcState.fromJson(Map<String, dynamic> json) =>
      _$NpcStateFromJson(json);
}

@freezed
abstract class ExamRecord with _$ExamRecord {
  const factory ExamRecord({
    required int turn,
    required int academicYearIndex,
    required String name,
    required int score,
  }) = _ExamRecord;

  factory ExamRecord.fromJson(Map<String, dynamic> json) =>
      _$ExamRecordFromJson(json);
}

@freezed
abstract class TermGrade with _$TermGrade {
  const factory TermGrade({
    required int academicYearIndex,
    required int term,

    /// 評定（1..5）。
    required int grade,
  }) = _TermGrade;

  factory TermGrade.fromJson(Map<String, dynamic> json) =>
      _$TermGradeFromJson(json);
}

/// 入力待ちイベント。
@freezed
abstract class PendingEvent with _$PendingEvent {
  const factory PendingEvent({
    required PendingEventType type,
    required int turn,
    @Default(<String, String>{}) Map<String, String> data,
  }) = _PendingEvent;

  factory PendingEvent.fromJson(Map<String, dynamic> json) =>
      _$PendingEventFromJson(json);
}

/// 今年度のコンクールの進行状況。
@freezed
abstract class ContestProgress with _$ContestProgress {
  const factory ContestProgress({
    required int fiscalYear,
    required BandDivision division,

    /// 次に出場する大会（敗退・終了なら null）。
    ContestStage? nextStage,

    /// 各大会の結果（出場順）。
    @Default(<ContestStageResult>[]) List<ContestStageResult> results,

    /// 全日程が終わったターン（引退判定用）。
    int? finishedTurn,

    /// 3 年生の引退処理を済ませたか。
    @Default(false) bool retirementDone,
  }) = _ContestProgress;

  factory ContestProgress.fromJson(Map<String, dynamic> json) =>
      _$ContestProgressFromJson(json);
}

/// 1 つの大会の結果。
@freezed
abstract class ContestStageResult with _$ContestStageResult {
  const factory ContestStageResult({
    required ContestStage stage,
    required ContestAward award,
    required bool advanced,

    /// 演奏の出来（0..100 前後）。
    required int score,

    /// 出場団体中の順位。
    required int rank,
    required int entrants,

    /// 同じ大会の他校の結果（表示用、上位のみ）。
    @Default(<String>[]) List<String> board,
  }) = _ContestStageResult;

  factory ContestStageResult.fromJson(Map<String, dynamic> json) =>
      _$ContestStageResultFromJson(json);
}

/// 受験の状況（高校受験・大学受験で共用）。
@freezed
abstract class EntranceExamState with _$EntranceExamState {
  const factory EntranceExamState({
    /// 'high'（高校受験）または 'university'（大学受験）。
    required String kind,

    /// 推薦の打診があった学校。
    @Default(<String>[]) List<String> offers,

    /// 推薦を受けて内定した学校。
    String? recommended,

    /// 出願した学校（一般入試）。
    @Default(<String>[]) List<String> applications,

    /// 合否（学校 ID → 合格か）。
    @Default(<String, bool>{}) Map<String, bool> results,

    /// 進学先。
    String? enrolled,
  }) = _EntranceExamState;

  factory EntranceExamState.fromJson(Map<String, dynamic> json) =>
      _$EntranceExamStateFromJson(json);
}

/// 大人編（キャリアモード）の状態。
@freezed
abstract class CareerState with _$CareerState {
  const factory CareerState({
    /// 任期が終わるターン。
    required int termEndTurn,

    /// 顧問: 練習メニュー（PracticeMenuPreset.name）。
    @Default('balanced') String menu,

    /// 外部講師: 契約している学校（先頭が拠点校）。
    @Default(<String>[]) List<String> contractedSchoolIds,

    /// 外部講師: 評判（0..100）。
    @Default(50) int reputation,

    /// 外部講師: 出張レッスンで鍛えた学校のコンクールでの上乗せ（学校 ID → 点）。
    @Default(<String, int>{}) Map<String, int> schoolBoosts,

    /// OB/OG: 所持金（円）。
    @Default(0) int money,

    /// OB/OG: 部との絆（0..100）。
    @Default(50) int bond,

    /// 解放のもとになった生徒時代の称号（お試しなら null）。
    String? originTitle,
  }) = _CareerState;

  factory CareerState.fromJson(Map<String, dynamic> json) =>
      _$CareerStateFromJson(json);
}

/// プレイヤーの実績（エンディング解析用）。
@freezed
abstract class Achievement with _$Achievement {
  const factory Achievement({
    required int fiscalYear,
    required String schoolId,
    required String kind,
    required String label,

    /// 実績の大きさ（0..100）。
    required int weight,
  }) = _Achievement;

  factory Achievement.fromJson(Map<String, dynamic> json) =>
      _$AchievementFromJson(json);
}

/// 1 週間の出来事。
@freezed
abstract class WeekLog with _$WeekLog {
  const factory WeekLog({
    required int turn,
    required String dateLabel,
    String? actionLabel,
    required List<String> lines,
  }) = _WeekLog;

  factory WeekLog.fromJson(Map<String, dynamic> json) =>
      _$WeekLogFromJson(json);
}
