// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'world_gen_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WorldGenConfig {

 int get middleSchoolCount; int get highSchoolCount; int get districtCount;/// プレイヤーが中学 1 年になる年度（西暦）。
 int get startYear;/// NPC 総数の下限・上限。部員数の計画値がこの範囲外になった場合、
/// 全部の部員数を比例的に補正して範囲内に収める。
 int get minNpcCount; int get maxNpcCount;/// 遡って生成するコンクール成績の年数。
 int get historyYears;
/// Create a copy of WorldGenConfig
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WorldGenConfigCopyWith<WorldGenConfig> get copyWith => _$WorldGenConfigCopyWithImpl<WorldGenConfig>(this as WorldGenConfig, _$identity);

  /// Serializes this WorldGenConfig to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as WorldGenConfig;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WorldGenConfig&&(identical(other.middleSchoolCount, _this.middleSchoolCount) || other.middleSchoolCount == _this.middleSchoolCount)&&(identical(other.highSchoolCount, _this.highSchoolCount) || other.highSchoolCount == _this.highSchoolCount)&&(identical(other.districtCount, _this.districtCount) || other.districtCount == _this.districtCount)&&(identical(other.startYear, _this.startYear) || other.startYear == _this.startYear)&&(identical(other.minNpcCount, _this.minNpcCount) || other.minNpcCount == _this.minNpcCount)&&(identical(other.maxNpcCount, _this.maxNpcCount) || other.maxNpcCount == _this.maxNpcCount)&&(identical(other.historyYears, _this.historyYears) || other.historyYears == _this.historyYears));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as WorldGenConfig;
  return Object.hash(runtimeType,_this.middleSchoolCount,_this.highSchoolCount,_this.districtCount,_this.startYear,_this.minNpcCount,_this.maxNpcCount,_this.historyYears);
}

@override
String toString() {
  final _this = this as WorldGenConfig;
  return 'WorldGenConfig(middleSchoolCount: ${_this.middleSchoolCount}, highSchoolCount: ${_this.highSchoolCount}, districtCount: ${_this.districtCount}, startYear: ${_this.startYear}, minNpcCount: ${_this.minNpcCount}, maxNpcCount: ${_this.maxNpcCount}, historyYears: ${_this.historyYears})';
}


}

