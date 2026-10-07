// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'game_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GameState {

/// 保存形式のバージョン。
 int get schemaVersion; int get worldSeed; int get generatorVersion;/// 次に過ごす週のターン番号。
 int get turn; GameStage get stage; PlayerState get player;/// 現在所属している学校。
 String get schoolId;/// 現在の部員（プレイヤー以外。退部・卒業した者は含まない）。
 List<String> get roster;/// NPC の変化する値（部員・元部員）。
 Map<String, NpcState> get npcs;/// ゲーム中に生成された NPC（翌年度以降の新入生など）。
 Map<String, Npc> get extraNpcs;/// 関係性ベクトル。キーは「主体ID>相手ID」（主体から見た相手）。
 Map<String, RelationshipVector> get relations;/// ゲーム中に生まれた記憶。
 List<MemoryTag> get memories; int get memorySeq;/// 週ごとの出来事ログ（新しいものが末尾）。
 List<WeekLog> get logs;/// プレイヤーの選択履歴（リプレイ・検証用）。
 List<String> get choices;/// 入力待ちのイベント。
 PendingEvent? get pending;/// 現在の月の方針。
 MonthlyPolicy get policy;/// テスト週は自動で勉強するか。
 bool get studyBeforeExams;
/// Create a copy of GameState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GameStateCopyWith<GameState> get copyWith => _$GameStateCopyWithImpl<GameState>(this as GameState, _$identity);

  /// Serializes this GameState to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as GameState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GameState&&(identical(other.schemaVersion, _this.schemaVersion) || other.schemaVersion == _this.schemaVersion)&&(identical(other.worldSeed, _this.worldSeed) || other.worldSeed == _this.worldSeed)&&(identical(other.generatorVersion, _this.generatorVersion) || other.generatorVersion == _this.generatorVersion)&&(identical(other.turn, _this.turn) || other.turn == _this.turn)&&(identical(other.stage, _this.stage) || other.stage == _this.stage)&&(identical(other.player, _this.player) || other.player == _this.player)&&(identical(other.schoolId, _this.schoolId) || other.schoolId == _this.schoolId)&&const DeepCollectionEquality().equals(other.roster, _this.roster)&&const DeepCollectionEquality().equals(other.npcs, _this.npcs)&&const DeepCollectionEquality().equals(other.extraNpcs, _this.extraNpcs)&&const DeepCollectionEquality().equals(other.relations, _this.relations)&&const DeepCollectionEquality().equals(other.memories, _this.memories)&&(identical(other.memorySeq, _this.memorySeq) || other.memorySeq == _this.memorySeq)&&const DeepCollectionEquality().equals(other.logs, _this.logs)&&const DeepCollectionEquality().equals(other.choices, _this.choices)&&(identical(other.pending, _this.pending) || other.pending == _this.pending)&&(identical(other.policy, _this.policy) || other.policy == _this.policy)&&(identical(other.studyBeforeExams, _this.studyBeforeExams) || other.studyBeforeExams == _this.studyBeforeExams));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as GameState;
  return Object.hash(runtimeType,_this.schemaVersion,_this.worldSeed,_this.generatorVersion,_this.turn,_this.stage,_this.player,_this.schoolId,const DeepCollectionEquality().hash(_this.roster),const DeepCollectionEquality().hash(_this.npcs),const DeepCollectionEquality().hash(_this.extraNpcs),const DeepCollectionEquality().hash(_this.relations),const DeepCollectionEquality().hash(_this.memories),_this.memorySeq,const DeepCollectionEquality().hash(_this.logs),const DeepCollectionEquality().hash(_this.choices),_this.pending,_this.policy,_this.studyBeforeExams);
}

@override
String toString() {
  final _this = this as GameState;
  return 'GameState(schemaVersion: ${_this.schemaVersion}, worldSeed: ${_this.worldSeed}, generatorVersion: ${_this.generatorVersion}, turn: ${_this.turn}, stage: ${_this.stage}, player: ${_this.player}, schoolId: ${_this.schoolId}, roster: ${_this.roster}, npcs: ${_this.npcs}, extraNpcs: ${_this.extraNpcs}, relations: ${_this.relations}, memories: ${_this.memories}, memorySeq: ${_this.memorySeq}, logs: ${_this.logs}, choices: ${_this.choices}, pending: ${_this.pending}, policy: ${_this.policy}, studyBeforeExams: ${_this.studyBeforeExams})';
}


}

/// @nodoc
abstract mixin class $GameStateCopyWith<$Res>  {
  factory $GameStateCopyWith(GameState value, $Res Function(GameState) _then) = _$GameStateCopyWithImpl;
@useResult
$Res call({
 int schemaVersion, int worldSeed, int generatorVersion, int turn, GameStage stage, PlayerState player, String schoolId, List<String> roster, Map<String, NpcState> npcs, Map<String, Npc> extraNpcs, Map<String, RelationshipVector> relations, List<MemoryTag> memories, int memorySeq, List<WeekLog> logs, List<String> choices, PendingEvent? pending, MonthlyPolicy policy, bool studyBeforeExams
});


$PlayerStateCopyWith<$Res> get player;$PendingEventCopyWith<$Res>? get pending;

}
/// @nodoc
class _$GameStateCopyWithImpl<$Res>
    implements $GameStateCopyWith<$Res> {
  _$GameStateCopyWithImpl(this._self, this._then);

  final GameState _self;
  final $Res Function(GameState) _then;

/// Create a copy of GameState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? schemaVersion = null,Object? worldSeed = null,Object? generatorVersion = null,Object? turn = null,Object? stage = null,Object? player = null,Object? schoolId = null,Object? roster = null,Object? npcs = null,Object? extraNpcs = null,Object? relations = null,Object? memories = null,Object? memorySeq = null,Object? logs = null,Object? choices = null,Object? pending = freezed,Object? policy = null,Object? studyBeforeExams = null,}) {
  return _then(GameState(
schemaVersion: null == schemaVersion ? _self.schemaVersion : schemaVersion // ignore: cast_nullable_to_non_nullable
as int,worldSeed: null == worldSeed ? _self.worldSeed : worldSeed // ignore: cast_nullable_to_non_nullable
as int,generatorVersion: null == generatorVersion ? _self.generatorVersion : generatorVersion // ignore: cast_nullable_to_non_nullable
as int,turn: null == turn ? _self.turn : turn // ignore: cast_nullable_to_non_nullable
as int,stage: null == stage ? _self.stage : stage // ignore: cast_nullable_to_non_nullable
as GameStage,player: null == player ? _self.player : player // ignore: cast_nullable_to_non_nullable
as PlayerState,schoolId: null == schoolId ? _self.schoolId : schoolId // ignore: cast_nullable_to_non_nullable
as String,roster: null == roster ? _self.roster : roster // ignore: cast_nullable_to_non_nullable
as List<String>,npcs: null == npcs ? _self.npcs : npcs // ignore: cast_nullable_to_non_nullable
as Map<String, NpcState>,extraNpcs: null == extraNpcs ? _self.extraNpcs : extraNpcs // ignore: cast_nullable_to_non_nullable
as Map<String, Npc>,relations: null == relations ? _self.relations : relations // ignore: cast_nullable_to_non_nullable
as Map<String, RelationshipVector>,memories: null == memories ? _self.memories : memories // ignore: cast_nullable_to_non_nullable
as List<MemoryTag>,memorySeq: null == memorySeq ? _self.memorySeq : memorySeq // ignore: cast_nullable_to_non_nullable
as int,logs: null == logs ? _self.logs : logs // ignore: cast_nullable_to_non_nullable
as List<WeekLog>,choices: null == choices ? _self.choices : choices // ignore: cast_nullable_to_non_nullable
as List<String>,pending: freezed == pending ? _self.pending : pending // ignore: cast_nullable_to_non_nullable
as PendingEvent?,policy: null == policy ? _self.policy : policy // ignore: cast_nullable_to_non_nullable
as MonthlyPolicy,studyBeforeExams: null == studyBeforeExams ? _self.studyBeforeExams : studyBeforeExams // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of GameState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PlayerStateCopyWith<$Res> get player {
  
  return $PlayerStateCopyWith<$Res>(_self.player, (value) {
    return _then(_self.copyWith(player: value));
  });
}/// Create a copy of GameState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PendingEventCopyWith<$Res>? get pending {
    if (_self.pending == null) {
    return null;
  }

  return $PendingEventCopyWith<$Res>(_self.pending!, (value) {
    return _then(_self.copyWith(pending: value));
  });
}
}


