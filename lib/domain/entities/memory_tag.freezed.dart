// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'memory_tag.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MemoryTag {

 String get id; GameDate get date; MemoryCategory get category;/// 記憶の主体（NPC ID またはプレイヤー ID）。
 String get subjectId;/// 関係する相手の ID 群。
 List<String> get objectIds;/// 理由テンプレートのキー。
 String get reasonKey;/// テンプレートに埋め込む値。
 Map<String, String> get params;/// 関係性の変化量（関係変化を伴わない出来事では null）。
 RelationshipVector? get delta;/// 重要度（0..100）。エンディング解析で使用する。
 int get importance; MemoryVisibility get visibility;
/// Create a copy of MemoryTag
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MemoryTagCopyWith<MemoryTag> get copyWith => _$MemoryTagCopyWithImpl<MemoryTag>(this as MemoryTag, _$identity);

  /// Serializes this MemoryTag to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as MemoryTag;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MemoryTag&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.date, _this.date) || other.date == _this.date)&&(identical(other.category, _this.category) || other.category == _this.category)&&(identical(other.subjectId, _this.subjectId) || other.subjectId == _this.subjectId)&&const DeepCollectionEquality().equals(other.objectIds, _this.objectIds)&&(identical(other.reasonKey, _this.reasonKey) || other.reasonKey == _this.reasonKey)&&const DeepCollectionEquality().equals(other.params, _this.params)&&(identical(other.delta, _this.delta) || other.delta == _this.delta)&&(identical(other.importance, _this.importance) || other.importance == _this.importance)&&(identical(other.visibility, _this.visibility) || other.visibility == _this.visibility));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as MemoryTag;
  return Object.hash(runtimeType,_this.id,_this.date,_this.category,_this.subjectId,const DeepCollectionEquality().hash(_this.objectIds),_this.reasonKey,const DeepCollectionEquality().hash(_this.params),_this.delta,_this.importance,_this.visibility);
}

@override
String toString() {
  final _this = this as MemoryTag;
  return 'MemoryTag(id: ${_this.id}, date: ${_this.date}, category: ${_this.category}, subjectId: ${_this.subjectId}, objectIds: ${_this.objectIds}, reasonKey: ${_this.reasonKey}, params: ${_this.params}, delta: ${_this.delta}, importance: ${_this.importance}, visibility: ${_this.visibility})';
}


}

/// @nodoc
abstract mixin class $MemoryTagCopyWith<$Res>  {
  factory $MemoryTagCopyWith(MemoryTag value, $Res Function(MemoryTag) _then) = _$MemoryTagCopyWithImpl;
@useResult
$Res call({
 String id, GameDate date, MemoryCategory category, String subjectId, List<String> objectIds, String reasonKey, Map<String, String> params, RelationshipVector? delta, int importance, MemoryVisibility visibility
});


$GameDateCopyWith<$Res> get date;$RelationshipVectorCopyWith<$Res>? get delta;

}
/// @nodoc
class _$MemoryTagCopyWithImpl<$Res>
    implements $MemoryTagCopyWith<$Res> {
  _$MemoryTagCopyWithImpl(this._self, this._then);

  final MemoryTag _self;
  final $Res Function(MemoryTag) _then;

/// Create a copy of MemoryTag
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? date = null,Object? category = null,Object? subjectId = null,Object? objectIds = null,Object? reasonKey = null,Object? params = null,Object? delta = freezed,Object? importance = null,Object? visibility = null,}) {
  return _then(MemoryTag(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as GameDate,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as MemoryCategory,subjectId: null == subjectId ? _self.subjectId : subjectId // ignore: cast_nullable_to_non_nullable
as String,objectIds: null == objectIds ? _self.objectIds : objectIds // ignore: cast_nullable_to_non_nullable
as List<String>,reasonKey: null == reasonKey ? _self.reasonKey : reasonKey // ignore: cast_nullable_to_non_nullable
as String,params: null == params ? _self.params : params // ignore: cast_nullable_to_non_nullable
as Map<String, String>,delta: freezed == delta ? _self.delta : delta // ignore: cast_nullable_to_non_nullable
as RelationshipVector?,importance: null == importance ? _self.importance : importance // ignore: cast_nullable_to_non_nullable
as int,visibility: null == visibility ? _self.visibility : visibility // ignore: cast_nullable_to_non_nullable
as MemoryVisibility,
  ));
}
/// Create a copy of MemoryTag
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GameDateCopyWith<$Res> get date {
  
  return $GameDateCopyWith<$Res>(_self.date, (value) {
    return _then(_self.copyWith(date: value));
  });
}/// Create a copy of MemoryTag
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RelationshipVectorCopyWith<$Res>? get delta {
    if (_self.delta == null) {
    return null;
  }

  return $RelationshipVectorCopyWith<$Res>(_self.delta!, (value) {
    return _then(_self.copyWith(delta: value));
  });
}
}


