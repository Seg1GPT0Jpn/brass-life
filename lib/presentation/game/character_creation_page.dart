import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../domain/game/engine/instrument_decision.dart';
import '../../domain/game/engine/player_setup_service.dart';
import '../../domain/game/models/player_setup.dart';
import '../../domain/value_objects/instrument.dart';
import '../../domain/value_objects/person_enums.dart';
import '../common/widgets/common_widgets.dart';
import '../world/world_controller.dart';
import 'game_controller.dart';

final playerSetupServiceProvider = Provider<PlayerSetupService?>((ref) {
  final world = ref.watch(worldControllerProvider).value?.world;
  return world == null ? null : PlayerSetupService(world);
});

/// 主人公の設定（ViewModel）。初期値は Seed が決めた主人公。
class CharacterCreationViewModel extends Notifier<PlayerSetup?> {
  @override
  PlayerSetup? build() => ref.watch(playerSetupServiceProvider)?.defaults();

  PlayerSetupService get _service => ref.read(playerSetupServiceProvider)!;

  void reset() => state = _service.defaults();

  void update(PlayerSetup Function(PlayerSetup s) f) {
    if (state != null) state = f(state!);
  }

  void setGender(Gender g) => update((s) {
    final schools = _service.selectableSchools(g);
    return s.copyWith(
      gender: g,
      schoolId: schools.contains(s.schoolId) ? s.schoolId : schools.first,
    );
  });

  /// 能力を変更する。上限を超える分は切り詰める。
  void setStat(String key, int value) => update((s) {
    final current = _statOf(s, key);
    final remaining = _service.budget - s.pointsUsed;
    final v = value.clamp(
      PlayerSetupService.minStat,
      current + (remaining > 0 ? remaining : 0),
    );
    final a = s.aptitude;
    return switch (key) {
      'pitch' => s.copyWith(aptitude: a.copyWith(pitch: v)),
      'rhythm' => s.copyWith(aptitude: a.copyWith(rhythm: v)),
      'breath' => s.copyWith(aptitude: a.copyWith(breath: v)),
      'dexterity' => s.copyWith(aptitude: a.copyWith(dexterity: v)),
      'expression' => s.copyWith(aptitude: a.copyWith(expression: v)),
      'reading' => s.copyWith(aptitude: a.copyWith(reading: v)),
      'academic' => s.copyWith(academic: v),
      _ => s.copyWith(stamina: v),
    };
  });

  static int _statOf(PlayerSetup s, String key) => switch (key) {
    'pitch' => s.aptitude.pitch,
    'rhythm' => s.aptitude.rhythm,
    'breath' => s.aptitude.breath,
    'dexterity' => s.aptitude.dexterity,
    'expression' => s.aptitude.expression,
    'reading' => s.aptitude.reading,
    'academic' => s.academic,
    _ => s.stamina,
  };

  void setAxis(String key, int value) => update((s) {
    final p = s.personality;
    return s.copyWith(
      personality: switch (key) {
        'extraversion' => p.copyWith(extraversion: value),
        'agreeableness' => p.copyWith(agreeableness: value),
        'conscientiousness' => p.copyWith(conscientiousness: value),
        'neuroticism' => p.copyWith(neuroticism: value),
        _ => p.copyWith(ambition: value),
      },
    );
  });
}

final characterCreationProvider =
    NotifierProvider<CharacterCreationViewModel, PlayerSetup?>(
      CharacterCreationViewModel.new,
    );

/// 主人公をつくる画面。
class CharacterCreationPage extends ConsumerStatefulWidget {
  const CharacterCreationPage({super.key});

  @override
  ConsumerState<CharacterCreationPage> createState() =>
      _CharacterCreationPageState();
}

class _CharacterCreationPageState extends ConsumerState<CharacterCreationPage> {
  final _family = TextEditingController();
  final _given = TextEditingController();
  bool _initialized = false;

  @override
  void dispose() {
    _family.dispose();
    _given.dispose();
    super.dispose();
  }

  void _syncNames(PlayerSetup s) {
    _family.text = s.familyName;
    _given.text = s.givenName;
  }