/// Adds pattern-matching-related methods to [GameState].
extension GameStatePatterns on GameState {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GameState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GameState() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GameState value)  $default,){
final _that = this;
switch (_that) {
case _GameState():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GameState value)?  $default,){
final _that = this;
switch (_that) {
case _GameState() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int schemaVersion,  int worldSeed,  int generatorVersion,  int turn,  GameStage stage,  PlayerState player,  String schoolId,  List<String> roster,  Map<String, NpcState> npcs,  Map<String, Npc> extraNpcs,  Map<String, RelationshipVector> relations,  List<MemoryTag> memories,  int memorySeq,  List<WeekLog> logs,  List<String> choices,  PendingEvent? pending,  MonthlyPolicy policy,  bool studyBeforeExams)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GameState() when $default != null:
return $default(_that.schemaVersion,_that.worldSeed,_that.generatorVersion,_that.turn,_that.stage,_that.player,_that.schoolId,_that.roster,_that.npcs,_that.extraNpcs,_that.relations,_that.memories,_that.memorySeq,_that.logs,_that.choices,_that.pending,_that.policy,_that.studyBeforeExams);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int schemaVersion,  int worldSeed,  int generatorVersion,  int turn,  GameStage stage,  PlayerState player,  String schoolId,  List<String> roster,  Map<String, NpcState> npcs,  Map<String, Npc> extraNpcs,  Map<String, RelationshipVector> relations,  List<MemoryTag> memories,  int memorySeq,  List<WeekLog> logs,  List<String> choices,  PendingEvent? pending,  MonthlyPolicy policy,  bool studyBeforeExams)  $default,) {final _that = this;
switch (_that) {
case _GameState():
return $default(_that.schemaVersion,_that.worldSeed,_that.generatorVersion,_that.turn,_that.stage,_that.player,_that.schoolId,_that.roster,_that.npcs,_that.extraNpcs,_that.relations,_that.memories,_that.memorySeq,_that.logs,_that.choices,_that.pending,_that.policy,_that.studyBeforeExams);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int schemaVersion,  int worldSeed,  int generatorVersion,  int turn,  GameStage stage,  PlayerState player,  String schoolId,  List<String> roster,  Map<String, NpcState> npcs,  Map<String, Npc> extraNpcs,  Map<String, RelationshipVector> relations,  List<MemoryTag> memories,  int memorySeq,  List<WeekLog> logs,  List<String> choices,  PendingEvent? pending,  MonthlyPolicy policy,  bool studyBeforeExams)?  $default,) {final _that = this;
switch (_that) {
case _GameState() when $default != null:
return $default(_that.schemaVersion,_that.worldSeed,_that.generatorVersion,_that.turn,_that.stage,_that.player,_that.schoolId,_that.roster,_that.npcs,_that.extraNpcs,_that.relations,_that.memories,_that.memorySeq,_that.logs,_that.choices,_that.pending,_that.policy,_that.studyBeforeExams);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GameState implements GameState {
  const _GameState({this.schemaVersion = 1, required this.worldSeed, required this.generatorVersion, required this.turn, required this.stage, required this.player, required this.schoolId, required  List<String> roster, required  Map<String, NpcState> npcs,  Map<String, Npc> extraNpcs = const <String, Npc>{},  Map<String, RelationshipVector> relations = const <String, RelationshipVector>{},  List<MemoryTag> memories = const <MemoryTag>[], this.memorySeq = 0,  List<WeekLog> logs = const <WeekLog>[],  List<String> choices = const <String>[], this.pending, this.policy = MonthlyPolicy.balanced, this.studyBeforeExams = true}): _roster = roster,_npcs = npcs,_extraNpcs = extraNpcs,_relations = relations,_memories = memories,_logs = logs,_choices = choices;
  factory _GameState.fromJson(Map<String, dynamic> json) => _$GameStateFromJson(json);

/// 保存形式のバージョン。
@override@JsonKey() final  int schemaVersion;
@override final  int worldSeed;
@override final  int generatorVersion;
/// 次に過ごす週のターン番号。
@override final  int turn;
@override final  GameStage stage;
@override final  PlayerState player;
/// 現在所属している学校。
@override final  String schoolId;
/// 現在の部員（プレイヤー以外。退部・卒業した者は含まない）。
 final  List<String> _roster;
/// 現在の部員（プレイヤー以外。退部・卒業した者は含まない）。
@override List<String> get roster {
  if (_roster is EqualUnmodifiableListView) return _roster;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_roster);
}

/// NPC の変化する値（部員・元部員）。
 final  Map<String, NpcState> _npcs;
/// NPC の変化する値（部員・元部員）。
@override Map<String, NpcState> get npcs {
  if (_npcs is EqualUnmodifiableMapView) return _npcs;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_npcs);
}

/// ゲーム中に生成された NPC（翌年度以降の新入生など）。
 final  Map<String, Npc> _extraNpcs;
/// ゲーム中に生成された NPC（翌年度以降の新入生など）。
@override@JsonKey() Map<String, Npc> get extraNpcs {
  if (_extraNpcs is EqualUnmodifiableMapView) return _extraNpcs;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_extraNpcs);
}

/// 関係性ベクトル。キーは「主体ID>相手ID」（主体から見た相手）。
 final  Map<String, RelationshipVector> _relations;
/// 関係性ベクトル。キーは「主体ID>相手ID」（主体から見た相手）。
@override@JsonKey() Map<String, RelationshipVector> get relations {
  if (_relations is EqualUnmodifiableMapView) return _relations;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_relations);
}

/// ゲーム中に生まれた記憶。
 final  List<MemoryTag> _memories;
/// ゲーム中に生まれた記憶。
@override@JsonKey() List<MemoryTag> get memories {
  if (_memories is EqualUnmodifiableListView) return _memories;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_memories);
}

@override@JsonKey() final  int memorySeq;
/// 週ごとの出来事ログ（新しいものが末尾）。
 final  List<WeekLog> _logs;
/// 週ごとの出来事ログ（新しいものが末尾）。
@override@JsonKey() List<WeekLog> get logs {
  if (_logs is EqualUnmodifiableListView) return _logs;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_logs);
}

/// プレイヤーの選択履歴（リプレイ・検証用）。
 final  List<String> _choices;
/// プレイヤーの選択履歴（リプレイ・検証用）。
@override@JsonKey() List<String> get choices {
  if (_choices is EqualUnmodifiableListView) return _choices;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_choices);
}

/// 入力待ちのイベント。
@override final  PendingEvent? pending;
/// 現在の月の方針。
@override@JsonKey() final  MonthlyPolicy policy;
/// テスト週は自動で勉強するか。
@override@JsonKey() final  bool studyBeforeExams;

/// Create a copy of GameState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GameStateCopyWith<_GameState> get copyWith => __$GameStateCopyWithImpl<_GameState>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GameStateToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _GameState&&(identical(other.schemaVersion, schemaVersion) || other.schemaVersion == schemaVersion)&&(identical(other.worldSeed, worldSeed) || other.worldSeed == worldSeed)&&(identical(other.generatorVersion, generatorVersion) || other.generatorVersion == generatorVersion)&&(identical(other.turn, turn) || other.turn == turn)&&(identical(other.stage, stage) || other.stage == stage)&&(identical(other.player, player) || other.player == player)&&(identical(other.schoolId, schoolId) || other.schoolId == schoolId)&&const DeepCollectionEquality().equals(other.roster, _roster)&&const DeepCollectionEquality().equals(other.npcs, _npcs)&&const DeepCollectionEquality().equals(other.extraNpcs, _extraNpcs)&&const DeepCollectionEquality().equals(other.relations, _relations)&&const DeepCollectionEquality().equals(other.memories, _memories)&&(identical(other.memorySeq, memorySeq) || other.memorySeq == memorySeq)&&const DeepCollectionEquality().equals(other.logs, _logs)&&const DeepCollectionEquality().equals(other.choices, _choices)&&(identical(other.pending, pending) || other.pending == pending)&&(identical(other.policy, policy) || other.policy == policy)&&(identical(other.studyBeforeExams, studyBeforeExams) || other.studyBeforeExams == studyBeforeExams));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,schemaVersion,worldSeed,generatorVersion,turn,stage,player,schoolId,const DeepCollectionEquality().hash(_roster),const DeepCollectionEquality().hash(_npcs),const DeepCollectionEquality().hash(_extraNpcs),const DeepCollectionEquality().hash(_relations),const DeepCollectionEquality().hash(_memories),memorySeq,const DeepCollectionEquality().hash(_logs),const DeepCollectionEquality().hash(_choices),pending,policy,studyBeforeExams);
}

@override
String toString() {
    return 'GameState(schemaVersion: $schemaVersion, worldSeed: $worldSeed, generatorVersion: $generatorVersion, turn: $turn, stage: $stage, player: $player, schoolId: $schoolId, roster: $roster, npcs: $npcs, extraNpcs: $extraNpcs, relations: $relations, memories: $memories, memorySeq: $memorySeq, logs: $logs, choices: $choices, pending: $pending, policy: $policy, studyBeforeExams: $studyBeforeExams)';
}


}

