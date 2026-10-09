import '../models/piece.dart';

/// 自由曲（10 曲）。どの年でも演奏できる。
///
/// 難易度ランクは B < A < S < SS。要求値はランクごとにおおむね
/// B 55〜68、A 60〜75、S 68〜84、SS 75〜92（課題曲の 6 年目 IV と同等以上）。
abstract final class FreePieces {
  static const grades = ['B', 'A', 'S', 'SS'];

  static const all = <Piece>[
    Piece(
      id: 'b0ec8d6a-bfd8-41ce-b240-0c2fdcbf1158',
      title: '交響詩「海神の怒り」',
      year: 0,
      category: '1',
      type: Piece.freeType,
      grade: 'A',
      url: 'https://suno.com/song/b0ec8d6a-bfd8-41ce-b240-0c2fdcbf1158?sh=8LynhxRZHQxeozcv',
      requiredStats: {
        'brass': 72,
        'lowRange': 70,
        'stamina': 68,
        'tension': 66,
        'percussion': 62,
      },
    ),
    Piece(
      id: 'dc15ce70-2c29-4fed-9461-626b57ac22c0',
      title: '妖精の森の組曲',
      year: 0,
      category: '2',
      type: Piece.freeType,
      grade: 'A',
      url: 'https://suno.com/song/dc15ce70-2c29-4fed-9461-626b57ac22c0?sh=gS3l6SEHziuf8JXt',
      requiredStats: {
        'highWoodwind': 72,
        'woodwindTech': 70,
        'expression': 68,
        'pitch': 66,
        'ensemble': 60,
      },
    ),
    Piece(
      id: '05246f7d-365b-4409-b696-eb5df9712a56',
      title: '焔の鳥の舞踏',
      year: 0,
      category: '3',
      type: Piece.freeType,
      grade: 'S',
      url: 'https://suno.com/song/05246f7d-365b-4409-b696-eb5df9712a56?sh=ON3x2Ha4f1bQnsZj',
      requiredStats: {
        'technique': 80,
        'rhythm': 78,
        'woodwindTech': 76,
        'brass': 74,
        'tension': 72,
        'conductorSync': 70,
      },
    ),
    Piece(
      id: 'c77d87d9-bbcf-4e9e-b652-942128e08ce9',
      title: '廃城の亡霊たち',
      year: 0,
      category: '4',
      type: Piece.freeType,
      grade: 'B',
      url: 'https://suno.com/song/c77d87d9-bbcf-4e9e-b652-942128e08ce9?sh=lUwiOc7678UZ3Ajo',
      requiredStats: {
        'expression': 64,
        'midLow': 62,
        'percussion': 60,
        'pitch': 56,
      },
    ),
    Piece(
      id: 'e6cfa493-cb95-488e-8ab6-992e6ee690be',
      title: '天馬の飛翔',
      year: 0,
      category: '5',
      type: Piece.freeType,
      grade: 'A',
      url: 'https://suno.com/song/e6cfa493-cb95-488e-8ab6-992e6ee690be?sh=GhA1AbkVzwEUWNQB',
      requiredStats: {
        'brass': 72,
        'groove': 68,
        'rhythm': 66,
        'charisma': 64,
        'stamina': 62,
      },
    ),
    Piece(
      id: '8c5e2e39-d406-4ae6-9244-ac0ca5046e40',
      title: '交響的断章「冬の嵐」',
      year: 0,
      category: '6',
      type: Piece.freeType,
      grade: 'S',
      url: 'https://suno.com/song/8c5e2e39-d406-4ae6-9244-ac0ca5046e40?sh=CJICWijD2LMbqrRb',
      requiredStats: {
        'ensemble': 80,
        'technique': 78,
        'lowRange': 76,
        'stamina': 74,
        'expression': 72,
        'fundamentals': 70,
      },
    ),
    Piece(
      id: '393d9da5-c029-402c-ace1-8736eaacf4ee',
      title: '砂漠のキャラバン',
      year: 0,
      category: '7',
      type: Piece.freeType,
      grade: 'B',
      url: 'https://suno.com/song/393d9da5-c029-402c-ace1-8736eaacf4ee?sh=xPHAXqyBQPGYjDOf',
      requiredStats: {
        'groove': 66,
        'percussion': 64,
        'woodwind': 60,
        'rhythm': 58,
      },
    ),
    Piece(
      id: 'a192ccce-b2b3-4a67-bed1-9a7d01d2e6a4',
      title: '吹奏楽のための「レクイエム」',
      year: 0,
      category: '8',
      type: Piece.freeType,
      grade: 'A',
      url: 'https://suno.com/song/a192ccce-b2b3-4a67-bed1-9a7d01d2e6a4?sh=k4cDukoPmadEMOzz',
      requiredStats: {
        'expression': 74,
        'pitch': 72,
        'ensemble': 70,
        'fundamentals': 66,
        'midLow': 62,
      },
    ),
    Piece(
      id: 'c758f5f0-6d53-40d4-9b84-650ea677ab8b',
      title: '機械都市の崩壊',
      year: 0,
      category: '9',
      type: Piece.freeType,
      grade: 'SS',
      url: 'https://suno.com/song/c758f5f0-6d53-40d4-9b84-650ea677ab8b?sh=aswzFSVeS5th4j9Z',
      requiredStats: {
        'technique': 90,
        'rhythm': 88,
        'percussion': 86,
        'conductorSync': 84,
        'woodwindTech': 82,
        'brass': 80,
        'stamina': 78,
        'tension': 76,
      },
    ),
    Piece(
      id: 'dbfd3fdd-ca58-423e-aee3-e7e6e8cc1efd',
      title: '交響的賛歌「輝ける未来へ」',
      year: 0,
      category: '10',
      type: Piece.freeType,
      grade: 'SS',
      url: 'https://suno.com/song/dbfd3fdd-ca58-423e-aee3-e7e6e8cc1efd?sh=srqVi9DlthB2oLra',
      requiredStats: {
        'ensemble': 90,
        'expression': 88,
        'brass': 86,
        'charisma': 84,
        'pitch': 82,
        'lowRange': 80,
        'fundamentals': 78,
        'highWoodwind': 76,
      },
    ),
  ];

  static List<Piece> byGrade(String grade) => [
    for (final p in all)
      if (p.grade == grade) p,
  ];

  static Piece? byId(String id) {
    for (final p in all) {
      if (p.id == id) return p;
    }
    return null;
  }
}
