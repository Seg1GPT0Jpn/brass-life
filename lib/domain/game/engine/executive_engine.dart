import '../../entities/memory_tag.dart';
import '../../value_objects/instrument.dart';
import '../../value_objects/personality.dart';
import '../../value_objects/relationship_vector.dart';
import '../../value_objects/school_enums.dart';
import '../models/candidacy.dart';
import '../models/game_enums.dart';
import '../models/game_state.dart';
import 'game_context.dart';
import 'memory_writer.dart';
import 'relations.dart';

/// 秋の幹部選出（3 年生の引退後、2 年生から選ぶ）。
///
/// 役職は学校の幹部制度で決まる:
/// - 制度A（中央集権型）: 部長・副部長・学生指揮・会計
/// - 制度B（合議型）: 学年代表・副代表・学生指揮
/// - 制度C（顧問主導型）: 部長・副部長（名目）・学生指揮
/// どの制度でも、木管・金管・打楽器のセクションリーダー（その系統の 2 年生から実力と統率力で）と、
/// 各楽器のパートリーダー（その楽器で最も上手い 2 年生、いなければ 1 年生）を置く。
///
/// プレイヤーは役職を選んで立候補できる（[Candidacy]）。立候補した人は狙った役職の候補にだけなり、
/// なりたい気持ちが強いほど選ばれやすいが、選ばれなかったときの心の傷も深く長く残る。
///
/// 選び方は選出文化で決まる:
/// - 部員投票: 全部員が「信頼 + 好感/2 + 統率力/2 + 揺らぎ」が最大の候補に投票
/// - 前任者指名: 前部長（いなければ最上手の 3 年生）が「信頼×2 + 統率力 + 揺らぎ」で指名
/// - 顧問任命: 顧問が「熟練度/10 + 勤勉性/2 + 統率力/2 + 顧問からの評価 + 揺らぎ」で任命
/// - 話し合い: 2 年生同士の「好感 + 信頼」の平均 + 統率力/2 + 揺らぎ
class ExecutiveEngine {
  const ExecutiveEngine(this.ctx);

  final GameContext ctx;

  static List<ClubRole> positionsOf(ExecutiveSystem system) => switch (system) {
    ExecutiveSystem.a => [
      ClubRole.captain,
      ClubRole.viceCaptain,
      ClubRole.conductor,
      ClubRole.treasurer,
    ],
    ExecutiveSystem.b => [
      ClubRole.gradeRep,
      ClubRole.viceRep,
      ClubRole.conductor,
    ],
    ExecutiveSystem.c => [
      ClubRole.captain,
      ClubRole.viceCaptain,
      ClubRole.conductor,
    ],
  };

  /// セクションリーダーを置く系統。
  static const sections = [
    InstrumentFamily.woodwind,
    InstrumentFamily.brass,
    InstrumentFamily.percussion,
  ];

  /// プレイヤーが立候補できる役職（2 年生の幹部選出時）。
  List<ClubRole> runnableRoles(GameState s) {
    final family = s.player.instrument?.family;
    return [
      ...positionsOf(ctx.club(s).executiveSystem),
      if (family != null && sections.contains(family)) ClubRole.sectionLeader,
      if (s.player.instrument != null) ClubRole.partLeader,
    ];
  }

  /// 立候補した役職に選ばれなかったときの心の傷（気持ちの強さ × 役職の重み）。
  static int heartacheOf(ClubRole role, int desire) =>
      desire *
      switch (role) {
        ClubRole.captain || ClubRole.gradeRep => 12,
        ClubRole.conductor => 11,
        ClubRole.sectionLeader => 9,
        ClubRole.partLeader => 7,
        _ => 8,
      };

  /// 立候補による候補者としての加点（気持ちが強いほど本気が伝わる）。
  static int _desireBonus(int desire) => desire * 5;