/// @nodoc
abstract mixin class _$GameStateCopyWith<$Res> implements $GameStateCopyWith<$Res> {
  factory _$GameStateCopyWith(_GameState value, $Res Function(_GameState) _then) = __$GameStateCopyWithImpl;
@override @useResult
$Res call({
 int schemaVersion, int worldSeed, int generatorVersion, int turn, GameStage stage, PlayerState player, String schoolId, List<String> roster, Map<String, NpcState> npcs, Map<String, Npc> extraNpcs, Map<String, RelationshipVector> relations, List<MemoryTag> memories, int memorySeq, List<WeekLog> logs, List<String> choices, PendingEvent? pending, MonthlyPolicy policy, bool studyBeforeExams
});


@override $PlayerStateCopyWith<$Res> get player;@override $PendingEventCopyWith<$Res>? get pending;

}
/// @nodoc
class __$GameStateCopyWithImpl<$Res>
    implements _$GameStateCopyWith<$Res> {
  __$GameStateCopyWithImpl(this._self, this._then);

  final _GameState _self;
  final $Res Function(_GameState) _then;

/// Create a copy of GameState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? schemaVersion = null,Object? worldSeed = null,Object? generatorVersion = null,Object? turn = null,Object? stage = null,Object? player = null,Object? schoolId = null,Object? roster = null,Object? npcs = null,Object? extraNpcs = null,Object? relations = null,Object? memories = null,Object? memorySeq = null,Object? logs = null,Object? choices = null,Object? pending = freezed,Object? policy = null,Object? studyBeforeExams = null,}) {
  return _then(_GameState(
schemaVersion: null == schemaVersion ? _self.schemaVersion : schemaVersion // ignore: cast_nullable_to_non_nullable
as int,worldSeed: null == worldSeed ? _self.worldSeed : worldSeed // ignore: cast_nullable_to_non_nullable
as int,generatorVersion: null == generatorVersion ? _self.generatorVersion : generatorVersion // ignore: cast_nullable_to_non_nullable
as int,turn: null == turn ? _self.turn : turn // ignore: cast_nullable_to_non_nullable
as int,stage: null == stage ? _self.stage : stage // ignore: cast_nullable_to_non_nullable
as GameStage,player: null == player ? _self.player : player // ignore: cast_nullable_to_non_nullable
as PlayerState,schoolId: null == schoolId ? _self.schoolId : schoolId // ignore: cast_nullable_to_non_nullable
as String,roster: null == roster ? _self._roster : roster // ignore: cast_nullable_to_non_nullable
as List<String>,npcs: null == npcs ? _self._npcs : npcs // ignore: cast_nullable_to_non_nullable
as Map<String, NpcState>,extraNpcs: null == extraNpcs ? _self._extraNpcs : extraNpcs // ignore: cast_nullable_to_non_nullable
as Map<String, Npc>,relations: null == relations ? _self._relations : relations // ignore: cast_nullable_to_non_nullable
as Map<String, RelationshipVector>,memories: null == memories ? _self._memories : memories // ignore: cast_nullable_to_non_nullable
as List<MemoryTag>,memorySeq: null == memorySeq ? _self.memorySeq : memorySeq // ignore: cast_nullable_to_non_nullable
as int,logs: null == logs ? _self._logs : logs // ignore: cast_nullable_to_non_nullable
as List<WeekLog>,choices: null == choices ? _self._choices : choices // ignore: cast_nullable_to_non_nullable
as List<String>,pending: freezed == pending ? _self.pending : pending // ignore: cast_nullable_to_non_nullable
as PendingEvent?,policy: null == policy ? _self.policy : policy // ignore: cast_nullable_to_non_nullable
as MonthlyPolicy,studyBeforeExams: null == studyBeforeExams ? _self.studyBeforeExams : studyBeforeExams // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of GameState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PlayerStateCopyWith<$Res> get player {
  
  return $PlayerStateCopyWith<$Res>(_self.player, (value) {
    return _then(_self.copyWith(player: value));
  });
}/// Create a copy of GameState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PendingEventCopyWith<$Res>? get pending {
    if (_self.pending == null) {
    return null;
  }

  return $PendingEventCopyWith<$Res>(_self.pending!, (value) {
    return _then(_self.copyWith(pending: value));
  });
}
}


/// @nodoc
mixin _$PlayerState {

 String get familyName; String get givenName; Gender get gender; PersonalityAxes get personality; List<TraitTag> get traits; AptitudeStats get aptitude; MusicBackground get background; int get grade;/// 担当楽器（決定前は null）。
 InstrumentType? get instrument;/// 担当楽器の熟練度（0..1000）。
 int get skill;/// 音楽性（0..1000）。楽器に依らない合奏力・表現の土台。
 int get musicality;/// 学力（0..1000）。
 int get academic;/// 体力（0..100）。疲労の回復力に影響。
 int get stamina;/// 疲労（0..100）。
 int get fatigue;/// ストレス（0..100）。
 int get stress;/// やる気（0..100）。
 int get motivation;/// 社交性（0..100）。
 int get social;/// 顧問からの評価（0..100）。
 int get advisorTrust;/// 楽器の希望（第 1〜3 希望）。
 List<InstrumentType> get wishes;/// 以前の担当楽器（高校で楽器が変わった場合など）。
 InstrumentType? get previousInstrument;/// 定期テストの成績。
 List<ExamRecord> get exams;/// 学期ごとの評定（1..5）。内申点の算出に用いる。
 List<TermGrade> get termGrades;/// 行動の累計回数（エンディング解析に用いる）。
 Map<String, int> get actionCounts;
/// Create a copy of PlayerState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlayerStateCopyWith<PlayerState> get copyWith => _$PlayerStateCopyWithImpl<PlayerState>(this as PlayerState, _$identity);

  /// Serializes this PlayerState to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PlayerState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlayerState&&(identical(other.familyName, _this.familyName) || other.familyName == _this.familyName)&&(identical(other.givenName, _this.givenName) || other.givenName == _this.givenName)&&(identical(other.gender, _this.gender) || other.gender == _this.gender)&&(identical(other.personality, _this.personality) || other.personality == _this.personality)&&const DeepCollectionEquality().equals(other.traits, _this.traits)&&(identical(other.aptitude, _this.aptitude) || other.aptitude == _this.aptitude)&&(identical(other.background, _this.background) || other.background == _this.background)&&(identical(other.grade, _this.grade) || other.grade == _this.grade)&&(identical(other.instrument, _this.instrument) || other.instrument == _this.instrument)&&(identical(other.skill, _this.skill) || other.skill == _this.skill)&&(identical(other.musicality, _this.musicality) || other.musicality == _this.musicality)&&(identical(other.academic, _this.academic) || other.academic == _this.academic)&&(identical(other.stamina, _this.stamina) || other.stamina == _this.stamina)&&(identical(other.fatigue, _this.fatigue) || other.fatigue == _this.fatigue)&&(identical(other.stress, _this.stress) || other.stress == _this.stress)&&(identical(other.motivation, _this.motivation) || other.motivation == _this.motivation)&&(identical(other.social, _this.social) || other.social == _this.social)&&(identical(other.advisorTrust, _this.advisorTrust) || other.advisorTrust == _this.advisorTrust)&&const DeepCollectionEquality().equals(other.wishes, _this.wishes)&&(identical(other.previousInstrument, _this.previousInstrument) || other.previousInstrument == _this.previousInstrument)&&const DeepCollectionEquality().equals(other.exams, _this.exams)&&const DeepCollectionEquality().equals(other.termGrades, _this.termGrades)&&const DeepCollectionEquality().equals(other.actionCounts, _this.actionCounts));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PlayerState;
  return Object.hashAll([runtimeType,_this.familyName,_this.givenName,_this.gender,_this.personality,const DeepCollectionEquality().hash(_this.traits),_this.aptitude,_this.background,_this.grade,_this.instrument,_this.skill,_this.musicality,_this.academic,_this.stamina,_this.fatigue,_this.stress,_this.motivation,_this.social,_this.advisorTrust,const DeepCollectionEquality().hash(_this.wishes),_this.previousInstrument,const DeepCollectionEquality().hash(_this.exams),const DeepCollectionEquality().hash(_this.termGrades),const DeepCollectionEquality().hash(_this.actionCounts)]);
}

@override
String toString() {
  final _this = this as PlayerState;
  return 'PlayerState(familyName: ${_this.familyName}, givenName: ${_this.givenName}, gender: ${_this.gender}, personality: ${_this.personality}, traits: ${_this.traits}, aptitude: ${_this.aptitude}, background: ${_this.background}, grade: ${_this.grade}, instrument: ${_this.instrument}, skill: ${_this.skill}, musicality: ${_this.musicality}, academic: ${_this.academic}, stamina: ${_this.stamina}, fatigue: ${_this.fatigue}, stress: ${_this.stress}, motivation: ${_this.motivation}, social: ${_this.social}, advisorTrust: ${_this.advisorTrust}, wishes: ${_this.wishes}, previousInstrument: ${_this.previousInstrument}, exams: ${_this.exams}, termGrades: ${_this.termGrades}, actionCounts: ${_this.actionCounts})';
}


}

