// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'relationship_vector.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RelationshipVector {

/// 好感度
 int get affection;/// 信頼度
 int get trust;/// ライバル度
 int get rivalry;
/// Create a copy of RelationshipVector
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RelationshipVectorCopyWith<RelationshipVector> get copyWith => _$RelationshipVectorCopyWithImpl<RelationshipVector>(this as RelationshipVector, _$identity);

  /// Serializes this RelationshipVector to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as RelationshipVector;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RelationshipVector&&(identical(other.affection, _this.affection) || other.affection == _this.affection)&&(identical(other.trust, _this.trust) || other.trust == _this.trust)&&(identical(other.rivalry, _this.rivalry) || other.rivalry == _this.rivalry));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as RelationshipVector;
  return Object.hash(runtimeType,_this.affection,_this.trust,_this.rivalry);
}

@override
String toString() {
  final _this = this as RelationshipVector;
  return 'RelationshipVector(affection: ${_this.affection}, trust: ${_this.trust}, rivalry: ${_this.rivalry})';
}


}

/// @nodoc
abstract mixin class $RelationshipVectorCopyWith<$Res>  {
  factory $RelationshipVectorCopyWith(RelationshipVector value, $Res Function(RelationshipVector) _then) = _$RelationshipVectorCopyWithImpl;
@useResult
$Res call({
 int affection, int trust, int rivalry
});




}
/// @nodoc
class _$RelationshipVectorCopyWithImpl<$Res>
    implements $RelationshipVectorCopyWith<$Res> {
  _$RelationshipVectorCopyWithImpl(this._self, this._then);

  final RelationshipVector _self;
  final $Res Function(RelationshipVector) _then;

/// Create a copy of RelationshipVector
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? affection = null,Object? trust = null,Object? rivalry = null,}) {
  return _then(RelationshipVector(
affection: null == affection ? _self.affection : affection // ignore: cast_nullable_to_non_nullable
as int,trust: null == trust ? _self.trust : trust // ignore: cast_nullable_to_non_nullable
as int,rivalry: null == rivalry ? _self.rivalry : rivalry // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [RelationshipVector].
extension RelationshipVectorPatterns on RelationshipVector {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RelationshipVector value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RelationshipVector() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RelationshipVector value)  $default,){
final _that = this;
switch (_that) {
case _RelationshipVector():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RelationshipVector value)?  $default,){
final _that = this;
switch (_that) {
case _RelationshipVector() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int affection,  int trust,  int rivalry)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RelationshipVector() when $default != null:
return $default(_that.affection,_that.trust,_that.rivalry);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int affection,  int trust,  int rivalry)  $default,) {final _that = this;
switch (_that) {
case _RelationshipVector():
return $default(_that.affection,_that.trust,_that.rivalry);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int affection,  int trust,  int rivalry)?  $default,) {final _that = this;
switch (_that) {
case _RelationshipVector() when $default != null:
return $default(_that.affection,_that.trust,_that.rivalry);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RelationshipVector extends RelationshipVector {
  const _RelationshipVector({this.affection = 0, this.trust = 0, this.rivalry = 0}): super._();
  factory _RelationshipVector.fromJson(Map<String, dynamic> json) => _$RelationshipVectorFromJson(json);

/// 好感度
@override@JsonKey() final  int affection;
/// 信頼度
@override@JsonKey() final  int trust;
/// ライバル度
@override@JsonKey() final  int rivalry;

/// Create a copy of RelationshipVector
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RelationshipVectorCopyWith<_RelationshipVector> get copyWith => __$RelationshipVectorCopyWithImpl<_RelationshipVector>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RelationshipVectorToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _RelationshipVector&&(identical(other.affection, affection) || other.affection == affection)&&(identical(other.trust, trust) || other.trust == trust)&&(identical(other.rivalry, rivalry) || other.rivalry == rivalry));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,affection,trust,rivalry);
}

@override
String toString() {
    return 'RelationshipVector(affection: $affection, trust: $trust, rivalry: $rivalry)';
}


}

/// @nodoc
abstract mixin class _$RelationshipVectorCopyWith<$Res> implements $RelationshipVectorCopyWith<$Res> {
  factory _$RelationshipVectorCopyWith(_RelationshipVector value, $Res Function(_RelationshipVector) _then) = __$RelationshipVectorCopyWithImpl;
@override @useResult
$Res call({
 int affection, int trust, int rivalry
});




}
/// @nodoc
class __$RelationshipVectorCopyWithImpl<$Res>
    implements _$RelationshipVectorCopyWith<$Res> {
  __$RelationshipVectorCopyWithImpl(this._self, this._then);

  final _RelationshipVector _self;
  final $Res Function(_RelationshipVector) _then;

/// Create a copy of RelationshipVector
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? affection = null,Object? trust = null,Object? rivalry = null,}) {
  return _then(_RelationshipVector(
affection: null == affection ? _self.affection : affection // ignore: cast_nullable_to_non_nullable
as int,trust: null == trust ? _self.trust : trust // ignore: cast_nullable_to_non_nullable
as int,rivalry: null == rivalry ? _self.rivalry : rivalry // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
