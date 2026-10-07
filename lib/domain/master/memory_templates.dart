/// [MemoryTag.reasonKey] → 表示テンプレート。`{key}` が params で置換される。
const Map<String, String> memoryTemplates = {
  'joined_club': '{school}吹奏楽部に入部した（担当：{instrument}）',
  'contest_result': '{fiscalYear}年度 {contest} {stage}で{award}{suffix}',
  'advisor_appointed': '{school}吹奏楽部の顧問として着任した',
  'coach_appointed': '{school}吹奏楽部の外部講師に就任した',
};

String renderMemory(String reasonKey, Map<String, String> params) {
  var text = memoryTemplates[reasonKey] ?? reasonKey;
  params.forEach((k, v) {
    text = text.replaceAll('{$k}', v);
  });
  return text;
}