/// Adds pattern-matching-related methods to [MemoryTag].
extension MemoryTagPatterns on MemoryTag {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MemoryTag value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MemoryTag() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MemoryTag value)  $default,){
final _that = this;
switch (_that) {
case _MemoryTag():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MemoryTag value)?  $default,){
final _that = this;
switch (_that) {
case _MemoryTag() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  GameDate date,  MemoryCategory category,  String subjectId,  List<String> objectIds,  String reasonKey,  Map<String, String> params,  RelationshipVector? delta,  int importance,  MemoryVisibility visibility)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MemoryTag() when $default != null:
return $default(_that.id,_that.date,_that.category,_that.subjectId,_that.objectIds,_that.reasonKey,_that.params,_that.delta,_that.importance,_that.visibility);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  GameDate date,  MemoryCategory category,  String subjectId,  List<String> objectIds,  String reasonKey,  Map<String, String> params,  RelationshipVector? delta,  int importance,  MemoryVisibility visibility)  $default,) {final _that = this;
switch (_that) {
case _MemoryTag():
return $default(_that.id,_that.date,_that.category,_that.subjectId,_that.objectIds,_that.reasonKey,_that.params,_that.delta,_that.importance,_that.visibility);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  GameDate date,  MemoryCategory category,  String subjectId,  List<String> objectIds,  String reasonKey,  Map<String, String> params,  RelationshipVector? delta,  int importance,  MemoryVisibility visibility)?  $default,) {final _that = this;
switch (_that) {
case _MemoryTag() when $default != null:
return $default(_that.id,_that.date,_that.category,_that.subjectId,_that.objectIds,_that.reasonKey,_that.params,_that.delta,_that.importance,_that.visibility);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MemoryTag implements MemoryTag {
  const _MemoryTag({required this.id, required this.date, required this.category, required this.subjectId,  List<String> objectIds = const <String>[], required this.reasonKey,  Map<String, String> params = const <String, String>{}, this.delta, required this.importance, required this.visibility}): _objectIds = objectIds,_params = params;
  factory _MemoryTag.fromJson(Map<String, dynamic> json) => _$MemoryTagFromJson(json);

@override final  String id;
@override final  GameDate date;
@override final  MemoryCategory category;
/// 記憶の主体（NPC ID またはプレイヤー ID）。
@override final  String subjectId;
/// 関係する相手の ID 群。
 final  List<String> _objectIds;
/// 関係する相手の ID 群。
@override@JsonKey() List<String> get objectIds {
  if (_objectIds is EqualUnmodifiableListView) return _objectIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_objectIds);
}

/// 理由テンプレートのキー。
@override final  String reasonKey;
/// テンプレートに埋め込む値。
 final  Map<String, String> _params;
/// テンプレートに埋め込む値。
@override@JsonKey() Map<String, String> get params {
  if (_params is EqualUnmodifiableMapView) return _params;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_params);
}

/// 関係性の変化量（関係変化を伴わない出来事では null）。
@override final  RelationshipVector? delta;
/// 重要度（0..100）。エンディング解析で使用する。
@override final  int importance;
@override final  MemoryVisibility visibility;

/// Create a copy of MemoryTag
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MemoryTagCopyWith<_MemoryTag> get copyWith => __$MemoryTagCopyWithImpl<_MemoryTag>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MemoryTagToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MemoryTag&&(identical(other.id, id) || other.id == id)&&(identical(other.date, date) || other.date == date)&&(identical(other.category, category) || other.category == category)&&(identical(other.subjectId, subjectId) || other.subjectId == subjectId)&&const DeepCollectionEquality().equals(other.objectIds, _objectIds)&&(identical(other.reasonKey, reasonKey) || other.reasonKey == reasonKey)&&const DeepCollectionEquality().equals(other.params, _params)&&(identical(other.delta, delta) || other.delta == delta)&&(identical(other.importance, importance) || other.importance == importance)&&(identical(other.visibility, visibility) || other.visibility == visibility));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,date,category,subjectId,const DeepCollectionEquality().hash(_objectIds),reasonKey,const DeepCollectionEquality().hash(_params),delta,importance,visibility);
}

