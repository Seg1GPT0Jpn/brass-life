import 'package:freezed_annotation/freezed_annotation.dart';

import '../../entities/memory_tag.dart';
import '../../entities/npc.dart';
import '../../value_objects/aptitude.dart';
import '../../value_objects/instrument.dart';
import '../../value_objects/person_enums.dart';
import '../../value_objects/personality.dart';
import '../../value_objects/relationship_vector.dart';
import 'game_enums.dart';

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
  }) = _PlayerState;

  const PlayerState._();

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
