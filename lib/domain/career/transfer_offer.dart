import '../game/engine/game_context.dart';
import '../game/engine/relations.dart';
import '../game/models/game_state.dart';
import '../value_objects/school_enums.dart';
import 'game_mode.dart';

/// 顧問の異動オファー（任期の終わりに、実績から次の赴任先を提示する）。
///
/// 実績 = 任期中のコンクールの最高成績（0..95）+ 部員からの信頼の平均 − 部を去った生徒 × 5。
/// - 実績 [successScore] 以上: 栄転（今より強い部）2 校 + 立て直し 1 校
/// - それ未満: 立て直し（今より弱い部）2 校 +（実績 30 以上なら）栄転 1 校
/// 候補は学校 ID 順に並べ、決定論的乱数（domain 'transfer'）で選ぶ。
/// 世界の暦は 6 年度ぶんなので、次の任期（3 年）が収まらない場合はオファーなし。
class TransferOfferEngine {
  const TransferOfferEngine(this.ctx);

  final GameContext ctx;

  static const int successScore = 55;
  static const int maxYears = 6;

  /// [fiscalYear] から始まる任期が、世界の暦（6 年度）に収まるか。
  bool termFits(int fiscalYear) =>
      fiscalYear + GameMode.termYears <= ctx.calendar.startYear + maxYears;

  /// 任期の実績（[offers] の判定に使う）。
  int score(GameState s) {
    final fy = ctx.calendar.dateOf(s.turn).fiscalYear;
    final termStartFy = fy - GameMode.termYears;
    final best = s.achievements
        .where(
          (a) =>
              a.kind == 'contest_career' &&
              a.schoolId == s.schoolId &&
              a.fiscalYear >= termStartFy,
        )
        .fold(0, (m, a) => a.weight > m ? a.weight : m);
    final termStartTurn = ctx.calendar.firstTurnOfFiscalYear(termStartFy);
    final quits = s.memories
        .where(
          (m) => m.reasonKey == 'quit_club' && m.date.turn >= termStartTurn,
        )
        .length;
    final members = ctx.activeMembers(s);
    final trust = members.isEmpty
        ? 0
        : members.fold(
                0,
                (a, m) => a + Relations.get(s, m.id, Relations.player).trust,
              ) ~/
              members.length;
    return best + trust - quits * 5;
  }

  List<TransferOffer> offers(GameState s) {
    if (s.mode != GameMode.teacher) return const [];
    final fy = ctx.calendar.dateOf(s.turn).fiscalYear;
    if (!termFits(fy)) return const [];
    final served = {...s.career!.servedSchoolIds, s.schoolId};
    final current = ctx.club(s);
    final pool = [
      for (final sc in [
        ...ctx.world.schools,
      ]..sort((a, b) => a.id.compareTo(b.id)))
        if (!served.contains(sc.id)) sc,
    ];
    int rank(String id) => ctx.index.clubOfSchool(id).tier.rank;
    final r = current.tier.rank;
    final promos = [
      for (final sc in pool)
        if (rank(sc.id) > r ||
            (r == ClubTier.national.rank &&
                rank(sc.id) == r &&
                ctx.index.clubOfSchool(sc.id).tradition > current.tradition))
          sc,
    ];
    final rebuilds = [
      for (final sc in pool)
        if (rank(sc.id) < r || (r == ClubTier.weak.rank && rank(sc.id) == r))
          sc,
    ];
    final sc = score(s);
    final success = sc >= successScore;
    final rng = ctx.sim.stream(
      turn: s.turn,
      domain: 'transfer',
      actor: Relations.player,
    );
    // 実績が届かなくても、そこそこなら栄転の芽を 1 つ残す
    final nPromo = success ? 2 : (sc >= 30 ? 1 : 0);
    final nRebuild = success ? 1 : 2;
    final chosenPromos = rng.sample(promos, nPromo.clamp(0, promos.length));
    final chosenRebuilds = rng.sample(
      rebuilds,
      nRebuild.clamp(0, rebuilds.length),
    );
    final schoolName = ctx.school(s).name;
    return [
      for (final p in chosenPromos)
        TransferOffer(
          schoolId: p.id,
          kind: 'promotion',
          reason:
              '$schoolNameでの実績が評価され、${ctx.index.clubOfSchool(p.id).tier.label}の'
              '${p.name}から「うちの部を率いてほしい」と声がかかった。',
        ),
      for (final p in chosenRebuilds)
        TransferOffer(
          schoolId: p.id,
          kind: 'rebuild',
          reason:
              '低迷している${p.name}（${ctx.index.clubOfSchool(p.id).tier.label}）から、'
              '部を立て直してほしいと頼まれた。',
        ),
    ];
  }
}
