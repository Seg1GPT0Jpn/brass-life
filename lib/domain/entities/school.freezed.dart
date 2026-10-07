// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'school.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$School {

 String get id; String get name; SchoolLevel get level; SchoolOwnership get ownership; String get districtId; String get town; int get foundedYear; int get studentCount;/// 偏差値（高校のみ。中学は null）。
 int? get deviation;/// 学力水準（0..100、平均 50）。中学では偏差値の代わりに用いる。
 int get academicLevel; List<SchoolCulture> get cultures; String get clubId;/// 女子校か。
 bool get girlsOnly;/// 中高一貫の相手校 ID（私立の系列校のみ）。
 String? get affiliatedSchoolId;
/// Create a copy of School
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SchoolCopyWith<School> get copyWith => _$SchoolCopyWithImpl<School>(this as School, _$identity);

  /// Serializes this School to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as School;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is School&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.level, _this.level) || other.level == _this.level)&&(identical(other.ownership, _this.ownership) || other.ownership == _this.ownership)&&(identical(other.districtId, _this.districtId) || other.districtId == _this.districtId)&&(identical(other.town, _this.town) || other.town == _this.town)&&(identical(other.foundedYear, _this.foundedYear) || other.foundedYear == _this.foundedYear)&&(identical(other.studentCount, _this.studentCount) || other.studentCount == _this.studentCount)&&(identical(other.deviation, _this.deviation) || other.deviation == _this.deviation)&&(identical(other.academicLevel, _this.academicLevel) || other.academicLevel == _this.academicLevel)&&const DeepCollectionEquality().equals(other.cultures, _this.cultures)&&(identical(other.clubId, _this.clubId) || other.clubId == _this.clubId)&&(identical(other.girlsOnly, _this.girlsOnly) || other.girlsOnly == _this.girlsOnly)&&(identical(other.affiliatedSchoolId, _this.affiliatedSchoolId) || other.affiliatedSchoolId == _this.affiliatedSchoolId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as School;
  return Object.hash(runtimeType,_this.id,_this.name,_this.level,_this.ownership,_this.districtId,_this.town,_this.foundedYear,_this.studentCount,_this.deviation,_this.academicLevel,const DeepCollectionEquality().hash(_this.cultures),_this.clubId,_this.girlsOnly,_this.affiliatedSchoolId);
}

@override
String toString() {
  final _this = this as School;
  return 'School(id: ${_this.id}, name: ${_this.name}, level: ${_this.level}, ownership: ${_this.ownership}, districtId: ${_this.districtId}, town: ${_this.town}, foundedYear: ${_this.foundedYear}, studentCount: ${_this.studentCount}, deviation: ${_this.deviation}, academicLevel: ${_this.academicLevel}, cultures: ${_this.cultures}, clubId: ${_this.clubId}, girlsOnly: ${_this.girlsOnly}, affiliatedSchoolId: ${_this.affiliatedSchoolId})';
}


}

