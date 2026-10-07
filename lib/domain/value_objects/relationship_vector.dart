import 'package:freezed_annotation/freezed_annotation.dart';

part 'relationship_vector.freezed.dart';
part 'relationship_vector.g.dart';

/// 関係性ベクトル（各 -100..100）。Phase 3 の Drama Engine で本格的に使用する。
/// [MemoryTag] の変化量としても用いる。
@freezed
abstract class RelationshipVector with _$RelationshipVector {
  const factory RelationshipVector({
    /// 好感度
    @Default(0) int affection,

    /// 信頼度
    @Default(0) int trust,

    /// ライバル度
    @Default(0) int rivalry,
  }) = _RelationshipVector;

  const RelationshipVector._();

  factory RelationshipVector.fromJson(Map<String, dynamic> json) =>
      _$RelationshipVectorFromJson(json);

  static int _clamp(int v) => v < -100 ? -100 : (v > 100 ? 100 : v);

  RelationshipVector operator +(RelationshipVector other) => RelationshipVector(
    affection: _clamp(affection + other.affection),
    trust: _clamp(trust + other.trust),
    rivalry: _clamp(rivalry + other.rivalry),
  );

  bool get isZero => affection == 0 && trust == 0 && rivalry == 0;
}
