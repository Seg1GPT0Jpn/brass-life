import 'package:flutter/material.dart';

import '../../../domain/game/scene/scene_models.dart';
import 'scene_palette.dart';

/// 見取り図（1000 × [canvasHeight]）を画面幅に合わせて描くジオラマ。
///
/// 配置・状態はすべて [ClubScene]（データ層）が決め、ここは描くだけ。
/// 人物は [AnimatedPositioned] で置くので、週が進んで場所が変わると歩いて移動する。
class DioramaView extends StatelessWidget {
  const DioramaView({
    super.key,
    required this.scene,
    this.onLocationTap,
    this.onActorTap,
  });

  final ClubScene scene;
  final ValueChanged<SceneLocation>? onLocationTap;
  final ValueChanged<SceneActor>? onActorTap;

  /// 見取り図の縦の広さ（場所の矩形が収まる範囲）。
  static const double canvasHeight = 840;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, box) {
        // 横は画面幅に合わせ、縦は狭い画面でも窮屈にならないよう下限をつける。
        final scale = box.maxWidth / 1000;
        final scaleY = scale < 0.6 ? 0.6 : scale;
        final height = canvasHeight * scaleY;
        final token = (36 * scale).clamp(18.0, 34.0);
        final byId = {for (final a in scene.actors) a.id: a};
        return ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: SizedBox(
            width: box.maxWidth,
            height: height,
            child: InteractiveViewer(
              maxScale: 3,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 900),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: ScenePalette.background(scene.season, scene.time),
                  ),
                ),
                child: Stack(
                  children: [
                    for (final l in SceneLocation.values)
                      _LocationTile(
                        key: ValueKey('loc-${l.name}'),
                        location: l,
                        scale: scale,
                        scaleY: scaleY,
                        count: scene.at(l).length,
                        onTap: onLocationTap == null
                            ? null
                            : () => onLocationTap!(l),
                      ),
                    // 二人組を結ぶ線
                    Positioned.fill(
                      child: IgnorePointer(
                        child: CustomPaint(
                          painter: _PairPainter(
                            scene.actors,
                            byId,
                            scale,
                            scaleY,
                          ),
                        ),
                      ),
                    ),
                    for (final a in scene.actors)
                      AnimatedPositioned(
                        key: ValueKey('actor-${a.id}'),
                        duration: const Duration(milliseconds: 700),
                        curve: Curves.easeInOut,
                        left: a.x * scale - token / 2,
                        top: a.y * scaleY - token / 2,
                        width: token,
                        height: token,
                        child: ActorToken(
                          actor: a,
                          size: token,
                          onTap: onActorTap == null
                              ? null
                              : () => onActorTap!(a),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _LocationTile extends StatelessWidget {
  const _LocationTile({
    super.key,
    required this.location,
    required this.scale,
    required this.scaleY,
    required this.count,
    this.onTap,
  });

  final SceneLocation location;
  final double scale;
  final double scaleY;
  final int count;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l = location;
    final small = scale < 0.6;
    return Positioned(
      left: l.left * scale,
      top: l.top * scaleY,
      width: l.width * scale,
      height: l.height * scaleY,
      child: Material(
        color: ScenePalette.floor(l).withValues(alpha: 0.82),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8 * scale + 2),
          side: BorderSide(color: Colors.black.withValues(alpha: 0.12)),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 6 * scale + 2,
                vertical: 4 * scale + 1,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    ScenePalette.locationIcon(l),
                    size: small ? 10 : 14,
                    color: Colors.black54,
                  ),
                  const SizedBox(width: 3),
                  Text(
                    count == 0 ? l.label : '${l.label} $count',
                    style: TextStyle(
                      fontSize: small ? 9 : 12,
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// 人物 1 人のアイコン（ちびキャラの代わりの丸）。
///
/// 塗り = 楽器の系統、枠 = 表情、右下 = いまの状態。
/// [glow] で枠を光らせる（本番の演出などで使う）。
class ActorToken extends StatelessWidget {
  const ActorToken({
    super.key,
    required this.actor,
    required this.size,
    this.onTap,
    this.glow = 0,
  });

  final SceneActor actor;
  final double size;
  final VoidCallback? onTap;

  /// 0..1 の光り具合。
  final double glow;

  @override
  Widget build(BuildContext context) {
    final a = actor;
    final ring = a.isPlayer
        ? const Color(0xFFFFC400)
        : ScenePalette.mood(a.mood);
    final fill = a.isAdvisor
        ? const Color(0xFF37474F)
        : ScenePalette.family(a.family);
    final face = ScenePalette.moodFace(a.mood);
    final glowAmount = a.mood == ActorMood.happy || a.towardPlayer
        ? glow.clamp(0.35, 1.0)
        : glow;
    return Tooltip(
      message: '${a.name}（${a.activity.label}）',
      child: GestureDetector(
        onTap: onTap,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: size,
              height: size,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: fill,
                shape: BoxShape.circle,
                border: Border.all(color: ring, width: a.isPlayer ? 3 : 2),
                boxShadow: [
                  if (glowAmount > 0)
                    BoxShadow(
                      color: ring.withValues(alpha: 0.75 * glowAmount),
                      blurRadius: 4 + 10 * glowAmount,
                      spreadRadius: 1 + 3 * glowAmount,
                    ),
                ],
              ),
              child: Text(
                a.isPlayer ? '★' : a.name.characters.first,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: size * 0.45,
                  fontWeight: FontWeight.bold,
                  height: 1,
                ),
              ),
            ),
            Positioned(
              right: -size * 0.18,
              bottom: -size * 0.18,
              child: Container(
                padding: const EdgeInsets.all(1.5),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  ScenePalette.activity(a.activity),
                  size: size * 0.38,
                  color: Colors.black87,
                ),
              ),
            ),
            if (face.isNotEmpty)
              Positioned(
                right: -size * 0.2,
                top: -size * 0.3,
                child: Text(face, style: TextStyle(fontSize: size * 0.4)),
              ),
          ],
        ),
      ),
    );
  }
}

class _PairPainter extends CustomPainter {
  _PairPainter(this.actors, this.byId, this.scale, this.scaleY);

  final List<SceneActor> actors;
  final Map<String, SceneActor> byId;
  final double scale;
  final double scaleY;

  @override
  void paint(Canvas canvas, Size size) {
    for (final a in actors) {
      final b = a.partnerId == null ? null : byId[a.partnerId];
      // 二重に描かないよう ID の小さい側だけが描く
      if (b == null || a.id.compareTo(b.id) > 0) continue;
      final paint = Paint()
        ..color = a.activity == ActorActivity.arguing
            ? const Color(0xAAE53935)
            : const Color(0x8842A5F5)
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke;
      canvas.drawLine(
        Offset(a.x * scale, a.y * scaleY),
        Offset(b.x * scale, b.y * scaleY),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_PairPainter old) =>
      old.actors != actors || old.scale != scale || old.scaleY != scaleY;
}
