import '../../entities/memory_tag.dart';
import '../../value_objects/relationship_vector.dart';
import '../models/game_enums.dart';
import '../models/game_state.dart';
import 'game_context.dart';
import 'memory_writer.dart';
import 'relations.dart';

/// 退部の理由（記憶と、周りの受け止め方・自分への影響に関わる）。
enum QuitReason {
  study('勉強に専念したい', '成績や受験のために、部活をやめて勉強に打ち込む。'),
  burnout('心が疲れてしまった', '練習や部の空気に疲れ切ってしまった。ストレスは大きく下がる。'),
  relations('部の人間関係がつらい', '部の中の誰かとの関係に耐えられなくなった。'),
  otherPath('ほかにやりたいことがある', '吹奏楽以外に打ち込みたいことができた。');

  const QuitReason(this.label, this.description);
  final String label;
  final String description;
}

/// 退部と再入部。
///
/// 退部すると部活のすべて（合奏・パート練習・オーディション・コンクール・定期演奏会・
/// 幹部選出）から外れ、役職も失う。週の時間は勉強や自主練、友達との時間に使える。
/// 仲の良かった部員は寂しがり、部員と顧問からの信頼は下がる。
/// 退部中はいつでも部に戻れるが、気まずさは残り、2 回目以降は周りの目も冷たい。
/// 3 年生の引退を迎えると戻れなくなる（高校に進むと、新しい部に入り直す）。
class ClubMembership {
  const ClubMembership(this.ctx);

  final GameContext ctx;

  /// 退部できない理由（できるなら null）。
  String? quitUnavailableReason(GameState s) {
    if (s.stage == GameStage.finished) return '6年間は終わった';
    if (s.pending != null) return 'イベントの途中では決められない';
    if (s.player.retired) return 'もう引退している';
    if (s.player.quitClub) return 'すでに部を辞めている';
    if (s.player.instrument == null) return '担当楽器が決まってから';
    return null;
  }

  /// 再入部できない理由（できるなら null）。
  String? rejoinUnavailableReason(GameState s) {
    if (s.stage == GameStage.finished) return '6年間は終わった';
    if (s.pending != null) return 'イベントの途中では決められない';
    if (!s.player.quitClub) return '部を辞めていない';
    if (s.player.retired) return '同級生はもう引退した';
    return null;
  }

