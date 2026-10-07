// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'npc.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Npc {

 String get id; String get familyName; String get givenName; Gender get gender; NpcRole get role; String get schoolId;/// 学年（部員のみ 1..3）。
 int? get grade;/// 年齢（大人のみ）。
 int? get age; PersonalityAxes get personality; List<TraitTag> get traits; AptitudeStats get aptitude;/// 学力（0..100）。
 int get academic;/// 体力（0..100）。
 int get stamina; MusicBackground get background;/// 担当楽器（新 1 年生は未決定で null）。
 InstrumentType? get instrument;/// 担当楽器の熟練度（0..1000）。
 int get instrumentSkill;/// 担当楽器が私物か。
 bool get ownsPersonalInstrument;/// 希望楽器（新 1 年生のみ）。
 InstrumentType? get wishInstrument;/// 入学前に担当していた楽器（経験者のみ）。
 InstrumentType? get previousInstrument; int get previousSkill;/// 顧問・外部講師の指導者プロフィール。
 AdvisorProfile? get advisorProfile;
/// Create a copy of Npc
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NpcCopyWith<Npc> get copyWith => _$NpcCopyWithImpl<Npc>(this as Npc, _$identity);

  /// Serializes this Npc to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Npc;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Npc&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.familyName, _this.familyName) || other.familyName == _this.familyName)&&(identical(other.givenName, _this.givenName) || other.givenName == _this.givenName)&&(identical(other.gender, _this.gender) || other.gender == _this.gender)&&(identical(other.role, _this.role) || other.role == _this.role)&&(identical(other.schoolId, _this.schoolId) || other.schoolId == _this.schoolId)&&(identical(other.grade, _this.grade) || other.grade == _this.grade)&&(identical(other.age, _this.age) || other.age == _this.age)&&(identical(other.personality, _this.personality) || other.personality == _this.personality)&&const DeepCollectionEquality().equals(other.traits, _this.traits)&&(identical(other.aptitude, _this.aptitude) || other.aptitude == _this.aptitude)&&(identical(other.academic, _this.academic) || other.academic == _this.academic)&&(identical(other.stamina, _this.stamina) || other.stamina == _this.stamina)&&(identical(other.background, _this.background) || other.background == _this.background)&&(identical(other.instrument, _this.instrument) || other.instrument == _this.instrument)&&(identical(other.instrumentSkill, _this.instrumentSkill) || other.instrumentSkill == _this.instrumentSkill)&&(identical(other.ownsPersonalInstrument, _this.ownsPersonalInstrument) || other.ownsPersonalInstrument == _this.ownsPersonalInstrument)&&(identical(other.wishInstrument, _this.wishInstrument) || other.wishInstrument == _this.wishInstrument)&&(identical(other.previousInstrument, _this.previousInstrument) || other.previousInstrument == _this.previousInstrument)&&(identical(other.previousSkill, _this.previousSkill) || other.previousSkill == _this.previousSkill)&&(identical(other.advisorProfile, _this.advisorProfile) || other.advisorProfile == _this.advisorProfile));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Npc;
  return Object.hashAll([runtimeType,_this.id,_this.familyName,_this.givenName,_this.gender,_this.role,_this.schoolId,_this.grade,_this.age,_this.personality,const DeepCollectionEquality().hash(_this.traits),_this.aptitude,_this.academic,_this.stamina,_this.background,_this.instrument,_this.instrumentSkill,_this.ownsPersonalInstrument,_this.wishInstrument,_this.previousInstrument,_this.previousSkill,_this.advisorProfile]);
}

@override
String toString() {
  final _this = this as Npc;
  return 'Npc(id: ${_this.id}, familyName: ${_this.familyName}, givenName: ${_this.givenName}, gender: ${_this.gender}, role: ${_this.role}, schoolId: ${_this.schoolId}, grade: ${_this.grade}, age: ${_this.age}, personality: ${_this.personality}, traits: ${_this.traits}, aptitude: ${_this.aptitude}, academic: ${_this.academic}, stamina: ${_this.stamina}, background: ${_this.background}, instrument: ${_this.instrument}, instrumentSkill: ${_this.instrumentSkill}, ownsPersonalInstrument: ${_this.ownsPersonalInstrument}, wishInstrument: ${_this.wishInstrument}, previousInstrument: ${_this.previousInstrument}, previousSkill: ${_this.previousSkill}, advisorProfile: ${_this.advisorProfile})';
}


}

