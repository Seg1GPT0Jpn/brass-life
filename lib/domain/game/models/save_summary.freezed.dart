// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'save_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SaveSummary {

 String get slot; int get worldSeed; String get seedCode; String get playerName; String get dateLabel; String get schoolName; String get savedAt;
/// Create a copy of SaveSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SaveSummaryCopyWith<SaveSummary> get copyWith => _$SaveSummaryCopyWithImpl<SaveSummary>(this as SaveSummary, _$identity);

  /// Serializes this SaveSummary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as SaveSummary;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SaveSummary&&(identical(other.slot, _this.slot) || other.slot == _this.slot)&&(identical(other.worldSeed, _this.worldSeed) || other.worldSeed == _this.worldSeed)&&(identical(other.seedCode, _this.seedCode) || other.seedCode == _this.seedCode)&&(identical(other.playerName, _this.playerName) || other.playerName == _this.playerName)&&(identical(other.dateLabel, _this.dateLabel) || other.dateLabel == _this.dateLabel)&&(identical(other.schoolName, _this.schoolName) || other.schoolName == _this.schoolName)&&(identical(other.savedAt, _this.savedAt) || other.savedAt == _this.savedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as SaveSummary;
  return Object.hash(runtimeType,_this.slot,_this.worldSeed,_this.seedCode,_this.playerName,_this.dateLabel,_this.schoolName,_this.savedAt);
}

@override
String toString() {
  final _this = this as SaveSummary;
  return 'SaveSummary(slot: ${_this.slot}, worldSeed: ${_this.worldSeed}, seedCode: ${_this.seedCode}, playerName: ${_this.playerName}, dateLabel: ${_this.dateLabel}, schoolName: ${_this.schoolName}, savedAt: ${_this.savedAt})';
}


}

