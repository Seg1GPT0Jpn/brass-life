// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'region.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Region {

 String get prefectureName;/// 架空の吹奏楽連盟名。
 String get federationName;/// 架空のコンクール名。
 String get contestName;/// 支部大会の支部名（架空）。
 String get blockName; List<District> get districts;
/// Create a copy of Region
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RegionCopyWith<Region> get copyWith => _$RegionCopyWithImpl<Region>(this as Region, _$identity);

  /// Serializes this Region to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Region;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Region&&(identical(other.prefectureName, _this.prefectureName) || other.prefectureName == _this.prefectureName)&&(identical(other.federationName, _this.federationName) || other.federationName == _this.federationName)&&(identical(other.contestName, _this.contestName) || other.contestName == _this.contestName)&&(identical(other.blockName, _this.blockName) || other.blockName == _this.blockName)&&const DeepCollectionEquality().equals(other.districts, _this.districts));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Region;
  return Object.hash(runtimeType,_this.prefectureName,_this.federationName,_this.contestName,_this.blockName,const DeepCollectionEquality().hash(_this.districts));
}

@override
String toString() {
  final _this = this as Region;
  return 'Region(prefectureName: ${_this.prefectureName}, federationName: ${_this.federationName}, contestName: ${_this.contestName}, blockName: ${_this.blockName}, districts: ${_this.districts})';
}


}

/// @nodoc
abstract mixin class $RegionCopyWith<$Res>  {
  factory $RegionCopyWith(Region value, $Res Function(Region) _then) = _$RegionCopyWithImpl;
@useResult
$Res call({
 String prefectureName, String federationName, String contestName, String blockName, List<District> districts
});




}
/// @nodoc
class _$RegionCopyWithImpl<$Res>
    implements $RegionCopyWith<$Res> {
  _$RegionCopyWithImpl(this._self, this._then);

  final Region _self;
  final $Res Function(Region) _then;

/// Create a copy of Region
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? prefectureName = null,Object? federationName = null,Object? contestName = null,Object? blockName = null,Object? districts = null,}) {
  return _then(Region(
prefectureName: null == prefectureName ? _self.prefectureName : prefectureName // ignore: cast_nullable_to_non_nullable
as String,federationName: null == federationName ? _self.federationName : federationName // ignore: cast_nullable_to_non_nullable
as String,contestName: null == contestName ? _self.contestName : contestName // ignore: cast_nullable_to_non_nullable
as String,blockName: null == blockName ? _self.blockName : blockName // ignore: cast_nullable_to_non_nullable
as String,districts: null == districts ? _self.districts : districts // ignore: cast_nullable_to_non_nullable
as List<District>,
  ));
}

}


/// Adds pattern-matching-related methods to [Region].
extension RegionPatterns on Region {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Region value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Region() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Region value)  $default,){
final _that = this;
switch (_that) {
case _Region():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Region value)?  $default,){
final _that = this;
switch (_that) {
case _Region() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String prefectureName,  String federationName,  String contestName,  String blockName,  List<District> districts)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Region() when $default != null:
return $default(_that.prefectureName,_that.federationName,_that.contestName,_that.blockName,_that.districts);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String prefectureName,  String federationName,  String contestName,  String blockName,  List<District> districts)  $default,) {final _that = this;
switch (_that) {
case _Region():
return $default(_that.prefectureName,_that.federationName,_that.contestName,_that.blockName,_that.districts);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String prefectureName,  String federationName,  String contestName,  String blockName,  List<District> districts)?  $default,) {final _that = this;
switch (_that) {
case _Region() when $default != null:
return $default(_that.prefectureName,_that.federationName,_that.contestName,_that.blockName,_that.districts);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Region implements Region {
  const _Region({required this.prefectureName, required this.federationName, required this.contestName, required this.blockName, required  List<District> districts}): _districts = districts;
  factory _Region.fromJson(Map<String, dynamic> json) => _$RegionFromJson(json);

@override final  String prefectureName;
/// 架空の吹奏楽連盟名。
@override final  String federationName;
/// 架空のコンクール名。
@override final  String contestName;
/// 支部大会の支部名（架空）。
@override final  String blockName;
 final  List<District> _districts;
@override List<District> get districts {
  if (_districts is EqualUnmodifiableListView) return _districts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_districts);
}


/// Create a copy of Region
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RegionCopyWith<_Region> get copyWith => __$RegionCopyWithImpl<_Region>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RegionToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Region&&(identical(other.prefectureName, prefectureName) || other.prefectureName == prefectureName)&&(identical(other.federationName, federationName) || other.federationName == federationName)&&(identical(other.contestName, contestName) || other.contestName == contestName)&&(identical(other.blockName, blockName) || other.blockName == blockName)&&const DeepCollectionEquality().equals(other.districts, _districts));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,prefectureName,federationName,contestName,blockName,const DeepCollectionEquality().hash(_districts));
}