/// @nodoc
abstract mixin class $NpcCopyWith<$Res>  {
  factory $NpcCopyWith(Npc value, $Res Function(Npc) _then) = _$NpcCopyWithImpl;
@useResult
$Res call({
 String id, String familyName, String givenName, Gender gender, NpcRole role, String schoolId, int? grade, int? age, PersonalityAxes personality, List<TraitTag> traits, AptitudeStats aptitude, int academic, int stamina, MusicBackground background, InstrumentType? instrument, int instrumentSkill, bool ownsPersonalInstrument, InstrumentType? wishInstrument, InstrumentType? previousInstrument, int previousSkill, AdvisorProfile? advisorProfile
});


$PersonalityAxesCopyWith<$Res> get personality;$AptitudeStatsCopyWith<$Res> get aptitude;$AdvisorProfileCopyWith<$Res>? get advisorProfile;

}
/// @nodoc
class _$NpcCopyWithImpl<$Res>
    implements $NpcCopyWith<$Res> {
  _$NpcCopyWithImpl(this._self, this._then);

  final Npc _self;
  final $Res Function(Npc) _then;

/// Create a copy of Npc
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? familyName = null,Object? givenName = null,Object? gender = null,Object? role = null,Object? schoolId = null,Object? grade = freezed,Object? age = freezed,Object? personality = null,Object? traits = null,Object? aptitude = null,Object? academic = null,Object? stamina = null,Object? background = null,Object? instrument = freezed,Object? instrumentSkill = null,Object? ownsPersonalInstrument = null,Object? wishInstrument = freezed,Object? previousInstrument = freezed,Object? previousSkill = null,Object? advisorProfile = freezed,}) {
  return _then(Npc(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,familyName: null == familyName ? _self.familyName : familyName // ignore: cast_nullable_to_non_nullable
as String,givenName: null == givenName ? _self.givenName : givenName // ignore: cast_nullable_to_non_nullable
as String,gender: null == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as Gender,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as NpcRole,schoolId: null == schoolId ? _self.schoolId : schoolId // ignore: cast_nullable_to_non_nullable
as String,grade: freezed == grade ? _self.grade : grade // ignore: cast_nullable_to_non_nullable
as int?,age: freezed == age ? _self.age : age // ignore: cast_nullable_to_non_nullable
as int?,personality: null == personality ? _self.personality : personality // ignore: cast_nullable_to_non_nullable
as PersonalityAxes,traits: null == traits ? _self.traits : traits // ignore: cast_nullable_to_non_nullable
as List<TraitTag>,aptitude: null == aptitude ? _self.aptitude : aptitude // ignore: cast_nullable_to_non_nullable
as AptitudeStats,academic: null == academic ? _self.academic : academic // ignore: cast_nullable_to_non_nullable
as int,stamina: null == stamina ? _self.stamina : stamina // ignore: cast_nullable_to_non_nullable
as int,background: null == background ? _self.background : background // ignore: cast_nullable_to_non_nullable
as MusicBackground,instrument: freezed == instrument ? _self.instrument : instrument // ignore: cast_nullable_to_non_nullable
as InstrumentType?,instrumentSkill: null == instrumentSkill ? _self.instrumentSkill : instrumentSkill // ignore: cast_nullable_to_non_nullable
as int,ownsPersonalInstrument: null == ownsPersonalInstrument ? _self.ownsPersonalInstrument : ownsPersonalInstrument // ignore: cast_nullable_to_non_nullable
as bool,wishInstrument: freezed == wishInstrument ? _self.wishInstrument : wishInstrument // ignore: cast_nullable_to_non_nullable
as InstrumentType?,previousInstrument: freezed == previousInstrument ? _self.previousInstrument : previousInstrument // ignore: cast_nullable_to_non_nullable
as InstrumentType?,previousSkill: null == previousSkill ? _self.previousSkill : previousSkill // ignore: cast_nullable_to_non_nullable
as int,advisorProfile: freezed == advisorProfile ? _self.advisorProfile : advisorProfile // ignore: cast_nullable_to_non_nullable
as AdvisorProfile?,
  ));
}
/// Create a copy of Npc
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PersonalityAxesCopyWith<$Res> get personality {
  
  return $PersonalityAxesCopyWith<$Res>(_self.personality, (value) {
    return _then(_self.copyWith(personality: value));
  });
}/// Create a copy of Npc
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AptitudeStatsCopyWith<$Res> get aptitude {
  
  return $AptitudeStatsCopyWith<$Res>(_self.aptitude, (value) {
    return _then(_self.copyWith(aptitude: value));
  });
}/// Create a copy of Npc
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AdvisorProfileCopyWith<$Res>? get advisorProfile {
    if (_self.advisorProfile == null) {
    return null;
  }

  return $AdvisorProfileCopyWith<$Res>(_self.advisorProfile!, (value) {
    return _then(_self.copyWith(advisorProfile: value));
  });
}
}