/// @nodoc
abstract mixin class $PlayerStateCopyWith<$Res>  {
  factory $PlayerStateCopyWith(PlayerState value, $Res Function(PlayerState) _then) = _$PlayerStateCopyWithImpl;
@useResult
$Res call({
 String familyName, String givenName, Gender gender, PersonalityAxes personality, List<TraitTag> traits, AptitudeStats aptitude, MusicBackground background, int grade, InstrumentType? instrument, int skill, int musicality, int academic, int stamina, int fatigue, int stress, int motivation, int social, int advisorTrust, List<InstrumentType> wishes, InstrumentType? previousInstrument, List<ExamRecord> exams, List<TermGrade> termGrades, Map<String, int> actionCounts
});


$PersonalityAxesCopyWith<$Res> get personality;$AptitudeStatsCopyWith<$Res> get aptitude;

}
/// @nodoc
class _$PlayerStateCopyWithImpl<$Res>
    implements $PlayerStateCopyWith<$Res> {
  _$PlayerStateCopyWithImpl(this._self, this._then);

  final PlayerState _self;
  final $Res Function(PlayerState) _then;

/// Create a copy of PlayerState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? familyName = null,Object? givenName = null,Object? gender = null,Object? personality = null,Object? traits = null,Object? aptitude = null,Object? background = null,Object? grade = null,Object? instrument = freezed,Object? skill = null,Object? musicality = null,Object? academic = null,Object? stamina = null,Object? fatigue = null,Object? stress = null,Object? motivation = null,Object? social = null,Object? advisorTrust = null,Object? wishes = null,Object? previousInstrument = freezed,Object? exams = null,Object? termGrades = null,Object? actionCounts = null,}) {
  return _then(PlayerState(
familyName: null == familyName ? _self.familyName : familyName // ignore: cast_nullable_to_non_nullable
as String,givenName: null == givenName ? _self.givenName : givenName // ignore: cast_nullable_to_non_nullable
as String,gender: null == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as Gender,personality: null == personality ? _self.personality : personality // ignore: cast_nullable_to_non_nullable
as PersonalityAxes,traits: null == traits ? _self.traits : traits // ignore: cast_nullable_to_non_nullable
as List<TraitTag>,aptitude: null == aptitude ? _self.aptitude : aptitude // ignore: cast_nullable_to_non_nullable
as AptitudeStats,background: null == background ? _self.background : background // ignore: cast_nullable_to_non_nullable
as MusicBackground,grade: null == grade ? _self.grade : grade // ignore: cast_nullable_to_non_nullable
as int,instrument: freezed == instrument ? _self.instrument : instrument // ignore: cast_nullable_to_non_nullable
as InstrumentType?,skill: null == skill ? _self.skill : skill // ignore: cast_nullable_to_non_nullable
as int,musicality: null == musicality ? _self.musicality : musicality // ignore: cast_nullable_to_non_nullable
as int,academic: null == academic ? _self.academic : academic // ignore: cast_nullable_to_non_nullable
as int,stamina: null == stamina ? _self.stamina : stamina // ignore: cast_nullable_to_non_nullable
as int,fatigue: null == fatigue ? _self.fatigue : fatigue // ignore: cast_nullable_to_non_nullable
as int,stress: null == stress ? _self.stress : stress // ignore: cast_nullable_to_non_nullable
as int,motivation: null == motivation ? _self.motivation : motivation // ignore: cast_nullable_to_non_nullable
as int,social: null == social ? _self.social : social // ignore: cast_nullable_to_non_nullable
as int,advisorTrust: null == advisorTrust ? _self.advisorTrust : advisorTrust // ignore: cast_nullable_to_non_nullable
as int,wishes: null == wishes ? _self.wishes : wishes // ignore: cast_nullable_to_non_nullable
as List<InstrumentType>,previousInstrument: freezed == previousInstrument ? _self.previousInstrument : previousInstrument // ignore: cast_nullable_to_non_nullable
as InstrumentType?,exams: null == exams ? _self.exams : exams // ignore: cast_nullable_to_non_nullable
as List<ExamRecord>,termGrades: null == termGrades ? _self.termGrades : termGrades // ignore: cast_nullable_to_non_nullable
as List<TermGrade>,actionCounts: null == actionCounts ? _self.actionCounts : actionCounts // ignore: cast_nullable_to_non_nullable
as Map<String, int>,
  ));
}
/// Create a copy of PlayerState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PersonalityAxesCopyWith<$Res> get personality {
  
  return $PersonalityAxesCopyWith<$Res>(_self.personality, (value) {
    return _then(_self.copyWith(personality: value));
  });
}/// Create a copy of PlayerState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AptitudeStatsCopyWith<$Res> get aptitude {
  
  return $AptitudeStatsCopyWith<$Res>(_self.aptitude, (value) {
    return _then(_self.copyWith(aptitude: value));
  });
}
}


/// Adds pattern-matching-related methods to [PlayerState].
extension PlayerStatePatterns on PlayerState {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PlayerState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PlayerState() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PlayerState value)  $default,){
final _that = this;
switch (_that) {
case _PlayerState():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PlayerState value)?  $default,){
final _that = this;
switch (_that) {
case _PlayerState() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String familyName,  String givenName,  Gender gender,  PersonalityAxes personality,  List<TraitTag> traits,  AptitudeStats aptitude,  MusicBackground background,  int grade,  InstrumentType? instrument,  int skill,  int musicality,  int academic,  int stamina,  int fatigue,  int stress,  int motivation,  int social,  int advisorTrust,  List<InstrumentType> wishes,  InstrumentType? previousInstrument,  List<ExamRecord> exams,  List<TermGrade> termGrades,  Map<String, int> actionCounts)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PlayerState() when $default != null:
return $default(_that.familyName,_that.givenName,_that.gender,_that.personality,_that.traits,_that.aptitude,_that.background,_that.grade,_that.instrument,_that.skill,_that.musicality,_that.academic,_that.stamina,_that.fatigue,_that.stress,_that.motivation,_that.social,_that.advisorTrust,_that.wishes,_that.previousInstrument,_that.exams,_that.termGrades,_that.actionCounts);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String familyName,  String givenName,  Gender gender,  PersonalityAxes personality,  List<TraitTag> traits,  AptitudeStats aptitude,  MusicBackground background,  int grade,  InstrumentType? instrument,  int skill,  int musicality,  int academic,  int stamina,  int fatigue,  int stress,  int motivation,  int social,  int advisorTrust,  List<InstrumentType> wishes,  InstrumentType? previousInstrument,  List<ExamRecord> exams,  List<TermGrade> termGrades,  Map<String, int> actionCounts)  $default,) {final _that = this;
switch (_that) {
case _PlayerState():
return $default(_that.familyName,_that.givenName,_that.gender,_that.personality,_that.traits,_that.aptitude,_that.background,_that.grade,_that.instrument,_that.skill,_that.musicality,_that.academic,_that.stamina,_that.fatigue,_that.stress,_that.motivation,_that.social,_that.advisorTrust,_that.wishes,_that.previousInstrument,_that.exams,_that.termGrades,_that.actionCounts);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String familyName,  String givenName,  Gender gender,  PersonalityAxes personality,  List<TraitTag> traits,  AptitudeStats aptitude,  MusicBackground background,  int grade,  InstrumentType? instrument,  int skill,  int musicality,  int academic,  int stamina,  int fatigue,  int stress,  int motivation,  int social,  int advisorTrust,  List<InstrumentType> wishes,  InstrumentType? previousInstrument,  List<ExamRecord> exams,  List<TermGrade> termGrades,  Map<String, int> actionCounts)?  $default,) {final _that = this;
switch (_that) {
case _PlayerState() when $default != null:
return $default(_that.familyName,_that.givenName,_that.gender,_that.personality,_that.traits,_that.aptitude,_that.background,_that.grade,_that.instrument,_that.skill,_that.musicality,_that.academic,_that.stamina,_that.fatigue,_that.stress,_that.motivation,_that.social,_that.advisorTrust,_that.wishes,_that.previousInstrument,_that.exams,_that.termGrades,_that.actionCounts);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PlayerState extends PlayerState {
  const _PlayerState({required this.familyName, required this.givenName, required this.gender, required this.personality, required  List<TraitTag> traits, required this.aptitude, required this.background, required this.grade, this.instrument, this.skill = 0, this.musicality = 100, required this.academic, required this.stamina, this.fatigue = 10, this.stress = 10, this.motivation = 60, this.social = 30, this.advisorTrust = 50,  List<InstrumentType> wishes = const <InstrumentType>[], this.previousInstrument,  List<ExamRecord> exams = const <ExamRecord>[],  List<TermGrade> termGrades = const <TermGrade>[],  Map<String, int> actionCounts = const <String, int>{}}): _traits = traits,_wishes = wishes,_exams = exams,_termGrades = termGrades,_actionCounts = actionCounts,super._();
  factory _PlayerState.fromJson(Map<String, dynamic> json) => _$PlayerStateFromJson(json);

@override final  String familyName;
@override final  String givenName;
@override final  Gender gender;
@override final  PersonalityAxes personality;
 final  List<TraitTag> _traits;
@override List<TraitTag> get traits {
  if (_traits is EqualUnmodifiableListView) return _traits;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_traits);
}

@override final  AptitudeStats aptitude;
@override final  MusicBackground background;
@override final  int grade;
/// 担当楽器（決定前は null）。
@override final  InstrumentType? instrument;
/// 担当楽器の熟練度（0..1000）。
@override@JsonKey() final  int skill;
/// 音楽性（0..1000）。楽器に依らない合奏力・表現の土台。
@override@JsonKey() final  int musicality;
/// 学力（0..1000）。
@override final  int academic;
/// 体力（0..100）。疲労の回復力に影響。
@override final  int stamina;
/// 疲労（0..100）。
@override@JsonKey() final  int fatigue;
/// ストレス（0..100）。
@override@JsonKey() final  int stress;
/// やる気（0..100）。
@override@JsonKey() final  int motivation;
/// 社交性（0..100）。
@override@JsonKey() final  int social;
/// 顧問からの評価（0..100）。
@override@JsonKey() final  int advisorTrust;
/// 楽器の希望（第 1〜3 希望）。
 final  List<InstrumentType> _wishes;
/// 楽器の希望（第 1〜3 希望）。
@override@JsonKey() List<InstrumentType> get wishes {
  if (_wishes is EqualUnmodifiableListView) return _wishes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_wishes);
}

/// 以前の担当楽器（高校で楽器が変わった場合など）。
@override final  InstrumentType? previousInstrument;
/// 定期テストの成績。
 final  List<ExamRecord> _exams;
/// 定期テストの成績。
@override@JsonKey() List<ExamRecord> get exams {
  if (_exams is EqualUnmodifiableListView) return _exams;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_exams);
}

/// 学期ごとの評定（1..5）。内申点の算出に用いる。
 final  List<TermGrade> _termGrades;
