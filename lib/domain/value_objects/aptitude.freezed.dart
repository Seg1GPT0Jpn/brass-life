// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'aptitude.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AptitudeStats {

 int get pitch; int get rhythm; int get breath; int get dexterity; int get expression; int get reading;
/// Create a copy of AptitudeStats
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AptitudeStatsCopyWith<AptitudeStats> get copyWith => _$AptitudeStatsCopyWithImpl<AptitudeStats>(this as AptitudeStats, _$identity);

  /// Serializes this AptitudeStats to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as AptitudeStats;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AptitudeStats&&(identical(other.pitch, _this.pitch) || other.pitch == _this.pitch)&&(identical(other.rhythm, _this.rhythm) || other.rhythm == _this.rhythm)&&(identical(other.breath, _this.breath) || other.breath == _this.breath)&&(identical(other.dexterity, _this.dexterity) || other.dexterity == _this.dexterity)&&(identical(other.expression, _this.expression) || other.expression == _this.expression)&&(identical(other.reading, _this.reading) || other.reading == _this.reading));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as AptitudeStats;
  return Object.hash(runtimeType,_this.pitch,_this.rhythm,_this.breath,_this.dexterity,_this.expression,_this.reading);
}

@override
String toString() {
  final _this = this as AptitudeStats;
  return 'AptitudeStats(pitch: ${_this.pitch}, rhythm: ${_this.rhythm}, breath: ${_this.breath}, dexterity: ${_this.dexterity}, expression: ${_this.expression}, reading: ${_this.reading})';
}


}

/// @nodoc
abstract mixin class $AptitudeStatsCopyWith<$Res>  {
  factory $AptitudeStatsCopyWith(AptitudeStats value, $Res Function(AptitudeStats) _then) = _$AptitudeStatsCopyWithImpl;
@useResult
$Res call({
 int pitch, int rhythm, int breath, int dexterity, int expression, int reading
});




}
/// @nodoc
class _$AptitudeStatsCopyWithImpl<$Res>
    implements $AptitudeStatsCopyWith<$Res> {
  _$AptitudeStatsCopyWithImpl(this._self, this._then);

  final AptitudeStats _self;
  final $Res Function(AptitudeStats) _then;

/// Create a copy of AptitudeStats
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? pitch = null,Object? rhythm = null,Object? breath = null,Object? dexterity = null,Object? expression = null,Object? reading = null,}) {
  return _then(AptitudeStats(
pitch: null == pitch ? _self.pitch : pitch // ignore: cast_nullable_to_non_nullable
as int,rhythm: null == rhythm ? _self.rhythm : rhythm // ignore: cast_nullable_to_non_nullable
as int,breath: null == breath ? _self.breath : breath // ignore: cast_nullable_to_non_nullable
as int,dexterity: null == dexterity ? _self.dexterity : dexterity // ignore: cast_nullable_to_non_nullable
as int,expression: null == expression ? _self.expression : expression // ignore: cast_nullable_to_non_nullable
as int,reading: null == reading ? _self.reading : reading // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [AptitudeStats].
extension AptitudeStatsPatterns on AptitudeStats {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AptitudeStats value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AptitudeStats() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AptitudeStats value)  $default,){
final _that = this;
switch (_that) {
case _AptitudeStats():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AptitudeStats value)?  $default,){
final _that = this;
switch (_that) {
case _AptitudeStats() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int pitch,  int rhythm,  int breath,  int dexterity,  int expression,  int reading)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AptitudeStats() when $default != null:
return $default(_that.pitch,_that.rhythm,_that.breath,_that.dexterity,_that.expression,_that.reading);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int pitch,  int rhythm,  int breath,  int dexterity,  int expression,  int reading)  $default,) {final _that = this;
switch (_that) {
case _AptitudeStats():
return $default(_that.pitch,_that.rhythm,_that.breath,_that.dexterity,_that.expression,_that.reading);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int pitch,  int rhythm,  int breath,  int dexterity,  int expression,  int reading)?  $default,) {final _that = this;
switch (_that) {
case _AptitudeStats() when $default != null:
return $default(_that.pitch,_that.rhythm,_that.breath,_that.dexterity,_that.expression,_that.reading);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AptitudeStats extends AptitudeStats {
  const _AptitudeStats({required this.pitch, required this.rhythm, required this.breath, required this.dexterity, required this.expression, required this.reading}): super._();
  factory _AptitudeStats.fromJson(Map<String, dynamic> json) => _$AptitudeStatsFromJson(json);

@override final  int pitch;
@override final  int rhythm;
@override final  int breath;
@override final  int dexterity;
@override final  int expression;
@override final  int reading;

/// Create a copy of AptitudeStats
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AptitudeStatsCopyWith<_AptitudeStats> get copyWith => __$AptitudeStatsCopyWithImpl<_AptitudeStats>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AptitudeStatsToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AptitudeStats&&(identical(other.pitch, pitch) || other.pitch == pitch)&&(identical(other.rhythm, rhythm) || other.rhythm == rhythm)&&(identical(other.breath, breath) || other.breath == breath)&&(identical(other.dexterity, dexterity) || other.dexterity == dexterity)&&(identical(other.expression, expression) || other.expression == expression)&&(identical(other.reading, reading) || other.reading == reading));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,pitch,rhythm,breath,dexterity,expression,reading);
}

@override
String toString() {
    return 'AptitudeStats(pitch: $pitch, rhythm: $rhythm, breath: $breath, dexterity: $dexterity, expression: $expression, reading: $reading)';
}


}

/// @nodoc
abstract mixin class _$AptitudeStatsCopyWith<$Res> implements $AptitudeStatsCopyWith<$Res> {
  factory _$AptitudeStatsCopyWith(_AptitudeStats value, $Res Function(_AptitudeStats) _then) = __$AptitudeStatsCopyWithImpl;
@override @useResult
$Res call({
 int pitch, int rhythm, int breath, int dexterity, int expression, int reading
});




}
/// @nodoc
class __$AptitudeStatsCopyWithImpl<$Res>
    implements _$AptitudeStatsCopyWith<$Res> {
  __$AptitudeStatsCopyWithImpl(this._self, this._then);

  final _AptitudeStats _self;
  final $Res Function(_AptitudeStats) _then;

/// Create a copy of AptitudeStats
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? pitch = null,Object? rhythm = null,Object? breath = null,Object? dexterity = null,Object? expression = null,Object? reading = null,}) {
  return _then(_AptitudeStats(
pitch: null == pitch ? _self.pitch : pitch // ignore: cast_nullable_to_non_nullable
as int,rhythm: null == rhythm ? _self.rhythm : rhythm // ignore: cast_nullable_to_non_nullable
as int,breath: null == breath ? _self.breath : breath // ignore: cast_nullable_to_non_nullable
as int,dexterity: null == dexterity ? _self.dexterity : dexterity // ignore: cast_nullable_to_non_nullable
as int,expression: null == expression ? _self.expression : expression // ignore: cast_nullable_to_non_nullable
as int,reading: null == reading ? _self.reading : reading // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