@override
String toString() {
    return 'MemoryTag(id: $id, date: $date, category: $category, subjectId: $subjectId, objectIds: $objectIds, reasonKey: $reasonKey, params: $params, delta: $delta, importance: $importance, visibility: $visibility)';
}


}

/// @nodoc
abstract mixin class _$MemoryTagCopyWith<$Res> implements $MemoryTagCopyWith<$Res> {
  factory _$MemoryTagCopyWith(_MemoryTag value, $Res Function(_MemoryTag) _then) = __$MemoryTagCopyWithImpl;
@override @useResult
$Res call({
 String id, GameDate date, MemoryCategory category, String subjectId, List<String> objectIds, String reasonKey, Map<String, String> params, RelationshipVector? delta, int importance, MemoryVisibility visibility
});


@override $GameDateCopyWith<$Res> get date;@override $RelationshipVectorCopyWith<$Res>? get delta;

}
/// @nodoc
class __$MemoryTagCopyWithImpl<$Res>
    implements _$MemoryTagCopyWith<$Res> {
  __$MemoryTagCopyWithImpl(this._self, this._then);

  final _MemoryTag _self;
  final $Res Function(_MemoryTag) _then;

/// Create a copy of MemoryTag
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? date = null,Object? category = null,Object? subjectId = null,Object? objectIds = null,Object? reasonKey = null,Object? params = null,Object? delta = freezed,Object? importance = null,Object? visibility = null,}) {
  return _then(_MemoryTag(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as GameDate,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as MemoryCategory,subjectId: null == subjectId ? _self.subjectId : subjectId // ignore: cast_nullable_to_non_nullable
as String,objectIds: null == objectIds ? _self._objectIds : objectIds // ignore: cast_nullable_to_non_nullable
as List<String>,reasonKey: null == reasonKey ? _self.reasonKey : reasonKey // ignore: cast_nullable_to_non_nullable
as String,params: null == params ? _self._params : params // ignore: cast_nullable_to_non_nullable
as Map<String, String>,delta: freezed == delta ? _self.delta : delta // ignore: cast_nullable_to_non_nullable
as RelationshipVector?,importance: null == importance ? _self.importance : importance // ignore: cast_nullable_to_non_nullable
as int,visibility: null == visibility ? _self.visibility : visibility // ignore: cast_nullable_to_non_nullable
as MemoryVisibility,
  ));
}

/// Create a copy of MemoryTag
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GameDateCopyWith<$Res> get date {
  
  return $GameDateCopyWith<$Res>(_self.date, (value) {
    return _then(_self.copyWith(date: value));
  });
}/// Create a copy of MemoryTag
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RelationshipVectorCopyWith<$Res>? get delta {
    if (_self.delta == null) {
    return null;
  }

  return $RelationshipVectorCopyWith<$Res>(_self.delta!, (value) {
    return _then(_self.copyWith(delta: value));
  });
}
}

// dart format on