/// 学期ごとの評定（1..5）。内申点の算出に用いる。
@override@JsonKey() List<TermGrade> get termGrades {
  if (_termGrades is EqualUnmodifiableListView) return _termGrades;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_termGrades);
}

/// 行動の累計回数（エンディング解析に用いる）。
 final  Map<String, int> _actionCounts;
/// 行動の累計回数（エンディング解析に用いる）。
@override@JsonKey() Map<String, int> get actionCounts {
  if (_actionCounts is EqualUnmodifiableMapView) return _actionCounts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_actionCounts);
}


/// Create a copy of PlayerState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlayerStateCopyWith<_PlayerState> get copyWith => __$PlayerStateCopyWithImpl<_PlayerState>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PlayerStateToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlayerState&&(identical(other.familyName, familyName) || other.familyName == familyName)&&(identical(other.givenName, givenName) || other.givenName == givenName)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.personality, personality) || other.personality == personality)&&const DeepCollectionEquality().equals(other.traits, _traits)&&(identical(other.aptitude, aptitude) || other.aptitude == aptitude)&&(identical(other.background, background) || other.background == background)&&(identical(other.grade, grade) || other.grade == grade)&&(identical(other.instrument, instrument) || other.instrument == instrument)&&(identical(other.skill, skill) || other.skill == skill)&&(identical(other.musicality, musicality) || other.musicality == musicality)&&(identical(other.academic, academic) || other.academic == academic)&&(identical(other.stamina, stamina) || other.stamina == stamina)&&(identical(other.fatigue, fatigue) || other.fatigue == fatigue)&&(identical(other.stress, stress) || other.stress == stress)&&(identical(other.motivation, motivation) || other.motivation == motivation)&&(identical(other.social, social) || other.social == social)&&(identical(other.advisorTrust, advisorTrust) || other.advisorTrust == advisorTrust)&&const DeepCollectionEquality().equals(other.wishes, _wishes)&&(identical(other.previousInstrument, previousInstrument) || other.previousInstrument == previousInstrument)&&const DeepCollectionEquality().equals(other.exams, _exams)&&const DeepCollectionEquality().equals(other.termGrades, _termGrades)&&const DeepCollectionEquality().equals(other.actionCounts, _actionCounts));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hashAll([runtimeType,familyName,givenName,gender,personality,const DeepCollectionEquality().hash(_traits),aptitude,background,grade,instrument,skill,musicality,academic,stamina,fatigue,stress,motivation,social,advisorTrust,const DeepCollectionEquality().hash(_wishes),previousInstrument,const DeepCollectionEquality().hash(_exams),const DeepCollectionEquality().hash(_termGrades),const DeepCollectionEquality().hash(_actionCounts)]);
}

@override
String toString() {
    return 'PlayerState(familyName: $familyName, givenName: $givenName, gender: $gender, personality: $personality, traits: $traits, aptitude: $aptitude, background: $background, grade: $grade, instrument: $instrument, skill: $skill, musicality: $musicality, academic: $academic, stamina: $stamina, fatigue: $fatigue, stress: $stress, motivation: $motivation, social: $social, advisorTrust: $advisorTrust, wishes: $wishes, previousInstrument: $previousInstrument, exams: $exams, termGrades: $termGrades, actionCounts: $actionCounts)';
}


}

/// @nodoc
abstract mixin class _$PlayerStateCopyWith<$Res> implements $PlayerStateCopyWith<$Res> {
  factory _$PlayerStateCopyWith(_PlayerState value, $Res Function(_PlayerState) _then) = __$PlayerStateCopyWithImpl;
@override @useResult
$Res call({
 String familyName, String givenName, Gender gender, PersonalityAxes personality, List<TraitTag> traits, AptitudeStats aptitude, MusicBackground background, int grade, InstrumentType? instrument, int skill, int musicality, int academic, int stamina, int fatigue, int stress, int motivation, int social, int advisorTrust, List<InstrumentType> wishes, InstrumentType? previousInstrument, List<ExamRecord> exams, List<TermGrade> termGrades, Map<String, int> actionCounts
});


@override $PersonalityAxesCopyWith<$Res> get personality;@override $AptitudeStatsCopyWith<$Res> get aptitude;

}
/// @nodoc
class __$PlayerStateCopyWithImpl<$Res>
    implements _$PlayerStateCopyWith<$Res> {
  __$PlayerStateCopyWithImpl(this._self, this._then);

  final _PlayerState _self;
  final $Res Function(_PlayerState) _then;

/// Create a copy of PlayerState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? familyName = null,Object? givenName = null,Object? gender = null,Object? personality = null,Object? traits = null,Object? aptitude = null,Object? background = null,Object? grade = null,Object? instrument = freezed,Object? skill = null,Object? musicality = null,Object? academic = null,Object? stamina = null,Object? fatigue = null,Object? stress = null,Object? motivation = null,Object? social = null,Object? advisorTrust = null,Object? wishes = null,Object? previousInstrument = freezed,Object? exams = null,Object? termGrades = null,Object? actionCounts = null,}) {
  return _then(_PlayerState(
familyName: null == familyName ? _self.familyName : familyName // ignore: cast_nullable_to_non_nullable
as String,givenName: null == givenName ? _self.givenName : givenName // ignore: cast_nullable_to_non_nullable
as String,gender: null == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as Gender,personality: null == personality ? _self.personality : personality // ignore: cast_nullable_to_non_nullable
as PersonalityAxes,traits: null == traits ? _self._traits : traits // ignore: cast_nullable_to_non_nullable
as List<TraitTag>,aptitude: null == aptitude ? _self.aptitude : aptitude // ignore: cast_nullable_to_non_nullable
as AptitudeStats,background: null == background ? _self.background : background // ignore: cast_nullable_to_non_nullable
as MusicBackground,grade: null == grade ? _self.grade : grade // ignore: cast_nullable_to_non_nullable
as int,instrument: freezed == instrument ? _self.instrument : instrument // ignore: cast_nullable_to_non_nullable
as InstrumentType?,skill: null == skill ? _self.skill : skill // ignore: cast_nullable_to_non_nullable
as int,musicality: null == musicality ? _self.musicality : musicality // ignore: cast_nullable_to_non_nullable
as int,academic: null == academic ? _self.academic : academic // ignore: cast_nullable_to_non_nullable
as int,stamina: null == stamina ? _self.stamina : stamina // ignore: cast_nullable_to_non_nullable
as int,fatigue: null == fatigue ? _self.fatigue : fatigue // ignore: cast_nullable_to_non_nullable
as int,stress: null == stress ? _self.stress : stress // ignore: cast_nullable_to_non_nullable
as int,motivation: null == motivation ? _self.motivation : motivation // ignore: cast_nullable_to_non_nullable
as int,social: null == social ? _self.social : social // ignore: cast_nullable_to_non_nullable
as int,advisorTrust: null == advisorTrust ? _self.advisorTrust : advisorTrust // ignore: cast_nullable_to_non_nullable
as int,wishes: null == wishes ? _self._wishes : wishes // ignore: cast_nullable_to_non_nullable
as List<InstrumentType>,previousInstrument: freezed == previousInstrument ? _self.previousInstrument : previousInstrument // ignore: cast_nullable_to_non_nullable
as InstrumentType?,exams: null == exams ? _self._exams : exams // ignore: cast_nullable_to_non_nullable
as List<ExamRecord>,termGrades: null == termGrades ? _self._termGrades : termGrades // ignore: cast_nullable_to_non_nullable
as List<TermGrade>,actionCounts: null == actionCounts ? _self._actionCounts : actionCounts // ignore: cast_nullable_to_non_nullable
as Map<String, int>,
  ));
}

/// Create a copy of PlayerState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PersonalityAxesCopyWith<$Res> get personality {
  
  return $PersonalityAxesCopyWith<$Res>(_self.personality, (value) {
    return _then(_self.copyWith(personality: value));
  });
}/// Create a copy of PlayerState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AptitudeStatsCopyWith<$Res> get aptitude {
  
  return $AptitudeStatsCopyWith<$Res>(_self.aptitude, (value) {
    return _then(_self.copyWith(aptitude: value));
  });
}
}


/// @nodoc
mixin _$NpcState {

 String get id; int get grade; InstrumentType? get instrument; int get skill; int get motivation; int get stress;/// 低いやる気が続いた週数（退部判定）。
 int get lowMotivationWeeks;/// 部に在籍しているか（卒業・退部で false）。
 bool get active;/// 退部した。
 bool get quit;/// 新入生の希望楽器。
 InstrumentType? get wish;
/// Create a copy of NpcState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NpcStateCopyWith<NpcState> get copyWith => _$NpcStateCopyWithImpl<NpcState>(this as NpcState, _$identity);

  /// Serializes this NpcState to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as NpcState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NpcState&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.grade, _this.grade) || other.grade == _this.grade)&&(identical(other.instrument, _this.instrument) || other.instrument == _this.instrument)&&(identical(other.skill, _this.skill) || other.skill == _this.skill)&&(identical(other.motivation, _this.motivation) || other.motivation == _this.motivation)&&(identical(other.stress, _this.stress) || other.stress == _this.stress)&&(identical(other.lowMotivationWeeks, _this.lowMotivationWeeks) || other.lowMotivationWeeks == _this.lowMotivationWeeks)&&(identical(other.active, _this.active) || other.active == _this.active)&&(identical(other.quit, _this.quit) || other.quit == _this.quit)&&(identical(other.wish, _this.wish) || other.wish == _this.wish));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as NpcState;
  return Object.hash(runtimeType,_this.id,_this.grade,_this.instrument,_this.skill,_this.motivation,_this.stress,_this.lowMotivationWeeks,_this.active,_this.quit,_this.wish);
}

