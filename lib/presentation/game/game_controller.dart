import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../core/rng/seed_code.dart';
import '../../domain/career/career_record.dart';
import '../../domain/career/game_mode.dart';
import '../../domain/career/mode_states.dart';
import '../../domain/game/conducting/conducting.dart';
import '../../domain/career/career_recorder.dart';
import '../../domain/game/engine/club_membership.dart';
import '../../domain/game/engine/ending_analyzer.dart';
import '../../domain/game/engine/game_context.dart';
import '../../domain/game/engine/time_manager.dart';
import '../../domain/game/master/approach_cards.dart';
import '../../domain/game/models/candidacy.dart';
import '../../domain/game/models/game_enums.dart';
import '../../domain/game/models/game_state.dart';
import '../../domain/game/models/player_setup.dart';
import '../../domain/game/models/save_summary.dart';
import '../../domain/game/scene/club_scene_service.dart';
import '../../domain/game/scene/scene_models.dart';
import '../../domain/repositories/game_save_repository.dart';
import '../../domain/services/world_generation/world_generator.dart';
import '../../domain/value_objects/instrument.dart';
import '../world/world_controller.dart';

/// 現在の世界に対するゲームエンジンの文脈。世界が変わると作り直される。
final gameContextProvider = Provider<GameContext?>((ref) {
  final world = ref.watch(worldControllerProvider).value?.world;
  return world == null ? null : GameContext(world);
});

/// ゲーム進行の ViewModel。状態の更新は必ず TimeManager を経由し、毎回オートセーブする。
class GameController extends Notifier<GameState?> {
  @override
  GameState? build() {
    // 別の世界が生成されたら、その世界と合わないゲームは破棄する。
    // （watch すると読み込み直後に再構築されて状態が消えるため listen を使う）
    ref.listen(worldControllerProvider, (_, next) {
      final seed = next.value?.world.seed;
      if (state != null && seed != state!.worldSeed) state = null;
    });
    return null;
  }

  GameContext get _ctx => ref.read(gameContextProvider)!;
  TimeManager get _tm => TimeManager(_ctx);

  /// 現在の世界で新しい人生を始める。
  /// [setup] を省略すると Seed が決めた主人公で始める。
  void newGame({PlayerSetup? setup}) =>
      _commit(_tm.newGame(_ctx.world, setup: setup));

  /// 今週の行動を確定する。[targetId] は相手の部員（「一緒に練習」等）。
  void submit(WeeklyAction action, {String? targetId}) =>
      _commit(_tm.submitAction(state!, action, targetId: targetId));

  /// テスト用: 状態をそのまま差し替える（保存はしない）。
  @visibleForTesting
  void debugReplace(GameState s) => state = s;

  /// 大人編を始める。
  void newCareerGame(
    GameMode mode, {
    required String schoolId,
    required String familyName,
    required String givenName,
    String? originTitle,
  }) => _commit(
    _tm.newCareerGame(
      _ctx.world,
      mode,
      schoolId: schoolId,
      familyName: familyName,
      givenName: givenName,
      originTitle: originTitle,
    ),
  );

  /// 大人編の週のコマンド。
  void submitCareer(CareerCommand command, {String? targetId}) =>
      _commit(_tm.submitCareerCommand(state!, command, targetId: targetId));

  /// 顧問: 異動のオファーを受けて、次の任期を始める。
  void acceptTransfer(String schoolId) =>
      _commit(_tm.acceptTransfer(state!, schoolId));

  void setPracticeMenu(PracticeMenuPreset menu) =>
      _commit(_tm.setPracticeMenu(state!, menu));

  List<String> resolveTeacherAudition(Set<String> selected) {
    final r = _tm.resolveTeacherAudition(state!, selected);
    _commit(r.state);
    return r.lines;
  }

  /// 楽器の希望を提出し、経緯の説明を返す。
  List<String> resolveInstrument(List<InstrumentType> wishes) {
    final r = _tm.resolveInstrumentDecision(state!, wishes);
    _commit(r.state);
    return r.lines;
  }

  List<String> resolvePieceSelection(String? pieceId) {
    final r = _tm.resolvePieceSelection(state!, pieceId);
    _commit(r.state);
    return r.lines;
  }

  List<String> resolveAudition(ApproachCard card) {
    final r = _tm.resolveAudition(state!, card);
    _commit(r.state);
    return r.lines;
  }

  List<String> resolveContest(ApproachCard? card, {ConductingPlan? plan}) {
    final r = _tm.resolveContest(state!, card, plan: plan);
    _commit(r.state);
    return r.lines;
  }

