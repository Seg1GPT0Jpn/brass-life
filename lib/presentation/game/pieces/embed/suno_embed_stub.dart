import 'package:flutter/material.dart';

/// Web 以外では埋め込みプレーヤーを表示できない。
bool get sunoEmbedSupported => false;

class SunoEmbedView extends StatelessWidget {
  const SunoEmbedView({super.key, required this.url, this.height = 220});

  final String url;
  final double height;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Text(
      'この環境では Suno のプレーヤーを埋め込めません。「Suno で開く」から聴いてください。',
      style: Theme.of(context).textTheme.bodySmall,
    ),
  );
}