/// @nodoc
abstract mixin class $SaveSummaryCopyWith<$Res>  {
  factory $SaveSummaryCopyWith(SaveSummary value, $Res Function(SaveSummary) _then) = _$SaveSummaryCopyWithImpl;
@useResult
$Res call({
 String slot, int worldSeed, String seedCode, String playerName, String dateLabel, String schoolName, String savedAt
});




}
/// @nodoc
class _$SaveSummaryCopyWithImpl<$Res>
    implements $SaveSummaryCopyWith<$Res> {
  _$SaveSummaryCopyWithImpl(this._self, this._then);

  final SaveSummary _self;
  final $Res Function(SaveSummary) _then;

/// Create a copy of SaveSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? slot = null,Object? worldSeed = null,Object? seedCode = null,Object? playerName = null,Object? dateLabel = null,Object? schoolName = null,Object? savedAt = null,}) {
  return _then(SaveSummary(
slot: null == slot ? _self.slot : slot // ignore: cast_nullable_to_non_nullable
as String,worldSeed: null == worldSeed ? _self.worldSeed : worldSeed // ignore: cast_nullable_to_non_nullable
as int,seedCode: null == seedCode ? _self.seedCode : seedCode // ignore: cast_nullable_to_non_nullable
as String,playerName: null == playerName ? _self.playerName : playerName // ignore: cast_nullable_to_non_nullable
as String,dateLabel: null == dateLabel ? _self.dateLabel : dateLabel // ignore: cast_nullable_to_non_nullable
as String,schoolName: null == schoolName ? _self.schoolName : schoolName // ignore: cast_nullable_to_non_nullable
as String,savedAt: null == savedAt ? _self.savedAt : savedAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [SaveSummary].
extension SaveSummaryPatterns on SaveSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SaveSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SaveSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SaveSummary value)  $default,){
final _that = this;
switch (_that) {
case _SaveSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SaveSummary value)?  $default,){
final _that = this;
switch (_that) {
case _SaveSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String slot,  int worldSeed,  String seedCode,  String playerName,  String dateLabel,  String schoolName,  String savedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SaveSummary() when $default != null:
return $default(_that.slot,_that.worldSeed,_that.seedCode,_that.playerName,_that.dateLabel,_that.schoolName,_that.savedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String slot,  int worldSeed,  String seedCode,  String playerName,  String dateLabel,  String schoolName,  String savedAt)  $default,) {final _that = this;
switch (_that) {
case _SaveSummary():
return $default(_that.slot,_that.worldSeed,_that.seedCode,_that.playerName,_that.dateLabel,_that.schoolName,_that.savedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String slot,  int worldSeed,  String seedCode,  String playerName,  String dateLabel,  String schoolName,  String savedAt)?  $default,) {final _that = this;
switch (_that) {
case _SaveSummary() when $default != null:
return $default(_that.slot,_that.worldSeed,_that.seedCode,_that.playerName,_that.dateLabel,_that.schoolName,_that.savedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SaveSummary implements SaveSummary {
  const _SaveSummary({required this.slot, required this.worldSeed, required this.seedCode, required this.playerName, required this.dateLabel, required this.schoolName, required this.savedAt});
  factory _SaveSummary.fromJson(Map<String, dynamic> json) => _$SaveSummaryFromJson(json);

@override final  String slot;
@override final  int worldSeed;
@override final  String seedCode;
@override final  String playerName;
@override final  String dateLabel;
@override final  String schoolName;
@override final  String savedAt;

/// Create a copy of SaveSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SaveSummaryCopyWith<_SaveSummary> get copyWith => __$SaveSummaryCopyWithImpl<_SaveSummary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SaveSummaryToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SaveSummary&&(identical(other.slot, slot) || other.slot == slot)&&(identical(other.worldSeed, worldSeed) || other.worldSeed == worldSeed)&&(identical(other.seedCode, seedCode) || other.seedCode == seedCode)&&(identical(other.playerName, playerName) || other.playerName == playerName)&&(identical(other.dateLabel, dateLabel) || other.dateLabel == dateLabel)&&(identical(other.schoolName, schoolName) || other.schoolName == schoolName)&&(identical(other.savedAt, savedAt) || other.savedAt == savedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,slot,worldSeed,seedCode,playerName,dateLabel,schoolName,savedAt);
}

@override
String toString() {
    return 'SaveSummary(slot: $slot, worldSeed: $worldSeed, seedCode: $seedCode, playerName: $playerName, dateLabel: $dateLabel, schoolName: $schoolName, savedAt: $savedAt)';
}


}

/// @nodoc
abstract mixin class _$SaveSummaryCopyWith<$Res> implements $SaveSummaryCopyWith<$Res> {
  factory _$SaveSummaryCopyWith(_SaveSummary value, $Res Function(_SaveSummary) _then) = __$SaveSummaryCopyWithImpl;
@override @useResult
$Res call({
 String slot, int worldSeed, String seedCode, String playerName, String dateLabel, String schoolName, String savedAt
});




}
/// @nodoc
class __$SaveSummaryCopyWithImpl<$Res>
    implements _$SaveSummaryCopyWith<$Res> {
  __$SaveSummaryCopyWithImpl(this._self, this._then);

  final _SaveSummary _self;
  final $Res Function(_SaveSummary) _then;

/// Create a copy of SaveSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? slot = null,Object? worldSeed = null,Object? seedCode = null,Object? playerName = null,Object? dateLabel = null,Object? schoolName = null,Object? savedAt = null,}) {
  return _then(_SaveSummary(
slot: null == slot ? _self.slot : slot // ignore: cast_nullable_to_non_nullable
as String,worldSeed: null == worldSeed ? _self.worldSeed : worldSeed // ignore: cast_nullable_to_non_nullable
as int,seedCode: null == seedCode ? _self.seedCode : seedCode // ignore: cast_nullable_to_non_nullable
as String,playerName: null == playerName ? _self.playerName : playerName // ignore: cast_nullable_to_non_nullable
as String,dateLabel: null == dateLabel ? _self.dateLabel : dateLabel // ignore: cast_nullable_to_non_nullable
as String,schoolName: null == schoolName ? _self.schoolName : schoolName // ignore: cast_nullable_to_non_nullable
as String,savedAt: null == savedAt ? _self.savedAt : savedAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