/// @nodoc
abstract mixin class $SchoolCopyWith<$Res>  {
  factory $SchoolCopyWith(School value, $Res Function(School) _then) = _$SchoolCopyWithImpl;
@useResult
$Res call({
 String id, String name, SchoolLevel level, SchoolOwnership ownership, String districtId, String town, int foundedYear, int studentCount, int? deviation, int academicLevel, List<SchoolCulture> cultures, String clubId, bool girlsOnly, String? affiliatedSchoolId
});




}
/// @nodoc
class _$SchoolCopyWithImpl<$Res>
    implements $SchoolCopyWith<$Res> {
  _$SchoolCopyWithImpl(this._self, this._then);

  final School _self;
  final $Res Function(School) _then;

/// Create a copy of School
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? level = null,Object? ownership = null,Object? districtId = null,Object? town = null,Object? foundedYear = null,Object? studentCount = null,Object? deviation = freezed,Object? academicLevel = null,Object? cultures = null,Object? clubId = null,Object? girlsOnly = null,Object? affiliatedSchoolId = freezed,}) {
  return _then(School(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as SchoolLevel,ownership: null == ownership ? _self.ownership : ownership // ignore: cast_nullable_to_non_nullable
as SchoolOwnership,districtId: null == districtId ? _self.districtId : districtId // ignore: cast_nullable_to_non_nullable
as String,town: null == town ? _self.town : town // ignore: cast_nullable_to_non_nullable
as String,foundedYear: null == foundedYear ? _self.foundedYear : foundedYear // ignore: cast_nullable_to_non_nullable
as int,studentCount: null == studentCount ? _self.studentCount : studentCount // ignore: cast_nullable_to_non_nullable
as int,deviation: freezed == deviation ? _self.deviation : deviation // ignore: cast_nullable_to_non_nullable
as int?,academicLevel: null == academicLevel ? _self.academicLevel : academicLevel // ignore: cast_nullable_to_non_nullable
as int,cultures: null == cultures ? _self.cultures : cultures // ignore: cast_nullable_to_non_nullable
as List<SchoolCulture>,clubId: null == clubId ? _self.clubId : clubId // ignore: cast_nullable_to_non_nullable
as String,girlsOnly: null == girlsOnly ? _self.girlsOnly : girlsOnly // ignore: cast_nullable_to_non_nullable
as bool,affiliatedSchoolId: freezed == affiliatedSchoolId ? _self.affiliatedSchoolId : affiliatedSchoolId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [School].
extension SchoolPatterns on School {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _School value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _School() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _School value)  $default,){
final _that = this;
switch (_that) {
case _School():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _School value)?  $default,){
final _that = this;
switch (_that) {
case _School() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  SchoolLevel level,  SchoolOwnership ownership,  String districtId,  String town,  int foundedYear,  int studentCount,  int? deviation,  int academicLevel,  List<SchoolCulture> cultures,  String clubId,  bool girlsOnly,  String? affiliatedSchoolId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _School() when $default != null:
return $default(_that.id,_that.name,_that.level,_that.ownership,_that.districtId,_that.town,_that.foundedYear,_that.studentCount,_that.deviation,_that.academicLevel,_that.cultures,_that.clubId,_that.girlsOnly,_that.affiliatedSchoolId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  SchoolLevel level,  SchoolOwnership ownership,  String districtId,  String town,  int foundedYear,  int studentCount,  int? deviation,  int academicLevel,  List<SchoolCulture> cultures,  String clubId,  bool girlsOnly,  String? affiliatedSchoolId)  $default,) {final _that = this;
switch (_that) {
case _School():
return $default(_that.id,_that.name,_that.level,_that.ownership,_that.districtId,_that.town,_that.foundedYear,_that.studentCount,_that.deviation,_that.academicLevel,_that.cultures,_that.clubId,_that.girlsOnly,_that.affiliatedSchoolId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  SchoolLevel level,  SchoolOwnership ownership,  String districtId,  String town,  int foundedYear,  int studentCount,  int? deviation,  int academicLevel,  List<SchoolCulture> cultures,  String clubId,  bool girlsOnly,  String? affiliatedSchoolId)?  $default,) {final _that = this;
switch (_that) {
case _School() when $default != null:
return $default(_that.id,_that.name,_that.level,_that.ownership,_that.districtId,_that.town,_that.foundedYear,_that.studentCount,_that.deviation,_that.academicLevel,_that.cultures,_that.clubId,_that.girlsOnly,_that.affiliatedSchoolId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _School extends School {
  const _School({required this.id, required this.name, required this.level, required this.ownership, required this.districtId, required this.town, required this.foundedYear, required this.studentCount, this.deviation, required this.academicLevel, required  List<SchoolCulture> cultures, required this.clubId, this.girlsOnly = false, this.affiliatedSchoolId}): _cultures = cultures,super._();
  factory _School.fromJson(Map<String, dynamic> json) => _$SchoolFromJson(json);

@override final  String id;
@override final  String name;
@override final  SchoolLevel level;
@override final  SchoolOwnership ownership;
@override final  String districtId;
@override final  String town;
@override final  int foundedYear;
@override final  int studentCount;
/// 偏差値（高校のみ。中学は null）。
@override final  int? deviation;
/// 学力水準（0..100、平均 50）。中学では偏差値の代わりに用いる。
@override final  int academicLevel;
 final  List<SchoolCulture> _cultures;
@override List<SchoolCulture> get cultures {
  if (_cultures is EqualUnmodifiableListView) return _cultures;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_cultures);
}

@override final  String clubId;
/// 女子校か。
@override@JsonKey() final  bool girlsOnly;
/// 中高一貫の相手校 ID（私立の系列校のみ）。
@override final  String? affiliatedSchoolId;

/// Create a copy of School
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SchoolCopyWith<_School> get copyWith => __$SchoolCopyWithImpl<_School>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SchoolToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _School&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.level, level) || other.level == level)&&(identical(other.ownership, ownership) || other.ownership == ownership)&&(identical(other.districtId, districtId) || other.districtId == districtId)&&(identical(other.town, town) || other.town == town)&&(identical(other.foundedYear, foundedYear) || other.foundedYear == foundedYear)&&(identical(other.studentCount, studentCount) || other.studentCount == studentCount)&&(identical(other.deviation, deviation) || other.deviation == deviation)&&(identical(other.academicLevel, academicLevel) || other.academicLevel == academicLevel)&&const DeepCollectionEquality().equals(other.cultures, _cultures)&&(identical(other.clubId, clubId) || other.clubId == clubId)&&(identical(other.girlsOnly, girlsOnly) || other.girlsOnly == girlsOnly)&&(identical(other.affiliatedSchoolId, affiliatedSchoolId) || other.affiliatedSchoolId == affiliatedSchoolId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name,level,ownership,districtId,town,foundedYear,studentCount,deviation,academicLevel,const DeepCollectionEquality().hash(_cultures),clubId,girlsOnly,affiliatedSchoolId);
}

@override
String toString() {
    return 'School(id: $id, name: $name, level: $level, ownership: $ownership, districtId: $districtId, town: $town, foundedYear: $foundedYear, studentCount: $studentCount, deviation: $deviation, academicLevel: $academicLevel, cultures: $cultures, clubId: $clubId, girlsOnly: $girlsOnly, affiliatedSchoolId: $affiliatedSchoolId)';
}


}

/// @nodoc
abstract mixin class _$SchoolCopyWith<$Res> implements $SchoolCopyWith<$Res> {
  factory _$SchoolCopyWith(_School value, $Res Function(_School) _then) = __$SchoolCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, SchoolLevel level, SchoolOwnership ownership, String districtId, String town, int foundedYear, int studentCount, int? deviation, int academicLevel, List<SchoolCulture> cultures, String clubId, bool girlsOnly, String? affiliatedSchoolId
});




}
/// @nodoc
class __$SchoolCopyWithImpl<$Res>
    implements _$SchoolCopyWith<$Res> {
  __$SchoolCopyWithImpl(this._self, this._then);

  final _School _self;
  final $Res Function(_School) _then;

/// Create a copy of School
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? level = null,Object? ownership = null,Object? districtId = null,Object? town = null,Object? foundedYear = null,Object? studentCount = null,Object? deviation = freezed,Object? academicLevel = null,Object? cultures = null,Object? clubId = null,Object? girlsOnly = null,Object? affiliatedSchoolId = freezed,}) {
  return _then(_School(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,level: null == level ? _self.level : level // ignore: cast_nullable_to_non_nullable
as SchoolLevel,ownership: null == ownership ? _self.ownership : ownership // ignore: cast_nullable_to_non_nullable
as SchoolOwnership,districtId: null == districtId ? _self.districtId : districtId // ignore: cast_nullable_to_non_nullable
as String,town: null == town ? _self.town : town // ignore: cast_nullable_to_non_nullable
as String,foundedYear: null == foundedYear ? _self.foundedYear : foundedYear // ignore: cast_nullable_to_non_nullable
as int,studentCount: null == studentCount ? _self.studentCount : studentCount // ignore: cast_nullable_to_non_nullable
as int,deviation: freezed == deviation ? _self.deviation : deviation // ignore: cast_nullable_to_non_nullable
as int?,academicLevel: null == academicLevel ? _self.academicLevel : academicLevel // ignore: cast_nullable_to_non_nullable
as int,cultures: null == cultures ? _self._cultures : cultures // ignore: cast_nullable_to_non_nullable
as List<SchoolCulture>,clubId: null == clubId ? _self.clubId : clubId // ignore: cast_nullable_to_non_nullable
as String,girlsOnly: null == girlsOnly ? _self.girlsOnly : girlsOnly // ignore: cast_nullable_to_non_nullable
as bool,affiliatedSchoolId: freezed == affiliatedSchoolId ? _self.affiliatedSchoolId : affiliatedSchoolId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
