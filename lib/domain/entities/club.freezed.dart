// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'club.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Club {

 String get id; String get schoolId; ClubTier get tier;/// 伝統値（0..100）。
 int get tradition;/// 練習強度（1..5）。
 int get practiceIntensity; ClubMood get mood; ExecutiveSystem get executiveSystem; SelectionCulture get selectionCulture; BudgetBand get budget; BandDivision get division; String get advisorId; String? get coachId;/// 保有楽器（学校所有分）。
 List<InstrumentSlot> get inventory;/// 過去 5 年のコンクール成績（古い順）。
 List<ContestRecord> get history;/// 部員 NPC の ID（学年降順・ID 昇順）。
 List<String> get memberIds;
/// Create a copy of Club
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ClubCopyWith<Club> get copyWith => _$ClubCopyWithImpl<Club>(this as Club, _$identity);

  /// Serializes this Club to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Club;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Club&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.schoolId, _this.schoolId) || other.schoolId == _this.schoolId)&&(identical(other.tier, _this.tier) || other.tier == _this.tier)&&(identical(other.tradition, _this.tradition) || other.tradition == _this.tradition)&&(identical(other.practiceIntensity, _this.practiceIntensity) || other.practiceIntensity == _this.practiceIntensity)&&(identical(other.mood, _this.mood) || other.mood == _this.mood)&&(identical(other.executiveSystem, _this.executiveSystem) || other.executiveSystem == _this.executiveSystem)&&(identical(other.selectionCulture, _this.selectionCulture) || other.selectionCulture == _this.selectionCulture)&&(identical(other.budget, _this.budget) || other.budget == _this.budget)&&(identical(other.division, _this.division) || other.division == _this.division)&&(identical(other.advisorId, _this.advisorId) || other.advisorId == _this.advisorId)&&(identical(other.coachId, _this.coachId) || other.coachId == _this.coachId)&&const DeepCollectionEquality().equals(other.inventory, _this.inventory)&&const DeepCollectionEquality().equals(other.history, _this.history)&&const DeepCollectionEquality().equals(other.memberIds, _this.memberIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Club;
  return Object.hash(runtimeType,_this.id,_this.schoolId,_this.tier,_this.tradition,_this.practiceIntensity,_this.mood,_this.executiveSystem,_this.selectionCulture,_this.budget,_this.division,_this.advisorId,_this.coachId,const DeepCollectionEquality().hash(_this.inventory),const DeepCollectionEquality().hash(_this.history),const DeepCollectionEquality().hash(_this.memberIds));
}

@override
String toString() {
  final _this = this as Club;
  return 'Club(id: ${_this.id}, schoolId: ${_this.schoolId}, tier: ${_this.tier}, tradition: ${_this.tradition}, practiceIntensity: ${_this.practiceIntensity}, mood: ${_this.mood}, executiveSystem: ${_this.executiveSystem}, selectionCulture: ${_this.selectionCulture}, budget: ${_this.budget}, division: ${_this.division}, advisorId: ${_this.advisorId}, coachId: ${_this.coachId}, inventory: ${_this.inventory}, history: ${_this.history}, memberIds: ${_this.memberIds})';
}


}