@override
String toString() {
  final _this = this as NpcState;
  return 'NpcState(id: ${_this.id}, grade: ${_this.grade}, instrument: ${_this.instrument}, skill: ${_this.skill}, motivation: ${_this.motivation}, stress: ${_this.stress}, lowMotivationWeeks: ${_this.lowMotivationWeeks}, active: ${_this.active}, quit: ${_this.quit}, wish: ${_this.wish})';
}


}

/// @nodoc
abstract mixin class $NpcStateCopyWith<$Res>  {
  factory $NpcStateCopyWith(NpcState value, $Res Function(NpcState) _then) = _$NpcStateCopyWithImpl;
@useResult
$Res call({
 String id, int grade, InstrumentType? instrument, int skill, int motivation, int stress, int lowMotivationWeeks, bool active, bool quit, InstrumentType? wish
});




}
/// @nodoc
class _$NpcStateCopyWithImpl<$Res>
    implements $NpcStateCopyWith<$Res> {
  _$NpcStateCopyWithImpl(this._self, this._then);

  final NpcState _self;
  final $Res Function(NpcState) _then;

/// Create a copy of NpcState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? grade = null,Object? instrument = freezed,Object? skill = null,Object? motivation = null,Object? stress = null,Object? lowMotivationWeeks = null,Object? active = null,Object? quit = null,Object? wish = freezed,}) {
  return _then(NpcState(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,grade: null == grade ? _self.grade : grade // ignore: cast_nullable_to_non_nullable
as int,instrument: freezed == instrument ? _self.instrument : instrument // ignore: cast_nullable_to_non_nullable
as InstrumentType?,skill: null == skill ? _self.skill : skill // ignore: cast_nullable_to_non_nullable
as int,motivation: null == motivation ? _self.motivation : motivation // ignore: cast_nullable_to_non_nullable
as int,stress: null == stress ? _self.stress : stress // ignore: cast_nullable_to_non_nullable
as int,lowMotivationWeeks: null == lowMotivationWeeks ? _self.lowMotivationWeeks : lowMotivationWeeks // ignore: cast_nullable_to_non_nullable
as int,active: null == active ? _self.active : active // ignore: cast_nullable_to_non_nullable
as bool,quit: null == quit ? _self.quit : quit // ignore: cast_nullable_to_non_nullable
as bool,wish: freezed == wish ? _self.wish : wish // ignore: cast_nullable_to_non_nullable
as InstrumentType?,
  ));
}

}


/// Adds pattern-matching-related methods to [NpcState].
extension NpcStatePatterns on NpcState {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NpcState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NpcState() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NpcState value)  $default,){
final _that = this;
switch (_that) {
case _NpcState():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NpcState value)?  $default,){
final _that = this;
switch (_that) {
case _NpcState() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  int grade,  InstrumentType? instrument,  int skill,  int motivation,  int stress,  int lowMotivationWeeks,  bool active,  bool quit,  InstrumentType? wish)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NpcState() when $default != null:
return $default(_that.id,_that.grade,_that.instrument,_that.skill,_that.motivation,_that.stress,_that.lowMotivationWeeks,_that.active,_that.quit,_that.wish);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  int grade,  InstrumentType? instrument,  int skill,  int motivation,  int stress,  int lowMotivationWeeks,  bool active,  bool quit,  InstrumentType? wish)  $default,) {final _that = this;
switch (_that) {
case _NpcState():
return $default(_that.id,_that.grade,_that.instrument,_that.skill,_that.motivation,_that.stress,_that.lowMotivationWeeks,_that.active,_that.quit,_that.wish);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  int grade,  InstrumentType? instrument,  int skill,  int motivation,  int stress,  int lowMotivationWeeks,  bool active,  bool quit,  InstrumentType? wish)?  $default,) {final _that = this;
switch (_that) {
case _NpcState() when $default != null:
return $default(_that.id,_that.grade,_that.instrument,_that.skill,_that.motivation,_that.stress,_that.lowMotivationWeeks,_that.active,_that.quit,_that.wish);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NpcState implements NpcState {
  const _NpcState({required this.id, required this.grade, this.instrument, this.skill = 0, this.motivation = 60, this.stress = 20, this.lowMotivationWeeks = 0, this.active = true, this.quit = false, this.wish});
  factory _NpcState.fromJson(Map<String, dynamic> json) => _$NpcStateFromJson(json);

@override final  String id;
@override final  int grade;
@override final  InstrumentType? instrument;
@override@JsonKey() final  int skill;
@override@JsonKey() final  int motivation;
@override@JsonKey() final  int stress;
/// 低いやる気が続いた週数（退部判定）。
@override@JsonKey() final  int lowMotivationWeeks;
/// 部に在籍しているか（卒業・退部で false）。
@override@JsonKey() final  bool active;
/// 退部した。
@override@JsonKey() final  bool quit;
/// 新入生の希望楽器。
@override final  InstrumentType? wish;

/// Create a copy of NpcState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NpcStateCopyWith<_NpcState> get copyWith => __$NpcStateCopyWithImpl<_NpcState>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NpcStateToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _NpcState&&(identical(other.id, id) || other.id == id)&&(identical(other.grade, grade) || other.grade == grade)&&(identical(other.instrument, instrument) || other.instrument == instrument)&&(identical(other.skill, skill) || other.skill == skill)&&(identical(other.motivation, motivation) || other.motivation == motivation)&&(identical(other.stress, stress) || other.stress == stress)&&(identical(other.lowMotivationWeeks, lowMotivationWeeks) || other.lowMotivationWeeks == lowMotivationWeeks)&&(identical(other.active, active) || other.active == active)&&(identical(other.quit, quit) || other.quit == quit)&&(identical(other.wish, wish) || other.wish == wish));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,grade,instrument,skill,motivation,stress,lowMotivationWeeks,active,quit,wish);
}

@override
String toString() {
    return 'NpcState(id: $id, grade: $grade, instrument: $instrument, skill: $skill, motivation: $motivation, stress: $stress, lowMotivationWeeks: $lowMotivationWeeks, active: $active, quit: $quit, wish: $wish)';
}


}

/// @nodoc
abstract mixin class _$NpcStateCopyWith<$Res> implements $NpcStateCopyWith<$Res> {
  factory _$NpcStateCopyWith(_NpcState value, $Res Function(_NpcState) _then) = __$NpcStateCopyWithImpl;
@override @useResult
$Res call({
 String id, int grade, InstrumentType? instrument, int skill, int motivation, int stress, int lowMotivationWeeks, bool active, bool quit, InstrumentType? wish
});




}
/// @nodoc
class __$NpcStateCopyWithImpl<$Res>
    implements _$NpcStateCopyWith<$Res> {
  __$NpcStateCopyWithImpl(this._self, this._then);

  final _NpcState _self;
  final $Res Function(_NpcState) _then;

/// Create a copy of NpcState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? grade = null,Object? instrument = freezed,Object? skill = null,Object? motivation = null,Object? stress = null,Object? lowMotivationWeeks = null,Object? active = null,Object? quit = null,Object? wish = freezed,}) {
  return _then(_NpcState(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,grade: null == grade ? _self.grade : grade // ignore: cast_nullable_to_non_nullable
as int,instrument: freezed == instrument ? _self.instrument : instrument // ignore: cast_nullable_to_non_nullable
as InstrumentType?,skill: null == skill ? _self.skill : skill // ignore: cast_nullable_to_non_nullable
as int,motivation: null == motivation ? _self.motivation : motivation // ignore: cast_nullable_to_non_nullable
as int,stress: null == stress ? _self.stress : stress // ignore: cast_nullable_to_non_nullable
as int,lowMotivationWeeks: null == lowMotivationWeeks ? _self.lowMotivationWeeks : lowMotivationWeeks // ignore: cast_nullable_to_non_nullable
as int,active: null == active ? _self.active : active // ignore: cast_nullable_to_non_nullable
as bool,quit: null == quit ? _self.quit : quit // ignore: cast_nullable_to_non_nullable
as bool,wish: freezed == wish ? _self.wish : wish // ignore: cast_nullable_to_non_nullable
as InstrumentType?,
  ));
}


}


/// @nodoc
mixin _$ExamRecord {

 int get turn; int get academicYearIndex; String get name; int get score;
/// Create a copy of ExamRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExamRecordCopyWith<ExamRecord> get copyWith => _$ExamRecordCopyWithImpl<ExamRecord>(this as ExamRecord, _$identity);

  /// Serializes this ExamRecord to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ExamRecord;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExamRecord&&(identical(other.turn, _this.turn) || other.turn == _this.turn)&&(identical(other.academicYearIndex, _this.academicYearIndex) || other.academicYearIndex == _this.academicYearIndex)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.score, _this.score) || other.score == _this.score));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ExamRecord;
  return Object.hash(runtimeType,_this.turn,_this.academicYearIndex,_this.name,_this.score);
}

@override
String toString() {
  final _this = this as ExamRecord;
  return 'ExamRecord(turn: ${_this.turn}, academicYearIndex: ${_this.academicYearIndex}, name: ${_this.name}, score: ${_this.score})';
}


}

