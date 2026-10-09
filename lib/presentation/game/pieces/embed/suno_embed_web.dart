import 'dart:ui_web' as ui_web;

import 'package:flutter/material.dart';
import 'package:web/web.dart' as web;

bool get sunoEmbedSupported => true;

final _registered = <String>{};

/// iframe で Suno の埋め込みプレーヤーを表示する（アプリ内で再生できる）。
class SunoEmbedView extends StatelessWidget {
  const SunoEmbedView({super.key, required this.url, this.height = 220});

  final String url;
  final double height;

  @override
  Widget build(BuildContext context) {
    final viewType = 'suno-embed:$url';
    if (_registered.add(viewType)) {
      ui_web.platformViewRegistry.registerViewFactory(viewType, (int _) {
        final frame =
            web.document.createElement('iframe') as web.HTMLIFrameElement
              ..src = url
              ..allow = 'autoplay; encrypted-media'
              ..style.border = 'none'
              ..style.width = '100%'
              ..style.height = '100%';
        return frame;
      });
    }
    return SizedBox(
      height: height,
      child: HtmlElementView(viewType: viewType),
    );
  }
}
