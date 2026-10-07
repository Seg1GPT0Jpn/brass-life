import '../../entities/memory_tag.dart';
import '../../value_objects/relationship_vector.dart';
import '../models/game_state.dart';
import 'game_context.dart';

/// ゲーム中の記憶（MemoryTag）を連番 ID で作る小さなビルダー。
/// 1 回の遷移処理の中で使い、最後に [apply] で状態へ反映する。
class MemoryWriter {
  MemoryWriter(this.ctx, GameState state)
    : _seq = state.memorySeq,
      _turn = state.turn;

  final GameContext ctx;
  int _seq;
  final int _turn;
  final List<MemoryTag> written = [];

  MemoryTag add({
    required MemoryCategory category,
    required String subjectId,
    List<String> objectIds = const [],
    required String reasonKey,
    Map<String, String> params = const {},
    RelationshipVector? delta,
    required int importance,
    MemoryVisibility visibility = MemoryVisibility.involved,
    int? turn,
  }) {
    final m = MemoryTag(
      id: 'g${(_seq++).toString().padLeft(6, '0')}',
      date: ctx.calendar.dateOf(turn ?? _turn),
      category: category,
      subjectId: subjectId,
      objectIds: objectIds,
      reasonKey: reasonKey,
      params: params,
      delta: delta,
      importance: importance.clamp(0, 100),
      visibility: visibility,
    );
    written.add(m);
    return m;
  }

  GameState apply(GameState s) =>
      s.copyWith(memories: [...s.memories, ...written], memorySeq: _seq);
}
