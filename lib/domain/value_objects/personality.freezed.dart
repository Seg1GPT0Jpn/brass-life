// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'personality.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PersonalityAxes {

/// 外向性
 int get extraversion;/// 協調性
 int get agreeableness;/// 勤勉性
 int get conscientiousness;/// 情緒不安定性（高いほど不安定）
 int get neuroticism;/// 野心・上昇志向
 int get ambition;
/// Create a copy of PersonalityAxes
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PersonalityAxesCopyWith<PersonalityAxes> get copyWith => _$PersonalityAxesCopyWithImpl<PersonalityAxes>(this as PersonalityAxes, _$identity);

  /// Serializes this PersonalityAxes to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PersonalityAxes;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PersonalityAxes&&(identical(other.extraversion, _this.extraversion) || other.extraversion == _this.extraversion)&&(identical(other.agreeableness, _this.agreeableness) || other.agreeableness == _this.agreeableness)&&(identical(other.conscientiousness, _this.conscientiousness) || other.conscientiousness == _this.conscientiousness)&&(identical(other.neuroticism, _this.neuroticism) || other.neuroticism == _this.neuroticism)&&(identical(other.ambition, _this.ambition) || other.ambition == _this.ambition));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PersonalityAxes;
  return Object.hash(runtimeType,_this.extraversion,_this.agreeableness,_this.conscientiousness,_this.neuroticism,_this.ambition);
}

@override
String toString() {
  final _this = this as PersonalityAxes;
  return 'PersonalityAxes(extraversion: ${_this.extraversion}, agreeableness: ${_this.agreeableness}, conscientiousness: ${_this.conscientiousness}, neuroticism: ${_this.neuroticism}, ambition: ${_this.ambition})';
}


}

/// @nodoc
abstract mixin class $PersonalityAxesCopyWith<$Res>  {
  factory $PersonalityAxesCopyWith(PersonalityAxes value, $Res Function(PersonalityAxes) _then) = _$PersonalityAxesCopyWithImpl;
@useResult
$Res call({
 int extraversion, int agreeableness, int conscientiousness, int neuroticism, int ambition
});




}
/// @nodoc
class _$PersonalityAxesCopyWithImpl<$Res>
    implements $PersonalityAxesCopyWith<$Res> {
  _$PersonalityAxesCopyWithImpl(this._self, this._then);

  final PersonalityAxes _self;
  final $Res Function(PersonalityAxes) _then;

/// Create a copy of PersonalityAxes
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? extraversion = null,Object? agreeableness = null,Object? conscientiousness = null,Object? neuroticism = null,Object? ambition = null,}) {
  return _then(PersonalityAxes(
extraversion: null == extraversion ? _self.extraversion : extraversion // ignore: cast_nullable_to_non_nullable
as int,agreeableness: null == agreeableness ? _self.agreeableness : agreeableness // ignore: cast_nullable_to_non_nullable
as int,conscientiousness: null == conscientiousness ? _self.conscientiousness : conscientiousness // ignore: cast_nullable_to_non_nullable
as int,neuroticism: null == neuroticism ? _self.neuroticism : neuroticism // ignore: cast_nullable_to_non_nullable
as int,ambition: null == ambition ? _self.ambition : ambition // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [PersonalityAxes].
extension PersonalityAxesPatterns on PersonalityAxes {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PersonalityAxes value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PersonalityAxes() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PersonalityAxes value)  $default,){
final _that = this;
switch (_that) {
case _PersonalityAxes():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PersonalityAxes value)?  $default,){
final _that = this;
switch (_that) {
case _PersonalityAxes() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int extraversion,  int agreeableness,  int conscientiousness,  int neuroticism,  int ambition)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PersonalityAxes() when $default != null:
return $default(_that.extraversion,_that.agreeableness,_that.conscientiousness,_that.neuroticism,_that.ambition);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int extraversion,  int agreeableness,  int conscientiousness,  int neuroticism,  int ambition)  $default,) {final _that = this;
switch (_that) {
case _PersonalityAxes():
return $default(_that.extraversion,_that.agreeableness,_that.conscientiousness,_that.neuroticism,_that.ambition);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int extraversion,  int agreeableness,  int conscientiousness,  int neuroticism,  int ambition)?  $default,) {final _that = this;
switch (_that) {
case _PersonalityAxes() when $default != null:
return $default(_that.extraversion,_that.agreeableness,_that.conscientiousness,_that.neuroticism,_that.ambition);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PersonalityAxes implements PersonalityAxes {
  const _PersonalityAxes({required this.extraversion, required this.agreeableness, required this.conscientiousness, required this.neuroticism, required this.ambition});
  factory _PersonalityAxes.fromJson(Map<String, dynamic> json) => _$PersonalityAxesFromJson(json);

/// 外向性
@override final  int extraversion;
/// 協調性
@override final  int agreeableness;
/// 勤勉性
@override final  int conscientiousness;
/// 情緒不安定性（高いほど不安定）
@override final  int neuroticism;
/// 野心・上昇志向
@override final  int ambition;

/// Create a copy of PersonalityAxes
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PersonalityAxesCopyWith<_PersonalityAxes> get copyWith => __$PersonalityAxesCopyWithImpl<_PersonalityAxes>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PersonalityAxesToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PersonalityAxes&&(identical(other.extraversion, extraversion) || other.extraversion == extraversion)&&(identical(other.agreeableness, agreeableness) || other.agreeableness == agreeableness)&&(identical(other.conscientiousness, conscientiousness) || other.conscientiousness == conscientiousness)&&(identical(other.neuroticism, neuroticism) || other.neuroticism == neuroticism)&&(identical(other.ambition, ambition) || other.ambition == ambition));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,extraversion,agreeableness,conscientiousness,neuroticism,ambition);
}

@override
String toString() {
    return 'PersonalityAxes(extraversion: $extraversion, agreeableness: $agreeableness, conscientiousness: $conscientiousness, neuroticism: $neuroticism, ambition: $ambition)';
}


}