  @override
  Widget build(BuildContext context) {
    final setup = ref.watch(characterCreationProvider);
    final service = ref.watch(playerSetupServiceProvider);
    final session = ref.watch(worldControllerProvider).value;
    if (setup == null || service == null || session == null) {
      return Scaffold(
        body: Center(
          child: FilledButton(
            onPressed: () => context.go('/'),
            child: const Text('タイトルへ'),
          ),
        ),
      );
    }
    if (!_initialized) {
      _syncNames(setup);
      _initialized = true;
    }
    final vm = ref.read(characterCreationProvider.notifier);
    final theme = Theme.of(context);
    final idx = session.index;
    final error = service.validate(setup);
    final remaining = service.budget - setup.pointsUsed;
    final finalAptitude = PlayerSetupService.withBackground(
      setup.aptitude,
      setup.background,
    );
    final traits = service.traitsFor(setup.personality);
    final defaultSchool = session.world.player.schoolId;

    Future<void> start() async {
      ref.read(gameControllerProvider.notifier).newGame(setup: setup);
      if (context.mounted) context.go('/game');
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('主人公をつくる'),
        actions: [
          TextButton.icon(
            onPressed: () {
              vm.reset();
              _syncNames(service.defaults());
            },
            icon: const Icon(Icons.casino_outlined),
            label: const Text('おまかせ（Seed のまま）'),
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 760),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                '最初は Seed が決めた主人公になっています。好きなところだけ変えて始められます。'
                '同じ Seed・同じ設定・同じ選択なら、必ず同じ人生になります。',
                style: theme.textTheme.bodySmall,
              ),
              const SizedBox(height: 12),
              SectionCard(
                title: '名前と性別',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _family,
                            maxLength: PlayerSetupService.maxNameLength,
                            decoration: const InputDecoration(
                              labelText: '姓',
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (v) =>
                                vm.update((s) => s.copyWith(familyName: v)),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            controller: _given,
                            maxLength: PlayerSetupService.maxNameLength,
                            decoration: const InputDecoration(
                              labelText: '名',
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (v) =>
                                vm.update((s) => s.copyWith(givenName: v)),
                          ),
                        ),
                      ],
                    ),
                    SegmentedButton<Gender>(
                      segments: [
                        for (final g in Gender.values)
                          ButtonSegment(value: g, label: Text(g.label)),
                      ],
                      selected: {setup.gender},
                      onSelectionChanged: (v) => vm.setGender(v.first),
                    ),
                  ],
                ),
              ),
              SectionCard(
                title: '入学する中学校',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    DropdownButton<String>(
                      value: setup.schoolId,
                      isExpanded: true,
                      menuMaxHeight: 480,
                      items: [
                        for (final id in service.selectableSchools(
                          setup.gender,
                        ))
                          DropdownMenuItem(
                            value: id,
                            child: Text(
                              '${idx.schoolById[id]!.name}'
                              '（${idx.clubOfSchool(id).tier.label}・部員${idx.clubOfSchool(id).memberIds.length}人）'
                              '${id == defaultSchool ? ' ★Seed' : ''}',
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                      ],
                      onChanged: (v) =>
                          vm.update((s) => s.copyWith(schoolId: v!)),
                    ),
                    _SchoolInfo(schoolId: setup.schoolId),
                  ],
                ),
              ),
              SectionCard(
                title: '入学前の音楽経験',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SegmentedButton<MusicBackground>(
                      segments: [
                        for (final b in [
                          MusicBackground.none,
                          MusicBackground.piano,
                          MusicBackground.elementaryBand,
                        ])
                          ButtonSegment(value: b, label: Text(b.label)),
                      ],
                      selected: {setup.background},
                      onSelectionChanged: (v) =>
                          vm.update((s) => s.copyWith(background: v.first)),
                    ),
                    const SizedBox(height: 6),
                    Text(switch (setup.background) {
                      MusicBackground.piano => 'ピアノ経験：読譜力 +12・音感 +6・指の器用さ +4',
                      MusicBackground.elementaryBand =>
                        '小学校金管バンド：肺活量・リズム・読譜力 +6、金管楽器なら最初から少し吹ける',
                      _ => '未経験：補正なし。まっさらな状態から始める。',
                    }, style: theme.textTheme.bodySmall),
                  ],
                ),
              ),
              SectionCard(
                title: '性格',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _AxisSlider(
                      '内向的',
                      '外向的',
                      setup.personality.extraversion,
                      (v) => vm.setAxis('extraversion', v),
                    ),
                    _AxisSlider(
                      '我が強い',
                      '協調的',
                      setup.personality.agreeableness,
                      (v) => vm.setAxis('agreeableness', v),
                    ),
                    _AxisSlider(
                      '気まま',
                      '勤勉',
                      setup.personality.conscientiousness,
                      (v) => vm.setAxis('conscientiousness', v),
                    ),
                    _AxisSlider(
                      '図太い',
                      '繊細',
                      setup.personality.neuroticism,
                      (v) => vm.setAxis('neuroticism', v),
                    ),
                    _AxisSlider(
                      '控えめ',
                      '野心的',
                      setup.personality.ambition,
                      (v) => vm.setAxis('ambition', v),
                    ),
                    const SizedBox(height: 8),
                    Text('この性格から付く性格タグ', style: theme.textTheme.labelLarge),
                    const SizedBox(height: 4),
                    TraitChips(traits),
                  ],
                ),
              ),
              SectionCard(
                title: '能力（残りポイント $remaining ／ 上限 ${service.budget}）',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      '合計が上限を超えないように配分します（増やしたいときは、ほかの能力を減らしてください）。'
                      '（ ）内は音楽経験の補正を加えた最終値。',
                      style: theme.textTheme.bodySmall,
                    ),
                    for (final (key, label, base, fin) in [
                      (
                        'pitch',
                        AptitudeKind.pitch.label,
                        setup.aptitude.pitch,
                        finalAptitude.pitch,
                      ),
                      (
                        'rhythm',
                        AptitudeKind.rhythm.label,
                        setup.aptitude.rhythm,
                        finalAptitude.rhythm,
                      ),
                      (
                        'breath',
                        AptitudeKind.breath.label,
                        setup.aptitude.breath,
                        finalAptitude.breath,
                      ),
                      (
                        'dexterity',
                        AptitudeKind.dexterity.label,
                        setup.aptitude.dexterity,
                        finalAptitude.dexterity,
                      ),
                      (
                        'expression',
                        AptitudeKind.expression.label,
                        setup.aptitude.expression,
                        finalAptitude.expression,
                      ),
                      (
                        'reading',
                        AptitudeKind.reading.label,
                        setup.aptitude.reading,
                        finalAptitude.reading,
                      ),
                      ('academic', '学力', setup.academic, setup.academic),
                      ('stamina', '体力', setup.stamina, setup.stamina),
                    ])
                      _StatSlider(
                        label: label,
                        value: base,
                        finalValue: fin,
                        onChanged: (v) => vm.setStat(key, v),
                      ),
                    const SizedBox(height: 8),
                    Text(
                      '楽器との相性（体験入部での手応えの目安）',
                      style: theme.textTheme.labelLarge,
                    ),
                    const SizedBox(height: 4),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        for (final (t, fit) in finalAptitude.rankedFits().take(
                          6,
                        ))
                          Chip(
                            visualDensity: VisualDensity.compact,
                            label: Text('${t.label} ${fitHint(fit)}'),
                          ),
                      ],
                    ),
                    Text(
                      '苦手：${finalAptitude.rankedFits().reversed.take(3).map((e) => e.$1.label).join('、')}',
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              if (error != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(
                    error,
                    style: TextStyle(color: theme.colorScheme.error),
                  ),
                ),
              FilledButton.icon(
                onPressed: error == null ? start : null,
                icon: const Icon(Icons.play_arrow),
                label: const Text('この主人公で始める'),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

class _SchoolInfo extends ConsumerWidget {
  const _SchoolInfo({required this.schoolId});
  final String schoolId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final idx = ref.watch(worldControllerProvider).value!.index;
    final s = idx.schoolById[schoolId]!;
    final c = idx.clubOfSchool(schoolId);
    final advisor = idx.npcById[c.advisorId]!.advisorProfile!;
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          KvRow(
            '所在地',
            '${idx.districtById[s.districtId]!.name}・${s.town}（${s.ownership.label}）',
          ),
          KvRow('学力水準', '${s.academicLevel}'),
          KvRow('校風', s.cultures.map((e) => e.label).join('・')),
          KvRow(
            '吹奏楽部',
            '${c.tier.label} ／ ${c.mood.label} ／ 練習強度 ${'●' * c.practiceIntensity}',
          ),
          KvRow('顧問', '${advisor.style.label}（指導力 ${advisor.teachingSkill}）'),
          KvRow('過去の成績', c.history.isEmpty ? '－' : c.history.last.summary),
        ],
      ),
    );
  }
}

