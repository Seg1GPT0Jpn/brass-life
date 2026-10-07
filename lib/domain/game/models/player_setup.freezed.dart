// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'player_setup.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PlayerSetup {

 String get familyName; String get givenName; Gender get gender;/// 入学する中学校。
 String get schoolId; MusicBackground get background; PersonalityAxes get personality;/// 音楽適性（経験による補正を含まない基礎値）。
 AptitudeStats get aptitude;/// 学力（0..100）。
 int get academic;/// 体力（0..100）。
 int get stamina;
/// Create a copy of PlayerSetup
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlayerSetupCopyWith<PlayerSetup> get copyWith => _$PlayerSetupCopyWithImpl<PlayerSetup>(this as PlayerSetup, _$identity);

  /// Serializes this PlayerSetup to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PlayerSetup;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlayerSetup&&(identical(other.familyName, _this.familyName) || other.familyName == _this.familyName)&&(identical(other.givenName, _this.givenName) || other.givenName == _this.givenName)&&(identical(other.gender, _this.gender) || other.gender == _this.gender)&&(identical(other.schoolId, _this.schoolId) || other.schoolId == _this.schoolId)&&(identical(other.background, _this.background) || other.background == _this.background)&&(identical(other.personality, _this.personality) || other.personality == _this.personality)&&(identical(other.aptitude, _this.aptitude) || other.aptitude == _this.aptitude)&&(identical(other.academic, _this.academic) || other.academic == _this.academic)&&(identical(other.stamina, _this.stamina) || other.stamina == _this.stamina));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PlayerSetup;
  return Object.hash(runtimeType,_this.familyName,_this.givenName,_this.gender,_this.schoolId,_this.background,_this.personality,_this.aptitude,_this.academic,_this.stamina);
}

@override
String toString() {
  final _this = this as PlayerSetup;
  return 'PlayerSetup(familyName: ${_this.familyName}, givenName: ${_this.givenName}, gender: ${_this.gender}, schoolId: ${_this.schoolId}, background: ${_this.background}, personality: ${_this.personality}, aptitude: ${_this.aptitude}, academic: ${_this.academic}, stamina: ${_this.stamina})';
}


}

/// @nodoc
abstract mixin class $PlayerSetupCopyWith<$Res>  {
  factory $PlayerSetupCopyWith(PlayerSetup value, $Res Function(PlayerSetup) _then) = _$PlayerSetupCopyWithImpl;
@useResult
$Res call({
 String familyName, String givenName, Gender gender, String schoolId, MusicBackground background, PersonalityAxes personality, AptitudeStats aptitude, int academic, int stamina
});


$PersonalityAxesCopyWith<$Res> get personality;$AptitudeStatsCopyWith<$Res> get aptitude;

}
/// @nodoc
class _$PlayerSetupCopyWithImpl<$Res>
    implements $PlayerSetupCopyWith<$Res> {
  _$PlayerSetupCopyWithImpl(this._self, this._then);

  final PlayerSetup _self;
  final $Res Function(PlayerSetup) _then;

/// Create a copy of PlayerSetup
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? familyName = null,Object? givenName = null,Object? gender = null,Object? schoolId = null,Object? background = null,Object? personality = null,Object? aptitude = null,Object? academic = null,Object? stamina = null,}) {
  return _then(PlayerSetup(
familyName: null == familyName ? _self.familyName : familyName // ignore: cast_nullable_to_non_nullable
as String,givenName: null == givenName ? _self.givenName : givenName // ignore: cast_nullable_to_non_nullable
as String,gender: null == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as Gender,schoolId: null == schoolId ? _self.schoolId : schoolId // ignore: cast_nullable_to_non_nullable
as String,background: null == background ? _self.background : background // ignore: cast_nullable_to_non_nullable
as MusicBackground,personality: null == personality ? _self.personality : personality // ignore: cast_nullable_to_non_nullable
as PersonalityAxes,aptitude: null == aptitude ? _self.aptitude : aptitude // ignore: cast_nullable_to_non_nullable
as AptitudeStats,academic: null == academic ? _self.academic : academic // ignore: cast_nullable_to_non_nullable
as int,stamina: null == stamina ? _self.stamina : stamina // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of PlayerSetup
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PersonalityAxesCopyWith<$Res> get personality {
  
  return $PersonalityAxesCopyWith<$Res>(_self.personality, (value) {
    return _then(_self.copyWith(personality: value));
  });
}/// Create a copy of PlayerSetup
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AptitudeStatsCopyWith<$Res> get aptitude {
  
  return $AptitudeStatsCopyWith<$Res>(_self.aptitude, (value) {
    return _then(_self.copyWith(aptitude: value));
  });
}
}


/// Adds pattern-matching-related methods to [PlayerSetup].
extension PlayerSetupPatterns on PlayerSetup {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PlayerSetup value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PlayerSetup() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PlayerSetup value)  $default,){
final _that = this;
switch (_that) {
case _PlayerSetup():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PlayerSetup value)?  $default,){
final _that = this;
switch (_that) {
case _PlayerSetup() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String familyName,  String givenName,  Gender gender,  String schoolId,  MusicBackground background,  PersonalityAxes personality,  AptitudeStats aptitude,  int academic,  int stamina)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PlayerSetup() when $default != null:
return $default(_that.familyName,_that.givenName,_that.gender,_that.schoolId,_that.background,_that.personality,_that.aptitude,_that.academic,_that.stamina);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String familyName,  String givenName,  Gender gender,  String schoolId,  MusicBackground background,  PersonalityAxes personality,  AptitudeStats aptitude,  int academic,  int stamina)  $default,) {final _that = this;
switch (_that) {
case _PlayerSetup():
return $default(_that.familyName,_that.givenName,_that.gender,_that.schoolId,_that.background,_that.personality,_that.aptitude,_that.academic,_that.stamina);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String familyName,  String givenName,  Gender gender,  String schoolId,  MusicBackground background,  PersonalityAxes personality,  AptitudeStats aptitude,  int academic,  int stamina)?  $default,) {final _that = this;
switch (_that) {
case _PlayerSetup() when $default != null:
return $default(_that.familyName,_that.givenName,_that.gender,_that.schoolId,_that.background,_that.personality,_that.aptitude,_that.academic,_that.stamina);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PlayerSetup extends PlayerSetup {
  const _PlayerSetup({required this.familyName, required this.givenName, required this.gender, required this.schoolId, required this.background, required this.personality, required this.aptitude, required this.academic, required this.stamina}): super._();
  factory _PlayerSetup.fromJson(Map<String, dynamic> json) => _$PlayerSetupFromJson(json);

@override final  String familyName;
@override final  String givenName;
@override final  Gender gender;
/// 入学する中学校。
@override final  String schoolId;
@override final  MusicBackground background;
@override final  PersonalityAxes personality;
/// 音楽適性（経験による補正を含まない基礎値）。
@override final  AptitudeStats aptitude;
/// 学力（0..100）。
@override final  int academic;
/// 体力（0..100）。
@override final  int stamina;

/// Create a copy of PlayerSetup
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlayerSetupCopyWith<_PlayerSetup> get copyWith => __$PlayerSetupCopyWithImpl<_PlayerSetup>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PlayerSetupToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlayerSetup&&(identical(other.familyName, familyName) || other.familyName == familyName)&&(identical(other.givenName, givenName) || other.givenName == givenName)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.schoolId, schoolId) || other.schoolId == schoolId)&&(identical(other.background, background) || other.background == background)&&(identical(other.personality, personality) || other.personality == personality)&&(identical(other.aptitude, aptitude) || other.aptitude == aptitude)&&(identical(other.academic, academic) || other.academic == academic)&&(identical(other.stamina, stamina) || other.stamina == stamina));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,familyName,givenName,gender,schoolId,background,personality,aptitude,academic,stamina);
}

