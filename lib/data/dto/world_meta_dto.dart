import 'dart:convert';

import '../../domain/entities/world_meta.dart';

/// [WorldMeta] の永続化形式。スキーマ変更に備えて schemaVersion を持たせる。
abstract final class WorldMetaDto {
  static const int schemaVersion = 1;

  static String encode(WorldMeta meta) =>
      jsonEncode({'schemaVersion': schemaVersion, 'data': meta.toJson()});

  /// 読めない・古すぎる形式は null（呼び出し側で破棄する）。
  static WorldMeta? decode(String raw) {
    try {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      final version = map['schemaVersion'] as int?;
      if (version != schemaVersion) return null;
      return WorldMeta.fromJson(map['data'] as Map<String, dynamic>);
    } on Object {
      return null;
    }
  }
}
