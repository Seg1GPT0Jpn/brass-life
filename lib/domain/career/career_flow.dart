import 'career_record.dart';
import 'game_mode.dart';
import 'mode_states.dart';

/// キャリアモードの状態遷移（Phase 8）。
///
/// ```
/// [タイトル] ─(本編を始める)→ [生徒モード] ─(6 年間終了)→ [エンディング]
///      ↑                                                   │ 記録を保存（CareerRecord）
///      └──────────────(タイトルへ)──────────────────────────┘
/// [タイトル] ─(解放済みのモードを選ぶ)→ [モード選択] ─(準備中なら戻る)→ [タイトル]
///                                        └─(実装済み)→ [大人編プレイ] ─(任期終了)→ [エンディング]
/// ```
sealed class CareerPhase {
  const CareerPhase();
}

/// タイトル画面（解放済みのモードが分かっている）。
class AtTitle extends CareerPhase {
  const AtTitle(this.unlocked);
  final Set<GameMode> unlocked;
}

/// モードを選んでいる。
class ChoosingMode extends CareerPhase {
  const ChoosingMode(this.mode);
  final GameMode mode;
}

/// プレイ中（モードごとの状態を持つ）。
class Playing extends CareerPhase {
  const Playing(this.session);
  final ModeSession session;
}

/// エンディング（記録済み）。
class Finished extends CareerPhase {
  const Finished(this.record);
  final CareerRecord record;
}

/// モードごとのプレイ状態。生徒モードは本編の GameState を使う（ここでは ID のみ）。
sealed class ModeSession {
  const ModeSession();
  GameMode get mode;
}

class StudentSession extends ModeSession {
  const StudentSession(this.saveSlot);
  final String saveSlot;
  @override
  GameMode get mode => GameMode.student;
}

class TeacherSession extends ModeSession {
  const TeacherSession(this.state);
  final TeacherModeState state;
  @override
  GameMode get mode => GameMode.teacher;
}

class InstructorSession extends ModeSession {
  const InstructorSession(this.state);
  final InstructorModeState state;
  @override
  GameMode get mode => GameMode.instructor;
}

class AlumniSession extends ModeSession {
  const AlumniSession(this.state);
  final AlumniModeState state;
  @override
  GameMode get mode => GameMode.alumni;
}

/// 遷移の結果（不正な遷移は理由つきで拒否する）。
sealed class CareerTransition {
  const CareerTransition();
}

class Moved extends CareerTransition {
  const Moved(this.to);
  final CareerPhase to;
}

class Rejected extends CareerTransition {
  const Rejected(this.reason);
  final String reason;
}

abstract final class CareerFlow {
  /// タイトルでモードを選ぶ。
  static CareerTransition chooseMode(CareerPhase from, GameMode mode) {
    if (from is! AtTitle) return const Rejected('タイトル画面からのみ選べる');
    if (!from.unlocked.contains(mode)) {
      return Rejected('まだ解放されていない（${CareerUnlocks.conditionOf(mode)}）');
    }
    return Moved(ChoosingMode(mode));
  }

  /// 選んだモードで始める。大人編は準備中のため、実装されるまでは拒否する。
  static CareerTransition start(CareerPhase from, ModeSession session) {
    if (from is! ChoosingMode || from.mode != session.mode) {
      return const Rejected('モードを選んでから始める');
    }
    if (!session.mode.implemented) {
      return Rejected('${session.mode.label}モードは準備中');
    }
    return Moved(Playing(session));
  }

  /// プレイを終えて記録する。
  static CareerTransition finish(CareerPhase from, CareerRecord record) =>
      from is Playing ? Moved(Finished(record)) : const Rejected('プレイ中ではない');

  /// エンディングからタイトルへ（記録を足して解放状況を更新する）。
  static CareerTransition backToTitle(
    CareerPhase from,
    Iterable<CareerRecord> allRecords,
  ) => from is Finished || from is ChoosingMode
      ? Moved(AtTitle(CareerUnlocks.unlocked(allRecords)))
      : const Rejected('エンディングかモード選択からのみ戻れる');
}
