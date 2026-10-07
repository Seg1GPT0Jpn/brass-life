import 'package:freezed_annotation/freezed_annotation.dart';

import '../../core/time/game_date.dart';
import '../value_objects/relationship_vector.dart';

part 'memory_tag.freezed.dart';
part 'memory_tag.g.dart';

enum MemoryCategory {
  joinedClub('入部'),
  contestResult('コンクール'),
  appointment('着任・任命'),
  practice('練習'),
  conflict('衝突'),
  reconciliation('和解'),
  audition('オーディション'),
  academic('学業'),
  life('学校生活'),
  rumor('噂');

  const MemoryCategory(this.label);
  final String label;
}

enum MemoryVisibility {
  selfOnly('本人のみ'),
  involved('当事者'),
  rumored('噂として拡散'),
  public('周知');

  const MemoryVisibility(this.label);
  final String label;
}

/// 「いつ・誰が・誰に・なぜ・何が変わったか」を保持する履歴の 1 件。
///
/// 文章そのものではなく [reasonKey] + [params] を保持し、
/// 表示時にテンプレートへ展開する（データ量削減と文言変更への耐性のため）。
@freezed
abstract class MemoryTag with _$MemoryTag {
  const factory MemoryTag({
    required String id,
    required GameDate date,
    required MemoryCategory category,

    /// 記憶の主体（NPC ID またはプレイヤー ID）。
    required String subjectId,

    /// 関係する相手の ID 群。
    @Default(<String>[]) List<String> objectIds,

    /// 理由テンプレートのキー。
    required String reasonKey,

    /// テンプレートに埋め込む値。
    @Default(<String, String>{}) Map<String, String> params,

    /// 関係性の変化量（関係変化を伴わない出来事では null）。
    RelationshipVector? delta,

    /// 重要度（0..100）。エンディング解析で使用する。
    required int importance,
    required MemoryVisibility visibility,
  }) = _MemoryTag;

  factory MemoryTag.fromJson(Map<String, dynamic> json) =>
      _$MemoryTagFromJson(json);
}
