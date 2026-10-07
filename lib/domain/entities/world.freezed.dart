// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'world.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$World {

 int get seed; String get seedCode; int get generatorVersion; WorldGenConfig get config; Region get region; List<School> get schools; List<Club> get clubs; List<Npc> get npcs; Player get player; List<MemoryTag> get memories;
/// Create a copy of World
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WorldCopyWith<World> get copyWith => _$WorldCopyWithImpl<World>(this as World, _$identity);

  /// Serializes this World to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as World;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is World&&(identical(other.seed, _this.seed) || other.seed == _this.seed)&&(identical(other.seedCode, _this.seedCode) || other.seedCode == _this.seedCode)&&(identical(other.generatorVersion, _this.generatorVersion) || other.generatorVersion == _this.generatorVersion)&&(identical(other.config, _this.config) || other.config == _this.config)&&(identical(other.region, _this.region) || other.region == _this.region)&&const DeepCollectionEquality().equals(other.schools, _this.schools)&&const DeepCollectionEquality().equals(other.clubs, _this.clubs)&&const DeepCollectionEquality().equals(other.npcs, _this.npcs)&&(identical(other.player, _this.player) || other.player == _this.player)&&const DeepCollectionEquality().equals(other.memories, _this.memories));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as World;
  return Object.hash(runtimeType,_this.seed,_this.seedCode,_this.generatorVersion,_this.config,_this.region,const DeepCollectionEquality().hash(_this.schools),const DeepCollectionEquality().hash(_this.clubs),const DeepCollectionEquality().hash(_this.npcs),_this.player,const DeepCollectionEquality().hash(_this.memories));
}

@override
String toString() {
  final _this = this as World;
  return 'World(seed: ${_this.seed}, seedCode: ${_this.seedCode}, generatorVersion: ${_this.generatorVersion}, config: ${_this.config}, region: ${_this.region}, schools: ${_this.schools}, clubs: ${_this.clubs}, npcs: ${_this.npcs}, player: ${_this.player}, memories: ${_this.memories})';
}


}

/// @nodoc
abstract mixin class $WorldCopyWith<$Res>  {
  factory $WorldCopyWith(World value, $Res Function(World) _then) = _$WorldCopyWithImpl;
@useResult
$Res call({
 int seed, String seedCode, int generatorVersion, WorldGenConfig config, Region region, List<School> schools, List<Club> clubs, List<Npc> npcs, Player player, List<MemoryTag> memories
});


$WorldGenConfigCopyWith<$Res> get config;$RegionCopyWith<$Res> get region;$PlayerCopyWith<$Res> get player;

}
/// @nodoc
class _$WorldCopyWithImpl<$Res>
    implements $WorldCopyWith<$Res> {
  _$WorldCopyWithImpl(this._self, this._then);

  final World _self;
  final $Res Function(World) _then;

/// Create a copy of World
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? seed = null,Object? seedCode = null,Object? generatorVersion = null,Object? config = null,Object? region = null,Object? schools = null,Object? clubs = null,Object? npcs = null,Object? player = null,Object? memories = null,}) {
  return _then(World(
seed: null == seed ? _self.seed : seed // ignore: cast_nullable_to_non_nullable
as int,seedCode: null == seedCode ? _self.seedCode : seedCode // ignore: cast_nullable_to_non_nullable
as String,generatorVersion: null == generatorVersion ? _self.generatorVersion : generatorVersion // ignore: cast_nullable_to_non_nullable
as int,config: null == config ? _self.config : config // ignore: cast_nullable_to_non_nullable
as WorldGenConfig,region: null == region ? _self.region : region // ignore: cast_nullable_to_non_nullable
as Region,schools: null == schools ? _self.schools : schools // ignore: cast_nullable_to_non_nullable
as List<School>,clubs: null == clubs ? _self.clubs : clubs // ignore: cast_nullable_to_non_nullable
as List<Club>,npcs: null == npcs ? _self.npcs : npcs // ignore: cast_nullable_to_non_nullable
as List<Npc>,player: null == player ? _self.player : player // ignore: cast_nullable_to_non_nullable
as Player,memories: null == memories ? _self.memories : memories // ignore: cast_nullable_to_non_nullable
as List<MemoryTag>,
  ));
}
/// Create a copy of World
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WorldGenConfigCopyWith<$Res> get config {
  
  return $WorldGenConfigCopyWith<$Res>(_self.config, (value) {
    return _then(_self.copyWith(config: value));
  });
}/// Create a copy of World
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RegionCopyWith<$Res> get region {
  
  return $RegionCopyWith<$Res>(_self.region, (value) {
    return _then(_self.copyWith(region: value));
  });
}/// Create a copy of World
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PlayerCopyWith<$Res> get player {
  
  return $PlayerCopyWith<$Res>(_self.player, (value) {
    return _then(_self.copyWith(player: value));
  });
}
}