/// Adds pattern-matching-related methods to [Npc].
extension NpcPatterns on Npc {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Npc value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Npc() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Npc value)  $default,){
final _that = this;
switch (_that) {
case _Npc():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Npc value)?  $default,){
final _that = this;
switch (_that) {
case _Npc() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String familyName,  String givenName,  Gender gender,  NpcRole role,  String schoolId,  int? grade,  int? age,  PersonalityAxes personality,  List<TraitTag> traits,  AptitudeStats aptitude,  int academic,  int stamina,  MusicBackground background,  InstrumentType? instrument,  int instrumentSkill,  bool ownsPersonalInstrument,  InstrumentType? wishInstrument,  InstrumentType? previousInstrument,  int previousSkill,  AdvisorProfile? advisorProfile)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Npc() when $default != null:
return $default(_that.id,_that.familyName,_that.givenName,_that.gender,_that.role,_that.schoolId,_that.grade,_that.age,_that.personality,_that.traits,_that.aptitude,_that.academic,_that.stamina,_that.background,_that.instrument,_that.instrumentSkill,_that.ownsPersonalInstrument,_that.wishInstrument,_that.previousInstrument,_that.previousSkill,_that.advisorProfile);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String familyName,  String givenName,  Gender gender,  NpcRole role,  String schoolId,  int? grade,  int? age,  PersonalityAxes personality,  List<TraitTag> traits,  AptitudeStats aptitude,  int academic,  int stamina,  MusicBackground background,  InstrumentType? instrument,  int instrumentSkill,  bool ownsPersonalInstrument,  InstrumentType? wishInstrument,  InstrumentType? previousInstrument,  int previousSkill,  AdvisorProfile? advisorProfile)  $default,) {final _that = this;
switch (_that) {
case _Npc():
return $default(_that.id,_that.familyName,_that.givenName,_that.gender,_that.role,_that.schoolId,_that.grade,_that.age,_that.personality,_that.traits,_that.aptitude,_that.academic,_that.stamina,_that.background,_that.instrument,_that.instrumentSkill,_that.ownsPersonalInstrument,_that.wishInstrument,_that.previousInstrument,_that.previousSkill,_that.advisorProfile);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String familyName,  String givenName,  Gender gender,  NpcRole role,  String schoolId,  int? grade,  int? age,  PersonalityAxes personality,  List<TraitTag> traits,  AptitudeStats aptitude,  int academic,  int stamina,  MusicBackground background,  InstrumentType? instrument,  int instrumentSkill,  bool ownsPersonalInstrument,  InstrumentType? wishInstrument,  InstrumentType? previousInstrument,  int previousSkill,  AdvisorProfile? advisorProfile)?  $default,) {final _that = this;
switch (_that) {
case _Npc() when $default != null:
return $default(_that.id,_that.familyName,_that.givenName,_that.gender,_that.role,_that.schoolId,_that.grade,_that.age,_that.personality,_that.traits,_that.aptitude,_that.academic,_that.stamina,_that.background,_that.instrument,_that.instrumentSkill,_that.ownsPersonalInstrument,_that.wishInstrument,_that.previousInstrument,_that.previousSkill,_that.advisorProfile);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Npc extends Npc {
  const _Npc({required this.id, required this.familyName, required this.givenName, required this.gender, required this.role, required this.schoolId, this.grade, this.age, required this.personality, required  List<TraitTag> traits, required this.aptitude, required this.academic, required this.stamina, required this.background, this.instrument, this.instrumentSkill = 0, this.ownsPersonalInstrument = false, this.wishInstrument, this.previousInstrument, this.previousSkill = 0, this.advisorProfile}): _traits = traits,super._();
  factory _Npc.fromJson(Map<String, dynamic> json) => _$NpcFromJson(json);

@override final  String id;
@override final  String familyName;
@override final  String givenName;
@override final  Gender gender;
@override final  NpcRole role;
@override final  String schoolId;
/// 学年（部員のみ 1..3）。
@override final  int? grade;
/// 年齢（大人のみ）。
@override final  int? age;
@override final  PersonalityAxes personality;
 final  List<TraitTag> _traits;
@override List<TraitTag> get traits {
  if (_traits is EqualUnmodifiableListView) return _traits;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_traits);
}

@override final  AptitudeStats aptitude;
/// 学力（0..100）。
@override final  int academic;
/// 体力（0..100）。
@override final  int stamina;
@override final  MusicBackground background;
/// 担当楽器（新 1 年生は未決定で null）。
@override final  InstrumentType? instrument;
/// 担当楽器の熟練度（0..1000）。
@override@JsonKey() final  int instrumentSkill;
/// 担当楽器が私物か。
@override@JsonKey() final  bool ownsPersonalInstrument;
/// 希望楽器（新 1 年生のみ）。
@override final  InstrumentType? wishInstrument;
/// 入学前に担当していた楽器（経験者のみ）。
@override final  InstrumentType? previousInstrument;
@override@JsonKey() final  int previousSkill;
/// 顧問・外部講師の指導者プロフィール。
@override final  AdvisorProfile? advisorProfile;

/// Create a copy of Npc
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NpcCopyWith<_Npc> get copyWith => __$NpcCopyWithImpl<_Npc>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NpcToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Npc&&(identical(other.id, id) || other.id == id)&&(identical(other.familyName, familyName) || other.familyName == familyName)&&(identical(other.givenName, givenName) || other.givenName == givenName)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.role, role) || other.role == role)&&(identical(other.schoolId, schoolId) || other.schoolId == schoolId)&&(identical(other.grade, grade) || other.grade == grade)&&(identical(other.age, age) || other.age == age)&&(identical(other.personality, personality) || other.personality == personality)&&const DeepCollectionEquality().equals(other.traits, _traits)&&(identical(other.aptitude, aptitude) || other.aptitude == aptitude)&&(identical(other.academic, academic) || other.academic == academic)&&(identical(other.stamina, stamina) || other.stamina == stamina)&&(identical(other.background, background) || other.background == background)&&(identical(other.instrument, instrument) || other.instrument == instrument)&&(identical(other.instrumentSkill, instrumentSkill) || other.instrumentSkill == instrumentSkill)&&(identical(other.ownsPersonalInstrument, ownsPersonalInstrument) || other.ownsPersonalInstrument == ownsPersonalInstrument)&&(identical(other.wishInstrument, wishInstrument) || other.wishInstrument == wishInstrument)&&(identical(other.previousInstrument, previousInstrument) || other.previousInstrument == previousInstrument)&&(identical(other.previousSkill, previousSkill) || other.previousSkill == previousSkill)&&(identical(other.advisorProfile, advisorProfile) || other.advisorProfile == advisorProfile));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hashAll([runtimeType,id,familyName,givenName,gender,role,schoolId,grade,age,personality,const DeepCollectionEquality().hash(_traits),aptitude,academic,stamina,background,instrument,instrumentSkill,ownsPersonalInstrument,wishInstrument,previousInstrument,previousSkill,advisorProfile]);
}

