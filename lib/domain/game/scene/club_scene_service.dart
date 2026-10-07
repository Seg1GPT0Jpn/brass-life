import '../../value_objects/instrument.dart';
import '../engine/game_context.dart';
import '../engine/relations.dart';
import '../master/behavior_table.dart';
import '../models/game_enums.dart';
import '../models/game_state.dart';
import 'scene_models.dart';

/// ゲーム状態から「いま部の誰がどこで何をしているか」（ジオラマ）を組み立てる。
///
/// 乱数は使わず、NPC の直近の自律行動・やる気・ストレスと
/// プレイヤーの直近の行動だけから決定論的に決まる。
class ClubSceneService {
  const ClubSceneService(this.ctx);

  final GameContext ctx;

  /// 時間帯: 居残り練習の直後と、日の短い冬（11〜1月）は夕暮れ。
  DayPhase timeOf(GameState s) {
    final month = ctx.calendar.dateOf(s.turn).month;
    final last = s.choices.isEmpty ? null : s.choices.last.split(':');
    final stayedLate =
        last != null &&
        last.length >= 2 &&
        last[1] == WeeklyAction.extraPractice.name;
    if (stayedLate || month == 11 || month == 12 || month == 1) {
      return DayPhase.dusk;
    }
    return DayPhase.afterSchool;
  }

  ClubScene compose(GameState s, {DayPhase? time}) {
    time ??= timeOf(s);
    final date = ctx.calendar.dateOf(s.turn);
    final season = Season.ofMonth(date.month);
    final placed = <String, _Placement>{};

    // ── NPC（引退していない部員）──
    for (final m in ctx.activeMembers(s)) {
      placed[m.id] = _placeNpc(m);
    }
    // 相手のいる行動は、相手を同じ場所に呼び寄せる（相手が NPC で、まだ二人組でない場合）。
    for (final m in ctx.activeMembers(s)) {
      final p = placed[m.id]!;
      final t = m.lastTargetId;
      if (t == null || t == Relations.player) continue;
      final other = placed[t];
      if (other == null || other.partnerId != null || p.partnerId != null) {
        continue;
      }
      final complement = switch (p.activity) {
        ActorActivity.teaching => ActorActivity.learning,
        ActorActivity.learning => ActorActivity.teaching,
        ActorActivity.arguing => ActorActivity.arguing,
        ActorActivity.chatting => ActorActivity.chatting,
        _ => null,
      };
      if (complement == null) continue;
      placed[m.id] = p.copyWith(partnerId: t);
      placed[t] = other.copyWith(
        location: p.location,
        activity: complement,
        partnerId: m.id,
        mood: p.activity == ActorActivity.arguing
            ? ActorMood.angry
            : other.mood,
      );
    }

    // ── プレイヤー ──
    final player = s.player;
    placed[Relations.player] = _placePlayer(s, placed);

    // ── 顧問（音楽室の指揮台）──
    final club = ctx.club(s);
    if (!player.retired) {
      placed[club.advisorId] = const _Placement(
        location: SceneLocation.musicRoom,
        activity: ActorActivity.conducting,
        mood: ActorMood.normal,
      );
    }

    // ── 座標の割り当て ──
    final actors = <SceneActor>[];
    for (final loc in SceneLocation.values) {
      final here = [
        for (final e in placed.entries)
          if (e.value.location == loc) e.key,
      ];
      here.sort((a, b) => _orderKey(a, placed).compareTo(_orderKey(b, placed)));
      final points = _grid(loc, here.length);
      for (var i = 0; i < here.length; i++) {
        final id = here[i];
        final p = placed[id]!;
        final isPlayer = id == Relations.player;
        final isAdvisor = id == club.advisorId;
        final st = s.npcs[id];
        actors.add(
          SceneActor(
            id: id,
            name: isPlayer
                ? player.fullName
                : (isAdvisor
                      ? ctx.index.npcById[id]!.fullName
                      : ctx.npc(s, id).fullName),
            location: loc,
            activity: p.activity,
            mood: p.mood,
            x: points[i].$1,
            y: points[i].$2,
            partnerId: p.partnerId,
            isPlayer: isPlayer,
            isAdvisor: isAdvisor,
            grade: isPlayer ? player.grade : st?.grade,
            instrumentLabel: isPlayer
                ? player.instrument?.label
                : st?.instrument?.label,
            family: isPlayer
                ? player.instrument?.family
                : st?.instrument?.family,
            towardPlayer: st?.lastTargetId == Relations.player,
          ),
        );
      }
    }
    return ClubScene(
      season: season,
      time: time,
      ambience: Ambience.of(season, time),
      actors: actors,
    );
  }