  /// 学生指揮としての音楽的な実力: 表現の適性×3 + 音楽性/2 + 熟練度/2。
  /// NPC は音楽性を持たないので、プレイヤーの初期値（100）相当とみなす。
  int _musicalScore(GameState s, String id) => id == Relations.player
      ? s.player.aptitude.expression * 3 +
            s.player.musicality ~/ 2 +
            s.player.skill ~/ 2
      : ctx.npc(s, id).aptitude.expression * 3 + 50 + _skill(s, id) ~/ 2;

  /// 統率力（候補者の資質）。
  int _leadership(GameState s, String id, Candidacy? choice) {
    final List<TraitTag> traits;
    final PersonalityAxes p;
    var extra = 0;
    if (id == Relations.player) {
      traits = s.player.traits;
      p = s.player.personality;
      extra =
          s.player.social ~/ 3 +
          s.player.advisorTrust ~/ 5 +
          s.player.skill ~/ 25;
      if (choice != null && choice.isRun) extra += _desireBonus(choice.desire);
    } else {
      final n = ctx.npc(s, id);
      traits = n.traits;
      p = n.personality;
      // プレイヤーの社交性・顧問評価に相当するものとして、やる気（部への熱意）を見る。
      final st = s.npcs[id];
      extra = (st?.skill ?? 0) ~/ 25 + (st?.motivation ?? 0) ~/ 3;
    }
    int t(String trait, int pts) {
      for (final x in traits) {
        if (x.traitId == trait) return pts * x.intensity;
      }
      return 0;
    }

    return t('leader', 15) +
        t('ambitious', 8) +
        t('caring', 5) +
        t('harmony', 3) +
        t('mood_maker', 3) -
        t('shy', 5) -
        t('lone_wolf', 6) +
        p.conscientiousness ~/ 3 +
        p.extraversion ~/ 5 +
        p.agreeableness ~/ 8 +
        extra;
  }

  int _skill(GameState s, String id) =>
      id == Relations.player ? s.player.skill : (s.npcs[id]?.skill ?? 0);

  InstrumentType? _instrument(GameState s, String id) =>
      id == Relations.player ? s.player.instrument : s.npcs[id]?.instrument;

  String _name(GameState s, String id) =>
      id == Relations.player ? s.player.fullName : ctx.npc(s, id).fullName;

