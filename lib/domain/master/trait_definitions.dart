import '../value_objects/personality.dart';

/// 性格タグのカテゴリ。
enum TraitCategory {
  motivation('意欲'),
  social('対人'),
  emotion('感情'),
  role('立ち位置'),
  outlook('価値観'),
  special('特殊');

  const TraitCategory(this.label);
  final String label;
}

/// 性格タグの定義。
///
/// - 導出タグ: [score] が正の値を返すとき候補となり、値が大きいほど付与されやすく強度も高い。
/// - 特殊タグ: [specialChance] が非 null のもの。性格軸とは独立に確率で付与される。
///
/// [group] が同じタグは同一人物に共存しない（例：努力家と怠け者）。
/// Phase 3 では各タグが NPC の自律行動の重みを決める。
class TraitDefinition {
  const TraitDefinition({
    required this.id,
    required this.label,
    required this.description,
    required this.category,
    this.group,
    this.score,
    this.specialChance,
  });

  final String id;
  final String label;
  final String description;
  final TraitCategory category;
  final String? group;
  final int Function(PersonalityAxes p)? score;

  /// 特殊タグの付与確率（万分率）。性格軸によって変わる場合がある。
  final int Function(PersonalityAxes p)? specialChance;

  bool get isSpecial => specialChance != null;
}

int _avg2(int a, int b) => (a + b) ~/ 2;
int _avg3(int a, int b, int c) => (a + b + c) ~/ 3;

