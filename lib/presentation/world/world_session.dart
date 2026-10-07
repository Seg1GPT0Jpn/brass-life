import '../../core/rng/rng_service.dart';
import '../../core/time/game_calendar.dart';
import '../../domain/entities/world.dart';
import '../../domain/entities/world_meta.dart';
import '../../domain/services/world_index.dart';

/// 現在ロードされている世界と、それに付随するサービス群。
class WorldSession {
  WorldSession({required this.world, required this.meta})
    : index = WorldIndex(world),
      rng = RngService(world.seed),
      calendar = GameCalendar(world.config.startYear);

  final World world;
  final WorldMeta meta;
  final WorldIndex index;
  final RngService rng;
  final GameCalendar calendar;
}
