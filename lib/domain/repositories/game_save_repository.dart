import '../game/models/game_state.dart';
import '../game/models/save_summary.dart';

/// ゲームのセーブデータ。スロット名 `auto` はオートセーブ。
abstract interface class GameSaveRepository {
  static const String autoSlot = 'auto';

  Future<void> save(String slot, GameState state, SaveSummary summary);

  Future<GameState?> load(String slot);

  Future<List<SaveSummary>> list();

  Future<void> delete(String slot);
}
