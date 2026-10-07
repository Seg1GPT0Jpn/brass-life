// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'game_date.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GameDate {

/// ゲーム開始週を 0 とする通算ターン番号（開始前の過去の出来事は負数）。
 int get turn;/// その週の月曜日の西暦年・月・日。
 int get year; int get month; int get day;/// 月内の第何週か（1 始まり）。
 int get weekOfMonth;/// その月の週数（4 または 5）。
 int get weeksInMonth;/// ゲーム開始年度を 0 とする年度インデックス（0〜2: 中学、3〜5: 高校）。
 int get academicYearIndex;/// 年度内の第何週か（1 始まり）。
 int get weekOfAcademicYear;
/// Create a copy of GameDate
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GameDateCopyWith<GameDate> get copyWith => _$GameDateCopyWithImpl<GameDate>(this as GameDate, _$identity);

  /// Serializes this GameDate to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as GameDate;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GameDate&&(identical(other.turn, _this.turn) || other.turn == _this.turn)&&(identical(other.year, _this.year) || other.year == _this.year)&&(identical(other.month, _this.month) || other.month == _this.month)&&(identical(other.day, _this.day) || other.day == _this.day)&&(identical(other.weekOfMonth, _this.weekOfMonth) || other.weekOfMonth == _this.weekOfMonth)&&(identical(other.weeksInMonth, _this.weeksInMonth) || other.weeksInMonth == _this.weeksInMonth)&&(identical(other.academicYearIndex, _this.academicYearIndex) || other.academicYearIndex == _this.academicYearIndex)&&(identical(other.weekOfAcademicYear, _this.weekOfAcademicYear) || other.weekOfAcademicYear == _this.weekOfAcademicYear));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as GameDate;
  return Object.hash(runtimeType,_this.turn,_this.year,_this.month,_this.day,_this.weekOfMonth,_this.weeksInMonth,_this.academicYearIndex,_this.weekOfAcademicYear);
}

@override
String toString() {
  final _this = this as GameDate;
  return 'GameDate(turn: ${_this.turn}, year: ${_this.year}, month: ${_this.month}, day: ${_this.day}, weekOfMonth: ${_this.weekOfMonth}, weeksInMonth: ${_this.weeksInMonth}, academicYearIndex: ${_this.academicYearIndex}, weekOfAcademicYear: ${_this.weekOfAcademicYear})';
}


}

