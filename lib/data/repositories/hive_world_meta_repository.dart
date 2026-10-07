import 'package:hive_ce/hive_ce.dart';

import '../../domain/entities/world_meta.dart';
import '../../domain/repositories/world_meta_repository.dart';
import '../dto/world_meta_dto.dart';

/// [WorldMetaRepository] の Hive 実装。キー `recent` に JSON 文字列のリストを保存する。
class HiveWorldMetaRepository implements WorldMetaRepository {
  HiveWorldMetaRepository(this._box);

  final Box<String> _box;
  static const int _maxEntries = 10;

  @override
  Future<List<WorldMeta>> recent() async {
    final list = <WorldMeta>[];
    for (var i = 0; i < _maxEntries; i++) {
      final raw = _box.get('recent_$i');
      if (raw == null) break;
      final meta = WorldMetaDto.decode(raw);
      if (meta != null) list.add(meta);
    }
    return list;
  }

  @override
  Future<void> save(WorldMeta meta) async {
    final current = await recent();
    final next = [
      meta,
      ...current.where((m) => m.seed != meta.seed),
    ].take(_maxEntries).toList();
    await _box.clear();
    for (var i = 0; i < next.length; i++) {
      await _box.put('recent_$i', WorldMetaDto.encode(next[i]));
    }
  }

  @override
  Future<void> clear() => _box.clear();
}

/// テスト・Hive 未初期化環境用のメモリ実装。
class InMemoryWorldMetaRepository implements WorldMetaRepository {
  final List<WorldMeta> _items = [];

  @override
  Future<List<WorldMeta>> recent() async => List.unmodifiable(_items);

  @override
  Future<void> save(WorldMeta meta) async {
    _items
      ..removeWhere((m) => m.seed == meta.seed)
      ..insert(0, meta);
    if (_items.length > 10) _items.removeLast();
  }

  @override
  Future<void> clear() async => _items.clear();
}
