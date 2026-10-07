// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'player.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Player {

 String get id; String get familyName; String get givenName; Gender get gender; String get schoolId; int get grade; PersonalityAxes get personality; List<TraitTag> get traits; AptitudeStats get aptitude; int get academic; int get stamina; MusicBackground get background;
/// Create a copy of Player
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlayerCopyWith<Player> get copyWith => _$PlayerCopyWithImpl<Player>(this as Player, _$identity);

  /// Serializes this Player to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Player;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Player&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.familyName, _this.familyName) || other.familyName == _this.familyName)&&(identical(other.givenName, _this.givenName) || other.givenName == _this.givenName)&&(identical(other.gender, _this.gender) || other.gender == _this.gender)&&(identical(other.schoolId, _this.schoolId) || other.schoolId == _this.schoolId)&&(identical(other.grade, _this.grade) || other.grade == _this.grade)&&(identical(other.personality, _this.personality) || other.personality == _this.personality)&&const DeepCollectionEquality().equals(other.traits, _this.traits)&&(identical(other.aptitude, _this.aptitude) || other.aptitude == _this.aptitude)&&(identical(other.academic, _this.academic) || other.academic == _this.academic)&&(identical(other.stamina, _this.stamina) || other.stamina == _this.stamina)&&(identical(other.background, _this.background) || other.background == _this.background));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Player;
  return Object.hash(runtimeType,_this.id,_this.familyName,_this.givenName,_this.gender,_this.schoolId,_this.grade,_this.personality,const DeepCollectionEquality().hash(_this.traits),_this.aptitude,_this.academic,_this.stamina,_this.background);
}

@override
String toString() {
  final _this = this as Player;
  return 'Player(id: ${_this.id}, familyName: ${_this.familyName}, givenName: ${_this.givenName}, gender: ${_this.gender}, schoolId: ${_this.schoolId}, grade: ${_this.grade}, personality: ${_this.personality}, traits: ${_this.traits}, aptitude: ${_this.aptitude}, academic: ${_this.academic}, stamina: ${_this.stamina}, background: ${_this.background})';
}


}

/// @nodoc
abstract mixin class $PlayerCopyWith<$Res>  {
  factory $PlayerCopyWith(Player value, $Res Function(Player) _then) = _$PlayerCopyWithImpl;
@useResult
$Res call({
 String id, String familyName, String givenName, Gender gender, String schoolId, int grade, PersonalityAxes personality, List<TraitTag> traits, AptitudeStats aptitude, int academic, int stamina, MusicBackground background
});


$PersonalityAxesCopyWith<$Res> get personality;$AptitudeStatsCopyWith<$Res> get aptitude;

}
/// @nodoc
class _$PlayerCopyWithImpl<$Res>
    implements $PlayerCopyWith<$Res> {
  _$PlayerCopyWithImpl(this._self, this._then);

  final Player _self;
  final $Res Function(Player) _then;

/// Create a copy of Player
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? familyName = null,Object? givenName = null,Object? gender = null,Object? schoolId = null,Object? grade = null,Object? personality = null,Object? traits = null,Object? aptitude = null,Object? academic = null,Object? stamina = null,Object? background = null,}) {
  return _then(Player(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,familyName: null == familyName ? _self.familyName : familyName // ignore: cast_nullable_to_non_nullable
as String,givenName: null == givenName ? _self.givenName : givenName // ignore: cast_nullable_to_non_nullable
as String,gender: null == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as Gender,schoolId: null == schoolId ? _self.schoolId : schoolId // ignore: cast_nullable_to_non_nullable
as String,grade: null == grade ? _self.grade : grade // ignore: cast_nullable_to_non_nullable
as int,personality: null == personality ? _self.personality : personality // ignore: cast_nullable_to_non_nullable
as PersonalityAxes,traits: null == traits ? _self.traits : traits // ignore: cast_nullable_to_non_nullable
as List<TraitTag>,aptitude: null == aptitude ? _self.aptitude : aptitude // ignore: cast_nullable_to_non_nullable
as AptitudeStats,academic: null == academic ? _self.academic : academic // ignore: cast_nullable_to_non_nullable
as int,stamina: null == stamina ? _self.stamina : stamina // ignore: cast_nullable_to_non_nullable
as int,background: null == background ? _self.background : background // ignore: cast_nullable_to_non_nullable
as MusicBackground,
  ));
}
/// Create a copy of Player
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PersonalityAxesCopyWith<$Res> get personality {
  
  return $PersonalityAxesCopyWith<$Res>(_self.personality, (value) {
    return _then(_self.copyWith(personality: value));
  });
}/// Create a copy of Player
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AptitudeStatsCopyWith<$Res> get aptitude {
  
  return $AptitudeStatsCopyWith<$Res>(_self.aptitude, (value) {
    return _then(_self.copyWith(aptitude: value));
  });
}
}