/// Adds pattern-matching-related methods to [World].
extension WorldPatterns on World {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _World value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _World() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _World value)  $default,){
final _that = this;
switch (_that) {
case _World():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _World value)?  $default,){
final _that = this;
switch (_that) {
case _World() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int seed,  String seedCode,  int generatorVersion,  WorldGenConfig config,  Region region,  List<School> schools,  List<Club> clubs,  List<Npc> npcs,  Player player,  List<MemoryTag> memories)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _World() when $default != null:
return $default(_that.seed,_that.seedCode,_that.generatorVersion,_that.config,_that.region,_that.schools,_that.clubs,_that.npcs,_that.player,_that.memories);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int seed,  String seedCode,  int generatorVersion,  WorldGenConfig config,  Region region,  List<School> schools,  List<Club> clubs,  List<Npc> npcs,  Player player,  List<MemoryTag> memories)  $default,) {final _that = this;
switch (_that) {
case _World():
return $default(_that.seed,_that.seedCode,_that.generatorVersion,_that.config,_that.region,_that.schools,_that.clubs,_that.npcs,_that.player,_that.memories);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int seed,  String seedCode,  int generatorVersion,  WorldGenConfig config,  Region region,  List<School> schools,  List<Club> clubs,  List<Npc> npcs,  Player player,  List<MemoryTag> memories)?  $default,) {final _that = this;
switch (_that) {
case _World() when $default != null:
return $default(_that.seed,_that.seedCode,_that.generatorVersion,_that.config,_that.region,_that.schools,_that.clubs,_that.npcs,_that.player,_that.memories);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _World implements World {
  const _World({required this.seed, required this.seedCode, required this.generatorVersion, required this.config, required this.region, required  List<School> schools, required  List<Club> clubs, required  List<Npc> npcs, required this.player, required  List<MemoryTag> memories}): _schools = schools,_clubs = clubs,_npcs = npcs,_memories = memories;
  factory _World.fromJson(Map<String, dynamic> json) => _$WorldFromJson(json);

@override final  int seed;
@override final  String seedCode;
@override final  int generatorVersion;
@override final  WorldGenConfig config;
@override final  Region region;
 final  List<School> _schools;
@override List<School> get schools {
  if (_schools is EqualUnmodifiableListView) return _schools;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_schools);
}

 final  List<Club> _clubs;
@override List<Club> get clubs {
  if (_clubs is EqualUnmodifiableListView) return _clubs;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_clubs);
}

 final  List<Npc> _npcs;
@override List<Npc> get npcs {
  if (_npcs is EqualUnmodifiableListView) return _npcs;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_npcs);
}

@override final  Player player;
 final  List<MemoryTag> _memories;
@override List<MemoryTag> get memories {
  if (_memories is EqualUnmodifiableListView) return _memories;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_memories);
}


