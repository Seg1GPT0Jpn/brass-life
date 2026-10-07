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
};

String renderMemory(String reasonKey, Map<String, String> params) {
  var text = memoryTemplates[reasonKey] ?? reasonKey;
  params.forEach((k, v) {
    text = text.replaceAll('{$k}', v);
  });
  return text;
}