/// @nodoc
abstract mixin class $GameDateCopyWith<$Res>  {
  factory $GameDateCopyWith(GameDate value, $Res Function(GameDate) _then) = _$GameDateCopyWithImpl;
@useResult
$Res call({
 int turn, int year, int month, int day, int weekOfMonth, int weeksInMonth, int academicYearIndex, int weekOfAcademicYear
});




}
/// @nodoc
class _$GameDateCopyWithImpl<$Res>
    implements $GameDateCopyWith<$Res> {
  _$GameDateCopyWithImpl(this._self, this._then);

  final GameDate _self;
  final $Res Function(GameDate) _then;

/// Create a copy of GameDate
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? turn = null,Object? year = null,Object? month = null,Object? day = null,Object? weekOfMonth = null,Object? weeksInMonth = null,Object? academicYearIndex = null,Object? weekOfAcademicYear = null,}) {
  return _then(GameDate(
turn: null == turn ? _self.turn : turn // ignore: cast_nullable_to_non_nullable
as int,year: null == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int,month: null == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as int,day: null == day ? _self.day : day // ignore: cast_nullable_to_non_nullable
as int,weekOfMonth: null == weekOfMonth ? _self.weekOfMonth : weekOfMonth // ignore: cast_nullable_to_non_nullable
as int,weeksInMonth: null == weeksInMonth ? _self.weeksInMonth : weeksInMonth // ignore: cast_nullable_to_non_nullable
as int,academicYearIndex: null == academicYearIndex ? _self.academicYearIndex : academicYearIndex // ignore: cast_nullable_to_non_nullable
as int,weekOfAcademicYear: null == weekOfAcademicYear ? _self.weekOfAcademicYear : weekOfAcademicYear // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [GameDate].
extension GameDatePatterns on GameDate {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GameDate value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GameDate() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GameDate value)  $default,){
final _that = this;
switch (_that) {
case _GameDate():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GameDate value)?  $default,){
final _that = this;
switch (_that) {
case _GameDate() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int turn,  int year,  int month,  int day,  int weekOfMonth,  int weeksInMonth,  int academicYearIndex,  int weekOfAcademicYear)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GameDate() when $default != null:
return $default(_that.turn,_that.year,_that.month,_that.day,_that.weekOfMonth,_that.weeksInMonth,_that.academicYearIndex,_that.weekOfAcademicYear);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int turn,  int year,  int month,  int day,  int weekOfMonth,  int weeksInMonth,  int academicYearIndex,  int weekOfAcademicYear)  $default,) {final _that = this;
switch (_that) {
case _GameDate():
return $default(_that.turn,_that.year,_that.month,_that.day,_that.weekOfMonth,_that.weeksInMonth,_that.academicYearIndex,_that.weekOfAcademicYear);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int turn,  int year,  int month,  int day,  int weekOfMonth,  int weeksInMonth,  int academicYearIndex,  int weekOfAcademicYear)?  $default,) {final _that = this;
switch (_that) {
case _GameDate() when $default != null:
return $default(_that.turn,_that.year,_that.month,_that.day,_that.weekOfMonth,_that.weeksInMonth,_that.academicYearIndex,_that.weekOfAcademicYear);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GameDate extends GameDate {
  const _GameDate({required this.turn, required this.year, required this.month, required this.day, required this.weekOfMonth, required this.weeksInMonth, required this.academicYearIndex, required this.weekOfAcademicYear}): super._();
  factory _GameDate.fromJson(Map<String, dynamic> json) => _$GameDateFromJson(json);

/// ゲーム開始週を 0 とする通算ターン番号（開始前の過去の出来事は負数）。
@override final  int turn;
/// その週の月曜日の西暦年・月・日。
@override final  int year;
@override final  int month;
@override final  int day;
/// 月内の第何週か（1 始まり）。
@override final  int weekOfMonth;
/// その月の週数（4 または 5）。
@override final  int weeksInMonth;
/// ゲーム開始年度を 0 とする年度インデックス（0〜2: 中学、3〜5: 高校）。
@override final  int academicYearIndex;
/// 年度内の第何週か（1 始まり）。
@override final  int weekOfAcademicYear;

/// Create a copy of GameDate
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GameDateCopyWith<_GameDate> get copyWith => __$GameDateCopyWithImpl<_GameDate>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GameDateToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _GameDate&&(identical(other.turn, turn) || other.turn == turn)&&(identical(other.year, year) || other.year == year)&&(identical(other.month, month) || other.month == month)&&(identical(other.day, day) || other.day == day)&&(identical(other.weekOfMonth, weekOfMonth) || other.weekOfMonth == weekOfMonth)&&(identical(other.weeksInMonth, weeksInMonth) || other.weeksInMonth == weeksInMonth)&&(identical(other.academicYearIndex, academicYearIndex) || other.academicYearIndex == academicYearIndex)&&(identical(other.weekOfAcademicYear, weekOfAcademicYear) || other.weekOfAcademicYear == weekOfAcademicYear));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,turn,year,month,day,weekOfMonth,weeksInMonth,academicYearIndex,weekOfAcademicYear);
}

@override
String toString() {
    return 'GameDate(turn: $turn, year: $year, month: $month, day: $day, weekOfMonth: $weekOfMonth, weeksInMonth: $weeksInMonth, academicYearIndex: $academicYearIndex, weekOfAcademicYear: $weekOfAcademicYear)';
}


}

/// @nodoc
abstract mixin class _$GameDateCopyWith<$Res> implements $GameDateCopyWith<$Res> {
  factory _$GameDateCopyWith(_GameDate value, $Res Function(_GameDate) _then) = __$GameDateCopyWithImpl;
@override @useResult
$Res call({
 int turn, int year, int month, int day, int weekOfMonth, int weeksInMonth, int academicYearIndex, int weekOfAcademicYear
});




}
/// @nodoc
class __$GameDateCopyWithImpl<$Res>
    implements _$GameDateCopyWith<$Res> {
  __$GameDateCopyWithImpl(this._self, this._then);

  final _GameDate _self;
  final $Res Function(_GameDate) _then;

/// Create a copy of GameDate
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? turn = null,Object? year = null,Object? month = null,Object? day = null,Object? weekOfMonth = null,Object? weeksInMonth = null,Object? academicYearIndex = null,Object? weekOfAcademicYear = null,}) {
  return _then(_GameDate(
turn: null == turn ? _self.turn : turn // ignore: cast_nullable_to_non_nullable
as int,year: null == year ? _self.year : year // ignore: cast_nullable_to_non_nullable
as int,month: null == month ? _self.month : month // ignore: cast_nullable_to_non_nullable
as int,day: null == day ? _self.day : day // ignore: cast_nullable_to_non_nullable
as int,weekOfMonth: null == weekOfMonth ? _self.weekOfMonth : weekOfMonth // ignore: cast_nullable_to_non_nullable
as int,weeksInMonth: null == weeksInMonth ? _self.weeksInMonth : weeksInMonth // ignore: cast_nullable_to_non_nullable
as int,academicYearIndex: null == academicYearIndex ? _self.academicYearIndex : academicYearIndex // ignore: cast_nullable_to_non_nullable
as int,weekOfAcademicYear: null == weekOfAcademicYear ? _self.weekOfAcademicYear : weekOfAcademicYear // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
