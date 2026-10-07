import 'rng_stream.dart';
import 'seed_hasher.dart';

/// インゲーム（シミュレーション）専用の乱数工場。
///
/// Seed = derive(WorldSeed, "sim", [turn], domain, actor, choice)
///
/// - [turn]: 通算ターン番号。
/// - [domain]: 処理の種類（`player_action`, `npc_autonomy`, `event`, `audition` …）。
/// - [actor]: 主体 ID。NPC ごとに独立したストリームになり、
///   ある NPC の乱数消費量が他の NPC の結果をずらさない。
/// - [choice]: プレイヤーの選択キー。同じターンに同じ選択をすれば必ず同じ結果。
///
/// この設計により「同じ Seed・同じ選択列 → 完全に同じ人生」が保証され、
/// セーブ/ロードによる再抽選（リセマラ）は原理的に成立しない。
class SimulationRng {
  const SimulationRng(this.worldSeed);

  final int worldSeed;

  RngStream stream({
    required int turn,
    required String domain,
    String actor = '',
    String choice = '',
  }) {
    final base = SeedHasher.derive(worldSeed, 'sim', [turn]);
    final withDomain = SeedHasher.derive(base, 'domain:$domain');
    final withActor = SeedHasher.derive(withDomain, 'actor:$actor');
    return RngStream(SeedHasher.derive(withActor, 'choice:$choice'));
  }
}
