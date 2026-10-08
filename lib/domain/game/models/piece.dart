/// 課題曲（コンクールで演奏する曲）。
library;

/// 曲が演奏者に求める要素。[Piece.requiredStats] のキーは [PieceStat.name]。
enum PieceStat {
  technique('総合技術'),
  fundamentals('基礎力'),
  expression('表現力'),
  rhythm('リズム感'),
  groove('ノリ'),
  pitch('ピッチ'),
  stamina('スタミナ'),
  tension('テンション'),
  charisma('カリスマ'),
  ensemble('アンサンブル'),
  conductorSync('指揮者相性'),
  brass('金管'),
  woodwind('木管'),
  woodwindTech('木管技術'),
  highWoodwind('高音木管'),
  percussion('打楽器'),
  midLow('中低音'),
  lowRange('低音');

  const PieceStat(this.label);
  final String label;

  static PieceStat? byKey(String key) {
    for (final s in values) {
      if (s.name == key) return s;
    }
    return null;
  }
}

/// 課題曲 1 曲。
///
/// [requiredStats] は「その要素がどれだけ求められるか」（0..100）。
/// 値が大きい要素ほど評価での比重が大きく、必要な部の実力も高くなる
/// （平均的な部が 50 として、要求 45 → 45、要求 85 → 58 程度）。
class Piece {
  const Piece({
    required this.id,
    required this.title,
    required this.year,
    required this.category,
    required this.url,
    required this.requiredStats,
    this.type = '課題曲',
    this.audioAsset,
  });

  /// 一意な ID（Suno の曲 ID をそのまま使う）。
  final String id;
  final String title;

  /// 何年目の課題曲か（1..6。中1〜高3）。
  final int year;

  /// 課題曲の番号（"I"〜"IV"）。
  final String category;
  final String type;

  /// 試聴用の Web リンク（Suno）。
  final String url;

  /// 同梱した音源のアセットパス（未同梱なら null。例: assets/audio/y1_I.mp3）。
  final String? audioAsset;

  /// 演奏に求められる要素の比重（キーは [PieceStat.name]）。
  final Map<String, int> requiredStats;

  /// 表示名（例: 課題曲 I「青空とファンファーレ」）。
  String get label => '$type $category「$title」';

  /// 求められる要素（比重の大きい順）。
  List<(PieceStat, int)> get demands {
    final list = [
      for (final e in requiredStats.entries)
        if (PieceStat.byKey(e.key) != null) (PieceStat.byKey(e.key)!, e.value),
    ]..sort((a, b) => b.$2.compareTo(a.$2));
    return list;
  }

  /// 難しさ（求められる要素の平均）。
  int get difficulty {
    if (requiredStats.isEmpty) return 0;
    final sum = requiredStats.values.fold(0, (a, b) => a + b);
    return sum ~/ requiredStats.length;
  }

  /// 同梱音源を使う場合のパス（命名規則: assets/audio/y{年}_{番号}.mp3）。
  String get conventionalAssetPath => 'assets/audio/y${year}_$category.mp3';
}