@override
String toString() {
    return 'Npc(id: $id, familyName: $familyName, givenName: $givenName, gender: $gender, role: $role, schoolId: $schoolId, grade: $grade, age: $age, personality: $personality, traits: $traits, aptitude: $aptitude, academic: $academic, stamina: $stamina, background: $background, instrument: $instrument, instrumentSkill: $instrumentSkill, ownsPersonalInstrument: $ownsPersonalInstrument, wishInstrument: $wishInstrument, previousInstrument: $previousInstrument, previousSkill: $previousSkill, advisorProfile: $advisorProfile)';
}


}

/// @nodoc
abstract mixin class _$NpcCopyWith<$Res> implements $NpcCopyWith<$Res> {
  factory _$NpcCopyWith(_Npc value, $Res Function(_Npc) _then) = __$NpcCopyWithImpl;
@override @useResult
$Res call({
 String id, String familyName, String givenName, Gender gender, NpcRole role, String schoolId, int? grade, int? age, PersonalityAxes personality, List<TraitTag> traits, AptitudeStats aptitude, int academic, int stamina, MusicBackground background, InstrumentType? instrument, int instrumentSkill, bool ownsPersonalInstrument, InstrumentType? wishInstrument, InstrumentType? previousInstrument, int previousSkill, AdvisorProfile? advisorProfile
});


@override $PersonalityAxesCopyWith<$Res> get personality;@override $AptitudeStatsCopyWith<$Res> get aptitude;@override $AdvisorProfileCopyWith<$Res>? get advisorProfile;

}
/// @nodoc
class __$NpcCopyWithImpl<$Res>
    implements _$NpcCopyWith<$Res> {
  __$NpcCopyWithImpl(this._self, this._then);

  final _Npc _self;
  final $Res Function(_Npc) _then;

/// Create a copy of Npc
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? familyName = null,Object? givenName = null,Object? gender = null,Object? role = null,Object? schoolId = null,Object? grade = freezed,Object? age = freezed,Object? personality = null,Object? traits = null,Object? aptitude = null,Object? academic = null,Object? stamina = null,Object? background = null,Object? instrument = freezed,Object? instrumentSkill = null,Object? ownsPersonalInstrument = null,Object? wishInstrument = freezed,Object? previousInstrument = freezed,Object? previousSkill = null,Object? advisorProfile = freezed,}) {
  return _then(_Npc(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,familyName: null == familyName ? _self.familyName : familyName // ignore: cast_nullable_to_non_nullable
as String,givenName: null == givenName ? _self.givenName : givenName // ignore: cast_nullable_to_non_nullable
as String,gender: null == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as Gender,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as NpcRole,schoolId: null == schoolId ? _self.schoolId : schoolId // ignore: cast_nullable_to_non_nullable
as String,grade: freezed == grade ? _self.grade : grade // ignore: cast_nullable_to_non_nullable
as int?,age: freezed == age ? _self.age : age // ignore: cast_nullable_to_non_nullable
as int?,personality: null == personality ? _self.personality : personality // ignore: cast_nullable_to_non_nullable
as PersonalityAxes,traits: null == traits ? _self._traits : traits // ignore: cast_nullable_to_non_nullable
as List<TraitTag>,aptitude: null == aptitude ? _self.aptitude : aptitude // ignore: cast_nullable_to_non_nullable
as AptitudeStats,academic: null == academic ? _self.academic : academic // ignore: cast_nullable_to_non_nullable
as int,stamina: null == stamina ? _self.stamina : stamina // ignore: cast_nullable_to_non_nullable
as int,background: null == background ? _self.background : background // ignore: cast_nullable_to_non_nullable
as MusicBackground,instrument: freezed == instrument ? _self.instrument : instrument // ignore: cast_nullable_to_non_nullable
as InstrumentType?,instrumentSkill: null == instrumentSkill ? _self.instrumentSkill : instrumentSkill // ignore: cast_nullable_to_non_nullable
as int,ownsPersonalInstrument: null == ownsPersonalInstrument ? _self.ownsPersonalInstrument : ownsPersonalInstrument // ignore: cast_nullable_to_non_nullable
as bool,wishInstrument: freezed == wishInstrument ? _self.wishInstrument : wishInstrument // ignore: cast_nullable_to_non_nullable
as InstrumentType?,previousInstrument: freezed == previousInstrument ? _self.previousInstrument : previousInstrument // ignore: cast_nullable_to_non_nullable
as InstrumentType?,previousSkill: null == previousSkill ? _self.previousSkill : previousSkill // ignore: cast_nullable_to_non_nullable
as int,advisorProfile: freezed == advisorProfile ? _self.advisorProfile : advisorProfile // ignore: cast_nullable_to_non_nullable
as AdvisorProfile?,
  ));
}