/// @nodoc
abstract mixin class _$PersonalityAxesCopyWith<$Res> implements $PersonalityAxesCopyWith<$Res> {
  factory _$PersonalityAxesCopyWith(_PersonalityAxes value, $Res Function(_PersonalityAxes) _then) = __$PersonalityAxesCopyWithImpl;
@override @useResult
$Res call({
 int extraversion, int agreeableness, int conscientiousness, int neuroticism, int ambition
});




}
/// @nodoc
class __$PersonalityAxesCopyWithImpl<$Res>
    implements _$PersonalityAxesCopyWith<$Res> {
  __$PersonalityAxesCopyWithImpl(this._self, this._then);

  final _PersonalityAxes _self;
  final $Res Function(_PersonalityAxes) _then;

/// Create a copy of PersonalityAxes
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? extraversion = null,Object? agreeableness = null,Object? conscientiousness = null,Object? neuroticism = null,Object? ambition = null,}) {
  return _then(_PersonalityAxes(
extraversion: null == extraversion ? _self.extraversion : extraversion // ignore: cast_nullable_to_non_nullable
as int,agreeableness: null == agreeableness ? _self.agreeableness : agreeableness // ignore: cast_nullable_to_non_nullable
as int,conscientiousness: null == conscientiousness ? _self.conscientiousness : conscientiousness // ignore: cast_nullable_to_non_nullable
as int,neuroticism: null == neuroticism ? _self.neuroticism : neuroticism // ignore: cast_nullable_to_non_nullable
as int,ambition: null == ambition ? _self.ambition : ambition // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$TraitTag {

 String get traitId; int get intensity;
/// Create a copy of TraitTag
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TraitTagCopyWith<TraitTag> get copyWith => _$TraitTagCopyWithImpl<TraitTag>(this as TraitTag, _$identity);

  /// Serializes this TraitTag to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as TraitTag;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TraitTag&&(identical(other.traitId, _this.traitId) || other.traitId == _this.traitId)&&(identical(other.intensity, _this.intensity) || other.intensity == _this.intensity));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as TraitTag;
  return Object.hash(runtimeType,_this.traitId,_this.intensity);
}

@override
String toString() {
  final _this = this as TraitTag;
  return 'TraitTag(traitId: ${_this.traitId}, intensity: ${_this.intensity})';
}


}

/// @nodoc
abstract mixin class $TraitTagCopyWith<$Res>  {
  factory $TraitTagCopyWith(TraitTag value, $Res Function(TraitTag) _then) = _$TraitTagCopyWithImpl;
@useResult
$Res call({
 String traitId, int intensity
});




}
/// @nodoc
class _$TraitTagCopyWithImpl<$Res>
    implements $TraitTagCopyWith<$Res> {
  _$TraitTagCopyWithImpl(this._self, this._then);

  final TraitTag _self;
  final $Res Function(TraitTag) _then;

/// Create a copy of TraitTag
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? traitId = null,Object? intensity = null,}) {
  return _then(TraitTag(
traitId: null == traitId ? _self.traitId : traitId // ignore: cast_nullable_to_non_nullable
as String,intensity: null == intensity ? _self.intensity : intensity // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [TraitTag].
extension TraitTagPatterns on TraitTag {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TraitTag value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TraitTag() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TraitTag value)  $default,){
final _that = this;
switch (_that) {
case _TraitTag():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TraitTag value)?  $default,){
final _that = this;
switch (_that) {
case _TraitTag() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String traitId,  int intensity)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TraitTag() when $default != null:
return $default(_that.traitId,_that.intensity);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String traitId,  int intensity)  $default,) {final _that = this;
switch (_that) {
case _TraitTag():
return $default(_that.traitId,_that.intensity);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String traitId,  int intensity)?  $default,) {final _that = this;
switch (_that) {
case _TraitTag() when $default != null:
return $default(_that.traitId,_that.intensity);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TraitTag implements TraitTag {
  const _TraitTag({required this.traitId, required this.intensity});
  factory _TraitTag.fromJson(Map<String, dynamic> json) => _$TraitTagFromJson(json);

@override final  String traitId;
@override final  int intensity;

/// Create a copy of TraitTag
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TraitTagCopyWith<_TraitTag> get copyWith => __$TraitTagCopyWithImpl<_TraitTag>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TraitTagToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TraitTag&&(identical(other.traitId, traitId) || other.traitId == traitId)&&(identical(other.intensity, intensity) || other.intensity == intensity));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,traitId,intensity);
}

@override
String toString() {
    return 'TraitTag(traitId: $traitId, intensity: $intensity)';
}


}

/// @nodoc
abstract mixin class _$TraitTagCopyWith<$Res> implements $TraitTagCopyWith<$Res> {
  factory _$TraitTagCopyWith(_TraitTag value, $Res Function(_TraitTag) _then) = __$TraitTagCopyWithImpl;
@override @useResult
$Res call({
 String traitId, int intensity
});




}
/// @nodoc
class __$TraitTagCopyWithImpl<$Res>
    implements _$TraitTagCopyWith<$Res> {
  __$TraitTagCopyWithImpl(this._self, this._then);

  final _TraitTag _self;
  final $Res Function(_TraitTag) _then;

/// Create a copy of TraitTag
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? traitId = null,Object? intensity = null,}) {
  return _then(_TraitTag(
traitId: null == traitId ? _self.traitId : traitId // ignore: cast_nullable_to_non_nullable
as String,intensity: null == intensity ? _self.intensity : intensity // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