class _AxisSlider extends StatelessWidget {
  const _AxisSlider(this.left, this.right, this.value, this.onChanged);

  final String left;
  final String right;
  final int value;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.bodySmall;
    return Row(
      children: [
        SizedBox(
          width: 64,
          child: Text(left, style: style, textAlign: TextAlign.right),
        ),
        Expanded(
          child: Slider(
            value: value.toDouble(),
            min: -100,
            max: 100,
            divisions: 40,
            onChanged: (v) => onChanged(v.round()),
          ),
        ),
        SizedBox(width: 64, child: Text(right, style: style)),
      ],
    );
  }
}

class _StatSlider extends StatelessWidget {
  const _StatSlider({
    required this.label,
    required this.value,
    required this.finalValue,
    required this.onChanged,
  });

  final String label;
  final int value;
  final int finalValue;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.bodySmall;
    return Row(
      children: [
        SizedBox(width: 84, child: Text(label, style: style)),
        Expanded(
          child: Slider(
            value: value.toDouble(),
            min: PlayerSetupService.minStat.toDouble(),
            max: PlayerSetupService.maxStat.toDouble(),
            divisions: PlayerSetupService.maxStat - PlayerSetupService.minStat,
            onChanged: (v) => onChanged(v.round()),
          ),
        ),
        SizedBox(
          width: 72,
          child: Text(
            finalValue == value ? '$value' : '$value（$finalValue）',
            style: style,
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
}