/// Create a copy of Npc
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PersonalityAxesCopyWith<$Res> get personality {
  
  return $PersonalityAxesCopyWith<$Res>(_self.personality, (value) {
    return _then(_self.copyWith(personality: value));
  });
}/// Create a copy of Npc
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AptitudeStatsCopyWith<$Res> get aptitude {
  
  return $AptitudeStatsCopyWith<$Res>(_self.aptitude, (value) {
    return _then(_self.copyWith(aptitude: value));
  });
}/// Create a copy of Npc
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AdvisorProfileCopyWith<$Res>? get advisorProfile {
    if (_self.advisorProfile == null) {
    return null;
  }

  return $AdvisorProfileCopyWith<$Res>(_self.advisorProfile!, (value) {
    return _then(_self.copyWith(advisorProfile: value));
  });
}
}


/// @nodoc
mixin _$AdvisorProfile {

 AdvisorStyle get style;/// 指導力（0..100）。
 int get teachingSkill;/// 熱意（0..100）。
 int get passion;/// 指導歴（年）。
 int get careerYears;/// 現任校での在任年数（1 = 今年度着任）。
 int get yearsAtSchool;/// 専門の楽器系統。
 InstrumentFamily get specialty;
/// Create a copy of AdvisorProfile
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AdvisorProfileCopyWith<AdvisorProfile> get copyWith => _$AdvisorProfileCopyWithImpl<AdvisorProfile>(this as AdvisorProfile, _$identity);

  /// Serializes this AdvisorProfile to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as AdvisorProfile;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AdvisorProfile&&(identical(other.style, _this.style) || other.style == _this.style)&&(identical(other.teachingSkill, _this.teachingSkill) || other.teachingSkill == _this.teachingSkill)&&(identical(other.passion, _this.passion) || other.passion == _this.passion)&&(identical(other.careerYears, _this.careerYears) || other.careerYears == _this.careerYears)&&(identical(other.yearsAtSchool, _this.yearsAtSchool) || other.yearsAtSchool == _this.yearsAtSchool)&&(identical(other.specialty, _this.specialty) || other.specialty == _this.specialty));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as AdvisorProfile;
  return Object.hash(runtimeType,_this.style,_this.teachingSkill,_this.passion,_this.careerYears,_this.yearsAtSchool,_this.specialty);
}