  /// 指揮台の顧問 → プレイヤー → 二人組（並べる）→ ID 順。
  static String _orderKey(String id, Map<String, _Placement> placed) {
    final p = placed[id]!;
    if (p.activity == ActorActivity.conducting) return '0';
    if (id == Relations.player) return '1';
    final pair = p.partnerId == null
        ? id
        : ([id, p.partnerId!]..sort()).join('+');
    return '2$pair:$id';
  }

  static SceneLocation partRoomOf(InstrumentType? t) => switch (t?.family) {
    InstrumentFamily.woodwind => SceneLocation.woodwindRoom,
    InstrumentFamily.brass => SceneLocation.brassRoom,
    _ => SceneLocation.musicRoom,
  };

  static ActorMood _moodOf(NpcState m) {
    if (m.stress >= 70) return ActorMood.tired;
    if (m.motivation < 30) return ActorMood.down;
    if (m.motivation >= 75) return ActorMood.happy;
    return ActorMood.normal;
  }

  _Placement _placeNpc(NpcState m) {
    final behavior = m.lastBehavior == null
        ? NpcBehavior.idle
        : NpcBehavior.values.byName(m.lastBehavior!);
    final part = partRoomOf(m.instrument);
    final mood = _moodOf(m);
    if (m.instrument == null) {
      return _Placement(
        location: SceneLocation.musicRoom,
        activity: ActorActivity.waiting,
        mood: mood,
      );
    }
    return switch (behavior) {
      NpcBehavior.practiceHard ||
      NpcBehavior.compete ||
      NpcBehavior.breakthrough => _Placement(
        location: part,
        activity: ActorActivity.practicing,
        mood: behavior == NpcBehavior.breakthrough ? ActorMood.happy : mood,
      ),
      NpcBehavior.slackOff => _Placement(
        location: SceneLocation.courtyard,
        activity: ActorActivity.slacking,
        mood: mood,
      ),
      NpcBehavior.teachJunior => _Placement(
        location: part,
        activity: ActorActivity.teaching,
        mood: mood,
      ),
      NpcBehavior.askSenior => _Placement(
        location: part,
        activity: ActorActivity.learning,
        mood: mood,
      ),
      NpcBehavior.quarrel => const _Placement(
        location: SceneLocation.hallway,
        activity: ActorActivity.arguing,
        mood: ActorMood.angry,
      ),
      NpcBehavior.reconcile || NpcBehavior.encourage => const _Placement(
        location: SceneLocation.hallway,
        activity: ActorActivity.chatting,
        mood: ActorMood.happy,
      ),
      NpcBehavior.bond ||
      NpcBehavior.gossip ||
      NpcBehavior.complainAdvisor => _Placement(
        location: SceneLocation.hallway,
        activity: ActorActivity.chatting,
        mood: behavior == NpcBehavior.complainAdvisor ? ActorMood.down : mood,
      ),
      NpcBehavior.idle =>
        m.motivation >= 55
            ? _Placement(
                location: part,
                activity: ActorActivity.practicing,
                mood: mood,
              )
            : m.motivation >= 30
            ? _Placement(
                location: SceneLocation.musicRoom,
                activity: ActorActivity.practicing,
                mood: mood,
              )
            : _Placement(
                location: SceneLocation.hallway,
                activity: ActorActivity.chatting,
                mood: mood,
              ),
    };
  }