  ({GameState state, List<String> lines}) quit(GameState s, QuitReason why) {
    final reason = quitUnavailableReason(s);
    if (reason != null) throw StateError(reason);
    final club = ctx.club(s);
    final mem = MemoryWriter(ctx, s);
    final relations = Map.of(s.relations);
    final npcs = Map.of(s.npcs);
    var p = s.player;
    final lines = <String>['吹奏楽部を辞めた。理由：${why.label}'];

    // 役職を手放す（任期の途中で辞めると、部員たちは戸惑う）
    final roles = Map.of(s.roles);
    final role = roles.remove(Relations.player);
    final abandoned = role != null && role != ClubRole.partLeader;
    if (role != null) lines.add('「${role.label}」の役目も降りた。');
    if (abandoned) lines.add('任期の途中で辞めたことに、部員たちは戸惑っている。');

    // コンクールのメンバーから外れる
    final contestMembers = [
      for (final id in s.contestMembers)
        if (id != Relations.player) id,
    ];
    if (contestMembers.length != s.contestMembers.length) {
      lines.add('コンクールのメンバーからも外れた。');
    }

    // 部員の受け止め方
    final sad = <String>[];
    for (final m in ctx.activeMembers(s)) {
      final toMe = Relations.get(s, m.id, Relations.player);
      var trust = -3 - (abandoned ? 6 : 0) - p.quitCount * 3;
      if (why == QuitReason.relations && toMe.affection < 0) trust = 0;
      Relations.add(
        relations,
        m.id,
        Relations.player,
        RelationshipVector(trust: trust),
      );
      if (toMe.affection >= 30) {
        sad.add(m.id);
        npcs[m.id] = npcs[m.id]!.copyWith(
          motivation: (npcs[m.id]!.motivation - 4).clamp(0, 100),
        );
        mem.add(
          category: MemoryCategory.life,
          subjectId: m.id,
          objectIds: [Relations.player],
          reasonKey: 'friend_quit_sad',
          params: {'actor': ctx.npc(s, m.id).fullName, 'target': p.fullName},
          importance: 30,
        );
      }
    }
    if (sad.isNotEmpty) {
      lines.add(
        '仲の良かった${sad.take(3).map((id) => ctx.npc(s, id).fullName).join('、')}'
        '${sad.length > 3 ? 'たち' : ''}は、とても寂しそうだった。',
      );
    }

    // 自分への影響: 肩の荷は下りるが、ぽっかりと穴が空く
    final relief = switch (why) {
      QuitReason.burnout => 30,
      QuitReason.relations => 25,
      _ => 15,
    };
    final emptiness = 6 + p.quitCount * 6 + (p.motivation >= 60 ? 6 : 0);
    p = p.copyWith(
      quitClub: true,
      quitCount: p.quitCount + 1,
      quitTurn: s.turn,
      stress: (p.stress - relief).clamp(0, 100),
      fatigue: (p.fatigue - 15).clamp(0, 100),
      advisorTrust: (p.advisorTrust - 20 - (abandoned ? 10 : 0)).clamp(0, 100),
      heartache: (p.heartache + emptiness).clamp(0, 100),
    );
    lines.add('肩の荷が下りた（ストレス -$relief）。けれど、胸にぽっかり穴が空いたようだ（心の傷 +$emptiness）。');
    lines.add('${ctx.advisor(s).fullName}先生は、残念そうに退部届を受け取った。');

    mem.add(
      category: MemoryCategory.life,
      subjectId: Relations.player,
      objectIds: [club.id],
      reasonKey: 'player_quit_club',
      params: {'actor': p.fullName, 'target': '（${why.label}）'},
      importance: 70,
      visibility: MemoryVisibility.public,
    );

    final out = mem.apply(
      s.copyWith(
        player: p,
        roles: roles,
        relations: relations,
        npcs: npcs,
        contestMembers: contestMembers,
        soloistId: s.soloistId == Relations.player ? null : s.soloistId,
        choices: [...s.choices, '${s.turn}:quit:${why.name}'],
      ),
    );
    return (state: out, lines: lines);
  }

  ({GameState state, List<String> lines}) rejoin(GameState s) {
    final reason = rejoinUnavailableReason(s);
    if (reason != null) throw StateError(reason);
    final club = ctx.club(s);
    final mem = MemoryWriter(ctx, s);
    final relations = Map.of(s.relations);
    var p = s.player;
    final lines = <String>['もう一度、吹奏楽部に戻ることにした。'];

    var welcomed = 0;
    for (final m in ctx.activeMembers(s)) {
      final toMe = Relations.get(s, m.id, Relations.player);
      if (toMe.affection >= 30) {
        welcomed++;
        Relations.add(
          relations,
          m.id,
          Relations.player,
          const RelationshipVector(affection: 3, trust: 2),
        );
      } else {
        Relations.add(
          relations,
          m.id,
          Relations.player,
          RelationshipVector(trust: -2 - (p.quitCount - 1) * 3),
        );
      }
    }
    if (welcomed > 0) lines.add('仲の良かった部員 $welcomed 人が「おかえり」と迎えてくれた。');
    lines.add(
      p.quitCount >= 2
          ? '二度目となると、さすがに周りの目は冷たい。信頼を取り戻すには時間がかかりそうだ。'
          : '少し気まずいけれど、また音を出せるのはうれしい。',
    );
    if (s.contest != null &&
        s.contest!.nextStage != null &&
        !s.contestMembers.contains(Relations.player)) {
      lines.add('今年のコンクールのメンバーには入れないが、部の一員として支えよう。');
    }

    p = p.copyWith(
      quitClub: false,
      motivation: (p.motivation + 6).clamp(0, 100),
      heartache: (p.heartache - 6).clamp(0, 100),
      advisorTrust: (p.advisorTrust + 5).clamp(0, 100),
    );
    mem.add(
      category: MemoryCategory.life,
      subjectId: Relations.player,
      objectIds: [club.id],
      reasonKey: 'rejoined_club',
      params: {'actor': p.fullName},
      importance: 55,
      visibility: MemoryVisibility.public,
    );
    final out = mem.apply(
      s.copyWith(
        player: p,
        relations: relations,
        choices: [...s.choices, '${s.turn}:rejoin'],
      ),
    );
    return (state: out, lines: lines);
  }
}