/// @nodoc
abstract mixin class $ClubCopyWith<$Res>  {
  factory $ClubCopyWith(Club value, $Res Function(Club) _then) = _$ClubCopyWithImpl;
@useResult
$Res call({
 String id, String schoolId, ClubTier tier, int tradition, int practiceIntensity, ClubMood mood, ExecutiveSystem executiveSystem, SelectionCulture selectionCulture, BudgetBand budget, BandDivision division, String advisorId, String? coachId, List<InstrumentSlot> inventory, List<ContestRecord> history, List<String> memberIds
});




}
/// @nodoc
class _$ClubCopyWithImpl<$Res>
    implements $ClubCopyWith<$Res> {
  _$ClubCopyWithImpl(this._self, this._then);

  final Club _self;
  final $Res Function(Club) _then;

/// Create a copy of Club
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? schoolId = null,Object? tier = null,Object? tradition = null,Object? practiceIntensity = null,Object? mood = null,Object? executiveSystem = null,Object? selectionCulture = null,Object? budget = null,Object? division = null,Object? advisorId = null,Object? coachId = freezed,Object? inventory = null,Object? history = null,Object? memberIds = null,}) {
  return _then(Club(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,schoolId: null == schoolId ? _self.schoolId : schoolId // ignore: cast_nullable_to_non_nullable
as String,tier: null == tier ? _self.tier : tier // ignore: cast_nullable_to_non_nullable
as ClubTier,tradition: null == tradition ? _self.tradition : tradition // ignore: cast_nullable_to_non_nullable
as int,practiceIntensity: null == practiceIntensity ? _self.practiceIntensity : practiceIntensity // ignore: cast_nullable_to_non_nullable
as int,mood: null == mood ? _self.mood : mood // ignore: cast_nullable_to_non_nullable
as ClubMood,executiveSystem: null == executiveSystem ? _self.executiveSystem : executiveSystem // ignore: cast_nullable_to_non_nullable
as ExecutiveSystem,selectionCulture: null == selectionCulture ? _self.selectionCulture : selectionCulture // ignore: cast_nullable_to_non_nullable
as SelectionCulture,budget: null == budget ? _self.budget : budget // ignore: cast_nullable_to_non_nullable
as BudgetBand,division: null == division ? _self.division : division // ignore: cast_nullable_to_non_nullable
as BandDivision,advisorId: null == advisorId ? _self.advisorId : advisorId // ignore: cast_nullable_to_non_nullable
as String,coachId: freezed == coachId ? _self.coachId : coachId // ignore: cast_nullable_to_non_nullable
as String?,inventory: null == inventory ? _self.inventory : inventory // ignore: cast_nullable_to_non_nullable
as List<InstrumentSlot>,history: null == history ? _self.history : history // ignore: cast_nullable_to_non_nullable
as List<ContestRecord>,memberIds: null == memberIds ? _self.memberIds : memberIds // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [Club].
extension ClubPatterns on Club {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Club value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Club() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Club value)  $default,){
final _that = this;
switch (_that) {
case _Club():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Club value)?  $default,){
final _that = this;
switch (_that) {
case _Club() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String schoolId,  ClubTier tier,  int tradition,  int practiceIntensity,  ClubMood mood,  ExecutiveSystem executiveSystem,  SelectionCulture selectionCulture,  BudgetBand budget,  BandDivision division,  String advisorId,  String? coachId,  List<InstrumentSlot> inventory,  List<ContestRecord> history,  List<String> memberIds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Club() when $default != null:
return $default(_that.id,_that.schoolId,_that.tier,_that.tradition,_that.practiceIntensity,_that.mood,_that.executiveSystem,_that.selectionCulture,_that.budget,_that.division,_that.advisorId,_that.coachId,_that.inventory,_that.history,_that.memberIds);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String schoolId,  ClubTier tier,  int tradition,  int practiceIntensity,  ClubMood mood,  ExecutiveSystem executiveSystem,  SelectionCulture selectionCulture,  BudgetBand budget,  BandDivision division,  String advisorId,  String? coachId,  List<InstrumentSlot> inventory,  List<ContestRecord> history,  List<String> memberIds)  $default,) {final _that = this;
switch (_that) {
case _Club():
return $default(_that.id,_that.schoolId,_that.tier,_that.tradition,_that.practiceIntensity,_that.mood,_that.executiveSystem,_that.selectionCulture,_that.budget,_that.division,_that.advisorId,_that.coachId,_that.inventory,_that.history,_that.memberIds);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String schoolId,  ClubTier tier,  int tradition,  int practiceIntensity,  ClubMood mood,  ExecutiveSystem executiveSystem,  SelectionCulture selectionCulture,  BudgetBand budget,  BandDivision division,  String advisorId,  String? coachId,  List<InstrumentSlot> inventory,  List<ContestRecord> history,  List<String> memberIds)?  $default,) {final _that = this;
switch (_that) {
case _Club() when $default != null:
return $default(_that.id,_that.schoolId,_that.tier,_that.tradition,_that.practiceIntensity,_that.mood,_that.executiveSystem,_that.selectionCulture,_that.budget,_that.division,_that.advisorId,_that.coachId,_that.inventory,_that.history,_that.memberIds);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Club extends Club {
  const _Club({required this.id, required this.schoolId, required this.tier, required this.tradition, required this.practiceIntensity, required this.mood, required this.executiveSystem, required this.selectionCulture, required this.budget, required this.division, required this.advisorId, this.coachId, required  List<InstrumentSlot> inventory, required  List<ContestRecord> history, required  List<String> memberIds}): _inventory = inventory,_history = history,_memberIds = memberIds,super._();
  factory _Club.fromJson(Map<String, dynamic> json) => _$ClubFromJson(json);

@override final  String id;
@override final  String schoolId;
@override final  ClubTier tier;
/// 伝統値（0..100）。
@override final  int tradition;
/// 練習強度（1..5）。
@override final  int practiceIntensity;
@override final  ClubMood mood;
@override final  ExecutiveSystem executiveSystem;
@override final  SelectionCulture selectionCulture;
@override final  BudgetBand budget;
@override final  BandDivision division;
@override final  String advisorId;
@override final  String? coachId;
/// 保有楽器（学校所有分）。
 final  List<InstrumentSlot> _inventory;
/// 保有楽器（学校所有分）。
@override List<InstrumentSlot> get inventory {
  if (_inventory is EqualUnmodifiableListView) return _inventory;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_inventory);
}

/// 過去 5 年のコンクール成績（古い順）。
 final  List<ContestRecord> _history;
/// 過去 5 年のコンクール成績（古い順）。
@override List<ContestRecord> get history {
  if (_history is EqualUnmodifiableListView) return _history;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_history);
}

/// 部員 NPC の ID（学年降順・ID 昇順）。
 final  List<String> _memberIds;
/// 部員 NPC の ID（学年降順・ID 昇順）。
@override List<String> get memberIds {
  if (_memberIds is EqualUnmodifiableListView) return _memberIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_memberIds);
}


/// Create a copy of Club
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ClubCopyWith<_Club> get copyWith => __$ClubCopyWithImpl<_Club>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ClubToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Club&&(identical(other.id, id) || other.id == id)&&(identical(other.schoolId, schoolId) || other.schoolId == schoolId)&&(identical(other.tier, tier) || other.tier == tier)&&(identical(other.tradition, tradition) || other.tradition == tradition)&&(identical(other.practiceIntensity, practiceIntensity) || other.practiceIntensity == practiceIntensity)&&(identical(other.mood, mood) || other.mood == mood)&&(identical(other.executiveSystem, executiveSystem) || other.executiveSystem == executiveSystem)&&(identical(other.selectionCulture, selectionCulture) || other.selectionCulture == selectionCulture)&&(identical(other.budget, budget) || other.budget == budget)&&(identical(other.division, division) || other.division == division)&&(identical(other.advisorId, advisorId) || other.advisorId == advisorId)&&(identical(other.coachId, coachId) || other.coachId == coachId)&&const DeepCollectionEquality().equals(other.inventory, _inventory)&&const DeepCollectionEquality().equals(other.history, _history)&&const DeepCollectionEquality().equals(other.memberIds, _memberIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,schoolId,tier,tradition,practiceIntensity,mood,executiveSystem,selectionCulture,budget,division,advisorId,coachId,const DeepCollectionEquality().hash(_inventory),const DeepCollectionEquality().hash(_history),const DeepCollectionEquality().hash(_memberIds));
}

@override
String toString() {
    return 'Club(id: $id, schoolId: $schoolId, tier: $tier, tradition: $tradition, practiceIntensity: $practiceIntensity, mood: $mood, executiveSystem: $executiveSystem, selectionCulture: $selectionCulture, budget: $budget, division: $division, advisorId: $advisorId, coachId: $coachId, inventory: $inventory, history: $history, memberIds: $memberIds)';
}


}

