import 'simulation_rng.dart';
import 'world_seed_rng.dart';

/// [WorldSeedRng] と [SimulationRng] を束ねるサービス。
///
/// アプリ内で乱数が必要な箇所は必ずこのサービス経由でストリームを得ること。
/// `dart:math` の `Random` の直接使用はアーキテクチャテストで禁止している。
class RngService {
  RngService(this.worldSeed)
    : world = WorldSeedRng(worldSeed),
      simulation = SimulationRng(worldSeed);

  final int worldSeed;
  final WorldSeedRng world;
  final SimulationRng simulation;
}
