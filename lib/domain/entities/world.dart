import 'package:freezed_annotation/freezed_annotation.dart';

import 'club.dart';
import 'memory_tag.dart';
import 'npc.dart';
import 'player.dart';
import 'region.dart';
import 'school.dart';
import 'world_gen_config.dart';

part 'world.freezed.dart';
part 'world.g.dart';

/// World Seed から生成される世界全体。
///
/// Phase 1 時点では「Seed から再生成できる設計図」であり、
/// 永続化するのは Seed と generatorVersion のみ。
@freezed
abstract class World with _$World {
  const factory World({
    required int seed,
    required String seedCode,
    required int generatorVersion,
    required WorldGenConfig config,
    required Region region,
    required List<School> schools,
    required List<Club> clubs,
    required List<Npc> npcs,
    required Player player,
    required List<MemoryTag> memories,
  }) = _World;

  factory World.fromJson(Map<String, dynamic> json) => _$WorldFromJson(json);
}
