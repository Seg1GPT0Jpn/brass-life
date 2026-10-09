# Phase 7・8 設計メモ

**実装済み（v2.0）**。機能の切り替えは `lib/app/feature_flags.dart`（不具合時に個別に止められる）。
本編の挙動は、指揮ミニゲームを遊ばない限り変わらない（6 年間のゴールデン `a7b28265`）。

| フラグ | 既定 | 内容 |
|---|---|---|
| `practiceBgm` | on | パート練習・合奏で課題曲を練習 BGM として流す |
| `conductingMiniGame` | on | コンクール・定期演奏会の本番の指揮者ミニゲーム |
| `careerModes` | on | タイトルの大人編（解放状況・お試しプレイ・開始） |

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

**今後の改善**: フェードイン/アウト、音量調整。直接再生できない環境（Suno の埋め込みのみ）では鳴らさない。

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

実装: `presentation/game/conducting/conducting_page.dart`（2 本のスライダー・判定のリアルタイム表示・フレーズの進行）。

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

実装: `domain/career/career_engine.dart`（コマンドと毎週の効果）、`presentation/career/`（開始画面・ホーム・顧問のイベント）。


---

## 実装メモ（v2.0）

- 指揮: 曲の構成 `PieceStructure`（I: ファンファーレ→行進→トリオ→再現→コーダ／II: 序奏→歌→高まり→クライマックス→余韻／
  III: つかみ→ブレイク→ソロ回し→盛り上がり→キメ／IV: 不穏→嵐→静寂→再燃→終結）。プランは `ConductingPlan` として
  選択ログ（`contest:カード:60.50-80.70-...`）に残るので、同じ操作なら同じ結果になる。評価は `ConductingEffect`。
- 大人編: `GameState.mode` と `CareerState`。週は `TimeManager.submitCareerCommand`（コマンド → 毎週の効果 → 部員の自律行動）。
  生徒としての出来事（楽器決定・受験・進級・卒業）は大人編では起きない。顧問は選曲・オーディション（`teacherAudition`）・
  コンクール・定期演奏会が入力待ちになる。任期の終わり（4 年目の 4 月）に `stage = finished`。
  エンディングは `CareerEndingAnalyzer`。大人編の終わりは周回の記録に残さない（解放は本編の卒業でのみ）。
