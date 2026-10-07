import '../../../core/rng/rng_stream.dart';
import '../../master/name_pools.dart';
import '../../value_objects/person_enums.dart';

/// 架空名称・人名の生成。重複・実在名称との一致は再抽選で回避する。
class NameGenerator {
  NameGenerator();

  /// 世界全体で使用済みの地名・校名理念語。
  final Set<String> _usedPlaces = {};
  final Set<String> _usedMottos = {};

  static const int _maxTries = 200;

  /// 架空の地名（市町名）。
  String placeName(RngStream rng) {
    for (var i = 0; i < _maxTries; i++) {
      final name = rng.pick(placePrefixes) + rng.pick(placeSuffixes);
      if (realNameBlocklist.contains(name) || _usedPlaces.contains(name)) {
        continue;
      }
      _usedPlaces.add(name);
      return name;
    }
    // パーツの組み合わせを使い切った場合の決定論的フォールバック。
    var n = 2;
    while (true) {
      final name = '${rng.pick(placePrefixes)}${rng.pick(placeSuffixes)}$n';
      if (_usedPlaces.add(name)) return name;
      n++;
    }
  }

  /// 架空の県名（「県」を含まない）。
  String prefectureName(RngStream rng) {
    for (var i = 0; i < _maxTries; i++) {
      final name = rng.pick(prefecturePrefixes) + rng.pick(prefectureSuffixes);
      if (!realNameBlocklist.contains(name)) return name;
    }
    return '${prefecturePrefixes.first}${prefectureSuffixes.last}';
  }

  /// 架空の支部名（「支部」を含まない）。
  String blockName(RngStream rng, String prefecture) {
    for (var i = 0; i < _maxTries; i++) {
      final name = rng.pick(prefecturePrefixes) + rng.pick(placeSuffixes);
      if (!realNameBlocklist.contains(name) && name != prefecture) return name;
    }
    return '$prefecture広域';
  }

  /// 私立校の理念語（例：煌星）。
  String privateMotto(RngStream rng) {
    for (var i = 0; i < _maxTries; i++) {
      final name = rng.pick(privatePrefixes) + rng.pick(privateSuffixes);
      if (realNameBlocklist.contains(name) || _usedMottos.contains(name)) {
        continue;
      }
      _usedMottos.add(name);
      return name;
    }
    var n = 2;
    while (true) {
      final name = '${rng.pick(privatePrefixes)}${rng.pick(privateSuffixes)}$n';
      if (_usedMottos.add(name)) return name;
      n++;
    }
  }

  /// 人名（姓, 名）。[used] に含まれるフルネームは避ける（同一校内の重複回避）。
  static (String, String) personName(
    RngStream rng, {
    required Gender gender,
    bool adult = false,
    Set<String>? used,
  }) {
    final givenPool = switch ((gender, adult)) {
      (Gender.female, false) => givenNamesFemale,
      (Gender.male, false) => givenNamesMale,
      (Gender.female, true) => adultGivenNamesFemale,
      (Gender.male, true) => adultGivenNamesMale,
    };
    for (var i = 0; i < _maxTries; i++) {
      final family = rng.pick(familyNames);
      final given = rng.pick(givenPool);
      final full = '$family$given';
      if (used == null || used.add(full)) return (family, given);
    }
    // 理論上ほぼ到達しないが、決定論的に一意化する。
    final family = rng.pick(familyNames);
    final given = rng.pick(givenPool);
    var n = 2;
    while (used != null && !used.add('$family$given$n')) {
      n++;
    }
    return (family, '$given$n');
  }
}
