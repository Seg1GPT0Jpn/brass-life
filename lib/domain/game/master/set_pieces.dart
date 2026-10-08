import '../models/piece.dart';

/// 6 年分（各年 I〜IV、全 24 曲）の課題曲。
///
/// 要求値は年を追うごとに高くなり、同じ年では IV が最も総合力を求める。
/// 平均的な部の実力が各要素 50 前後なので、1 年目は 45〜60、6 年目は 60〜85 程度。
abstract final class SetPieces {
  static const all = <Piece>[
    // ── 1 年目 ──
    Piece(
      id: '66d07e38-a4a2-425d-8b18-9350890ab4ec',
      title: '青空とファンファーレ',
      year: 1,
      category: 'I',
      url: 'https://suno.com/song/66d07e38-a4a2-425d-8b18-9350890ab4ec?sh=CAUvP2L1jdEZzW56',
      requiredStats: {'rhythm': 55, 'brass': 58, 'fundamentals': 40},
    ),
    Piece(
      id: '30b65b09-3ea0-411d-a5f8-c86ed4037f65',
      title: '風の歌、森の息吹',
      year: 1,
      category: 'II',
      url: 'https://suno.com/song/30b65b09-3ea0-411d-a5f8-c86ed4037f65?sh=TO0dYVIqIbFVIeGu',
      requiredStats: {'expression': 58, 'woodwind': 56, 'pitch': 42},
    ),
    Piece(
      id: '58df1273-7e65-4ff1-a8a7-e09b7c2a954f',
      title: 'ディスコ・キッド・アゲイン',
      year: 1,
      category: 'III',
      url: 'https://suno.com/song/58df1273-7e65-4ff1-a8a7-e09b7c2a954f?sh=2QKauU2B6HmdVfQj',
      requiredStats: {'groove': 58, 'percussion': 57, 'rhythm': 45},
    ),
    Piece(
      id: 'e94d61ea-f88b-44ea-9d8f-e83e536f93ad',
      title: '無機質な都市のスケッチ',
      year: 1,
      category: 'IV',
      url: 'https://suno.com/song/e94d61ea-f88b-44ea-9d8f-e83e536f93ad?sh=1Rk69sSosdQo33V7',
      requiredStats: {'technique': 62, 'stamina': 60, 'ensemble': 45},
    ),
    // ── 2 年目 ──
    Piece(
      id: 'f1d5923c-8bd9-4471-95bb-1b41ba0c16bb',
      title: '黒潮を越えて',
      year: 2,
      category: 'I',
      url: 'https://suno.com/song/f1d5923c-8bd9-4471-95bb-1b41ba0c16bb?sh=rXhXswlw7RdkWKeL',
      requiredStats: {'stamina': 60, 'brass': 60, 'rhythm': 45},
    ),
    Piece(
      id: '169f111b-cd17-459e-a23f-5cac520220d9',
      title: '夕暮れの祈り',
      year: 2,
      category: 'II',
      url: 'https://suno.com/song/169f111b-cd17-459e-a23f-5cac520220d9?sh=t3ktQ4YLjpLUjZpy',
      requiredStats: {'expression': 62, 'pitch': 60, 'ensemble': 45},
    ),
    Piece(
      id: '1d1a2c5d-ebff-4b2e-990f-e22b711b1d13',
      title: 'カルナヴァル・ラティーノ',
      year: 2,
      category: 'III',
      url: 'https://suno.com/song/1d1a2c5d-ebff-4b2e-990f-e22b711b1d13?sh=FbJAp3dOcKno2q2l',
      requiredStats: {'rhythm': 62, 'tension': 60, 'percussion': 45},
    ),
    Piece(
      id: '55967c82-616f-469a-909b-033ade8bc3ee',
      title: '狂気なる嵐のプレリュード',
      year: 2,
      category: 'IV',
      url: 'https://suno.com/song/55967c82-616f-469a-909b-033ade8bc3ee?sh=HoaVz0rlWuxLwUQ5',
      requiredStats: {'technique': 65, 'woodwind': 63, 'stamina': 50},
    ),
    // ── 3 年目 ──
    Piece(
      id: 'fbed265f-8182-4d88-b7a5-867b0ad623ec',
      title: '夜明けを告げるファンファーレと祈り',
      year: 3,
      category: 'I',
      url: 'https://suno.com/song/fbed265f-8182-4d88-b7a5-867b0ad623ec?sh=SOOWmia2AO7JUriW',
      requiredStats: {'pitch': 63, 'fundamentals': 63, 'brass': 48},
    ),
    Piece(
      id: 'd24fa4c8-1b13-4fa5-916e-c9aef4f750d6',
      title: '真夜中のメリーゴーランド',
      year: 3,
      category: 'II',
      url: 'https://suno.com/song/d24fa4c8-1b13-4fa5-916e-c9aef4f750d6?sh=XrHIxxRXPjrCzfxo',
      requiredStats: {'expression': 64, 'rhythm': 62, 'woodwind': 48},
    ),
    Piece(
      id: '36f9693b-7962-46c8-a847-25b86d41e669',
      title: '神楽舞と祝祭',
      year: 3,
      category: 'III',
      url: 'https://suno.com/song/36f9693b-7962-46c8-a847-25b86d41e669?sh=AdnYzCnPyp9cjHwX',
      requiredStats: {'percussion': 64, 'highWoodwind': 63, 'rhythm': 50},
    ),
    Piece(
      id: '46b2aa87-0740-4c11-81e8-08799fedb55e',
      title: '竜の眠る火山',
      year: 3,
      category: 'IV',
      url: 'https://suno.com/song/46b2aa87-0740-4c11-81e8-08799fedb55e?sh=494WI8uFiUY03JrN',
      requiredStats: {'stamina': 68, 'brass': 67, 'technique': 58},
    ),
    // ── 4 年目 ──
    Piece(
      id: '3ae2898b-8e76-4d9b-be2c-51090c403e8c',
      title: '喜劇のための序曲',
      year: 4,
      category: 'I',
      url: 'https://suno.com/song/3ae2898b-8e76-4d9b-be2c-51090c403e8c?sh=VgKsx2vAleyhcv44',
      requiredStats: {'woodwindTech': 66, 'ensemble': 65, 'rhythm': 50},
    ),
    Piece(
      id: '223f7d10-748f-45e9-9bb5-5db08cecb6db',
      title: '黒バラのタンゴ',
      year: 4,
      category: 'II',
      url: 'https://suno.com/song/223f7d10-748f-45e9-9bb5-5db08cecb6db?sh=EBJBzkXXqLwDxErK',
      requiredStats: {'expression': 68, 'charisma': 66, 'rhythm': 52},
    ),
    Piece(
      id: 'ccf1af04-3dfe-4f9a-a091-d0ec886c09d5',
      title: 'ブロードウェイ・ドリーム',
      year: 4,
      category: 'III',
      url: 'https://suno.com/song/ccf1af04-3dfe-4f9a-a091-d0ec886c09d5?sh=WhrbCDzRUNbIA5HS',
      requiredStats: {'brass': 68, 'tension': 66, 'groove': 52},
    ),
    Piece(
      id: 'd619a461-dac9-4506-9741-efe56ef9bfc0',
      title: '忘れられた辺境の舞曲',
      year: 4,
      category: 'IV',
      url: 'https://suno.com/song/d619a461-dac9-4506-9741-efe56ef9bfc0?sh=szmbTVjD7P6jNeoV',
      requiredStats: {'rhythm': 70, 'conductorSync': 68, 'technique': 60},
    ),
    // ── 5 年目 ──
    Piece(
      id: '1e7ee67a-6225-4439-9919-4703bf4a97d8',
      title: 'スカ・パラダイス・マーチ',
      year: 5,
      category: 'I',
      url: 'https://suno.com/song/1e7ee67a-6225-4439-9919-4703bf4a97d8?sh=to6tIz0zVTLrRK97',
      requiredStats: {'rhythm': 70, 'stamina': 68, 'groove': 55},
    ),
    Piece(
      id: 'ce769811-d44e-4747-b574-e2bb782439e3',
      title: '希望へのゴスペル',
      year: 5,
      category: 'II',
      url: 'https://suno.com/song/ce769811-d44e-4747-b574-e2bb782439e3?sh=RQB16zebM6iIxZgv',
      requiredStats: {'expression': 72, 'midLow': 68, 'ensemble': 55},
    ),
    Piece(
      id: '6bb9aed2-71ac-42e0-87eb-28f1c5599b83',
      title: 'ネオンシティ・オーバードライブ',
      year: 5,
      category: 'III',
      url: 'https://suno.com/song/6bb9aed2-71ac-42e0-87eb-28f1c5599b83?sh=yDAfl61UpS14DXPe',
      requiredStats: {'woodwindTech': 72, 'percussion': 70, 'tension': 55},
    ),
    Piece(
      id: 'cce334c5-1264-4a0c-9ea2-b20aa2a5b611',
      title: '深海に潜む影',
      year: 5,
      category: 'IV',
      url: 'https://suno.com/song/cce334c5-1264-4a0c-9ea2-b20aa2a5b611?sh=RZzZA69GOSYxyhM3',
      requiredStats: {'lowRange': 74, 'pitch': 72, 'technique': 62},
    ),
    // ── 6 年目 ──
    Piece(
      id: '0d866f76-ef2c-4d8e-b03c-4f91e5f1c3e2',
      title: '行進曲「茜空のカンバス」',
      year: 6,
      category: 'I',
      url: 'https://suno.com/song/0d866f76-ef2c-4d8e-b03c-4f91e5f1c3e2?sh=XBDeF43qmKFSuvnf',
      requiredStats: {'expression': 72, 'fundamentals': 74, 'rhythm': 58},
    ),
    Piece(
      id: 'acb727d8-aebb-4712-bd78-82e608ebe21b',
      title: 'ジオメトリック・パルス',
      year: 6,
      category: 'II',
      url: 'https://suno.com/song/acb727d8-aebb-4712-bd78-82e608ebe21b?sh=F3pXsj6DNJo0FRqR',
      requiredStats: {'rhythm': 75, 'brass': 73, 'technique': 60},
    ),
    Piece(
      id: '88ed75bb-45b3-4e9d-a95e-8d02131d213d',
      title: 'とびだせ！からくりマーチ',
      year: 6,
      category: 'III',
      url: 'https://suno.com/song/88ed75bb-45b3-4e9d-a95e-8d02131d213d?sh=2oBKGej21byXpckf',
      requiredStats: {'percussion': 74, 'groove': 74, 'rhythm': 58},
    ),
    Piece(
      id: 'c3ce3ed5-9b5a-4959-b9b0-33b2fe5f31c8',
      title: '吹奏楽のための交響的断章',
      year: 6,
      category: 'IV',
      url: 'https://suno.com/song/c3ce3ed5-9b5a-4959-b9b0-33b2fe5f31c8?sh=FyMnzFnKdeLg3WzZ',
      requiredStats: {
        'technique': 85,
        'expression': 82,
        'fundamentals': 80,
        'pitch': 80,
        'rhythm': 80,
        'stamina': 80,
        'ensemble': 80,
        'brass': 78,
        'woodwind': 78,
        'percussion': 75,
      },
    ),
  ];

  static List<Piece> byYear(int year) => [
    for (final p in all)
      if (p.year == year) p,
  ];

  static Piece? byId(String id) {
    for (final p in all) {
      if (p.id == id) return p;
    }
    return null;
  }
}
