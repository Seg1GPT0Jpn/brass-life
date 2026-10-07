import '../../../core/rng/rng_stream.dart';
import '../../../core/rng/world_seed_rng.dart';
import '../../entities/region.dart';
import '../../entities/school.dart';
import '../../entities/world_gen_config.dart';
import '../../master/name_pools.dart';
import '../../value_objects/school_enums.dart';
import 'name_generator.dart';

/// 学校の生成。
///
/// ストリーム:
/// - `world/schools/{level}/layout`: 校種全体の配置（地区割当・偏差値の層化抽選・私立選定）
/// - `world/school/{id}`: 個別校の属性（市町・校名・規模・校風・創立年）
class SchoolGenerator {
  SchoolGenerator(this._rng, this._names);

  final WorldSeedRng _rng;
  final NameGenerator _names;
  final Set<String> _usedSchoolNames = {};

  static String highId(int i) => 'sch_h${i.toString().padLeft(2, '0')}';
  static String middleId(int i) => 'sch_m${i.toString().padLeft(2, '0')}';
  static String clubIdOf(String schoolId) => 'club_${schoolId.substring(4)}';

  List<School> generate(WorldGenConfig config, Region region) {
    final highs = _layoutHigh(config, region);
    final middles = _layoutMiddle(config, region, highs);
    final drafts = [...highs, ...middles];
    return [for (final d in drafts) _build(d, region)];
  }

  // ───────────────────────── 配置（校種単位） ─────────────────────────

  List<_Draft> _layoutHigh(WorldGenConfig config, Region region) {
    final n = config.highSchoolCount;
    final rng = _rng.stream('world/schools/high/layout');
    final districts = _districtAssignment(rng, n, region.districts.length);

    // 偏差値の層化抽選: 35〜74 を 8 帯に分け、各帯に均等に割り当ててから揺らぎを加える。
    final bands = rng.shuffled([
      for (var i = 0; i < n; i++) 35 + (i * 8 ~/ n) * 5,
    ]);
    final deviations = [for (final b in bands) b + rng.range(0, 4)];

    // 私立（約 3 割）: 偏差値が極端な学校ほど私立になりやすい。
    final privateCount = (n * 3 + 5) ~/ 10;
    final privateIdx = rng
        .weightedSample(
          [for (var i = 0; i < n; i++) i],
          [for (final d in deviations) 10 + (d - 55).abs() * 3],
          privateCount,
        )
        .toSet();

    final drafts = <_Draft>[];
    for (var i = 0; i < n; i++) {
      final isPrivate = privateIdx.contains(i);
      drafts.add(
        _Draft(
          id: highId(i),
          level: SchoolLevel.high,
          districtIndex: districts[i],
          isPrivate: isPrivate,
          deviation: deviations[i],
          motto: isPrivate ? _names.privateMotto(rng) : null,
          form: isPrivate ? _privateForm(rng) : null,
        ),
      );
    }
    return drafts;
  }

  List<_Draft> _layoutMiddle(
    WorldGenConfig config,
    Region region,
    List<_Draft> highs,
  ) {
    final n = config.middleSchoolCount;
    final rng = _rng.stream('world/schools/middle/layout');
    final districts = _districtAssignment(rng, n, region.districts.length);

    // 私立中（約 1 割）は私立高の系列校（中高一貫）とする。偏差値の高い私立高ほど系列中を持ちやすい。
    final privateHighs = [
      for (final h in highs)
        if (h.isPrivate) h,
    ];
    final privateCount = ((n + 5) ~/ 10).clamp(0, privateHighs.length);
    final partners = rng.weightedSample(privateHighs, [
      for (final h in privateHighs) (h.deviation! - 30).clamp(1, 100),
    ], privateCount);
    final privateIdx = rng.sample([
      for (var i = 0; i < n; i++) i,
    ], privateCount);

    final drafts = <_Draft>[];
    for (var i = 0; i < n; i++) {
      final pIndex = privateIdx.indexOf(i);
      final partner = pIndex >= 0 ? partners[pIndex] : null;
      final draft = _Draft(
        id: middleId(i),
        level: SchoolLevel.middle,
        // 系列中は系列高と同じ地区に置く。
        districtIndex: partner?.districtIndex ?? districts[i],
        isPrivate: partner != null,
        deviation: null,
        motto: partner?.motto,
        form: partner?.form,
        partner: partner,
      );
      if (partner != null) partner.affiliatedId = draft.id;
      drafts.add(draft);
    }
    return drafts;
  }

  /// 地区への均等割当（地区 i に n/D 校前後）をシャッフルしたもの。
  List<int> _districtAssignment(RngStream rng, int n, int d) =>
      rng.shuffled([for (var i = 0; i < n; i++) i % d]);

  String _privateForm(RngStream rng) =>
      rng.weighted(privateForms, [35, 25, 15, 10, 15]);

  // ───────────────────────── 個別校 ─────────────────────────

