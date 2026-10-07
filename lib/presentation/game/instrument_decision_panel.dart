import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/game/engine/instrument_decision.dart';
import '../../domain/value_objects/instrument.dart';
import '../common/widgets/common_widgets.dart';
import 'game_controller.dart';

/// 楽器決定イベント: 第 1〜3 希望を選んで提出する。
class InstrumentDecisionPanel extends ConsumerStatefulWidget {
  const InstrumentDecisionPanel({super.key});

  @override
  ConsumerState<InstrumentDecisionPanel> createState() =>
      _InstrumentDecisionPanelState();
}

class _InstrumentDecisionPanelState
    extends ConsumerState<InstrumentDecisionPanel> {
  final List<InstrumentType> _wishes = [];

  void _toggle(InstrumentType t) => setState(() {
    if (_wishes.contains(t)) {
      _wishes.remove(t);
    } else if (_wishes.length < 3) {
      _wishes.add(t);
    }
  });

  Future<void> _submit() async {
    final lines = ref
        .read(gameControllerProvider.notifier)
        .resolveInstrument(List.of(_wishes));
    if (!mounted) return;
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('楽器決定'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [for (final l in lines) Text(l)],
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = ref.watch(gameControllerProvider)!;
    final ctx = ref.watch(gameContextProvider)!;
    final preview = InstrumentDecision(ctx).preview(s);
    final theme = Theme.of(context);
    return SectionCard(
      title: 'イベント：担当楽器の決定',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            '体験入部が終わり、担当楽器を決める日が来た。希望を第3希望まで提出しよう。'
            '最終的には、体験での手応え（適性）・希望・楽器の空き・先輩や顧問の考え方で決まる。',
          ),
          const SizedBox(height: 8),
          Text(
            '手応え ◎ とても良い ／ ○ まずまず ／ △ いまひとつ　'
            '「枠」は今年の新入生が入れそうな人数の目安、「希望者」は他の新入生の第1希望の人数。',
            style: theme.textTheme.bodySmall,
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final t in InstrumentType.values)
                if (t != InstrumentType.ebClarinet)
                  FilterChip(
                    selected: _wishes.contains(t),
                    onSelected: (_) => _toggle(t),
                    avatar: _wishes.contains(t)
                        ? CircleAvatar(child: Text('${_wishes.indexOf(t) + 1}'))
                        : null,
                    label: Text(
                      '${t.label} ${fitHint(s.player.aptitude.fitFor(t))} '
                      '枠${preview[t]!.capacity} 希望者${preview[t]!.wishers}',
                    ),
                  ),
            ],
          ),
          const SizedBox(height: 12),
          KvRow(
            'あなたの希望',
            _wishes.isEmpty
                ? '（楽器をタップして選択）'
                : [
                    for (var i = 0; i < _wishes.length; i++)
                      '第${i + 1}希望 ${_wishes[i].label}',
                  ].join(' ／ '),
          ),
          const SizedBox(height: 8),
          FilledButton(
            onPressed: _wishes.isEmpty ? null : _submit,
            child: const Text('希望を提出する'),
          ),
        ],
      ),
    );
  }
}