/// Create a copy of World
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WorldCopyWith<_World> get copyWith => __$WorldCopyWithImpl<_World>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WorldToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _World&&(identical(other.seed, seed) || other.seed == seed)&&(identical(other.seedCode, seedCode) || other.seedCode == seedCode)&&(identical(other.generatorVersion, generatorVersion) || other.generatorVersion == generatorVersion)&&(identical(other.config, config) || other.config == config)&&(identical(other.region, region) || other.region == region)&&const DeepCollectionEquality().equals(other.schools, _schools)&&const DeepCollectionEquality().equals(other.clubs, _clubs)&&const DeepCollectionEquality().equals(other.npcs, _npcs)&&(identical(other.player, player) || other.player == player)&&const DeepCollectionEquality().equals(other.memories, _memories));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,seed,seedCode,generatorVersion,config,region,const DeepCollectionEquality().hash(_schools),const DeepCollectionEquality().hash(_clubs),const DeepCollectionEquality().hash(_npcs),player,const DeepCollectionEquality().hash(_memories));
}

@override
String toString() {
    return 'World(seed: $seed, seedCode: $seedCode, generatorVersion: $generatorVersion, config: $config, region: $region, schools: $schools, clubs: $clubs, npcs: $npcs, player: $player, memories: $memories)';
}


}

/// @nodoc
abstract mixin class _$WorldCopyWith<$Res> implements $WorldCopyWith<$Res> {
  factory _$WorldCopyWith(_World value, $Res Function(_World) _then) = __$WorldCopyWithImpl;
@override @useResult
$Res call({
 int seed, String seedCode, int generatorVersion, WorldGenConfig config, Region region, List<School> schools, List<Club> clubs, List<Npc> npcs, Player player, List<MemoryTag> memories
});


@override $WorldGenConfigCopyWith<$Res> get config;@override $RegionCopyWith<$Res> get region;@override $PlayerCopyWith<$Res> get player;

}
/// @nodoc
class __$WorldCopyWithImpl<$Res>
    implements _$WorldCopyWith<$Res> {
  __$WorldCopyWithImpl(this._self, this._then);

  final _World _self;
  final $Res Function(_World) _then;

/// Create a copy of World
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? seed = null,Object? seedCode = null,Object? generatorVersion = null,Object? config = null,Object? region = null,Object? schools = null,Object? clubs = null,Object? npcs = null,Object? player = null,Object? memories = null,}) {
  return _then(_World(
seed: null == seed ? _self.seed : seed // ignore: cast_nullable_to_non_nullable
as int,seedCode: null == seedCode ? _self.seedCode : seedCode // ignore: cast_nullable_to_non_nullable
as String,generatorVersion: null == generatorVersion ? _self.generatorVersion : generatorVersion // ignore: cast_nullable_to_non_nullable
as int,config: null == config ? _self.config : config // ignore: cast_nullable_to_non_nullable
as WorldGenConfig,region: null == region ? _self.region : region // ignore: cast_nullable_to_non_nullable
as Region,schools: null == schools ? _self._schools : schools // ignore: cast_nullable_to_non_nullable
as List<School>,clubs: null == clubs ? _self._clubs : clubs // ignore: cast_nullable_to_non_nullable
as List<Club>,npcs: null == npcs ? _self._npcs : npcs // ignore: cast_nullable_to_non_nullable
as List<Npc>,player: null == player ? _self.player : player // ignore: cast_nullable_to_non_nullable
as Player,memories: null == memories ? _self._memories : memories // ignore: cast_nullable_to_non_nullable
as List<MemoryTag>,
  ));
}

/// Create a copy of World
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WorldGenConfigCopyWith<$Res> get config {
  
  return $WorldGenConfigCopyWith<$Res>(_self.config, (value) {
    return _then(_self.copyWith(config: value));
  });
}/// Create a copy of World
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RegionCopyWith<$Res> get region {
  
  return $RegionCopyWith<$Res>(_self.region, (value) {
    return _then(_self.copyWith(region: value));
  });
}/// Create a copy of World
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$PlayerCopyWith<$Res> get player {
  
  return $PlayerCopyWith<$Res>(_self.player, (value) {
    return _then(_self.copyWith(player: value));
  });
}
}

// dart format on