/// @nodoc
abstract mixin class $WorldGenConfigCopyWith<$Res>  {
  factory $WorldGenConfigCopyWith(WorldGenConfig value, $Res Function(WorldGenConfig) _then) = _$WorldGenConfigCopyWithImpl;
@useResult
$Res call({
 int middleSchoolCount, int highSchoolCount, int districtCount, int startYear, int minNpcCount, int maxNpcCount, int historyYears
});




}
/// @nodoc
class _$WorldGenConfigCopyWithImpl<$Res>
    implements $WorldGenConfigCopyWith<$Res> {
  _$WorldGenConfigCopyWithImpl(this._self, this._then);

  final WorldGenConfig _self;
  final $Res Function(WorldGenConfig) _then;

/// Create a copy of WorldGenConfig
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? middleSchoolCount = null,Object? highSchoolCount = null,Object? districtCount = null,Object? startYear = null,Object? minNpcCount = null,Object? maxNpcCount = null,Object? historyYears = null,}) {
  return _then(WorldGenConfig(
middleSchoolCount: null == middleSchoolCount ? _self.middleSchoolCount : middleSchoolCount // ignore: cast_nullable_to_non_nullable
as int,highSchoolCount: null == highSchoolCount ? _self.highSchoolCount : highSchoolCount // ignore: cast_nullable_to_non_nullable
as int,districtCount: null == districtCount ? _self.districtCount : districtCount // ignore: cast_nullable_to_non_nullable
as int,startYear: null == startYear ? _self.startYear : startYear // ignore: cast_nullable_to_non_nullable
as int,minNpcCount: null == minNpcCount ? _self.minNpcCount : minNpcCount // ignore: cast_nullable_to_non_nullable
as int,maxNpcCount: null == maxNpcCount ? _self.maxNpcCount : maxNpcCount // ignore: cast_nullable_to_non_nullable
as int,historyYears: null == historyYears ? _self.historyYears : historyYears // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [WorldGenConfig].
extension WorldGenConfigPatterns on WorldGenConfig {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WorldGenConfig value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WorldGenConfig() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WorldGenConfig value)  $default,){
final _that = this;
switch (_that) {
case _WorldGenConfig():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WorldGenConfig value)?  $default,){
final _that = this;
switch (_that) {
case _WorldGenConfig() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int middleSchoolCount,  int highSchoolCount,  int districtCount,  int startYear,  int minNpcCount,  int maxNpcCount,  int historyYears)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WorldGenConfig() when $default != null:
return $default(_that.middleSchoolCount,_that.highSchoolCount,_that.districtCount,_that.startYear,_that.minNpcCount,_that.maxNpcCount,_that.historyYears);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int middleSchoolCount,  int highSchoolCount,  int districtCount,  int startYear,  int minNpcCount,  int maxNpcCount,  int historyYears)  $default,) {final _that = this;
switch (_that) {
case _WorldGenConfig():
return $default(_that.middleSchoolCount,_that.highSchoolCount,_that.districtCount,_that.startYear,_that.minNpcCount,_that.maxNpcCount,_that.historyYears);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int middleSchoolCount,  int highSchoolCount,  int districtCount,  int startYear,  int minNpcCount,  int maxNpcCount,  int historyYears)?  $default,) {final _that = this;
switch (_that) {
case _WorldGenConfig() when $default != null:
return $default(_that.middleSchoolCount,_that.highSchoolCount,_that.districtCount,_that.startYear,_that.minNpcCount,_that.maxNpcCount,_that.historyYears);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WorldGenConfig implements WorldGenConfig {
  const _WorldGenConfig({this.middleSchoolCount = 40, this.highSchoolCount = 24, this.districtCount = 5, this.startYear = 2026, this.minNpcCount = 1000, this.maxNpcCount = 2000, this.historyYears = 5});
  factory _WorldGenConfig.fromJson(Map<String, dynamic> json) => _$WorldGenConfigFromJson(json);

@override@JsonKey() final  int middleSchoolCount;
@override@JsonKey() final  int highSchoolCount;
@override@JsonKey() final  int districtCount;
/// プレイヤーが中学 1 年になる年度（西暦）。
@override@JsonKey() final  int startYear;
/// NPC 総数の下限・上限。部員数の計画値がこの範囲外になった場合、
/// 全部の部員数を比例的に補正して範囲内に収める。
@override@JsonKey() final  int minNpcCount;
@override@JsonKey() final  int maxNpcCount;
/// 遡って生成するコンクール成績の年数。
@override@JsonKey() final  int historyYears;

/// Create a copy of WorldGenConfig
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WorldGenConfigCopyWith<_WorldGenConfig> get copyWith => __$WorldGenConfigCopyWithImpl<_WorldGenConfig>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WorldGenConfigToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _WorldGenConfig&&(identical(other.middleSchoolCount, middleSchoolCount) || other.middleSchoolCount == middleSchoolCount)&&(identical(other.highSchoolCount, highSchoolCount) || other.highSchoolCount == highSchoolCount)&&(identical(other.districtCount, districtCount) || other.districtCount == districtCount)&&(identical(other.startYear, startYear) || other.startYear == startYear)&&(identical(other.minNpcCount, minNpcCount) || other.minNpcCount == minNpcCount)&&(identical(other.maxNpcCount, maxNpcCount) || other.maxNpcCount == maxNpcCount)&&(identical(other.historyYears, historyYears) || other.historyYears == historyYears));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,middleSchoolCount,highSchoolCount,districtCount,startYear,minNpcCount,maxNpcCount,historyYears);
}

@override
String toString() {
    return 'WorldGenConfig(middleSchoolCount: $middleSchoolCount, highSchoolCount: $highSchoolCount, districtCount: $districtCount, startYear: $startYear, minNpcCount: $minNpcCount, maxNpcCount: $maxNpcCount, historyYears: $historyYears)';
}


}

/// @nodoc
abstract mixin class _$WorldGenConfigCopyWith<$Res> implements $WorldGenConfigCopyWith<$Res> {
  factory _$WorldGenConfigCopyWith(_WorldGenConfig value, $Res Function(_WorldGenConfig) _then) = __$WorldGenConfigCopyWithImpl;
@override @useResult
$Res call({
 int middleSchoolCount, int highSchoolCount, int districtCount, int startYear, int minNpcCount, int maxNpcCount, int historyYears
});




}
/// @nodoc
class __$WorldGenConfigCopyWithImpl<$Res>
    implements _$WorldGenConfigCopyWith<$Res> {
  __$WorldGenConfigCopyWithImpl(this._self, this._then);

  final _WorldGenConfig _self;
  final $Res Function(_WorldGenConfig) _then;

/// Create a copy of WorldGenConfig
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? middleSchoolCount = null,Object? highSchoolCount = null,Object? districtCount = null,Object? startYear = null,Object? minNpcCount = null,Object? maxNpcCount = null,Object? historyYears = null,}) {
  return _then(_WorldGenConfig(
middleSchoolCount: null == middleSchoolCount ? _self.middleSchoolCount : middleSchoolCount // ignore: cast_nullable_to_non_nullable
as int,highSchoolCount: null == highSchoolCount ? _self.highSchoolCount : highSchoolCount // ignore: cast_nullable_to_non_nullable
as int,districtCount: null == districtCount ? _self.districtCount : districtCount // ignore: cast_nullable_to_non_nullable
as int,startYear: null == startYear ? _self.startYear : startYear // ignore: cast_nullable_to_non_nullable
as int,minNpcCount: null == minNpcCount ? _self.minNpcCount : minNpcCount // ignore: cast_nullable_to_non_nullable
as int,maxNpcCount: null == maxNpcCount ? _self.maxNpcCount : maxNpcCount // ignore: cast_nullable_to_non_nullable
as int,historyYears: null == historyYears ? _self.historyYears : historyYears // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