  ({GameState state, List<String> lines}) run(GameState s, Candidacy? choice) {
    final club = ctx.club(s);
    final members = ctx.activeMembers(s);
    final playerActive = s.player.inClub && s.player.instrument != null;
    final secondYears = [
      for (final m in members)
        if (m.grade == 2) m.id,
      if (playerActive &&
          s.player.grade == 2 &&
          choice?.choice != CandidacyChoice.decline)
        Relations.player,
    ];
    final lines = <String>[];
    final mem = MemoryWriter(ctx, s);
    final relations = Map.of(s.relations);
    var player = s.player;
    // 新しい代の役職を一から決める（前の代の役職は引退とともに終わる）。
    final roles = <String, ClubRole>{};

    final rng = ctx.sim.stream(
      turn: s.turn,
      domain: 'executive',
      actor: club.id,
      choice: choice?.key ?? '',
    );
    final lead = {for (final id in secondYears) id: _leadership(s, id, choice)};

    // 候補者の得点（選出文化別）
    final score = <String, int>{};
    final votes = <String, int>{};
    switch (club.selectionCulture) {
      case SelectionCulture.vote:
        final voters = [
          for (final m in members) m.id,
          if (playerActive) Relations.player,
        ];
        for (final v in voters) {
          final options = secondYears.where((c) => c != v).toList();
          if (options.isEmpty) continue;
          final vr = ctx.sim.stream(
            turn: s.turn,
            domain: 'executive_vote',
            actor: v,
          );
          var best = options.first;
          var bestScore = -1000000;
          for (final c in options) {
            final r = Relations.get(s, v, c);
            final sc =
                r.trust + r.affection ~/ 2 + lead[c]! ~/ 2 + vr.range(0, 15);
            if (sc > bestScore) {
              best = c;
              bestScore = sc;
            }
          }
          votes[best] = (votes[best] ?? 0) + 1;
        }
        for (final c in secondYears) {
          score[c] = (votes[c] ?? 0) * 1000 + lead[c]!;
        }
      case SelectionCulture.nomination:
        String? nominator;
        for (final e in s.roles.entries) {
          if (e.value == ClubRole.captain || e.value == ClubRole.gradeRep) {
            nominator = e.key;
          }
        }
        nominator ??= _bestThirdYear(s);
        for (final c in secondYears) {
          final trust = nominator == null
              ? 0
              : Relations.get(s, nominator, c).trust;
          score[c] = trust * 2 + lead[c]! + rng.range(0, 20);
        }
        if (nominator != null) lines.add('前部長の${_name(s, nominator)}が後任を指名した。');
      case SelectionCulture.advisorAppointment:
        for (final c in secondYears) {
          final consc = c == Relations.player
              ? s.player.personality.conscientiousness
              : ctx.npc(s, c).personality.conscientiousness;
          // 顧問からの評価: プレイヤーは顧問の評価値、NPC はやる気と顧問への不満から推定。
          final view = c == Relations.player
              ? s.player.advisorTrust - 50
              : (s.npcs[c]!.motivation - 50) +
                    Relations.get(s, c, club.advisorId).trust.clamp(-30, 0) ~/
                        2;
          score[c] =
              _skill(s, c) ~/ 10 +
              consc ~/ 2 +
              lead[c]! ~/ 2 +
              view +
              rng.range(0, 15);
        }
        lines.add('顧問が幹部を任命した。');
      case SelectionCulture.discussion:
        for (final c in secondYears) {
          var sum = 0;
          var n = 0;
          for (final p in secondYears) {
            if (p == c) continue;
            final r = Relations.get(s, p, c);
            sum += r.affection + r.trust;
            n++;
          }
          score[c] = (n == 0 ? 0 : sum ~/ n) + lead[c]! ~/ 2 + rng.range(0, 15);
        }
        lines.add('2年生の話し合いで幹部が決まった。');
    }

    final ranked = [...secondYears]
      ..sort((a, b) {
        final c = score[b]!.compareTo(score[a]!);
        return c != 0 ? c : a.compareTo(b);
      });
    final positions = positionsOf(club.executiveSystem);
    // 立候補したプレイヤーは狙った役職の候補にだけなる。
    final target = choice != null && choice.isRun ? choice.role : null;
    final desire = choice?.desire ?? 0;
    bool eligible(String id, ClubRole pos) =>
        id != Relations.player || target == null || target == pos;
    // 実力で選ぶ役職での加点（各役職の得点の尺度に合わせる）。
    // 部長などの票・指名で決まる役職は、統率力への加点（_desireBonus）で反映済み。
    int bonus(String id, ClubRole pos) {
      if (id != Relations.player || target != pos) return 0;
      return switch (pos) {
        ClubRole.conductor => 20 + desire * 15,
        ClubRole.sectionLeader => 10 + desire * 8,
        ClubRole.partLeader => 20 + desire * 12,
        _ => 0,
      };
    }

    final taken = <String>{};
    for (final pos in positions) {
      String? chosen;
      if (pos == ClubRole.conductor) {
        // 学生指揮は音楽的な実力で選ぶ
        final pool =
            ranked.where((c) => !taken.contains(c) && eligible(c, pos)).toList()
              ..sort((a, b) {
                int mus(String id) => _musicalScore(s, id) + bonus(id, pos);
                final c = mus(b).compareTo(mus(a));
                return c != 0 ? c : a.compareTo(b);
              });
        chosen = pool.isEmpty ? null : pool.first;
      } else {
        chosen = ranked.firstWhere(
          (c) => !taken.contains(c) && eligible(c, pos),
          orElse: () => '',
        );
        if (chosen.isEmpty) chosen = null;
      }
      if (chosen == null) continue;
      taken.add(chosen);
      roles[chosen] = pos;
    }

    // セクションリーダー: 系統ごとに、まだ役職のない 2 年生から実力と統率力で
    final sectionOf = <String, InstrumentFamily>{};
    for (final family in sections) {
      final pool =
          secondYears
              .where(
                (c) =>
                    !taken.contains(c) &&
                    eligible(c, ClubRole.sectionLeader) &&
                    _instrument(s, c)?.family == family,
              )
              .toList()
            ..sort((a, b) {
              int sc(String id) =>
                  _skill(s, id) ~/ 3 +
                  lead[id]! ~/ 2 +
                  bonus(id, ClubRole.sectionLeader);
              final c = sc(b).compareTo(sc(a));
              return c != 0 ? c : a.compareTo(b);
            });
      if (pool.isEmpty) continue;
      taken.add(pool.first);
      roles[pool.first] = ClubRole.sectionLeader;
      sectionOf[pool.first] = family;
    }

    // パートリーダー: 各楽器で最も上手い 2 年生（いなければ 1 年生）
    final byInstrument = <InstrumentType, List<String>>{};
    for (final id in [
      for (final m in members) m.id,
      if (playerActive) Relations.player,
    ]) {
      final inst = _instrument(s, id);
      if (inst == null) continue;
      (byInstrument[inst] ??= []).add(id);
    }
    for (final e in byInstrument.entries) {
      int grade(String id) =>
          id == Relations.player ? s.player.grade : s.npcs[id]!.grade;
      final pool = e.value.where((id) => grade(id) == 2).toList();
      final pool2 = pool.isNotEmpty
          ? pool
          : e.value.where((id) => grade(id) == 1).toList();
      if (pool2.isEmpty) continue;
      int sc(String id) => _skill(s, id) + bonus(id, ClubRole.partLeader);
      pool2.sort((a, b) {
        final c = sc(b).compareTo(sc(a));
        return c != 0 ? c : a.compareTo(b);
      });
      // ほかの役職に就いた人は除き、残りで最も上手い人
      final leader = pool2.where((id) => !roles.containsKey(id)).firstOrNull;
      if (leader != null) roles[leader] = ClubRole.partLeader;
    }

    // 結果の反映
    for (final e in roles.entries) {
      if (e.value == ClubRole.partLeader && e.key != Relations.player) continue;
      mem.add(
        category: MemoryCategory.appointment,
        subjectId: e.key,
        objectIds: [club.id],
        reasonKey: 'appointed_role',
        params: {'actor': _name(s, e.key), 'role': e.value.label},
        importance: switch (e.value) {
          ClubRole.captain || ClubRole.gradeRep => 60,
          ClubRole.partLeader => 30,
          _ => 40,
        },
        visibility: MemoryVisibility.public,
      );
    }
    final top = positions.isEmpty
        ? null
        : roles.entries
              .where((e) => e.value == positions.first)
              .map((e) => e.key)
              .firstOrNull;
    if (top != null) {
      lines.add('新しい${positions.first.label}は${_name(s, top)}に決まった。');
      // 部長に選ばれた人への信頼
      for (final m in members) {
        if (m.id != top && m.grade <= 2) {
          Relations.add(
            relations,
            m.id,
            top,
            const RelationshipVector(trust: 3),
          );
        }
      }
    }
    for (final e in roles.entries) {
      if (e.key == top || e.value == ClubRole.partLeader) continue;
      final section = sectionOf[e.key];
      lines.add(
        '${e.value.label}${section == null ? '' : '（${section.label}）'}：${_name(s, e.key)}',
      );
    }
    if (club.selectionCulture == SelectionCulture.vote && votes.isNotEmpty) {
      final tally = votes.entries.toList()
        ..sort((a, b) {
          final c = b.value.compareTo(a.value);
          return c != 0 ? c : a.key.compareTo(b.key);
        });
      lines.add(
        '得票：${tally.take(3).map((e) => '${_name(s, e.key)} ${e.value}票').join('、')}',
      );
    }

    final myRole = roles[Relations.player];
    if (playerActive && s.player.grade == 2) {
      if (target != null && myRole == target) {
        lines.add('あなたは立候補した「${myRole!.label}」に選ばれた！');
        player = player.copyWith(
          motivation: (player.motivation + 4 + desire * 2).clamp(0, 100),
          // 念願がかなうと、古い傷も少し癒える
          heartache: (player.heartache - desire * 4).clamp(0, 100),
        );
      } else if (target != null) {
        // 狙った役職に選ばれなかった: 気持ちが強いほど深く傷つく
        final winner = roles.entries
            .where(
              (e) =>
                  e.value == target && _sameGroup(s, e.key, target, sectionOf),
            )
            .map((e) => e.key)
            .firstOrNull;
        final damage = heartacheOf(target, desire);
        lines.add(
          '「${target.label}」に立候補したが、選ばれたのは'
          '${winner == null ? '別の人' : _name(s, winner)}だった……。',
        );
        if (myRole != null) lines.add('代わりに「${myRole.label}」を任された。');
        lines.add(switch (desire) {
          >= 5 => 'すべてを懸けていた。頭が真っ白になり、楽器を持つ手が震えた。この痛みはきっと長く残る。',
          4 => '本気でなりたかった分、悔しさが胸に深く刺さった。しばらくは立ち直れそうにない。',
          3 => '悔しさがじわじわとこみ上げてくる。',
          _ => '残念だけど、仕方ない。少しだけ胸がちくりとした。',
        });
        lines.add('心の傷 +$damage');
        player = player.copyWith(
          motivation: (player.motivation - 3 - damage ~/ 2).clamp(0, 100),
          stress: (player.stress + damage ~/ 2).clamp(0, 100),
          heartache: (player.heartache + damage).clamp(0, 100),
        );
        if (winner != null) {
          Relations.add(
            relations,
            Relations.player,
            winner,
            RelationshipVector(rivalry: 4 + desire * 2),
          );
        }
        mem.add(
          category: MemoryCategory.appointment,
          subjectId: Relations.player,
          objectIds: [?winner],
          reasonKey: desire >= 4 ? 'lost_role_heartbreak' : 'lost_role',
          params: {
            'actor': player.fullName,
            'role': target.label,
            'target': winner == null ? '別の人' : _name(s, winner),
          },
          importance: 30 + damage ~/ 2,
        );
      } else if (myRole != null) {
        lines.add('あなたは「${myRole.label}」になった。');
        player = player.copyWith(
          motivation: (player.motivation + 8).clamp(0, 100),
        );
      }
    }
    if (myRole != null) {
      final stageLabel = ctx.calendar.dateOf(s.turn).stageLabel;
      final weight = switch (myRole) {
        ClubRole.captain || ClubRole.gradeRep => 70,
        ClubRole.conductor => 55,
        ClubRole.sectionLeader => 35,
        ClubRole.partLeader => 25,
        _ => 40,
      };
      s = s.copyWith(
        achievements: [
          ...s.achievements,
          Achievement(
            fiscalYear: ctx.calendar.dateOf(s.turn).fiscalYear,
            schoolId: s.schoolId,
            kind: 'role:${myRole.name}',
            label: '$stageLabel ${ctx.school(s).name} 吹奏楽部 ${myRole.label}',
            weight: weight,
          ),
        ],
      );
    }

    final out = mem.apply(
      s.copyWith(
        roles: roles,
        relations: relations,
        player: player,
        executiveSelectionTurn: null,
      ),
    );
    return (state: out, lines: lines);
  }

  /// [id] がプレイヤーと同じ枠を争った相手か
  /// （セクションリーダーなら同じ系統、パートリーダーなら同じ楽器）。
  bool _sameGroup(
    GameState s,
    String id,
    ClubRole role,
    Map<String, InstrumentFamily> sectionOf,
  ) => switch (role) {
    ClubRole.sectionLeader => sectionOf[id] == s.player.instrument?.family,
    ClubRole.partLeader => _instrument(s, id) == s.player.instrument,
    _ => true,
  };

  String? _bestThirdYear(GameState s) {
    String? best;
    var bestSkill = -1;
    for (final id in s.roster) {
      final st = s.npcs[id];
      if (st == null || !st.active || st.grade != 3) continue;
      if (st.skill > bestSkill) {
        best = id;
        bestSkill = st.skill;
      }
    }
    return best;
  }
}
