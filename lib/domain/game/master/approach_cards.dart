/// 演奏・オーディションの前に選ぶアプローチカード。
enum ApproachCard {
  steady('堅実に', '大崩れしない演奏を心がける。結果のぶれが小さい。'),
  bold('攻めの表現', '思い切った表現に挑む。表現力が高いほど効果的だが、ぶれも大きい。'),
  trustFriends('仲間を信じる', '部の結束が強いほど力を発揮する。'),
  watchConductor('指揮をよく見る', '顧問（指揮者）との信頼関係と指導力が活きる。'),
  soloShine('ソロで魅せる', 'ソリストだけが選べる。熟練度が高いほど大きく響く。'),
  breatheTogether('呼吸を合わせる', 'パートの仲間との信頼が活きる。'),
  lastPush('直前まで追い込む', '本番直前まで練習する。効果はあるが疲れ、疲労が高いと逆効果。'),
  calmMind('平常心', '緊張を抑える。あがり症の人には特に効く。');

  const ApproachCard(this.label, this.description);
  final String label;
  final String description;
}