/// @nodoc
abstract mixin class _$ClubCopyWith<$Res> implements $ClubCopyWith<$Res> {
  factory _$ClubCopyWith(_Club value, $Res Function(_Club) _then) = __$ClubCopyWithImpl;
@override @useResult
$Res call({
 String id, String schoolId, ClubTier tier, int tradition, int practiceIntensity, ClubMood mood, ExecutiveSystem executiveSystem, SelectionCulture selectionCulture, BudgetBand budget, BandDivision division, String advisorId, String? coachId, List<InstrumentSlot> inventory, List<ContestRecord> history, List<String> memberIds
});




}
/// @nodoc
class __$ClubCopyWithImpl<$Res>
    implements _$ClubCopyWith<$Res> {
  __$ClubCopyWithImpl(this._self, this._then);

  final _Club _self;
  final $Res Function(_Club) _then;

/// Create a copy of Club
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? schoolId = null,Object? tier = null,Object? tradition = null,Object? practiceIntensity = null,Object? mood = null,Object? executiveSystem = null,Object? selectionCulture = null,Object? budget = null,Object? division = null,Object? advisorId = null,Object? coachId = freezed,Object? inventory = null,Object? history = null,Object? memberIds = null,}) {
  return _then(_Club(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,schoolId: null == schoolId ? _self.schoolId : schoolId // ignore: cast_nullable_to_non_nullable
as String,tier: null == tier ? _self.tier : tier // ignore: cast_nullable_to_non_nullable
as ClubTier,tradition: null == tradition ? _self.tradition : tradition // ignore: cast_nullable_to_non_nullable
as int,practiceIntensity: null == practiceIntensity ? _self.practiceIntensity : practiceIntensity // ignore: cast_nullable_to_non_nullable
as int,mood: null == mood ? _self.mood : mood // ignore: cast_nullable_to_non_nullable
as ClubMood,executiveSystem: null == executiveSystem ? _self.executiveSystem : executiveSystem // ignore: cast_nullable_to_non_nullable
as ExecutiveSystem,selectionCulture: null == selectionCulture ? _self.selectionCulture : selectionCulture // ignore: cast_nullable_to_non_nullable
as SelectionCulture,budget: null == budget ? _self.budget : budget // ignore: cast_nullable_to_non_nullable
as BudgetBand,division: null == division ? _self.division : division // ignore: cast_nullable_to_non_nullable
as BandDivision,advisorId: null == advisorId ? _self.advisorId : advisorId // ignore: cast_nullable_to_non_nullable
as String,coachId: freezed == coachId ? _self.coachId : coachId // ignore: cast_nullable_to_non_nullable
as String?,inventory: null == inventory ? _self._inventory : inventory // ignore: cast_nullable_to_non_nullable
as List<InstrumentSlot>,history: null == history ? _self._history : history // ignore: cast_nullable_to_non_nullable
as List<ContestRecord>,memberIds: null == memberIds ? _self._memberIds : memberIds // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}


/// @nodoc
mixin _$InstrumentSlot {

 InstrumentType get type; int get count; InstrumentCondition get condition;
/// Create a copy of InstrumentSlot
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InstrumentSlotCopyWith<InstrumentSlot> get copyWith => _$InstrumentSlotCopyWithImpl<InstrumentSlot>(this as InstrumentSlot, _$identity);

  /// Serializes this InstrumentSlot to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as InstrumentSlot;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InstrumentSlot&&(identical(other.type, _this.type) || other.type == _this.type)&&(identical(other.count, _this.count) || other.count == _this.count)&&(identical(other.condition, _this.condition) || other.condition == _this.condition));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as InstrumentSlot;
  return Object.hash(runtimeType,_this.type,_this.count,_this.condition);
}

@override
String toString() {
  final _this = this as InstrumentSlot;
  return 'InstrumentSlot(type: ${_this.type}, count: ${_this.count}, condition: ${_this.condition})';
}


}

/// @nodoc
abstract mixin class $InstrumentSlotCopyWith<$Res>  {
  factory $InstrumentSlotCopyWith(InstrumentSlot value, $Res Function(InstrumentSlot) _then) = _$InstrumentSlotCopyWithImpl;
@useResult
$Res call({
 InstrumentType type, int count, InstrumentCondition condition
});




}
/// @nodoc
class _$InstrumentSlotCopyWithImpl<$Res>
    implements $InstrumentSlotCopyWith<$Res> {
  _$InstrumentSlotCopyWithImpl(this._self, this._then);

  final InstrumentSlot _self;
  final $Res Function(InstrumentSlot) _then;

/// Create a copy of InstrumentSlot
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = null,Object? count = null,Object? condition = null,}) {
  return _then(InstrumentSlot(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as InstrumentType,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,condition: null == condition ? _self.condition : condition // ignore: cast_nullable_to_non_nullable
as InstrumentCondition,
  ));
}

}


