/// 課題曲・自由曲（コンクールで演奏する曲）。
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

/// 課題曲または自由曲 1 曲。
///
/// 自由曲は [type] が [freeType]、[year] が 0（どの年でも演奏できる）、
/// [category] が通し番号（"1"〜"10"）、[grade] が難易度ランク（B / A / S / SS）。
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
    this.type = setType,
    this.audioAsset,
    this.grade,
  });

  static const setType = '課題曲';
  static const freeType = '自由曲';

  /// 一意な ID（Suno の曲 ID をそのまま使う）。
  final String id;
  final String title;

  /// 何年目の課題曲か（1..6。中1〜高3）。自由曲は 0。
  final int year;

  /// 課題曲の番号（"I"〜"IV"）。自由曲は通し番号（"1"〜）。
  final String category;
  final String type;

  /// 曲ページの Web リンク（Suno）。
  final String url;

  /// アプリ内で再生するための音声ファイルの URL（Suno の配信用 MP3）。
  String get streamUrl => 'https://cdn1.suno.ai/$id.mp3';

  /// Suno の埋め込みプレーヤー（無料プランの公開曲でも使える）。
  String get embedUrl => 'https://suno.com/embed/$id';

  /// 同梱した音源のアセットパス（未同梱なら null。例: assets/audio/y1_I.mp3）。
  final String? audioAsset;

  /// 演奏に求められる要素の比重（キーは [PieceStat.name]）。
  final Map<String, int> requiredStats;

  /// 難易度ランク（自由曲のみ。B / A / S / SS）。
  final String? grade;

  bool get isFree => type == freeType;

  /// 表示名（例: 課題曲 I「青空とファンファーレ」、自由曲「天馬の飛翔」）。
  String get label => isFree ? '$type「$title」' : '$type $category「$title」';

  /// 一覧や再生中の表示（例: 1年目 I「…」、自由曲 S「…」）。
  String get heading => isFree
      ? '$type${grade == null ? '' : ' $grade'}「$title」'
      : '$year年目 $category「$title」';

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

  /// 同梱音源のファイル名（拡張子なし。課題曲 y{年}_{番号}、自由曲 free_{番号}）。
  String get assetStem => isFree ? 'free_$category' : 'y${year}_$category';

  /// 同梱音源を使う場合のパス（例: assets/audio/y1_I.mp3、assets/audio/free_1.mp3）。
  String get conventionalAssetPath => 'assets/audio/$assetStem.mp3';
}