@override
String toString() {
  final _this = this as AdvisorProfile;
  return 'AdvisorProfile(style: ${_this.style}, teachingSkill: ${_this.teachingSkill}, passion: ${_this.passion}, careerYears: ${_this.careerYears}, yearsAtSchool: ${_this.yearsAtSchool}, specialty: ${_this.specialty})';
}


}

/// @nodoc
abstract mixin class $AdvisorProfileCopyWith<$Res>  {
  factory $AdvisorProfileCopyWith(AdvisorProfile value, $Res Function(AdvisorProfile) _then) = _$AdvisorProfileCopyWithImpl;
@useResult
$Res call({
 AdvisorStyle style, int teachingSkill, int passion, int careerYears, int yearsAtSchool, InstrumentFamily specialty
});




}
/// @nodoc
class _$AdvisorProfileCopyWithImpl<$Res>
    implements $AdvisorProfileCopyWith<$Res> {
  _$AdvisorProfileCopyWithImpl(this._self, this._then);

  final AdvisorProfile _self;
  final $Res Function(AdvisorProfile) _then;

/// Create a copy of AdvisorProfile
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? style = null,Object? teachingSkill = null,Object? passion = null,Object? careerYears = null,Object? yearsAtSchool = null,Object? specialty = null,}) {
  return _then(AdvisorProfile(
style: null == style ? _self.style : style // ignore: cast_nullable_to_non_nullable
as AdvisorStyle,teachingSkill: null == teachingSkill ? _self.teachingSkill : teachingSkill // ignore: cast_nullable_to_non_nullable
as int,passion: null == passion ? _self.passion : passion // ignore: cast_nullable_to_non_nullable
as int,careerYears: null == careerYears ? _self.careerYears : careerYears // ignore: cast_nullable_to_non_nullable
as int,yearsAtSchool: null == yearsAtSchool ? _self.yearsAtSchool : yearsAtSchool // ignore: cast_nullable_to_non_nullable
as int,specialty: null == specialty ? _self.specialty : specialty // ignore: cast_nullable_to_non_nullable
as InstrumentFamily,
  ));
}

}