/// Adds pattern-matching-related methods to [Player].
extension PlayerPatterns on Player {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Player value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Player() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Player value)  $default,){
final _that = this;
switch (_that) {
case _Player():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Player value)?  $default,){
final _that = this;
switch (_that) {
case _Player() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String familyName,  String givenName,  Gender gender,  String schoolId,  int grade,  PersonalityAxes personality,  List<TraitTag> traits,  AptitudeStats aptitude,  int academic,  int stamina,  MusicBackground background)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Player() when $default != null:
return $default(_that.id,_that.familyName,_that.givenName,_that.gender,_that.schoolId,_that.grade,_that.personality,_that.traits,_that.aptitude,_that.academic,_that.stamina,_that.background);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String familyName,  String givenName,  Gender gender,  String schoolId,  int grade,  PersonalityAxes personality,  List<TraitTag> traits,  AptitudeStats aptitude,  int academic,  int stamina,  MusicBackground background)  $default,) {final _that = this;
switch (_that) {
case _Player():
return $default(_that.id,_that.familyName,_that.givenName,_that.gender,_that.schoolId,_that.grade,_that.personality,_that.traits,_that.aptitude,_that.academic,_that.stamina,_that.background);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String familyName,  String givenName,  Gender gender,  String schoolId,  int grade,  PersonalityAxes personality,  List<TraitTag> traits,  AptitudeStats aptitude,  int academic,  int stamina,  MusicBackground background)?  $default,) {final _that = this;
switch (_that) {
case _Player() when $default != null:
return $default(_that.id,_that.familyName,_that.givenName,_that.gender,_that.schoolId,_that.grade,_that.personality,_that.traits,_that.aptitude,_that.academic,_that.stamina,_that.background);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Player extends Player {
  const _Player({required this.id, required this.familyName, required this.givenName, required this.gender, required this.schoolId, required this.grade, required this.personality, required  List<TraitTag> traits, required this.aptitude, required this.academic, required this.stamina, required this.background}): _traits = traits,super._();
  factory _Player.fromJson(Map<String, dynamic> json) => _$PlayerFromJson(json);

@override final  String id;
@override final  String familyName;
@override final  String givenName;
@override final  Gender gender;
@override final  String schoolId;
@override final  int grade;
@override final  PersonalityAxes personality;
 final  List<TraitTag> _traits;
@override List<TraitTag> get traits {
  if (_traits is EqualUnmodifiableListView) return _traits;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_traits);
}

@override final  AptitudeStats aptitude;
@override final  int academic;
@override final  int stamina;
@override final  MusicBackground background;

/// Create a copy of Player
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlayerCopyWith<_Player> get copyWith => __$PlayerCopyWithImpl<_Player>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PlayerToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Player&&(identical(other.id, id) || other.id == id)&&(identical(other.familyName, familyName) || other.familyName == familyName)&&(identical(other.givenName, givenName) || other.givenName == givenName)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.schoolId, schoolId) || other.schoolId == schoolId)&&(identical(other.grade, grade) || other.grade == grade)&&(identical(other.personality, personality) || other.personality == personality)&&const DeepCollectionEquality().equals(other.traits, _traits)&&(identical(other.aptitude, aptitude) || other.aptitude == aptitude)&&(identical(other.academic, academic) || other.academic == academic)&&(identical(other.stamina, stamina) || other.stamina == stamina)&&(identical(other.background, background) || other.background == background));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,familyName,givenName,gender,schoolId,grade,personality,const DeepCollectionEquality().hash(_traits),aptitude,academic,stamina,background);
}

@override
String toString() {
    return 'Player(id: $id, familyName: $familyName, givenName: $givenName, gender: $gender, schoolId: $schoolId, grade: $grade, personality: $personality, traits: $traits, aptitude: $aptitude, academic: $academic, stamina: $stamina, background: $background)';
}


}

/// @nodoc
abstract mixin class _$PlayerCopyWith<$Res> implements $PlayerCopyWith<$Res> {
  factory _$PlayerCopyWith(_Player value, $Res Function(_Player) _then) = __$PlayerCopyWithImpl;
@override @useResult
$Res call({
 String id, String familyName, String givenName, Gender gender, String schoolId, int grade, PersonalityAxes personality, List<TraitTag> traits, AptitudeStats aptitude, int academic, int stamina, MusicBackground background
});


@override $PersonalityAxesCopyWith<$Res> get personality;@override $AptitudeStatsCopyWith<$Res> get aptitude;

}
/// @nodoc
class __$PlayerCopyWithImpl<$Res>
    implements _$PlayerCopyWith<$Res> {
  __$PlayerCopyWithImpl(this._self, this._then);

  final _Player _self;
  final $Res Function(_Player) _then;

/// Create a copy of Player
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? familyName = null,Object? givenName = null,Object? gender = null,Object? schoolId = null,Object? grade = null,Object? personality = null,Object? traits = null,Object? aptitude = null,Object? academic = null,Object? stamina = null,Object? background = null,}) {
  return _then(_Player(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,familyName: null == familyName ? _self.familyName : familyName // ignore: cast_nullable_to_non_nullable
as String,givenName: null == givenName ? _self.givenName : givenName // ignore: cast_nullable_to_non_nullable
as String,gender: null == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as Gender,schoolId: null == schoolId ? _self.schoolId : schoolId // ignore: cast_nullable_to_non_nullable
as String,grade: null == grade ? _self.grade : grade // ignore: cast_nullable_to_non_nullable
as int,personality: null == personality ? _self.personality : personality // ignore: cast_nullable_to_non_nullable
as PersonalityAxes,traits: null == traits ? _self._traits : traits // ignore: cast_nullable_to_non_nullable
as List<TraitTag>,aptitude: null == aptitude ? _self.aptitude : aptitude // ignore: cast_nullable_to_non_nullable
as AptitudeStats,academic: null == academic ? _self.academic : academic // ignore: cast_nullable_to_non_nullable
as int,stamina: null == stamina ? _self.stamina : stamina // ignore: cast_nullable_to_non_nullable
as int,background: null == background ? _self.background : background // ignore: cast_nullable_to_non_nullable
as MusicBackground,
  ));
}

/// Create a copy of Player
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PersonalityAxesCopyWith<$Res> get personality {
  
  return $PersonalityAxesCopyWith<$Res>(_self.personality, (value) {
    return _then(_self.copyWith(personality: value));
  });
}/// Create a copy of Player
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
