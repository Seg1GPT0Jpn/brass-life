import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../domain/game/scene/scene_models.dart';
import 'diorama_view.dart';

/// 合奏・本番の演出つき結果画面。
///
/// 照明が落ちて（色調変化）→ 音符が舞い → 演奏者の枠が光り → 結果が浮かび上がる。
/// アニメーションは一度きりで止まる（ループしない）。
Future<void> showPerformanceStage(
  BuildContext context, {
  required String title,
  required List<String> lines,
  required List<SceneActor> performers,
}) => showGeneralDialog<void>(
  context: context,
  barrierDismissible: false,
  barrierColor: Colors.black87,
  transitionDuration: const Duration(milliseconds: 300),
  pageBuilder: (context, _, _) =>
      PerformanceStage(title: title, lines: lines, performers: performers),
);

class PerformanceStage extends StatefulWidget {
  const PerformanceStage({
    super.key,
    required this.title,
    required this.lines,
    required this.performers,
  });

  final String title;
  final List<String> lines;
  final List<SceneActor> performers;

  /// 演奏の演出の長さ。
  static const duration = Duration(milliseconds: 3600);

  @override
  State<PerformanceStage> createState() => _PerformanceStageState();
}

class _PerformanceStageState extends State<PerformanceStage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: PerformanceStage.duration,
  )..forward();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      type: MaterialType.transparency,
      child: AnimatedBuilder(
        animation: _c,
        builder: (context, _) {
          final t = _c.value;
          // 0..0.25 暗転 → 0.25..0.7 照明が温かくなる → 以降は余韻
          final warm = Curves.easeInOut.transform(
            ((t - 0.25) / 0.45).clamp(0.0, 1.0),
          );
          final dark = Curves.easeOut.transform((t / 0.25).clamp(0.0, 1.0));
          final top = Color.lerp(
            Color.lerp(const Color(0xFF263238), Colors.black, dark),
            const Color(0xFF4A148C),
            warm * 0.8,
          )!;
          final bottom = Color.lerp(
            const Color(0xFF37474F),
            const Color(0xFFFF8F00),
            warm * 0.7,
          )!;
          final pulse = t < 0.25
              ? 0.0
              : (0.5 + 0.5 * math.sin(t * math.pi * 10)) * (1 - t * 0.4);
          final resultOpacity = ((t - 0.6) / 0.3).clamp(0.0, 1.0);
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [top, bottom],
              ),
            ),
            child: Stack(
              children: [
                // スポットライト
                Positioned.fill(
                  child: IgnorePointer(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: RadialGradient(
                          center: const Alignment(0, -0.3),
                          radius: 0.4 + 0.5 * warm,
                          colors: [
                            Colors.white.withValues(alpha: 0.22 * warm),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned.fill(
                  child: IgnorePointer(
                    child: CustomPaint(
                      painter: _NotesPainter(
                        t,
                        theme.textTheme.bodyMedium?.fontFamily,
                      ),
                    ),
                  ),
                ),
                SafeArea(
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 640),
                      child: ListView(
                        shrinkWrap: true,
                        padding: const EdgeInsets.all(16),
                        children: [
                          Text(
                            widget.title,
                            textAlign: TextAlign.center,
                            style: theme.textTheme.headlineSmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Wrap(
                            alignment: WrapAlignment.center,
                            spacing: 10,
                            runSpacing: 10,
                            children: [
                              for (final a in widget.performers)
                                ActorToken(
                                  actor: a,
                                  size: a.isPlayer ? 40 : 28,
                                  glow: a.isPlayer ? pulse : pulse * 0.6,
                                ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Opacity(
                            opacity: resultOpacity,
                            child: Card(
                              color: Colors.white.withValues(alpha: 0.92),
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    for (final l in widget.lines) Text(l),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Center(
                            child: FilledButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text(t < 1 ? 'スキップ' : 'OK'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// 舞い上がる音楽記号。位置や速さは番号から決まる（乱数は使わない）。
class _NotesPainter extends CustomPainter {
  _NotesPainter(this.t, this.fontFamily);

  final double t;

  /// アプリのフォント（CustomPainter はテーマを継承しないので明示する）。
  final String? fontFamily;

  static const _symbols = ['♪', '♫', '♬', '♩', '♯', '♭'];
  static const _count = 28;

  static int _hash(int i, int salt) {
    var h = (i * 0x9E3779B1 + salt * 0x85EBCA77) & 0xFFFFFFFF;
    h = ((h ^ (h >> 15)) * 0x2C1B3C6D) & 0xFFFFFFFF;
    h = ((h ^ (h >> 12)) * 0x297A2D39) & 0xFFFFFFFF;
    return h ^ (h >> 15);
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (t < 0.2) return;
    final local = (t - 0.2) / 0.8;
    for (var i = 0; i < _count; i++) {
      final x0 = (_hash(i, 1) % 1000) / 1000;
      final speed = 0.5 + (_hash(i, 2) % 1000) / 1000;
      final phase = (_hash(i, 3) % 1000) / 1000;
      final sway = math.sin((local * speed * 6 + phase * 6) * math.pi) * 0.04;
      final y = 1.1 - ((local * speed + phase) % 1.0) * 1.2;
      final opacity = (math.sin(((local * speed + phase) % 1.0) * math.pi))
          .clamp(0.0, 1.0);
      final color = Color.lerp(
        const Color(0xFFFFF59D),
        const Color(0xFFF48FB1),
        (_hash(i, 4) % 100) / 100,
      )!.withValues(alpha: opacity * (1 - local * 0.3));
      final tp = TextPainter(
        text: TextSpan(
          text: _symbols[_hash(i, 5) % _symbols.length],
          style: TextStyle(
            fontFamily: fontFamily,
            fontSize: 16 + (_hash(i, 6) % 18),
            color: color,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset((x0 + sway) * size.width, y * size.height));
    }
  }

  @override
  bool shouldRepaint(_NotesPainter old) => old.t != t;
}