  School _build(_Draft d, Region region) {
    final rng = _rng.stream('world/school/${d.id}');
    final district = region.districts[d.districtIndex];
    final town = rng.pick(district.towns);
    final isHigh = d.level == SchoolLevel.high;

    final name = d.isPrivate ? _privateName(d) : _publicName(rng, town, isHigh);

    final studentCount = switch ((isHigh, d.isPrivate)) {
      (false, false) => rng.normalInt(mean: 450, sd: 160, min: 150, max: 850),
      (false, true) => rng.normalInt(mean: 480, sd: 100, min: 300, max: 700),
      (true, false) => rng.normalInt(mean: 720, sd: 180, min: 360, max: 1080),
      (true, true) => rng.normalInt(mean: 1000, sd: 250, min: 600, max: 1600),
    };

    final academicLevel = switch ((isHigh, d.partner)) {
      (true, _) => d.deviation!,
      (false, final _Draft p?) => (p.deviation! - 3 + rng.range(-2, 2)).clamp(
        35,
        75,
      ),
      (false, null) => rng.normalInt(mean: 50, sd: 6, min: 38, max: 62),
    };

    final cultures = _cultures(
      rng,
      isHigh: isHigh,
      isPrivate: d.isPrivate,
      academic: academicLevel,
      inherited: d.partner?.cultures,
    );
    d.cultures = cultures;

    final foundedYear = switch (cultures) {
      _ when cultures.contains(SchoolCulture.traditional) => rng.range(
        1890,
        1950,
      ),
      _ when cultures.contains(SchoolCulture.newSchool) => rng.range(
        1990,
        2016,
      ),
      _ => rng.range(1950, 1989),
    };

    return School(
      id: d.id,
      name: name,
      level: d.level,
      ownership: d.isPrivate
          ? SchoolOwnership.privateSchool
          : SchoolOwnership.publicSchool,
      districtId: district.id,
      town: town,
      foundedYear: foundedYear,
      studentCount: studentCount,
      deviation: isHigh ? d.deviation : null,
      academicLevel: academicLevel,
      cultures: cultures,
      clubId: clubIdOf(d.id),
      girlsOnly: d.form == '女子学園',
      affiliatedSchoolId: d.partner?.id ?? d.affiliatedId,
    );
  }

  String _publicName(RngStream rng, String town, bool isHigh) {
    final qualifiers = isHigh ? highSchoolQualifiers : middleSchoolQualifiers;
    final suffix = isHigh ? '高等学校' : '中学校';
    final offset = rng.nextInt(qualifiers.length);
    // 最初は無印を優先し、重複したら別の修飾語を試す。
    final order = [
      qualifiers.first,
      for (var i = 0; i < qualifiers.length; i++)
        qualifiers[(offset + i) % qualifiers.length],
    ];
    for (final q in order) {
      final name = '$town$q$suffix';
      if (_usedSchoolNames.add(name)) return name;
    }
    var n = 3;
    while (!_usedSchoolNames.add('$town第$n$suffix')) {
      n++;
    }
    return '$town第$n$suffix';
  }

  String _privateName(_Draft d) {
    final suffix = d.level == SchoolLevel.high ? '高等学校' : '中学校';
    final name = '${d.motto}${d.form}$suffix';
    _usedSchoolNames.add(name);
    return name;
  }

  /// 校風タグの抽選（1〜3 個、同一グループは排他）。系列中は系列高の校風を継承しやすい。
  List<SchoolCulture> _cultures(
    RngStream rng, {
    required bool isHigh,
    required bool isPrivate,
    required int academic,
    List<SchoolCulture>? inherited,
  }) {
    int weight(SchoolCulture c) {
      var w = switch (c) {
        SchoolCulture.free => 20 + (academic >= 60 ? 15 : 0),
        SchoolCulture.strict =>
          20 + (isPrivate ? 15 : 0) + (academic < 45 ? 10 : 0),
        SchoolCulture.academic =>
          academic >= 60 ? 50 : (academic >= 52 ? 20 : 3),
        SchoolCulture.balanced => 25,
        SchoolCulture.traditional => isPrivate ? 15 : 22,
        SchoolCulture.newSchool => 12 + (isPrivate ? 10 : 0),
        SchoolCulture.clubFocused => 20 + (academic < 55 ? 15 : 0),
        SchoolCulture.community => isPrivate ? 3 : 20,
        SchoolCulture.international => isPrivate ? 20 : 3,
        SchoolCulture.arts => 10,
      };
      if (inherited != null && inherited.contains(c)) w *= 6;
      return w;
    }

    final count = rng.weighted([1, 2, 3], [30, 50, 20]);
    final pool = List.of(SchoolCulture.values);
    final picked = <SchoolCulture>[];
    while (picked.length < count && pool.isNotEmpty) {
      final idx = rng.weightedIndex([for (final c in pool) weight(c)]);
      final c = pool.removeAt(idx);
      picked.add(c);
      if (c.group != null) pool.removeWhere((o) => o.group == c.group);
    }
    picked.sort((a, b) => a.index.compareTo(b.index));
    return picked;
  }
}

class _Draft {
  _Draft({
    required this.id,
    required this.level,
    required this.districtIndex,
    required this.isPrivate,
    required this.deviation,
    this.motto,
    this.form,
    this.partner,
  });

  final String id;
  final SchoolLevel level;
  final int districtIndex;
  final bool isPrivate;
  final int? deviation;
  final String? motto;
  final String? form;
  final _Draft? partner;
  String? affiliatedId;
  List<SchoolCulture>? cultures;
}