/// @nodoc
abstract mixin class $ExamRecordCopyWith<$Res>  {
  factory $ExamRecordCopyWith(ExamRecord value, $Res Function(ExamRecord) _then) = _$ExamRecordCopyWithImpl;
@useResult
$Res call({
 int turn, int academicYearIndex, String name, int score
});




}
/// @nodoc
class _$ExamRecordCopyWithImpl<$Res>
    implements $ExamRecordCopyWith<$Res> {
  _$ExamRecordCopyWithImpl(this._self, this._then);

  final ExamRecord _self;
  final $Res Function(ExamRecord) _then;

/// Create a copy of ExamRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? turn = null,Object? academicYearIndex = null,Object? name = null,Object? score = null,}) {
  return _then(ExamRecord(
turn: null == turn ? _self.turn : turn // ignore: cast_nullable_to_non_nullable
as int,academicYearIndex: null == academicYearIndex ? _self.academicYearIndex : academicYearIndex // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ExamRecord].
extension ExamRecordPatterns on ExamRecord {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExamRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExamRecord() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExamRecord value)  $default,){
final _that = this;
switch (_that) {
case _ExamRecord():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExamRecord value)?  $default,){
final _that = this;
switch (_that) {
case _ExamRecord() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int turn,  int academicYearIndex,  String name,  int score)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExamRecord() when $default != null:
return $default(_that.turn,_that.academicYearIndex,_that.name,_that.score);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int turn,  int academicYearIndex,  String name,  int score)  $default,) {final _that = this;
switch (_that) {
case _ExamRecord():
return $default(_that.turn,_that.academicYearIndex,_that.name,_that.score);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int turn,  int academicYearIndex,  String name,  int score)?  $default,) {final _that = this;
switch (_that) {
case _ExamRecord() when $default != null:
return $default(_that.turn,_that.academicYearIndex,_that.name,_that.score);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ExamRecord implements ExamRecord {
  const _ExamRecord({required this.turn, required this.academicYearIndex, required this.name, required this.score});
  factory _ExamRecord.fromJson(Map<String, dynamic> json) => _$ExamRecordFromJson(json);

@override final  int turn;
@override final  int academicYearIndex;
@override final  String name;
@override final  int score;

/// Create a copy of ExamRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExamRecordCopyWith<_ExamRecord> get copyWith => __$ExamRecordCopyWithImpl<_ExamRecord>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ExamRecordToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExamRecord&&(identical(other.turn, turn) || other.turn == turn)&&(identical(other.academicYearIndex, academicYearIndex) || other.academicYearIndex == academicYearIndex)&&(identical(other.name, name) || other.name == name)&&(identical(other.score, score) || other.score == score));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,turn,academicYearIndex,name,score);
}

@override
String toString() {
    return 'ExamRecord(turn: $turn, academicYearIndex: $academicYearIndex, name: $name, score: $score)';
}


}

/// @nodoc
abstract mixin class _$ExamRecordCopyWith<$Res> implements $ExamRecordCopyWith<$Res> {
  factory _$ExamRecordCopyWith(_ExamRecord value, $Res Function(_ExamRecord) _then) = __$ExamRecordCopyWithImpl;
@override @useResult
$Res call({
 int turn, int academicYearIndex, String name, int score
});




}
/// @nodoc
class __$ExamRecordCopyWithImpl<$Res>
    implements _$ExamRecordCopyWith<$Res> {
  __$ExamRecordCopyWithImpl(this._self, this._then);

  final _ExamRecord _self;
  final $Res Function(_ExamRecord) _then;

/// Create a copy of ExamRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? turn = null,Object? academicYearIndex = null,Object? name = null,Object? score = null,}) {
  return _then(_ExamRecord(
turn: null == turn ? _self.turn : turn // ignore: cast_nullable_to_non_nullable
as int,academicYearIndex: null == academicYearIndex ? _self.academicYearIndex : academicYearIndex // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,score: null == score ? _self.score : score // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$TermGrade {

 int get academicYearIndex; int get term;/// 評定（1..5）。
 int get grade;
/// Create a copy of TermGrade
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TermGradeCopyWith<TermGrade> get copyWith => _$TermGradeCopyWithImpl<TermGrade>(this as TermGrade, _$identity);

  /// Serializes this TermGrade to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as TermGrade;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TermGrade&&(identical(other.academicYearIndex, _this.academicYearIndex) || other.academicYearIndex == _this.academicYearIndex)&&(identical(other.term, _this.term) || other.term == _this.term)&&(identical(other.grade, _this.grade) || other.grade == _this.grade));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as TermGrade;
  return Object.hash(runtimeType,_this.academicYearIndex,_this.term,_this.grade);
}

@override
String toString() {
  final _this = this as TermGrade;
  return 'TermGrade(academicYearIndex: ${_this.academicYearIndex}, term: ${_this.term}, grade: ${_this.grade})';
}


}

/// @nodoc
abstract mixin class $TermGradeCopyWith<$Res>  {
  factory $TermGradeCopyWith(TermGrade value, $Res Function(TermGrade) _then) = _$TermGradeCopyWithImpl;
@useResult
$Res call({
 int academicYearIndex, int term, int grade
});




}
/// @nodoc
class _$TermGradeCopyWithImpl<$Res>
    implements $TermGradeCopyWith<$Res> {
  _$TermGradeCopyWithImpl(this._self, this._then);

  final TermGrade _self;
  final $Res Function(TermGrade) _then;

/// Create a copy of TermGrade
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? academicYearIndex = null,Object? term = null,Object? grade = null,}) {
  return _then(TermGrade(
academicYearIndex: null == academicYearIndex ? _self.academicYearIndex : academicYearIndex // ignore: cast_nullable_to_non_nullable
as int,term: null == term ? _self.term : term // ignore: cast_nullable_to_non_nullable
as int,grade: null == grade ? _self.grade : grade // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [TermGrade].
extension TermGradePatterns on TermGrade {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TermGrade value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TermGrade() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TermGrade value)  $default,){
final _that = this;
switch (_that) {
case _TermGrade():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TermGrade value)?  $default,){
final _that = this;
switch (_that) {
case _TermGrade() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int academicYearIndex,  int term,  int grade)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TermGrade() when $default != null:
return $default(_that.academicYearIndex,_that.term,_that.grade);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int academicYearIndex,  int term,  int grade)  $default,) {final _that = this;
switch (_that) {
case _TermGrade():
return $default(_that.academicYearIndex,_that.term,_that.grade);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int academicYearIndex,  int term,  int grade)?  $default,) {final _that = this;
switch (_that) {
case _TermGrade() when $default != null:
return $default(_that.academicYearIndex,_that.term,_that.grade);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TermGrade implements TermGrade {
  const _TermGrade({required this.academicYearIndex, required this.term, required this.grade});
  factory _TermGrade.fromJson(Map<String, dynamic> json) => _$TermGradeFromJson(json);

@override final  int academicYearIndex;
@override final  int term;
/// 評定（1..5）。
@override final  int grade;

/// Create a copy of TermGrade
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TermGradeCopyWith<_TermGrade> get copyWith => __$TermGradeCopyWithImpl<_TermGrade>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TermGradeToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TermGrade&&(identical(other.academicYearIndex, academicYearIndex) || other.academicYearIndex == academicYearIndex)&&(identical(other.term, term) || other.term == term)&&(identical(other.grade, grade) || other.grade == grade));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,academicYearIndex,term,grade);
}

@override
String toString() {
    return 'TermGrade(academicYearIndex: $academicYearIndex, term: $term, grade: $grade)';
}


}

/// @nodoc
abstract mixin class _$TermGradeCopyWith<$Res> implements $TermGradeCopyWith<$Res> {
  factory _$TermGradeCopyWith(_TermGrade value, $Res Function(_TermGrade) _then) = __$TermGradeCopyWithImpl;
@override @useResult
$Res call({
 int academicYearIndex, int term, int grade
});




}
/// @nodoc
class __$TermGradeCopyWithImpl<$Res>
    implements _$TermGradeCopyWith<$Res> {
  __$TermGradeCopyWithImpl(this._self, this._then);

  final _TermGrade _self;
  final $Res Function(_TermGrade) _then;

/// Create a copy of TermGrade
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? academicYearIndex = null,Object? term = null,Object? grade = null,}) {
  return _then(_TermGrade(
academicYearIndex: null == academicYearIndex ? _self.academicYearIndex : academicYearIndex // ignore: cast_nullable_to_non_nullable
as int,term: null == term ? _self.term : term // ignore: cast_nullable_to_non_nullable
as int,grade: null == grade ? _self.grade : grade // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$PendingEvent {

 PendingEventType get type; int get turn; Map<String, String> get data;
/// Create a copy of PendingEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PendingEventCopyWith<PendingEvent> get copyWith => _$PendingEventCopyWithImpl<PendingEvent>(this as PendingEvent, _$identity);

  /// Serializes this PendingEvent to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PendingEvent;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PendingEvent&&(identical(other.type, _this.type) || other.type == _this.type)&&(identical(other.turn, _this.turn) || other.turn == _this.turn)&&const DeepCollectionEquality().equals(other.data, _this.data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PendingEvent;
  return Object.hash(runtimeType,_this.type,_this.turn,const DeepCollectionEquality().hash(_this.data));
}

@override
String toString() {
  final _this = this as PendingEvent;
  return 'PendingEvent(type: ${_this.type}, turn: ${_this.turn}, data: ${_this.data})';
}


}

/// @nodoc
abstract mixin class $PendingEventCopyWith<$Res>  {
  factory $PendingEventCopyWith(PendingEvent value, $Res Function(PendingEvent) _then) = _$PendingEventCopyWithImpl;
@useResult
$Res call({
 PendingEventType type, int turn, Map<String, String> data
});




}
/// @nodoc
class _$PendingEventCopyWithImpl<$Res>
    implements $PendingEventCopyWith<$Res> {
  _$PendingEventCopyWithImpl(this._self, this._then);

  final PendingEvent _self;
  final $Res Function(PendingEvent) _then;

/// Create a copy of PendingEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = null,Object? turn = null,Object? data = null,}) {
  return _then(PendingEvent(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as PendingEventType,turn: null == turn ? _self.turn : turn // ignore: cast_nullable_to_non_nullable
as int,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as Map<String, String>,
  ));
}

}


/// Adds pattern-matching-related methods to [PendingEvent].
extension PendingEventPatterns on PendingEvent {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PendingEvent value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PendingEvent() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PendingEvent value)  $default,){
final _that = this;
switch (_that) {
case _PendingEvent():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PendingEvent value)?  $default,){
final _that = this;
switch (_that) {
case _PendingEvent() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( PendingEventType type,  int turn,  Map<String, String> data)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PendingEvent() when $default != null:
return $default(_that.type,_that.turn,_that.data);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( PendingEventType type,  int turn,  Map<String, String> data)  $default,) {final _that = this;
switch (_that) {
case _PendingEvent():
return $default(_that.type,_that.turn,_that.data);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( PendingEventType type,  int turn,  Map<String, String> data)?  $default,) {final _that = this;
switch (_that) {
case _PendingEvent() when $default != null:
return $default(_that.type,_that.turn,_that.data);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PendingEvent implements PendingEvent {
  const _PendingEvent({required this.type, required this.turn,  Map<String, String> data = const <String, String>{}}): _data = data;
  factory _PendingEvent.fromJson(Map<String, dynamic> json) => _$PendingEventFromJson(json);

@override final  PendingEventType type;
@override final  int turn;
 final  Map<String, String> _data;
@override@JsonKey() Map<String, String> get data {
  if (_data is EqualUnmodifiableMapView) return _data;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_data);
}


/// Create a copy of PendingEvent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PendingEventCopyWith<_PendingEvent> get copyWith => __$PendingEventCopyWithImpl<_PendingEvent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PendingEventToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PendingEvent&&(identical(other.type, type) || other.type == type)&&(identical(other.turn, turn) || other.turn == turn)&&const DeepCollectionEquality().equals(other.data, _data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,type,turn,const DeepCollectionEquality().hash(_data));
}

@override
String toString() {
    return 'PendingEvent(type: $type, turn: $turn, data: $data)';
}


}

/// @nodoc
abstract mixin class _$PendingEventCopyWith<$Res> implements $PendingEventCopyWith<$Res> {
  factory _$PendingEventCopyWith(_PendingEvent value, $Res Function(_PendingEvent) _then) = __$PendingEventCopyWithImpl;
@override @useResult
$Res call({
 PendingEventType type, int turn, Map<String, String> data
});




}
/// @nodoc
class __$PendingEventCopyWithImpl<$Res>
    implements _$PendingEventCopyWith<$Res> {
  __$PendingEventCopyWithImpl(this._self, this._then);

  final _PendingEvent _self;
  final $Res Function(_PendingEvent) _then;

/// Create a copy of PendingEvent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = null,Object? turn = null,Object? data = null,}) {
  return _then(_PendingEvent(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as PendingEventType,turn: null == turn ? _self.turn : turn // ignore: cast_nullable_to_non_nullable
as int,data: null == data ? _self._data : data // ignore: cast_nullable_to_non_nullable
as Map<String, String>,
  ));
}


}


/// @nodoc
mixin _$WeekLog {

 int get turn; String get dateLabel; String? get actionLabel; List<String> get lines;
/// Create a copy of WeekLog
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WeekLogCopyWith<WeekLog> get copyWith => _$WeekLogCopyWithImpl<WeekLog>(this as WeekLog, _$identity);

  /// Serializes this WeekLog to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as WeekLog;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WeekLog&&(identical(other.turn, _this.turn) || other.turn == _this.turn)&&(identical(other.dateLabel, _this.dateLabel) || other.dateLabel == _this.dateLabel)&&(identical(other.actionLabel, _this.actionLabel) || other.actionLabel == _this.actionLabel)&&const DeepCollectionEquality().equals(other.lines, _this.lines));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as WeekLog;
  return Object.hash(runtimeType,_this.turn,_this.dateLabel,_this.actionLabel,const DeepCollectionEquality().hash(_this.lines));
}

@override
String toString() {
  final _this = this as WeekLog;
  return 'WeekLog(turn: ${_this.turn}, dateLabel: ${_this.dateLabel}, actionLabel: ${_this.actionLabel}, lines: ${_this.lines})';
}


}

