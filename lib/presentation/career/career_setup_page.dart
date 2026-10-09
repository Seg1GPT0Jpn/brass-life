import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../domain/career/game_mode.dart';
import '../../domain/entities/school.dart';
import '../../domain/value_objects/school_enums.dart';
import '../common/widgets/common_widgets.dart';
import '../game/game_controller.dart';
import '../world/world_controller.dart';

/// 大人編を始める前の設定（名前と学校）。
class CareerSetupPage extends ConsumerStatefulWidget {
  const CareerSetupPage({super.key, required this.mode});

  final GameMode mode;

  @override
  ConsumerState<CareerSetupPage> createState() => _CareerSetupPageState();
}

class _CareerSetupPageState extends ConsumerState<CareerSetupPage> {
  final _family = TextEditingController();
  final _given = TextEditingController();
  String? _schoolId;
  bool _initialized = false;

  @override
  void dispose() {
    _family.dispose();
    _given.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(worldControllerProvider).value;
    final theme = Theme.of(context);
    if (session == null) {
      return Scaffold(
        appBar: AppBar(title: Text('${widget.mode.label}モード')),
        body: const Center(child: Text('タイトルで Seed を入力してから始めてください。')),
      );
    }
    final world = session.world;
    final records = ref.watch(careerRecordsProvider).value ?? const [];
    final last = records.isEmpty ? null : records.last;
    if (!_initialized) {
      _initialized = true;
      final name = (last?.playerName ?? world.player.fullName).split(' ');
      _family.text = name.first;
      _given.text = name.length > 1 ? name.sublist(1).join(' ') : '';
      _schoolId = world.player.schoolId;
    }
    final schools = [...world.schools]
      ..sort((a, b) {
        final c = a.level.index.compareTo(b.level.index);
        return c != 0 ? c : a.name.compareTo(b.name);
      });
    String tierOf(School sc) => session.index.clubOfSchool(sc.id).tier.label;
    final schoolLabel = switch (widget.mode) {
      GameMode.teacher => '赴任する学校',
      GameMode.instructor => '拠点にする学校（ほかに同じ学校段階の 2 校と契約する）',
      _ => '母校',
    };
    final ok =
        _family.text.trim().isNotEmpty &&
        _given.text.trim().isNotEmpty &&
        _schoolId != null;
    return Scaffold(
      appBar: AppBar(title: Text('${widget.mode.label}モードを始める')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SectionCard(
            title: '${widget.mode.label}モード',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(widget.mode.description),
                const SizedBox(height: 4),
                Text(
                  '任期は ${GameMode.termYears} 年。'
                  '${last == null ? '' : '生徒時代の「${last.title}」を経て、大人になった自分で挑む。'}',
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
          SectionCard(
            title: '名前',
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _family,
                    decoration: const InputDecoration(labelText: '姓'),
                    onChanged: (_) => setState(() {}),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _given,
                    decoration: const InputDecoration(labelText: '名'),
                    onChanged: (_) => setState(() {}),
                  ),
                ),
              ],
            ),
          ),
          SectionCard(
            title: schoolLabel,
            child: DropdownButton<String>(
              isExpanded: true,
              value: _schoolId,
              items: [
                for (final sc in schools)
                  DropdownMenuItem(
                    value: sc.id,
                    child: Text(
                      '${sc.name}（${sc.level == SchoolLevel.middle ? '中学' : '高校'}・${tierOf(sc)}）',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
              ],
              onChanged: (v) => setState(() => _schoolId = v),
            ),
          ),
          const SizedBox(height: 8),
          FilledButton(
            onPressed: !ok
                ? null
                : () {
                    ref
                        .read(gameControllerProvider.notifier)
                        .newCareerGame(
                          widget.mode,
                          schoolId: _schoolId!,
                          familyName: _family.text.trim(),
                          givenName: _given.text.trim(),
                          originTitle: last?.title,
                        );
                    context.go('/game');
                  },
            child: Text('${widget.mode.label}として始める'),
          ),
        ],
      ),
    );
  }
}
