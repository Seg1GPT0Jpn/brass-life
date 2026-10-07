import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'router.dart';

class BrassLifeApp extends ConsumerWidget {
  const BrassLifeApp({super.key});

  static const _seed = Color(0xFF8C6A1C); // 真鍮色
  static const _font = 'BIZUDPGothic';

  ThemeData _theme(Brightness b) => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: _seed, brightness: b),
    fontFamily: _font,
    visualDensity: VisualDensity.standard,
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'ブラス・ライフ',
      debugShowCheckedModeBanner: false,
      theme: _theme(Brightness.light),
      darkTheme: _theme(Brightness.dark),
      locale: const Locale('ja', 'JP'),
      routerConfig: ref.watch(routerProvider),
    );
  }
}
