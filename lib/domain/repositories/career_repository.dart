import '../career/career_record.dart';

/// 周回をまたぐ記録（エンディングごとに 1 件）。セーブスロットとは独立。
abstract interface class CareerRepository {
  Future<void> add(CareerRecord record);

  /// 古い順。
  Future<List<CareerRecord>> all();
}