/// Adds pattern-matching-related methods to [InstrumentSlot].
extension InstrumentSlotPatterns on InstrumentSlot {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InstrumentSlot value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InstrumentSlot() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InstrumentSlot value)  $default,){
final _that = this;
switch (_that) {
case _InstrumentSlot():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InstrumentSlot value)?  $default,){
final _that = this;
switch (_that) {
case _InstrumentSlot() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( InstrumentType type,  int count,  InstrumentCondition condition)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InstrumentSlot() when $default != null:
return $default(_that.type,_that.count,_that.condition);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( InstrumentType type,  int count,  InstrumentCondition condition)  $default,) {final _that = this;
switch (_that) {
case _InstrumentSlot():
return $default(_that.type,_that.count,_that.condition);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( InstrumentType type,  int count,  InstrumentCondition condition)?  $default,) {final _that = this;
switch (_that) {
case _InstrumentSlot() when $default != null:
return $default(_that.type,_that.count,_that.condition);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _InstrumentSlot implements InstrumentSlot {
  const _InstrumentSlot({required this.type, required this.count, required this.condition});
  factory _InstrumentSlot.fromJson(Map<String, dynamic> json) => _$InstrumentSlotFromJson(json);

@override final  InstrumentType type;
@override final  int count;
@override final  InstrumentCondition condition;

/// Create a copy of InstrumentSlot
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InstrumentSlotCopyWith<_InstrumentSlot> get copyWith => __$InstrumentSlotCopyWithImpl<_InstrumentSlot>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$InstrumentSlotToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _InstrumentSlot&&(identical(other.type, type) || other.type == type)&&(identical(other.count, count) || other.count == count)&&(identical(other.condition, condition) || other.condition == condition));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,type,count,condition);
}

@override
String toString() {
    return 'InstrumentSlot(type: $type, count: $count, condition: $condition)';
}


}

/// @nodoc
abstract mixin class _$InstrumentSlotCopyWith<$Res> implements $InstrumentSlotCopyWith<$Res> {
  factory _$InstrumentSlotCopyWith(_InstrumentSlot value, $Res Function(_InstrumentSlot) _then) = __$InstrumentSlotCopyWithImpl;
@override @useResult
$Res call({
 InstrumentType type, int count, InstrumentCondition condition
});




}
/// @nodoc
class __$InstrumentSlotCopyWithImpl<$Res>
    implements _$InstrumentSlotCopyWith<$Res> {
  __$InstrumentSlotCopyWithImpl(this._self, this._then);

  final _InstrumentSlot _self;
  final $Res Function(_InstrumentSlot) _then;

/// Create a copy of InstrumentSlot
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = null,Object? count = null,Object? condition = null,}) {
  return _then(_InstrumentSlot(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as InstrumentType,count: null == count ? _self.count : count // ignore: cast_nullable_to_non_nullable
as int,condition: null == condition ? _self.condition : condition // ignore: cast_nullable_to_non_nullable
as InstrumentCondition,
  ));
}


}