@override
String toString() {
    return 'Region(prefectureName: $prefectureName, federationName: $federationName, contestName: $contestName, blockName: $blockName, districts: $districts)';
}


}

/// @nodoc
abstract mixin class _$RegionCopyWith<$Res> implements $RegionCopyWith<$Res> {
  factory _$RegionCopyWith(_Region value, $Res Function(_Region) _then) = __$RegionCopyWithImpl;
@override @useResult
$Res call({
 String prefectureName, String federationName, String contestName, String blockName, List<District> districts
});




}
/// @nodoc
class __$RegionCopyWithImpl<$Res>
    implements _$RegionCopyWith<$Res> {
  __$RegionCopyWithImpl(this._self, this._then);

  final _Region _self;
  final $Res Function(_Region) _then;

/// Create a copy of Region
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? prefectureName = null,Object? federationName = null,Object? contestName = null,Object? blockName = null,Object? districts = null,}) {
  return _then(_Region(
prefectureName: null == prefectureName ? _self.prefectureName : prefectureName // ignore: cast_nullable_to_non_nullable
as String,federationName: null == federationName ? _self.federationName : federationName // ignore: cast_nullable_to_non_nullable
as String,contestName: null == contestName ? _self.contestName : contestName // ignore: cast_nullable_to_non_nullable
as String,blockName: null == blockName ? _self.blockName : blockName // ignore: cast_nullable_to_non_nullable
as String,districts: null == districts ? _self._districts : districts // ignore: cast_nullable_to_non_nullable
as List<District>,
  ));
}


}


/// @nodoc
mixin _$District {

 String get id; String get name;/// 地区内の架空の市町名。
 List<String> get towns;
/// Create a copy of District
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DistrictCopyWith<District> get copyWith => _$DistrictCopyWithImpl<District>(this as District, _$identity);

  /// Serializes this District to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as District;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is District&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&const DeepCollectionEquality().equals(other.towns, _this.towns));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as District;
  return Object.hash(runtimeType,_this.id,_this.name,const DeepCollectionEquality().hash(_this.towns));
}

@override
String toString() {
  final _this = this as District;
  return 'District(id: ${_this.id}, name: ${_this.name}, towns: ${_this.towns})';
}


}

/// @nodoc
abstract mixin class $DistrictCopyWith<$Res>  {
  factory $DistrictCopyWith(District value, $Res Function(District) _then) = _$DistrictCopyWithImpl;
@useResult
$Res call({
 String id, String name, List<String> towns
});




}
/// @nodoc
class _$DistrictCopyWithImpl<$Res>
    implements $DistrictCopyWith<$Res> {
  _$DistrictCopyWithImpl(this._self, this._then);

  final District _self;
  final $Res Function(District) _then;

/// Create a copy of District
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? towns = null,}) {
  return _then(District(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,towns: null == towns ? _self.towns : towns // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [District].
extension DistrictPatterns on District {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _District value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _District() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _District value)  $default,){
final _that = this;
switch (_that) {
case _District():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _District value)?  $default,){
final _that = this;
switch (_that) {
case _District() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  List<String> towns)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _District() when $default != null:
return $default(_that.id,_that.name,_that.towns);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  List<String> towns)  $default,) {final _that = this;
switch (_that) {
case _District():
return $default(_that.id,_that.name,_that.towns);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  List<String> towns)?  $default,) {final _that = this;
switch (_that) {
case _District() when $default != null:
return $default(_that.id,_that.name,_that.towns);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _District implements District {
  const _District({required this.id, required this.name, required  List<String> towns}): _towns = towns;
  factory _District.fromJson(Map<String, dynamic> json) => _$DistrictFromJson(json);

@override final  String id;
@override final  String name;
/// 地区内の架空の市町名。
 final  List<String> _towns;
/// 地区内の架空の市町名。
@override List<String> get towns {
  if (_towns is EqualUnmodifiableListView) return _towns;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_towns);
}


/// Create a copy of District
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DistrictCopyWith<_District> get copyWith => __$DistrictCopyWithImpl<_District>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DistrictToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _District&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&const DeepCollectionEquality().equals(other.towns, _towns));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name,const DeepCollectionEquality().hash(_towns));
}

@override
String toString() {
    return 'District(id: $id, name: $name, towns: $towns)';
}


}

/// @nodoc
abstract mixin class _$DistrictCopyWith<$Res> implements $DistrictCopyWith<$Res> {
  factory _$DistrictCopyWith(_District value, $Res Function(_District) _then) = __$DistrictCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, List<String> towns
});




}
/// @nodoc
class __$DistrictCopyWithImpl<$Res>
    implements _$DistrictCopyWith<$Res> {
  __$DistrictCopyWithImpl(this._self, this._then);

  final _District _self;
  final $Res Function(_District) _then;

/// Create a copy of District
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? towns = null,}) {
  return _then(_District(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,towns: null == towns ? _self._towns : towns // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
