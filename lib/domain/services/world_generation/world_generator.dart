import '../../../core/rng/seed_code.dart';
import '../../../core/rng/world_seed_rng.dart';
import '../../../core/time/game_calendar.dart';
import '../../entities/club.dart';
import '../../entities/npc.dart';
import '../../entities/player.dart';
import '../../entities/school.dart';
import '../../entities/world.dart';
import '../../entities/world_gen_config.dart';
import '../../value_objects/person_enums.dart';
import '../../value_objects/school_enums.dart';
import 'club_generator.dart';
import 'memory_seeder.dart';
import 'name_generator.dart';
import 'personality_generator.dart';
import 'region_generator.dart';
import 'school_generator.dart';
import 'world_validator.dart';

/// 世界生成のオーケストレーター。
///
/// 同じ (seed, config, [generatorVersion]) からは必ず同一の [World] が生成される。
/// 生成テーブルやアルゴリズムを変更した場合は [generatorVersion] を上げること。
class WorldGenerator {
  const WorldGenerator();

  static const int generatorVersion = 1;

  World generate(int seed, {WorldGenConfig config = const WorldGenConfig()}) {
    final rng = WorldSeedRng(seed);
    final names = NameGenerator();

    // 1. 地域
    final region = RegionGenerator(rng, names).generate(config);

    // 2. 学校
    final schools = SchoolGenerator(rng, names).generate(config, region);

    // 3. 部の計画 → NPC 総数の補正 → 部と部員の構築
    final clubGen = ClubGenerator(rng);
    final plans = clubGen.plan(schools);
    ClubGenerator.scaleSizes(plans, config);
    final clubs = <Club>[];
    final npcs = <Npc>[];
    for (final p in plans) {
      final (club, members) = clubGen.build(p, config);
      clubs.add(club);
      npcs.addAll(members);
    }

    // 4. プレイヤー（所属中学は Seed から自動決定）
    final player = _player(rng, schools);

    // 5. 背景となる記憶
    final calendar = GameCalendar(config.startYear);
    final npcById = {for (final n in npcs) n.id: n};
    final memories = MemorySeeder(
      calendar,
      region,
    ).seed(schools: schools, clubs: clubs, npcById: npcById);

    final world = World(
      seed: seed,
      seedCode: SeedCode.encode(seed),
      generatorVersion: generatorVersion,
      config: config,
      region: region,
      schools: schools,
      clubs: clubs,
      npcs: npcs,
      player: player,
      memories: memories,
    );

    final problems = WorldValidator.validate(world);
    if (problems.isNotEmpty) {
      throw StateError('World validation failed: ${problems.join(' / ')}');
    }
    return world;
  }

  Player _player(WorldSeedRng rng, List<School> schools) {
    final middles = [
      for (final s in schools)
        if (s.level == SchoolLevel.middle) s,
    ]..sort((a, b) => a.id.compareTo(b.id));
    final school = rng.stream('world/player/school').pick(middles);

    final p = rng.stream('world/player/person');
    final gender = school.girlsOnly || p.chance(5000)
        ? Gender.female
        : Gender.male;
    final (family, given) = NameGenerator.personName(p, gender: gender);
    final personality = PersonalityGenerator.axes(p);
    final traits = PersonalityGenerator.traits(p, personality);
    final background = p.weighted(
      [
        MusicBackground.none,
        MusicBackground.piano,
        MusicBackground.elementaryBand,
      ],
      [60, 30, 10],
    );
    final aptitude = PersonalityGenerator.aptitude(
      p,
      traits: traits,
      background: background,
    );
    return Player(
      id: 'player',
      familyName: family,
      givenName: given,
      gender: gender,
      schoolId: school.id,
      grade: 1,
      personality: personality,
      traits: traits,
      aptitude: aptitude,
      academic: p.normalInt(
        mean: school.academicLevel,
        sd: 12,
        min: 0,
        max: 100,
      ),
      stamina: p.normalInt(mean: 50, sd: 15, min: 0, max: 100),
      background: background,
    );
  }
}