@override
String toString() {
    return 'PlayerSetup(familyName: $familyName, givenName: $givenName, gender: $gender, schoolId: $schoolId, background: $background, personality: $personality, aptitude: $aptitude, academic: $academic, stamina: $stamina)';
}


}

/// @nodoc
abstract mixin class _$PlayerSetupCopyWith<$Res> implements $PlayerSetupCopyWith<$Res> {
  factory _$PlayerSetupCopyWith(_PlayerSetup value, $Res Function(_PlayerSetup) _then) = __$PlayerSetupCopyWithImpl;
@override @useResult
$Res call({
 String familyName, String givenName, Gender gender, String schoolId, MusicBackground background, PersonalityAxes personality, AptitudeStats aptitude, int academic, int stamina
});


@override $PersonalityAxesCopyWith<$Res> get personality;@override $AptitudeStatsCopyWith<$Res> get aptitude;

}
/// @nodoc
class __$PlayerSetupCopyWithImpl<$Res>
    implements _$PlayerSetupCopyWith<$Res> {
  __$PlayerSetupCopyWithImpl(this._self, this._then);

  final _PlayerSetup _self;
  final $Res Function(_PlayerSetup) _then;

/// Create a copy of PlayerSetup
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? familyName = null,Object? givenName = null,Object? gender = null,Object? schoolId = null,Object? background = null,Object? personality = null,Object? aptitude = null,Object? academic = null,Object? stamina = null,}) {
  return _then(_PlayerSetup(
familyName: null == familyName ? _self.familyName : familyName // ignore: cast_nullable_to_non_nullable
as String,givenName: null == givenName ? _self.givenName : givenName // ignore: cast_nullable_to_non_nullable
as String,gender: null == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as Gender,schoolId: null == schoolId ? _self.schoolId : schoolId // ignore: cast_nullable_to_non_nullable
as String,background: null == background ? _self.background : background // ignore: cast_nullable_to_non_nullable
as MusicBackground,personality: null == personality ? _self.personality : personality // ignore: cast_nullable_to_non_nullable
as PersonalityAxes,aptitude: null == aptitude ? _self.aptitude : aptitude // ignore: cast_nullable_to_non_nullable
as AptitudeStats,academic: null == academic ? _self.academic : academic // ignore: cast_nullable_to_non_nullable
as int,stamina: null == stamina ? _self.stamina : stamina // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of PlayerSetup
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PersonalityAxesCopyWith<$Res> get personality {
  
  return $PersonalityAxesCopyWith<$Res>(_self.personality, (value) {
    return _then(_self.copyWith(personality: value));
  });
}/// Create a copy of PlayerSetup
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AptitudeStatsCopyWith<$Res> get aptitude {
  
  return $AptitudeStatsCopyWith<$Res>(_self.aptitude, (value) {
    return _then(_self.copyWith(aptitude: value));
  });
}
}

// dart format on
