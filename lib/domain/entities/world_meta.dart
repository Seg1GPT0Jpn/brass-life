import 'package:freezed_annotation/freezed_annotation.dart';

part 'world_meta.freezed.dart';
part 'world_meta.g.dart';

/// 保存対象となる世界のメタ情報。世界本体は Seed から再生成する。
@freezed
abstract class WorldMeta with _$WorldMeta {
  const factory WorldMeta({
    /// ユーザーが入力した元の文字列。
    required String input,
    required int seed,
    required String seedCode,
    required int generatorVersion,

    /// 生成結果のフィンガープリント（再生成時の一致確認に使う）。
    required String fingerprint,
  }) = _WorldMeta;

  factory WorldMeta.fromJson(Map<String, dynamic> json) =>
      _$WorldMetaFromJson(json);
}
