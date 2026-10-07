import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/app.dart';
import 'app/providers.dart';
import 'data/datasources/hive/hive_store.dart';
import 'data/repositories/hive_game_save_repository.dart';
import 'data/repositories/hive_world_meta_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  LicenseRegistry.addLicense(() async* {
    final text = await rootBundle.loadString('assets/fonts/OFL.txt');
    yield LicenseEntryWithLineBreaks(['BIZ UDPGothic'], text);
  });

  await HiveStore.init();

  runApp(
    ProviderScope(
      overrides: [
        worldMetaRepositoryProvider.overrideWithValue(
          HiveWorldMetaRepository(HiveStore.worldMeta),
        ),
        gameSaveRepositoryProvider.overrideWithValue(
          HiveGameSaveRepository(HiveStore.gameSaves),
        ),
      ],
      child: const BrassLifeApp(),
    ),
  );
}
