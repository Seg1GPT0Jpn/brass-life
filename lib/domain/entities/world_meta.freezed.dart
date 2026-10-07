// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'world_meta.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WorldMeta {

/// ユーザーが入力した元の文字列。
 String get input; int get seed; String get seedCode; int get generatorVersion;/// 生成結果のフィンガープリント（再生成時の一致確認に使う）。
 String get fingerprint;
/// Create a copy of WorldMeta
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WorldMetaCopyWith<WorldMeta> get copyWith => _$WorldMetaCopyWithImpl<WorldMeta>(this as WorldMeta, _$identity);

  /// Serializes this WorldMeta to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as WorldMeta;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WorldMeta&&(identical(other.input, _this.input) || other.input == _this.input)&&(identical(other.seed, _this.seed) || other.seed == _this.seed)&&(identical(other.seedCode, _this.seedCode) || other.seedCode == _this.seedCode)&&(identical(other.generatorVersion, _this.generatorVersion) || other.generatorVersion == _this.generatorVersion)&&(identical(other.fingerprint, _this.fingerprint) || other.fingerprint == _this.fingerprint));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as WorldMeta;
  return Object.hash(runtimeType,_this.input,_this.seed,_this.seedCode,_this.generatorVersion,_this.fingerprint);
}

@override
String toString() {
  final _this = this as WorldMeta;
  return 'WorldMeta(input: ${_this.input}, seed: ${_this.seed}, seedCode: ${_this.seedCode}, generatorVersion: ${_this.generatorVersion}, fingerprint: ${_this.fingerprint})';
}


}

/// @nodoc
abstract mixin class $WorldMetaCopyWith<$Res>  {
  factory $WorldMetaCopyWith(WorldMeta value, $Res Function(WorldMeta) _then) = _$WorldMetaCopyWithImpl;
@useResult
$Res call({
 String input, int seed, String seedCode, int generatorVersion, String fingerprint
});




}
/// @nodoc
class _$WorldMetaCopyWithImpl<$Res>
    implements $WorldMetaCopyWith<$Res> {
  _$WorldMetaCopyWithImpl(this._self, this._then);

  final WorldMeta _self;
  final $Res Function(WorldMeta) _then;

/// Create a copy of WorldMeta
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? input = null,Object? seed = null,Object? seedCode = null,Object? generatorVersion = null,Object? fingerprint = null,}) {
  return _then(WorldMeta(
input: null == input ? _self.input : input // ignore: cast_nullable_to_non_nullable
as String,seed: null == seed ? _self.seed : seed // ignore: cast_nullable_to_non_nullable
as int,seedCode: null == seedCode ? _self.seedCode : seedCode // ignore: cast_nullable_to_non_nullable
as String,generatorVersion: null == generatorVersion ? _self.generatorVersion : generatorVersion // ignore: cast_nullable_to_non_nullable
as int,fingerprint: null == fingerprint ? _self.fingerprint : fingerprint // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [WorldMeta].
extension WorldMetaPatterns on WorldMeta {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WorldMeta value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WorldMeta() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WorldMeta value)  $default,){
final _that = this;
switch (_that) {
case _WorldMeta():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WorldMeta value)?  $default,){
final _that = this;
switch (_that) {
case _WorldMeta() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String input,  int seed,  String seedCode,  int generatorVersion,  String fingerprint)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WorldMeta() when $default != null:
return $default(_that.input,_that.seed,_that.seedCode,_that.generatorVersion,_that.fingerprint);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String input,  int seed,  String seedCode,  int generatorVersion,  String fingerprint)  $default,) {final _that = this;
switch (_that) {
case _WorldMeta():
return $default(_that.input,_that.seed,_that.seedCode,_that.generatorVersion,_that.fingerprint);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String input,  int seed,  String seedCode,  int generatorVersion,  String fingerprint)?  $default,) {final _that = this;
switch (_that) {
case _WorldMeta() when $default != null:
return $default(_that.input,_that.seed,_that.seedCode,_that.generatorVersion,_that.fingerprint);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WorldMeta implements WorldMeta {
  const _WorldMeta({required this.input, required this.seed, required this.seedCode, required this.generatorVersion, required this.fingerprint});
  factory _WorldMeta.fromJson(Map<String, dynamic> json) => _$WorldMetaFromJson(json);

/// ユーザーが入力した元の文字列。
@override final  String input;
@override final  int seed;
@override final  String seedCode;
@override final  int generatorVersion;
/// 生成結果のフィンガープリント（再生成時の一致確認に使う）。
@override final  String fingerprint;

/// Create a copy of WorldMeta
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WorldMetaCopyWith<_WorldMeta> get copyWith => __$WorldMetaCopyWithImpl<_WorldMeta>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WorldMetaToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _WorldMeta&&(identical(other.input, input) || other.input == input)&&(identical(other.seed, seed) || other.seed == seed)&&(identical(other.seedCode, seedCode) || other.seedCode == seedCode)&&(identical(other.generatorVersion, generatorVersion) || other.generatorVersion == generatorVersion)&&(identical(other.fingerprint, fingerprint) || other.fingerprint == fingerprint));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,input,seed,seedCode,generatorVersion,fingerprint);
}

@override
String toString() {
    return 'WorldMeta(input: $input, seed: $seed, seedCode: $seedCode, generatorVersion: $generatorVersion, fingerprint: $fingerprint)';
}


}

/// @nodoc
abstract mixin class _$WorldMetaCopyWith<$Res> implements $WorldMetaCopyWith<$Res> {
  factory _$WorldMetaCopyWith(_WorldMeta value, $Res Function(_WorldMeta) _then) = __$WorldMetaCopyWithImpl;
@override @useResult
$Res call({
 String input, int seed, String seedCode, int generatorVersion, String fingerprint
});




}
/// @nodoc
class __$WorldMetaCopyWithImpl<$Res>
    implements _$WorldMetaCopyWith<$Res> {
  __$WorldMetaCopyWithImpl(this._self, this._then);

  final _WorldMeta _self;
  final $Res Function(_WorldMeta) _then;

/// Create a copy of WorldMeta
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? input = null,Object? seed = null,Object? seedCode = null,Object? generatorVersion = null,Object? fingerprint = null,}) {
  return _then(_WorldMeta(
input: null == input ? _self.input : input // ignore: cast_nullable_to_non_nullable
as String,seed: null == seed ? _self.seed : seed // ignore: cast_nullable_to_non_nullable
as int,seedCode: null == seedCode ? _self.seedCode : seedCode // ignore: cast_nullable_to_non_nullable
as String,generatorVersion: null == generatorVersion ? _self.generatorVersion : generatorVersion // ignore: cast_nullable_to_non_nullable
as int,fingerprint: null == fingerprint ? _self.fingerprint : fingerprint // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
