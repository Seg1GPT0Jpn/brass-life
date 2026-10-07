import 'dart:convert';

import 'package:hive_ce/hive_ce.dart';

import '../../domain/game/models/game_state.dart';
import '../../domain/game/models/save_summary.dart';
import '../../domain/repositories/game_save_repository.dart';

/// [GameSaveRepository] の Hive 実装。
/// キー `state:{slot}` に GameState の JSON、`summary:{slot}` に要約を保存する。
class HiveGameSaveRepository implements GameSaveRepository {
  HiveGameSaveRepository(this._box);

  final Box<String> _box;
  static const int schemaVersion = 1;

  @override
  Future<void> save(String slot, GameState state, SaveSummary summary) async {
    await _box.put(
      'state:$slot',
      jsonEncode({'schemaVersion': schemaVersion, 'data': state.toJson()}),
    );
    await _box.put('summary:$slot', jsonEncode(summary.toJson()));
  }

  @override
  Future<GameState?> load(String slot) async {
    final raw = _box.get('state:$slot');
    if (raw == null) return null;
    try {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      if (map['schemaVersion'] != schemaVersion) return null;
      return GameState.fromJson(map['data'] as Map<String, dynamic>);
    } on Object {
      return null;
    }
  }

  @override
  Future<List<SaveSummary>> list() async {
    final out = <SaveSummary>[];
    final keys =
        _box.keys
            .whereType<String>()
            .where((k) => k.startsWith('summary:'))
            .toList()
          ..sort();
    for (final k in keys) {
      try {
        out.add(
          SaveSummary.fromJson(
            jsonDecode(_box.get(k)!) as Map<String, dynamic>,
          ),
        );
      } on Object {
        // 壊れた要約は無視する。
      }
    }
    return out;
  }

  @override
  Future<void> delete(String slot) async {
    await _box.delete('state:$slot');
    await _box.delete('summary:$slot');
  }
}

/// テスト用のメモリ実装。
class InMemoryGameSaveRepository implements GameSaveRepository {
  final Map<String, GameState> _states = {};
  final Map<String, SaveSummary> _summaries = {};

  @override
  Future<void> save(String slot, GameState state, SaveSummary summary) async {
    _states[slot] = state;
    _summaries[slot] = summary;
  }

  @override
  Future<GameState?> load(String slot) async => _states[slot];

  @override
  Future<List<SaveSummary>> list() async {
    final keys = _summaries.keys.toList()..sort();
    return [for (final k in keys) _summaries[k]!];
  }

  @override
  Future<void> delete(String slot) async {
    _states.remove(slot);
    _summaries.remove(slot);
  }
}