/// @nodoc
mixin _$ContestRecord {

 int get fiscalYear; BandDivision get division;/// 最後に出場した大会（＝その年の最終到達段階）。
 ContestStage get stage;/// その大会での賞。
 ContestAward get award;
/// Create a copy of ContestRecord
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ContestRecordCopyWith<ContestRecord> get copyWith => _$ContestRecordCopyWithImpl<ContestRecord>(this as ContestRecord, _$identity);

  /// Serializes this ContestRecord to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ContestRecord;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ContestRecord&&(identical(other.fiscalYear, _this.fiscalYear) || other.fiscalYear == _this.fiscalYear)&&(identical(other.division, _this.division) || other.division == _this.division)&&(identical(other.stage, _this.stage) || other.stage == _this.stage)&&(identical(other.award, _this.award) || other.award == _this.award));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ContestRecord;
  return Object.hash(runtimeType,_this.fiscalYear,_this.division,_this.stage,_this.award);
}

@override
String toString() {
  final _this = this as ContestRecord;
  return 'ContestRecord(fiscalYear: ${_this.fiscalYear}, division: ${_this.division}, stage: ${_this.stage}, award: ${_this.award})';
}


}

/// @nodoc
abstract mixin class $ContestRecordCopyWith<$Res>  {
  factory $ContestRecordCopyWith(ContestRecord value, $Res Function(ContestRecord) _then) = _$ContestRecordCopyWithImpl;
@useResult
$Res call({
 int fiscalYear, BandDivision division, ContestStage stage, ContestAward award
});




}
/// @nodoc
class _$ContestRecordCopyWithImpl<$Res>
    implements $ContestRecordCopyWith<$Res> {
  _$ContestRecordCopyWithImpl(this._self, this._then);

  final ContestRecord _self;
  final $Res Function(ContestRecord) _then;

/// Create a copy of ContestRecord
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? fiscalYear = null,Object? division = null,Object? stage = null,Object? award = null,}) {
  return _then(ContestRecord(
fiscalYear: null == fiscalYear ? _self.fiscalYear : fiscalYear // ignore: cast_nullable_to_non_nullable
as int,division: null == division ? _self.division : division // ignore: cast_nullable_to_non_nullable
as BandDivision,stage: null == stage ? _self.stage : stage // ignore: cast_nullable_to_non_nullable
as ContestStage,award: null == award ? _self.award : award // ignore: cast_nullable_to_non_nullable
as ContestAward,
  ));
}

}


