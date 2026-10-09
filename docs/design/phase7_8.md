# Phase 7・8 設計メモ（準備段階）

Phase 1〜6（本編）の完成を優先し、Phase 7・8 は **データモデル・判定ロジック・状態遷移・差し込み口** だけを用意している。
本編の挙動は変えていない（6 年間のゴールデン `3fd5e143` は変化なし）。機能の切り替えは `lib/app/feature_flags.dart`。

| フラグ | 既定 | 内容 |
|---|---|---|
| `practiceBgm` | off | パート練習・合奏で課題曲を練習 BGM として流す |
| `conductingMiniGame` | off | コンクール本番の指揮者ミニゲーム（UI 未実装） |
| `careerModes` | on | タイトルに大人編の一覧と解放状況を表示（遊べるのは本編のみ） |

---

## Phase 7: 練習オーディオ連動と指揮者ミニゲーム

### 7-1 練習 BGM

```
[ホーム: 行動を選ぶ] → PracticeBgm.cueFor(ctx, state, action)  … domain（乱数なし）
        │                    └─ 今年の課題曲 + 開始秒 + ループ有無（PracticeBgmCue）
        └→ PiecePlayer.playFrom(piece, start, loop)              … presentation
                 └→ AudioEngine.setLooping / playUrl|playAsset(start:)
```

- 合奏: 曲の頭から通し（ループなし）
- パート練習・一緒に練習・居残り: 週ごとに 0/30/60/90 秒からの区間をループ
- `AudioEngine`（`presentation/game/pieces/piece_player.dart`）にループと開始位置を追加済み。実装は audioplayers。
- 差し込み口: `home_tab.dart` の行動確定処理（`FeatureFlags.practiceBgm` が off の間は何もしない）。

**残作業**: フラグを on にする前に、毎週曲が切り替わる体験の調整（フェードイン/アウト、音量、練習中の画面での再生）。
Suno の埋め込みプレーヤーでしか鳴らない環境では自動再生できないため、同梱音源があるときだけ鳴らす方針がよい。

### 7-2 指揮者ミニゲーム（Tactical Conducting）

`lib/domain/game/conducting/conducting.dart`

- `ConductingParams`（スタミナ・技術・団結）… `PieceFit.bandStats` から作る（課題曲の相性と同じ部の見積もり）
- `ConductingInput`（時刻・ダイナミクス 0..100・表現力 0..100）
- `ConductingJudge.judge` … 1 入力の判定。倍率は千分率で 500〜1300
  - fff 側（>70）はスタミナ、ppp 側（<30）は技術、表現力 >70 は団結を要求（要求量は振れ幅に比例、最大 90）
  - 足りていれば攻めた分だけ加点（会心）、足りなければ不足分だけ減点、不足 >10 で「崩壊」
- `ConductingSession` … 入力の記録、平均倍率、崩壊回数、コンクール評価への補正（予定値）

状態遷移（予定）:

```
[コンクール本番イベント] ─(カードを選ぶ)→ [指揮ミニゲーム: 曲が流れる]
        ↑                                      │ スライダー操作のたびに record(input)
        │                                      ↓
        └──────────────(結果)────────── [判定まとめ → ContestEngine に contestBonus を渡す]
```

**残作業**: UI（2 本のスライダー、判定のリアルタイム表示、曲の進行に合わせた区間表示）、
`ContestEngine.perform` に指揮の補正を足す引数を追加（決定論のため、入力列を choices に記録する）。

---

## Phase 8: キャリアモード（大人編）

### 8-1 クリア記録（SaveData のフラグ）

- `CareerRecord`（`domain/career/career_record.dart`）: 称号・最終進路（univ / univ_music / ronin / none）・
  最終熟練度・音楽性・経験した役職・最高のコンクール結果・退部して卒業したか。
- `CareerRecorder.record` … 6 年間の最終状態とエンディングから作る。
- 保存: `CareerRepository`（Hive の `career_v1` ボックス）。セーブスロットとは独立で、周回をまたいで残る。
- 記録のタイミング: `GameController._commit` で「卒業（stage = finished）になった瞬間」に 1 回。

### 8-2 解放条件（`CareerUnlocks`）

| モード | 解放条件 |
|---|---|
| 顧問 | 大学に進学し、部長（代表）・副部長・学生指揮・セクションリーダーのいずれかを経験 |
| 外部講師 | 音楽大学に進学、または熟練度 700 以上で卒業 |
| OB/OG | 6 年間を最後まで遊ぶ |

### 8-3 状態遷移（`CareerFlow`）

```
[AtTitle(解放済み)] ─chooseMode(解放済み)→ [ChoosingMode]
       ↑                                         │ start(session)  ※大人編は implemented=false の間は拒否
       │                                         ↓
       │                                    [Playing(ModeSession)]
       │                                         │ finish(record)
       └──────── backToTitle(全記録) ──── [Finished(record)]
```

`ModeSession` は `StudentSession` / `TeacherSession` / `InstructorSession` / `AlumniSession`。

### 8-4 各モードの状態とコマンド（`domain/career/mode_states.dart`）

| モード | 状態 | コマンド |
|---|---|---|
| 顧問 | 赴任校・演じる顧問・練習メニュー配分・残り指示数 | 練習メニュー指示 / オーディション合否 / 選曲 / 面談 |
| 外部講師 | 契約校の一覧・現在の学校・行動回数（少ない）・評判 | 集中レッスン（特定パートを大きく伸ばす）/ 公開講座 / 移動 |
| OB/OG | 母校・所持金・週の収入・部との絆 | 差し入れ / 悩み相談 / 寄付 / 仕事 |

**実装方針**: 週の進行・NPC の自律行動・コンクールは本編のエンジン（TimeManager / DramaEngine / ContestEngine）を流用し、
「プレイヤーが選べる行動」と「プレイヤーが持つ資源」だけをモードごとに差し替える。
NPC への影響はすべて既存の関係性ベクトルと記憶（MemoryTag）で表し、決定論的乱数の domain 名をモードごとに分ける。

**残作業**: 各モードの週処理（コマンド → 状態変化）、UI、エンディング、解放済みモードの開始画面。
