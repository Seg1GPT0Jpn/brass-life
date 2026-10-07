import 'package:flutter/material.dart';

import '../../../domain/game/scene/scene_models.dart';
import '../../../domain/value_objects/instrument.dart';

/// ジオラマの見た目（色・アイコン）の対応表。
///
/// データ層（場所・状態）は変えずに、ここを差し替えれば絵柄を変えられる。
abstract final class ScenePalette {
  /// 季節×時間帯の背景グラデーション（上→下）。
  static List<Color> background(Season season, DayPhase time) {
    final (top, bottom) = switch (season) {
      Season.spring => (const Color(0xFFFCE4EC), const Color(0xFFE8F5E9)),
      Season.summer => (const Color(0xFFB3E5FC), const Color(0xFFFFF9C4)),
      Season.autumn => (const Color(0xFFFFE0B2), const Color(0xFFD7CCC8)),
      Season.winter => (const Color(0xFFE3F2FD), const Color(0xFFECEFF1)),
    };
    return switch (time) {
      DayPhase.afterSchool => [top, bottom],
      DayPhase.dusk => [
        Color.lerp(top, const Color(0xFFFF8A65), 0.55)!,
        Color.lerp(bottom, const Color(0xFF5C6BC0), 0.45)!,
      ],
      DayPhase.night => [const Color(0xFF1A237E), const Color(0xFF263238)],
    };
  }

  /// 場所の床の色。
  static Color floor(SceneLocation l) => switch (l) {
    SceneLocation.musicRoom => const Color(0xFFFFF3E0),
    SceneLocation.woodwindRoom => const Color(0xFFE8F5E9),
    SceneLocation.brassRoom => const Color(0xFFFFF8E1),
    SceneLocation.storage => const Color(0xFFEFEBE9),
    SceneLocation.hallway => const Color(0xFFF5F5F5),
    SceneLocation.library => const Color(0xFFE3F2FD),
    SceneLocation.courtyard => const Color(0xFFDCEDC8),
    SceneLocation.gate => const Color(0xFFECEFF1),
  };

  static IconData locationIcon(SceneLocation l) => switch (l) {
    SceneLocation.musicRoom => Icons.piano,
    SceneLocation.woodwindRoom => Icons.air,
    SceneLocation.brassRoom => Icons.campaign,
    SceneLocation.storage => Icons.inventory_2,
    SceneLocation.hallway => Icons.door_sliding,
    SceneLocation.library => Icons.menu_book,
    SceneLocation.courtyard => Icons.park,
    SceneLocation.gate => Icons.directions_walk,
  };

  /// 楽器の系統ごとの色（アイコンの塗り）。
  static Color family(InstrumentFamily? f) => switch (f) {
    InstrumentFamily.woodwind => const Color(0xFF43A047),
    InstrumentFamily.brass => const Color(0xFFF9A825),
    InstrumentFamily.percussion => const Color(0xFF8E24AA),
    InstrumentFamily.strings => const Color(0xFF8D6E63),
    null => const Color(0xFF78909C),
  };

  /// 表情ごとの枠の色。
  static Color mood(ActorMood m) => switch (m) {
    ActorMood.happy => const Color(0xFFFF4081),
    ActorMood.normal => const Color(0xFF90A4AE),
    ActorMood.tired => const Color(0xFF7E57C2),
    ActorMood.down => const Color(0xFF546E7A),
    ActorMood.angry => const Color(0xFFE53935),
  };

  static String moodFace(ActorMood m) => switch (m) {
    ActorMood.happy => '♪',
    ActorMood.normal => '',
    ActorMood.tired => 'ｚ',
    ActorMood.down => '…',
    ActorMood.angry => '！',
  };

  static IconData activity(ActorActivity a) => switch (a) {
    ActorActivity.practicing => Icons.music_note,
    ActorActivity.ensemble => Icons.queue_music,
    ActorActivity.teaching => Icons.school,
    ActorActivity.learning => Icons.lightbulb,
    ActorActivity.chatting => Icons.chat_bubble,
    ActorActivity.arguing => Icons.flash_on,
    ActorActivity.slacking => Icons.weekend,
    ActorActivity.maintaining => Icons.build,
    ActorActivity.studying => Icons.edit,
    ActorActivity.resting => Icons.coffee,
    ActorActivity.conducting => Icons.straighten,
    ActorActivity.waiting => Icons.visibility,
  };
}
