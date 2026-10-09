import 'package:hive_ce_flutter/hive_ce_flutter.dart';

/// Hive CE の初期化と Box 管理。値は JSON 文字列で保存し、TypeAdapter に依存しない。
/// Web では IndexedDB に保存される（完全オフライン）。
abstract final class HiveStore {
  static const String worldMetaBox = 'world_meta_v1';
  static const String gameSaveBox = 'game_saves_v1';
  static const String careerBox = 'career_v1';

  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox<String>(worldMetaBox);
    await Hive.openBox<String>(gameSaveBox);
    await Hive.openBox<String>(careerBox);
  }

  static Box<String> get worldMeta => Hive.box<String>(worldMetaBox);

  static Box<String> get gameSaves => Hive.box<String>(gameSaveBox);

  static Box<String> get career => Hive.box<String>(careerBox);
}