/// Adds pattern-matching-related methods to [AdvisorProfile].
extension AdvisorProfilePatterns on AdvisorProfile {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AdvisorProfile value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AdvisorProfile() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AdvisorProfile value)  $default,){
final _that = this;
switch (_that) {
case _AdvisorProfile():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AdvisorProfile value)?  $default,){
final _that = this;
switch (_that) {
case _AdvisorProfile() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( AdvisorStyle style,  int teachingSkill,  int passion,  int careerYears,  int yearsAtSchool,  InstrumentFamily specialty)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AdvisorProfile() when $default != null:
return $default(_that.style,_that.teachingSkill,_that.passion,_that.careerYears,_that.yearsAtSchool,_that.specialty);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( AdvisorStyle style,  int teachingSkill,  int passion,  int careerYears,  int yearsAtSchool,  InstrumentFamily specialty)  $default,) {final _that = this;
switch (_that) {
case _AdvisorProfile():
return $default(_that.style,_that.teachingSkill,_that.passion,_that.careerYears,_that.yearsAtSchool,_that.specialty);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( AdvisorStyle style,  int teachingSkill,  int passion,  int careerYears,  int yearsAtSchool,  InstrumentFamily specialty)?  $default,) {final _that = this;
switch (_that) {
case _AdvisorProfile() when $default != null:
return $default(_that.style,_that.teachingSkill,_that.passion,_that.careerYears,_that.yearsAtSchool,_that.specialty);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AdvisorProfile extends AdvisorProfile {
  const _AdvisorProfile({required this.style, required this.teachingSkill, required this.passion, required this.careerYears, required this.yearsAtSchool, required this.specialty}): super._();
  factory _AdvisorProfile.fromJson(Map<String, dynamic> json) => _$AdvisorProfileFromJson(json);

@override final  AdvisorStyle style;
/// 指導力（0..100）。
@override final  int teachingSkill;
/// 熱意（0..100）。
@override final  int passion;
/// 指導歴（年）。
@override final  int careerYears;
/// 現任校での在任年数（1 = 今年度着任）。
@override final  int yearsAtSchool;
/// 専門の楽器系統。
@override final  InstrumentFamily specialty;

/// Create a copy of AdvisorProfile
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AdvisorProfileCopyWith<_AdvisorProfile> get copyWith => __$AdvisorProfileCopyWithImpl<_AdvisorProfile>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AdvisorProfileToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AdvisorProfile&&(identical(other.style, style) || other.style == style)&&(identical(other.teachingSkill, teachingSkill) || other.teachingSkill == teachingSkill)&&(identical(other.passion, passion) || other.passion == passion)&&(identical(other.careerYears, careerYears) || other.careerYears == careerYears)&&(identical(other.yearsAtSchool, yearsAtSchool) || other.yearsAtSchool == yearsAtSchool)&&(identical(other.specialty, specialty) || other.specialty == specialty));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,style,teachingSkill,passion,careerYears,yearsAtSchool,specialty);
}

@override
String toString() {
    return 'AdvisorProfile(style: $style, teachingSkill: $teachingSkill, passion: $passion, careerYears: $careerYears, yearsAtSchool: $yearsAtSchool, specialty: $specialty)';
}


}

/// @nodoc
abstract mixin class _$AdvisorProfileCopyWith<$Res> implements $AdvisorProfileCopyWith<$Res> {
  factory _$AdvisorProfileCopyWith(_AdvisorProfile value, $Res Function(_AdvisorProfile) _then) = __$AdvisorProfileCopyWithImpl;
@override @useResult
$Res call({
 AdvisorStyle style, int teachingSkill, int passion, int careerYears, int yearsAtSchool, InstrumentFamily specialty
});




}
/// @nodoc
class __$AdvisorProfileCopyWithImpl<$Res>
    implements _$AdvisorProfileCopyWith<$Res> {
  __$AdvisorProfileCopyWithImpl(this._self, this._then);

  final _AdvisorProfile _self;
  final $Res Function(_AdvisorProfile) _then;

/// Create a copy of AdvisorProfile
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? style = null,Object? teachingSkill = null,Object? passion = null,Object? careerYears = null,Object? yearsAtSchool = null,Object? specialty = null,}) {
  return _then(_AdvisorProfile(
style: null == style ? _self.style : style // ignore: cast_nullable_to_non_nullable
as AdvisorStyle,teachingSkill: null == teachingSkill ? _self.teachingSkill : teachingSkill // ignore: cast_nullable_to_non_nullable
as int,passion: null == passion ? _self.passion : passion // ignore: cast_nullable_to_non_nullable
as int,careerYears: null == careerYears ? _self.careerYears : careerYears // ignore: cast_nullable_to_non_nullable
as int,yearsAtSchool: null == yearsAtSchool ? _self.yearsAtSchool : yearsAtSchool // ignore: cast_nullable_to_non_nullable
as int,specialty: null == specialty ? _self.specialty : specialty // ignore: cast_nullable_to_non_nullable
as InstrumentFamily,
  ));
}


}

// dart format on