/// Adds pattern-matching-related methods to [ContestRecord].
extension ContestRecordPatterns on ContestRecord {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ContestRecord value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ContestRecord() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ContestRecord value)  $default,){
final _that = this;
switch (_that) {
case _ContestRecord():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ContestRecord value)?  $default,){
final _that = this;
switch (_that) {
case _ContestRecord() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int fiscalYear,  BandDivision division,  ContestStage stage,  ContestAward award)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ContestRecord() when $default != null:
return $default(_that.fiscalYear,_that.division,_that.stage,_that.award);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int fiscalYear,  BandDivision division,  ContestStage stage,  ContestAward award)  $default,) {final _that = this;
switch (_that) {
case _ContestRecord():
return $default(_that.fiscalYear,_that.division,_that.stage,_that.award);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int fiscalYear,  BandDivision division,  ContestStage stage,  ContestAward award)?  $default,) {final _that = this;
switch (_that) {
case _ContestRecord() when $default != null:
return $default(_that.fiscalYear,_that.division,_that.stage,_that.award);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ContestRecord extends ContestRecord {
  const _ContestRecord({required this.fiscalYear, required this.division, required this.stage, required this.award}): super._();
  factory _ContestRecord.fromJson(Map<String, dynamic> json) => _$ContestRecordFromJson(json);

@override final  int fiscalYear;
@override final  BandDivision division;
/// 最後に出場した大会（＝その年の最終到達段階）。
@override final  ContestStage stage;
/// その大会での賞。
@override final  ContestAward award;

/// Create a copy of ContestRecord
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ContestRecordCopyWith<_ContestRecord> get copyWith => __$ContestRecordCopyWithImpl<_ContestRecord>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ContestRecordToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ContestRecord&&(identical(other.fiscalYear, fiscalYear) || other.fiscalYear == fiscalYear)&&(identical(other.division, division) || other.division == division)&&(identical(other.stage, stage) || other.stage == stage)&&(identical(other.award, award) || other.award == award));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,fiscalYear,division,stage,award);
}

@override
String toString() {
    return 'ContestRecord(fiscalYear: $fiscalYear, division: $division, stage: $stage, award: $award)';
}


}

/// @nodoc
abstract mixin class _$ContestRecordCopyWith<$Res> implements $ContestRecordCopyWith<$Res> {
  factory _$ContestRecordCopyWith(_ContestRecord value, $Res Function(_ContestRecord) _then) = __$ContestRecordCopyWithImpl;
@override @useResult
$Res call({
 int fiscalYear, BandDivision division, ContestStage stage, ContestAward award
});




}
/// @nodoc
class __$ContestRecordCopyWithImpl<$Res>
    implements _$ContestRecordCopyWith<$Res> {
  __$ContestRecordCopyWithImpl(this._self, this._then);

  final _ContestRecord _self;
  final $Res Function(_ContestRecord) _then;

/// Create a copy of ContestRecord
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? fiscalYear = null,Object? division = null,Object? stage = null,Object? award = null,}) {
  return _then(_ContestRecord(
fiscalYear: null == fiscalYear ? _self.fiscalYear : fiscalYear // ignore: cast_nullable_to_non_nullable
as int,division: null == division ? _self.division : division // ignore: cast_nullable_to_non_nullable
as BandDivision,stage: null == stage ? _self.stage : stage // ignore: cast_nullable_to_non_nullable
as ContestStage,award: null == award ? _self.award : award // ignore: cast_nullable_to_non_nullable
as ContestAward,
  ));
}


}

// dart format on