  List<String> resolveExecutive(Candidacy choice) {
    final r = _tm.resolveExecutive(state!, choice);
    _commit(r.state);
    return r.lines;
  }

  List<String> resolveConcert(ApproachCard? card, {ConductingPlan? plan}) {
    final r = _tm.resolveConcert(state!, card, plan: plan);
    _commit(r.state);
    return r.lines;
  }

  List<String> resolveRecommendation(String? schoolId) {
    final r = _tm.resolveRecommendation(state!, schoolId);
    _commit(r.state);
    return r.lines;
  }

  List<String> resolveApplication(List<String> schoolIds) {
    final r = _tm.resolveApplication(state!, schoolIds);
    _commit(r.state);
    return r.lines;
  }

  List<String> quitClub(QuitReason why) {
    final r = _tm.quitClub(state!, why);
    _commit(r.state);
    return r.lines;
  }

  List<String> rejoinClub() {
    final r = _tm.rejoinClub(state!);
    _commit(r.state);
    return r.lines;
  }

  void resolveNotice() => _commit(_tm.resolveNotice(state!).state);

  void skipMonth(MonthlyPolicy policy) =>
      _commit(_tm.skipMonth(state!, policy));

  void skipToNextEvent(MonthlyPolicy policy) =>
      _commit(_tm.skipToNextEvent(state!, policy));

  void setPolicy(MonthlyPolicy policy) =>
      _commit(state!.copyWith(policy: policy), save: false);

  void setStudyBeforeExams(bool v) =>
      _commit(state!.copyWith(studyBeforeExams: v), save: false);

  /// セーブデータを読み込む。世界は Seed から再生成する。
  Future<String?> load(String slot) async {
    final repo = ref.read(gameSaveRepositoryProvider);
    final saved = await repo.load(slot);
    if (saved == null) return 'セーブデータを読み込めませんでした';
    if (saved.generatorVersion != WorldGenerator.generatorVersion) {
      return '生成器のバージョンが異なるため読み込めません';
    }
    final ok = await ref
        .read(worldControllerProvider.notifier)
        .generate(SeedCode.format(saved.worldSeed));
    if (!ok) return '世界の再生成に失敗しました';
    state = saved;
    return null;
  }

  /// 指定スロットへ保存する。
  Future<void> saveTo(String slot) async {
    final s = state;
    if (s == null) return;
    await ref
        .read(gameSaveRepositoryProvider)
        .save(slot, s, summaryOf(s, slot));
    ref.invalidate(saveListProvider);
  }

  SaveSummary summaryOf(GameState s, String slot) {
    final ctx = _ctx;
    return SaveSummary(
      slot: slot,
      worldSeed: s.worldSeed,
      seedCode: SeedCode.format(s.worldSeed),
      playerName: s.player.fullName,
      dateLabel: ctx.dateLabelOf(s),
      schoolName: ctx.index.schoolById[s.schoolId]!.name,
      savedAt: DateTime.now().toIso8601String(),
    );
  }

  void _commit(GameState s, {bool save = true}) {
    final justFinished =
        state?.stage != GameStage.finished && s.stage == GameStage.finished;
    state = s;
    if (save) saveTo(GameSaveRepository.autoSlot);
    // 6 年間を終えた瞬間に、進路とエンディングを周回の記録として残す（キャリアモードの解放用）
    if (justFinished && s.mode == GameMode.student) {
      final ending = EndingAnalyzer(_ctx).analyze(s);
      ref
          .read(careerRepositoryProvider)
          .add(
            CareerRecorder.record(
              s,
              ending,
              clearedAt: DateTime.now().toIso8601String(),
            ),
          )
          .then((_) => ref.invalidate(careerRecordsProvider));
    }
  }
}

/// これまでの周回の記録。
final careerRecordsProvider = FutureProvider<List<CareerRecord>>(
  (ref) => ref.watch(careerRepositoryProvider).all(),
);

final gameControllerProvider = NotifierProvider<GameController, GameState?>(
  GameController.new,
);

/// ホーム画面のジオラマ（誰がどこで何をしているか）。
final clubSceneProvider = Provider<ClubScene?>((ref) {
  final ctx = ref.watch(gameContextProvider);
  final s = ref.watch(gameControllerProvider);
  if (ctx == null || s == null) return null;
  return ClubSceneService(ctx).compose(s);
});

final saveListProvider = FutureProvider<List<SaveSummary>>(
  (ref) => ref.watch(gameSaveRepositoryProvider).list(),
);
