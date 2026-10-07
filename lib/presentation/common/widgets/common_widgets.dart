import 'package:flutter/material.dart';

import '../../../domain/entities/npc.dart';
import '../../../domain/master/trait_definitions.dart';
import '../../../domain/value_objects/personality.dart';
import '../../../domain/value_objects/school_enums.dart';

/// 見出し付きのカード。
class SectionCard extends StatelessWidget {
  const SectionCard({
    super.key,
    required this.title,
    required this.child,
    this.trailing,
  });

  final String title;
  final Widget child;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ?trailing,
              ],
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}

/// 「ラベル: 値」の 1 行。
class KvRow extends StatelessWidget {
  const KvRow(this.label, this.value, {super.key, this.onTap});

  final String label;
  final String value;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final text = Text(
      value,
      style: onTap == null
          ? theme.textTheme.bodyMedium
          : theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.primary,
              decoration: TextDecoration.underline,
            ),
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 136,
            child: Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(
            child: onTap == null ? text : InkWell(onTap: onTap, child: text),
          ),
        ],
      ),
    );
  }
}

/// 数値を横棒で表示する。[min] が負なら中央を 0 とした両方向バー。
class ValueBar extends StatelessWidget {
  const ValueBar({
    super.key,
    required this.label,
    required this.value,
    this.min = 0,
    required this.max,
    this.valueText,
    this.labelWidth = 112,
  });

  final String label;
  final int value;
  final int min;
  final int max;
  final String? valueText;
  final double labelWidth;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final bipolar = min < 0;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          SizedBox(
            width: labelWidth,
            child: Text(
              label,
              style: theme.textTheme.bodySmall,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            child: LayoutBuilder(
              builder: (context, c) {
                final w = c.maxWidth;
                final range = (max - min).toDouble();
                final zeroX = bipolar ? w * (-min) / range : 0.0;
                final valueX = w * (value - min) / range;
                final left = valueX < zeroX ? valueX : zeroX;
                final width = (valueX - zeroX).abs();
                return SizedBox(
                  height: 12,
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: scheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      Positioned(
                        left: left,
                        width: width,
                        top: 0,
                        bottom: 0,
                        child: Container(
                          decoration: BoxDecoration(
                            color: value < 0 ? scheme.tertiary : scheme.primary,
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                      ),
                      if (bipolar)
                        Positioned(
                          left: zeroX - 0.5,
                          width: 1,
                          top: 0,
                          bottom: 0,
                          child: Container(color: scheme.outline),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
          SizedBox(
            width: 52,
            child: Text(
              valueText ?? '$value',
              textAlign: TextAlign.right,
              style: theme.textTheme.bodySmall?.copyWith(
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 件数の分布を横棒で表示する。
class DistributionBars extends StatelessWidget {
  const DistributionBars({
    super.key,
    required this.entries,
    this.labelWidth = 112,
  });

  final List<(String, int)> entries;
  final double labelWidth;

  @override
  Widget build(BuildContext context) {
    final max = entries.fold(1, (m, e) => e.$2 > m ? e.$2 : m);
    return Column(
      children: [
        for (final (label, count) in entries)
          ValueBar(
            label: label,
            value: count,
            max: max,
            labelWidth: labelWidth,
          ),
      ],
    );
  }
}

/// 性格タグのチップ。強度を ★ で表す。
class TraitChip extends StatelessWidget {
  const TraitChip(this.tag, {super.key, this.dense = false});

  final TraitTag tag;
  final bool dense;

  @override
  Widget build(BuildContext context) {
    final def = traitById[tag.traitId];
    final scheme = Theme.of(context).colorScheme;
    final special = def?.category == TraitCategory.special;
    final label = '${def?.label ?? tag.traitId}${'★' * tag.intensity}';
    return Tooltip(
      message: def?.description ?? '',
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: dense ? 6 : 8,
          vertical: dense ? 1 : 3,
        ),
        decoration: BoxDecoration(
          color: special ? scheme.tertiaryContainer : scheme.secondaryContainer,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: dense ? 11 : 12,
            color: special
                ? scheme.onTertiaryContainer
                : scheme.onSecondaryContainer,
          ),
        ),
      ),
    );
  }
}

class TraitChips extends StatelessWidget {
  const TraitChips(this.traits, {super.key, this.dense = false, this.max});

  final List<TraitTag> traits;
  final bool dense;
  final int? max;

  @override
  Widget build(BuildContext context) {
    final shown = max == null ? traits : traits.take(max!).toList();
    return Wrap(
      spacing: 4,
      runSpacing: 4,
      children: [
        for (final t in shown) TraitChip(t, dense: dense),
        if (shown.length < traits.length)
          Text(
            '+${traits.length - shown.length}',
            style: const TextStyle(fontSize: 11),
          ),
      ],
    );
  }
}

/// 強さ帯のバッジ。
class TierBadge extends StatelessWidget {
  const TierBadge(this.tier, {super.key});

  final ClubTier tier;

  @override
  Widget build(BuildContext context) {
    final color = switch (tier) {
      ClubTier.national => const Color(0xFFC9A227),
      ClubTier.block => const Color(0xFF9E9E9E),
      ClubTier.prefectural => const Color(0xFFB0703C),
      ClubTier.district => const Color(0xFF5C8A6E),
      ClubTier.weak => const Color(0xFF7A7F87),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.18),
        border: Border.all(color: color),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(tier.label, style: TextStyle(fontSize: 11, color: color)),
    );
  }
}

/// NPC の担当・希望楽器の短い表示。
String instrumentSummary(Npc n) {
  if (n.instrument != null) return n.instrument!.label;
  if (n.wishInstrument != null) return '希望: ${n.wishInstrument!.label}';
  return '－';
}

/// 絞り込み用のコンパクトなドロップダウン。
class FilterDropdown<T> extends StatelessWidget {
  const FilterDropdown({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
    this.hint,
  });

  final T value;
  final List<(T, String)> items;
  final ValueChanged<T?> onChanged;
  final String? hint;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<T>(
      value: value,
      hint: hint == null ? null : Text(hint!),
      isDense: true,
      menuMaxHeight: 420,
      items: [
        for (final (v, label) in items)
          DropdownMenuItem<T>(value: v, child: Text(label)),
      ],
      onChanged: onChanged,
    );
  }
}
