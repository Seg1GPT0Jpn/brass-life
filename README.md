# ブラス・ライフ（brass-life）

吹奏楽部 × 学校生活 × 人生シミュレーション。Flutter Web で完全にオフラインで動きます。

- 実在の名称（学校・地名・大会・連盟）は使いません。名称はすべて生成した架空のものです。
- Firebase などの外部サービスは使いません。データは端末内（Web では IndexedDB）に保存します。
- 乱数は完全に決定論的です。**同じ Seed と同じ選択からは、必ず同じ人生になります。**

## 開発フェーズ

| Phase | 内容 | 状態 |
|---|---|---|
| 1 | 基盤・RngService・世界／NPC 生成・デバッグ画面 | 完了 |
| 2 | コアゲームループ（週ターン）・楽器決定イベント・月単位スキップ | 完了 |
| 3 | Drama Engine（NPC の自律行動と関係性の履歴） | 完了 |
| 4 | オーディション・幹部選出・演奏シミュレーション | 完了 |
| 5 | 高校受験と高校への進学 | 完了 |
| 6 | 大学受験・エンディング・セーブスロット | 未着手 |

## 動かし方

```sh
flutter pub get
flutter run -d chrome          # 開発実行
flutter test                   # テスト（VM）
flutter test --platform chrome test/core test/domain   # Web でも同じ結果になるかの確認
flutter build web --release --no-web-resources-cdn      # 完全オフライン構成のビルド
```

生成コード（`*.g.dart` / `*.freezed.dart`）もコミットしているので、`build_runner` を実行しなくても動きます。
モデルを変更したときは `dart run build_runner build --delete-conflicting-outputs` を実行してください。

`main` に push すると GitHub Actions がテストを実行し、GitHub Pages に公開します。
公開するには、リポジトリの **Settings → Pages → Source** を「GitHub Actions」にしておく必要があります。

## Phase 1 の確認方法

1. タイトル画面で Seed を入力し（空欄ならランダム）、「世界を生成」を押します。
2. デバッグ画面では次のものを確認できます。
   - **概要**: Seed とフィンガープリント、**決定性の検証**（同じ Seed で再生成して完全一致を確認）、舞台となる架空の県、プレイヤー、各種分布、実カレンダーに準拠した暦
   - **学校**: 64 校（中学 40・高校 24）。地区・強さ・公立／私立で絞り込みと並べ替えができます。詳細画面には「基本・部活（幹部制度／選出文化／顧問／過去の成績）・楽器（保有台数／状態／担当者／新入生の希望）・部員」のタブがあります。
   - **NPC**: 約 1,700〜1,850 人。名前・学校・役割・学年・楽器・性格タグで絞り込めます。詳細画面には性格タグ、性格軸と適性（隠し値）、楽器適性、記憶が表示されます。
   - **記憶**: MemoryTag の履歴（Phase 1 時点では、ゲーム開始前の入部・過去のコンクール・指導者の着任）

Seed `TEST` のフィンガープリントは、VM と Web のどちらでも `9EBA95EBDA15DF00` になります（ゴールデンテストで固定）。

## アーキテクチャ

```
lib/
├─ app/            ルーティング・テーマ・DI（Riverpod Provider）
├─ core/
│  ├─ rng/         決定論的乱数（xoshiro128** を 32bit 演算のみで実装）
│  └─ time/        実カレンダーに準拠した暦（DateTime に依存しない日付演算）
├─ domain/         Flutter に依存しない純 Dart
│  ├─ entities/        World, Region, School, Club, Npc, Player, MemoryTag …
│  ├─ value_objects/   楽器・性格・適性・関係性ベクトル・各種列挙型
│  ├─ master/          性格タグ定義・名前素材・実在名称ブロックリスト・記憶テンプレート
│  ├─ services/        世界生成（world_generation/）・索引・フィンガープリント
│  ├─ repositories/    抽象インターフェース
│  └─ usecases/        世界生成・決定性検証
├─ data/           Hive CE による永続化（JSON 文字列として保存し、schemaVersion を持たせる）
└─ presentation/   MVVM（各画面の View と ViewModel = Notifier / Provider）
```

### 決定論的乱数（`core/rng`）

- `dart:math` の `Random` は使いません（アーキテクチャテストで禁止しています）。
- **WorldSeedRng**: パス（例: `world/club/club_m07/member/2/13`）ごとに独立した乱数列を作ります。ある部の生成で乱数を余分に使っても、他の部の生成結果は変わりません。
- **SimulationRng**: `(WorldSeed, ターン, ドメイン, 主体, 選択)` から乱数列を作ります。同じターンに同じ選択をすれば必ず同じ結果になり、セーブ／ロードによる再抽選はできません。
- Web（JS の数値）でも VM と同じ数列になるよう、演算はすべて 32bit の範囲に収めています。確率は万分率の整数で扱い、正規分布は Irwin–Hall 近似で生成します（`log` や `sin` は使いません）。

### 世界生成（`domain/services/world_generation`）

地域 → 学校（偏差値は層化抽選）→ 部の計画（強さ帯を構成比どおりに割当）→ NPC 総数の補正（1,000〜2,000 人）→ 部と部員の構築（保有楽器・過去の成績・学年構成・楽器の割当・熟練度）→ プレイヤー → 背景の記憶、の順に生成し、最後に整合性を検証します。

## ライセンス

- 同梱フォント: BIZ UDPGothic（SIL Open Font License 1.1、`assets/fonts/OFL.txt`）