  _Placement _placePlayer(GameState s, Map<String, _Placement> placed) {
    final p = s.player;
    final mood = p.stress >= 70 || p.fatigue >= 80
        ? ActorMood.tired
        : (p.motivation < 30
              ? ActorMood.down
              : (p.motivation >= 75 ? ActorMood.happy : ActorMood.normal));
    final home = p.retired ? SceneLocation.library : partRoomOf(p.instrument);
    // 直近の行動の場所にいる（ターン開始時の選択前の姿）。
    final last = s.choices.isEmpty ? null : s.choices.last.split(':');
    final action = last == null || last.length < 2
        ? null
        : WeeklyAction.values.where((a) => a.name == last[1]).firstOrNull;
    final target = last != null && last.length >= 3 ? last[2] : null;
    if (action == null) {
      return _Placement(
        location: home,
        activity: ActorActivity.practicing,
        mood: mood,
      );
    }
    final (location, activity) = switch (action) {
      WeeklyAction.ensemble => (
        SceneLocation.musicRoom,
        ActorActivity.ensemble,
      ),
      WeeklyAction.maintenance => (
        SceneLocation.storage,
        ActorActivity.maintaining,
      ),
      WeeklyAction.study => (SceneLocation.library, ActorActivity.studying),
      WeeklyAction.breather => (SceneLocation.courtyard, ActorActivity.resting),
      WeeklyAction.hangOut ||
      WeeklyAction.rest => (SceneLocation.gate, ActorActivity.resting),
      WeeklyAction.chat => (
        placed[target]?.location ?? SceneLocation.hallway,
        ActorActivity.chatting,
      ),
      WeeklyAction.learnFrom => (
        placed[target]?.location ?? home,
        ActorActivity.learning,
      ),
      WeeklyAction.teach => (
        placed[target]?.location ?? home,
        ActorActivity.teaching,
      ),
      WeeklyAction.practiceWith => (
        placed[target]?.location ?? home,
        ActorActivity.practicing,
      ),
      _ => (home, ActorActivity.practicing),
    };
    return _Placement(
      location: location,
      activity: activity,
      mood: mood,
      partnerId: action.needsTarget && placed.containsKey(target)
          ? target
          : null,
    );
  }

  /// 場所の中に [n] 人を格子状に並べた中心座標（0..1000）。
  static List<(int, int)> _grid(SceneLocation loc, int n) {
    if (n == 0) return const [];
    // 場所の縦横比に合わせた列数（整数演算で決める）。
    var cols = 1;
    while (cols * cols * loc.height < n * loc.width && cols < n) {
      cols++;
    }
    final rows = (n + cols - 1) ~/ cols;
    const pad = 30; // 見出しのぶん上を空ける
    final w = loc.width;
    final h = loc.height - pad;
    return [
      for (var i = 0; i < n; i++)
        (
          loc.left + (i % cols) * w ~/ cols + w ~/ (2 * cols),
          loc.top + pad + (i ~/ cols) * h ~/ rows + h ~/ (2 * rows),
        ),
    ];
  }
}

class _Placement {
  const _Placement({
    required this.location,
    required this.activity,
    required this.mood,
    this.partnerId,
  });

  final SceneLocation location;
  final ActorActivity activity;
  final ActorMood mood;
  final String? partnerId;

  _Placement copyWith({
    SceneLocation? location,
    ActorActivity? activity,
    ActorMood? mood,
    String? partnerId,
  }) => _Placement(
    location: location ?? this.location,
    activity: activity ?? this.activity,
    mood: mood ?? this.mood,
    partnerId: partnerId ?? this.partnerId,
  );
}