/// 全性格タグ（表示・抽選ともにこの順序を正とする）。
final List<TraitDefinition> traitDefinitions = [
  // ── 意欲 ──
  TraitDefinition(
    id: 'hardworking',
    label: '努力家',
    description: 'こつこつ練習を積み重ねる。上達が安定している。',
    category: TraitCategory.motivation,
    group: 'diligence',
    score: (p) => p.conscientiousness - 35,
  ),
  TraitDefinition(
    id: 'lazy',
    label: '怠け者',
    description: '楽な方へ流れがち。練習をサボることがある。',
    category: TraitCategory.motivation,
    group: 'diligence',
    score: (p) => -p.conscientiousness - 35,
  ),
  TraitDefinition(
    id: 'perfectionist',
    label: '完璧主義',
    description: '妥協を許さない。自分にも他人にも厳しい。',
    category: TraitCategory.motivation,
    group: 'standards',
    score: (p) => _avg2(p.conscientiousness, p.neuroticism) - 30,
  ),
  TraitDefinition(
    id: 'easygoing',
    label: 'マイペース',
    description: '周りに流されず自分のペースを守る。競争に興味が薄い。',
    category: TraitCategory.motivation,
    group: 'standards',
    score: (p) => _avg2(-p.ambition, -p.extraversion) - 25,
  ),
  TraitDefinition(
    id: 'competitive',
    label: '負けず嫌い',
    description: '同じパートの相手に強いライバル心を燃やす。',
    category: TraitCategory.motivation,
    score: (p) => p.ambition - 40,
  ),
  TraitDefinition(
    id: 'ambitious',
    label: '野心家',
    description: '幹部やソロの座を積極的に狙う。',
    category: TraitCategory.motivation,
    score: (p) => _avg2(p.ambition, p.extraversion) - 45,
  ),
  // ── 対人 ──
  TraitDefinition(
    id: 'sociable',
    label: '社交的',
    description: '誰とでもすぐ打ち解ける。交友関係が広い。',
    category: TraitCategory.social,
    group: 'sociability',
    score: (p) => p.extraversion - 40,
  ),
  TraitDefinition(
    id: 'shy',
    label: '人見知り',
    description: '初対面が苦手。慣れるまで時間がかかる。',
    category: TraitCategory.social,
    group: 'sociability',
    score: (p) => -p.extraversion - 40,
  ),
  TraitDefinition(
    id: 'lone_wolf',
    label: '一匹狼',
    description: '群れるのを嫌い、一人で行動することを好む。',
    category: TraitCategory.social,
    group: 'sociability',
    score: (p) => _avg2(-p.extraversion, -p.agreeableness) - 30,
  ),
  TraitDefinition(
    id: 'caring',
    label: '面倒見が良い',
    description: '後輩や困っている人を放っておけない。',
    category: TraitCategory.social,
    score: (p) => _avg2(p.agreeableness, p.conscientiousness) - 30,
  ),
  TraitDefinition(
    id: 'harmony',
    label: '和を重んじる',
    description: '対立を避け、場の調和を優先する。',
    category: TraitCategory.social,
    group: 'warmth',
    score: (p) => p.agreeableness - 40,
  ),
  TraitDefinition(
    id: 'cynical',
    label: '皮肉屋',
    description: '物言いが辛辣で、敵を作りやすい。',
    category: TraitCategory.social,
    group: 'warmth',
    score: (p) => -p.agreeableness - 40,
  ),
  TraitDefinition(
    id: 'gossip',
    label: '噂好き',
    description: '人の話を広めずにはいられない。情報通。',
    category: TraitCategory.social,
    score: (p) => (p.extraversion * 2 - p.agreeableness) ~/ 3 - 30,
  ),
  TraitDefinition(
    id: 'mood_maker',
    label: 'ムードメーカー',
    description: 'その場を明るくする。部の雰囲気を良くする。',
    category: TraitCategory.social,
    score: (p) => _avg2(p.extraversion, p.agreeableness) - 35,
  ),
  // ── 感情 ──
  TraitDefinition(
    id: 'short_tempered',
    label: '短気',
    description: 'カッとなりやすく、衝突を起こしやすい。',
    category: TraitCategory.emotion,
    group: 'temper',
    score: (p) => _avg2(p.neuroticism, -p.agreeableness) - 30,
  ),
  TraitDefinition(
    id: 'gentle',
    label: '温厚',
    description: 'めったに怒らない。衝突を和らげる。',
    category: TraitCategory.emotion,
    group: 'temper',
    score: (p) => _avg2(p.agreeableness, -p.neuroticism) - 30,
  ),
  TraitDefinition(
    id: 'sensitive',
    label: '繊細',
    description: '傷つきやすく、ストレスを溜め込みやすい。',
    category: TraitCategory.emotion,
    group: 'stability',
    score: (p) => p.neuroticism - 45,
  ),
  TraitDefinition(
    id: 'optimistic',
    label: '楽観的',
    description: '失敗を引きずらない。立ち直りが早い。',
    category: TraitCategory.emotion,
    group: 'stability',
    score: (p) => _avg2(-p.neuroticism, p.extraversion) - 30,
  ),
  TraitDefinition(
    id: 'moody',
    label: '気分屋',
    description: '調子の波が激しく、日によって別人のよう。',
    category: TraitCategory.emotion,
    group: 'stability',
    score: (p) => p.neuroticism - 25 - p.conscientiousness ~/ 2,
  ),
  // ── 立ち位置 ──
  TraitDefinition(
    id: 'leader',
    label: 'リーダー気質',
    description: '自然と人の上に立ち、まとめ役になる。',
    category: TraitCategory.role,
    group: 'role',
    score: (p) => _avg3(p.extraversion, p.ambition, p.conscientiousness) - 30,
  ),
  TraitDefinition(
    id: 'follower',
    label: '従順',
    description: '上の指示に素直に従う。波風を立てない。',
    category: TraitCategory.role,
    group: 'role',
    score: (p) => _avg2(p.agreeableness, -p.ambition) - 35,
  ),
  TraitDefinition(
    id: 'rebellious',
    label: '反骨精神',
    description: '権威や理不尽な慣習に反発する。',
    category: TraitCategory.role,
    group: 'role',
    score: (p) => _avg2(p.ambition, -p.agreeableness) - 35,
  ),
  TraitDefinition(
    id: 'attention_seeker',
    label: '目立ちたがり',
    description: 'ソロや注目される場面を好む。',
    category: TraitCategory.role,
    score: (p) => _avg2(p.extraversion, p.ambition) - 40,
  ),
  // ── 価値観 ──
  TraitDefinition(
    id: 'cautious',
    label: '慎重',
    description: '石橋を叩いて渡る。大きな失敗は少ない。',
    category: TraitCategory.outlook,
    group: 'boldness',
    score: (p) => _avg2(p.conscientiousness, -p.extraversion) - 30,
  ),
  TraitDefinition(
    id: 'reckless',
    label: '向こう見ず',
    description: '考えるより先に動く。周りを巻き込みがち。',
    category: TraitCategory.outlook,
    group: 'boldness',
    score: (p) => _avg2(p.extraversion, -p.conscientiousness) - 35,
  ),
  TraitDefinition(
    id: 'airhead',
    label: '天然',
    description: 'どこか抜けているが憎めない。',
    category: TraitCategory.outlook,
    score: (p) => _avg2(p.agreeableness, -p.conscientiousness) - 35,
  ),
  // ── 特殊 ──
  TraitDefinition(
    id: 'genius',
    label: '天才肌',
    description: '音楽的センスが突出している。努力せずとも伸びる。',
    category: TraitCategory.special,
    specialChance: (p) => 200,
  ),
  TraitDefinition(
    id: 'music_nerd',
    label: '音楽オタク',
    description: '音源や楽典に異常に詳しい。マイナー楽器を好む。',
    category: TraitCategory.special,
    specialChance: (p) => p.extraversion < 0 ? 900 : 400,
  ),
  TraitDefinition(
    id: 'late_bloomer',
    label: '大器晩成',
    description: '最初は目立たないが、学年が上がるにつれ急成長する。',
    category: TraitCategory.special,
    specialChance: (p) => p.conscientiousness > 0 ? 500 : 250,
  ),
  TraitDefinition(
    id: 'stage_fright',
    label: 'あがり症',
    description: '本番やオーディションで実力を出し切れない。',
    category: TraitCategory.special,
    specialChance: (p) => p.neuroticism > 20 ? 1500 : 300,
  ),
  TraitDefinition(
    id: 'romantic',
    label: '恋愛体質',
    description: '恋愛ごとで一喜一憂し、人間関係が揺れやすい。',
    category: TraitCategory.special,
    specialChance: (p) => p.extraversion > 20 ? 700 : 350,
  ),
];

final Map<String, TraitDefinition> traitById = {
  for (final t in traitDefinitions) t.id: t,
};