/// @nodoc
abstract mixin class $WeekLogCopyWith<$Res>  {
  factory $WeekLogCopyWith(WeekLog value, $Res Function(WeekLog) _then) = _$WeekLogCopyWithImpl;
@useResult
$Res call({
 int turn, String dateLabel, String? actionLabel, List<String> lines
});




}
/// @nodoc
class _$WeekLogCopyWithImpl<$Res>
    implements $WeekLogCopyWith<$Res> {
  _$WeekLogCopyWithImpl(this._self, this._then);

  final WeekLog _self;
  final $Res Function(WeekLog) _then;

/// Create a copy of WeekLog
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? turn = null,Object? dateLabel = null,Object? actionLabel = freezed,Object? lines = null,}) {
  return _then(WeekLog(
turn: null == turn ? _self.turn : turn // ignore: cast_nullable_to_non_nullable
as int,dateLabel: null == dateLabel ? _self.dateLabel : dateLabel // ignore: cast_nullable_to_non_nullable
as String,actionLabel: freezed == actionLabel ? _self.actionLabel : actionLabel // ignore: cast_nullable_to_non_nullable
as String?,lines: null == lines ? _self.lines : lines // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [WeekLog].
extension WeekLogPatterns on WeekLog {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WeekLog value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WeekLog() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WeekLog value)  $default,){
final _that = this;
switch (_that) {
case _WeekLog():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WeekLog value)?  $default,){
final _that = this;
switch (_that) {
case _WeekLog() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int turn,  String dateLabel,  String? actionLabel,  List<String> lines)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WeekLog() when $default != null:
return $default(_that.turn,_that.dateLabel,_that.actionLabel,_that.lines);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int turn,  String dateLabel,  String? actionLabel,  List<String> lines)  $default,) {final _that = this;
switch (_that) {
case _WeekLog():
return $default(_that.turn,_that.dateLabel,_that.actionLabel,_that.lines);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int turn,  String dateLabel,  String? actionLabel,  List<String> lines)?  $default,) {final _that = this;
switch (_that) {
case _WeekLog() when $default != null:
return $default(_that.turn,_that.dateLabel,_that.actionLabel,_that.lines);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WeekLog implements WeekLog {
  const _WeekLog({required this.turn, required this.dateLabel, this.actionLabel, required  List<String> lines}): _lines = lines;
  factory _WeekLog.fromJson(Map<String, dynamic> json) => _$WeekLogFromJson(json);

@override final  int turn;
@override final  String dateLabel;
@override final  String? actionLabel;
 final  List<String> _lines;
@override List<String> get lines {
  if (_lines is EqualUnmodifiableListView) return _lines;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_lines);
}


/// Create a copy of WeekLog
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WeekLogCopyWith<_WeekLog> get copyWith => __$WeekLogCopyWithImpl<_WeekLog>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WeekLogToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _WeekLog&&(identical(other.turn, turn) || other.turn == turn)&&(identical(other.dateLabel, dateLabel) || other.dateLabel == dateLabel)&&(identical(other.actionLabel, actionLabel) || other.actionLabel == actionLabel)&&const DeepCollectionEquality().equals(other.lines, _lines));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,turn,dateLabel,actionLabel,const DeepCollectionEquality().hash(_lines));
}

@override
String toString() {
    return 'WeekLog(turn: $turn, dateLabel: $dateLabel, actionLabel: $actionLabel, lines: $lines)';
}


}

/// @nodoc
abstract mixin class _$WeekLogCopyWith<$Res> implements $WeekLogCopyWith<$Res> {
  factory _$WeekLogCopyWith(_WeekLog value, $Res Function(_WeekLog) _then) = __$WeekLogCopyWithImpl;
@override @useResult
$Res call({
 int turn, String dateLabel, String? actionLabel, List<String> lines
});




}
/// @nodoc
class __$WeekLogCopyWithImpl<$Res>
    implements _$WeekLogCopyWith<$Res> {
  __$WeekLogCopyWithImpl(this._self, this._then);

  final _WeekLog _self;
  final $Res Function(_WeekLog) _then;

/// Create a copy of WeekLog
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? turn = null,Object? dateLabel = null,Object? actionLabel = freezed,Object? lines = null,}) {
  return _then(_WeekLog(
turn: null == turn ? _self.turn : turn // ignore: cast_nullable_to_non_nullable
as int,dateLabel: null == dateLabel ? _self.dateLabel : dateLabel // ignore: cast_nullable_to_non_nullable
as String,actionLabel: freezed == actionLabel ? _self.actionLabel : actionLabel // ignore: cast_nullable_to_non_nullable
as String?,lines: null == lines ? _self._lines : lines // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
