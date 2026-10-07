import '../../value_objects/school_enums.dart';

/// NPC の自律行動。
enum NpcBehavior {
  idle('（特になし）', false),
  practiceHard('自主練に励む', false),
  slackOff('練習をサボる', false),
  breakthrough('壁を越える', false),
  teachJunior('後輩に教える', true),
  askSenior('先輩に教わる', true),
  bond('仲良くなる', true),
  quarrel('口論する', true),
  compete('張り合う', true),
  gossip('噂を広める', true),
  reconcile('仲直りする', true),
  complainAdvisor('顧問への不満を漏らす', true),
  encourage('励ます', true);

  const NpcBehavior(this.label, this.needsTarget);
  final String label;
  final bool needsTarget;
}

/// 行動の基礎重み（1 週あたり、合計 1000 前後）。
const Map<NpcBehavior, int> baseBehaviorWeights = {
  NpcBehavior.idle: 640,
  NpcBehavior.practiceHard: 80,
  NpcBehavior.slackOff: 40,
  NpcBehavior.breakthrough: 4,
  NpcBehavior.teachJunior: 30,
  NpcBehavior.askSenior: 25,
  NpcBehavior.bond: 55,
  NpcBehavior.quarrel: 14,
  NpcBehavior.compete: 25,
  NpcBehavior.gossip: 10,
  NpcBehavior.reconcile: 20,
  NpcBehavior.complainAdvisor: 10,
  NpcBehavior.encourage: 15,
};

/// 性格タグ → 行動の重み補正（％）。記載のない組み合わせは 100%。
/// 強度（★）が 2 以上なら補正が強まる（100 からの差分 × 強度 / 2 … ★1 は半分）。
const Map<String, Map<NpcBehavior, int>> traitBehaviorModifiers = {
  'hardworking': {NpcBehavior.practiceHard: 250, NpcBehavior.slackOff: 30},
  'lazy': {NpcBehavior.slackOff: 300, NpcBehavior.practiceHard: 40},
  'perfectionist': {NpcBehavior.practiceHard: 150, NpcBehavior.quarrel: 150},
  'easygoing': {NpcBehavior.compete: 40, NpcBehavior.idle: 120},
  'competitive': {NpcBehavior.compete: 300, NpcBehavior.quarrel: 130},
  'ambitious': {NpcBehavior.compete: 180, NpcBehavior.practiceHard: 130},
  'sociable': {NpcBehavior.bond: 220, NpcBehavior.gossip: 130},
  'shy': {NpcBehavior.bond: 50, NpcBehavior.quarrel: 50},
  'lone_wolf': {NpcBehavior.bond: 40, NpcBehavior.practiceHard: 130},
  'caring': {NpcBehavior.teachJunior: 280, NpcBehavior.encourage: 250},
  'harmony': {NpcBehavior.reconcile: 300, NpcBehavior.quarrel: 30},
  'cynical': {
    NpcBehavior.quarrel: 220,
    NpcBehavior.gossip: 150,
    NpcBehavior.complainAdvisor: 180,
  },
  'gossip': {NpcBehavior.gossip: 500},
  'mood_maker': {NpcBehavior.bond: 200, NpcBehavior.encourage: 200},
  'short_tempered': {NpcBehavior.quarrel: 300},
  'gentle': {NpcBehavior.quarrel: 30, NpcBehavior.reconcile: 200},
  'sensitive': {NpcBehavior.complainAdvisor: 130, NpcBehavior.slackOff: 130},
  'optimistic': {NpcBehavior.encourage: 150},
  'moody': {NpcBehavior.slackOff: 180, NpcBehavior.quarrel: 150},
  'leader': {NpcBehavior.teachJunior: 180, NpcBehavior.encourage: 150},
  'follower': {NpcBehavior.askSenior: 180},
  'rebellious': {NpcBehavior.complainAdvisor: 300, NpcBehavior.quarrel: 150},
  'attention_seeker': {NpcBehavior.compete: 150},
  'cautious': {NpcBehavior.quarrel: 50},
  'reckless': {NpcBehavior.quarrel: 150},
  'airhead': {NpcBehavior.idle: 120},
  'genius': {NpcBehavior.breakthrough: 400, NpcBehavior.slackOff: 130},
  'music_nerd': {NpcBehavior.practiceHard: 150},
  'late_bloomer': {NpcBehavior.breakthrough: 200},
  'romantic': {NpcBehavior.bond: 200},
};

/// 部の雰囲気による補正（％）。
const Map<ClubMood, Map<NpcBehavior, int>> moodBehaviorModifiers = {
  ClubMood.strict: {NpcBehavior.slackOff: 60, NpcBehavior.complainAdvisor: 140},
  ClubMood.competitive: {
    NpcBehavior.compete: 150,
    NpcBehavior.practiceHard: 120,
  },
  ClubMood.harmonious: {NpcBehavior.bond: 130, NpcBehavior.quarrel: 60},
  ClubMood.relaxed: {NpcBehavior.slackOff: 150, NpcBehavior.practiceHard: 80},
  ClubMood.factional: {NpcBehavior.quarrel: 150, NpcBehavior.gossip: 150},
};
