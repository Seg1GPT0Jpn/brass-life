import '../entities/world_meta.dart';

/// 生成した世界のメタ情報（Seed など）の永続化。
abstract interface class WorldMetaRepository {
  /// 最近生成した世界（新しい順）。
  Future<List<WorldMeta>> recent();

  /// 先頭に追加する。同じ Seed の既存エントリは置き換える。
  Future<void> save(WorldMeta meta);

  Future<void> clear();
}
