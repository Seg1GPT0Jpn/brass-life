import 'dart:convert';

import 'package:hive_ce/hive_ce.dart';

import '../../domain/career/career_record.dart';
import '../../domain/repositories/career_repository.dart';

/// [CareerRepository] の Hive 実装（キー `record:{連番}` に JSON）。
class HiveCareerRepository implements CareerRepository {
  HiveCareerRepository(this._box);

  final Box<String> _box;

  @override
  Future<void> add(CareerRecord record) async {
    final n = _box.keys.whereType<String>().length;
    await _box.put(
      'record:${n.toString().padLeft(5, '0')}',
      jsonEncode(record.toJson()),
    );
  }

  @override
  Future<List<CareerRecord>> all() async {
    final keys = _box.keys.whereType<String>().toList()..sort();
    final out = <CareerRecord>[];
    for (final k in keys) {
      try {
        out.add(
          CareerRecord.fromJson(
            jsonDecode(_box.get(k)!) as Map<String, Object?>,
          ),
        );
      } on Object {
        // 壊れた記録は無視する。
      }
    }
    return out;
  }
}

/// テスト用・既定のメモリ実装。
class InMemoryCareerRepository implements CareerRepository {
  final _records = <CareerRecord>[];

  @override
  Future<void> add(CareerRecord record) async => _records.add(record);

  @override
  Future<List<CareerRecord>> all() async => List.of(_records);
}
