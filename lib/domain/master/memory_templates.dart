/// [MemoryTag.reasonKey] → 表示テンプレート。`{key}` が params で置換される。
const Map<String, String> memoryTemplates = {
  'joined_club': '{school}吹奏楽部に入部した（担当：{instrument}）',
  'contest_result': '{fiscalYear}年度 {contest} {stage}で{award}{suffix}',
  'advisor_appointed': '{school}吹奏楽部の顧問として着任した',
  'coach_appointed': '{school}吹奏楽部の外部講師に就任した',
  'player_joined_club': '{school}に入学し、吹奏楽部に入部した',
  'instrument_wish_granted': '希望どおり{instrument}の担当になった',
  'instrument_wish_denied': '第1希望（{wish}）は叶わず、{instrument}の担当になった',
  'player_fell_ill': '無理がたたって体調を崩し、一週間寝込んだ',
  'exam_result': '{exam}で{score}点を取った',
  'player_hung_out': '{actor}は{target}と遊びに出かけた',
  'noticed_slacking': '{actor}は{target}が練習をサボっているのに気づいた',
  'npc_breakthrough': '{actor}は{instrument}の壁を越え、一気に上達した',
  'taught_junior': '{actor}は後輩の{target}に練習を教えた',
  'asked_senior': '{actor}は先輩の{target}に教えを請うた',
  'bonded': '{actor}は{target}と話が弾み、仲良くなった',
  'quarreled': '{actor}は{target}と口論になった',
  'competed': '{actor}は{target}に対抗心を燃やした',
  'spread_rumor': '{actor}は{target}に、{victim}についての噂を話した',
  'reconciled': '{actor}は{target}と仲直りした',
  'complained_advisor': '{actor}は{target}に顧問への不満を漏らした',
  'encouraged': '{actor}は落ち込んでいた{target}を励ました',
  'quit_club': '{actor}は吹奏楽部を辞めた',
  'audition_passed': '{actor}はオーディションに合格し、コンクールメンバーに選ばれた',
  'audition_failed': '{actor}はオーディションに落ち、コンクールメンバーになれなかった',
  'solo_chosen': '{actor}は自由曲の{instrument}ソロに抜擢された',
  'contest_support':
      '{fiscalYear}年度 {contest} {stage}：客席から仲間を応援した（{award}{suffix}）',
  'appointed_role': '{actor}は{role}に選ばれた',
  'lost_election': '{actor}は立候補したが、{target}に及ばなかった',
  'retired': '{actor}は部活を引退した',
  'concert_result': '{school}の定期演奏会に出演した（{rating}）',
  'concert_watched': '{school}の定期演奏会を見守った（{rating}）',
  'exam_passed': '{school}に合格した',
  'exam_failed': '{school}は不合格だった',
  'recommended': '{school}への部活推薦を受けた',
  'graduated_middle': '{school}を卒業した',
  'entered_high': '{school}に入学し、吹奏楽部に入部した',
  'reunited': '{school}で{target}と再会した',
};

String renderMemory(String reasonKey, Map<String, String> params) {
  var text = memoryTemplates[reasonKey] ?? reasonKey;
  params.forEach((k, v) {
    text = text.replaceAll('{$k}', v);
  });
  return text;
}
