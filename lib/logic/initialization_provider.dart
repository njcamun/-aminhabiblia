import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/services/bible_import_service.dart';
import '../data/services/cross_reference_import_service.dart';
import '../services/notification_service.dart';
import 'providers.dart';

final appInitializationProvider = FutureProvider<void>((ref) async {
  final startupWatch = Stopwatch()..start();

  final bibleDao = ref.watch(bibleDaoProvider);
  final bibleRepo = ref.read(bibleRepositoryProvider);
  final hymnRepo = ref.read(hymnRepositoryProvider);
  final syncService = ref.read(firebaseSyncServiceProvider);

  final bibleImport = BibleImportService(bibleDao);
  final crossRefImport = CrossReferenceImportService(bibleDao);

  // 1) Inicializacao minima para abrir app
  await NotificationService.instance.init();
  debugPrint(
      'DEBUG: Init notifications em ${startupWatch.elapsedMilliseconds}ms');

  // 2) Garantir NAA (essencial para abrir a app)
  try {
    final naaCheckWatch = Stopwatch()..start();
    final isNaaImported = await bibleDao.isVersionImported('NAA').timeout(
          const Duration(seconds: 10),
          onTimeout: () => true,
        );
    debugPrint('DEBUG: Check NAA em ${naaCheckWatch.elapsedMilliseconds}ms');

    if (!isNaaImported) {
      ref.read(initializationMessageProvider.notifier).state =
          'A carregar a Biblia Sagrada...';
      debugPrint('DEBUG: Iniciando importacao de NAA...');
      final naaImportWatch = Stopwatch()..start();

      await bibleImport.importFromJson(
        'NAA',
        'assets/biblias/NAA.json',
        onProgress: (p) {
          ref.read(importProgressProvider.notifier).state = p * 0.75;
        },
      ).timeout(
        const Duration(minutes: 2),
        onTimeout: () {
          debugPrint('AVISO: Importacao de NAA demorou, continuando startup');
        },
      );

      debugPrint(
          'DEBUG: Importacao NAA em ${naaImportWatch.elapsedMilliseconds}ms');
    } else {
      debugPrint('DEBUG: NAA ja importado');
    }
  } catch (e) {
    debugPrint('Erro ao verificar/importar NAA: $e');
  }

  // 3) Listener de auth para sync (barato e nao bloqueante)
  if (syncService != null) {
    try {
      final StreamSubscription subscription =
          syncService.authStateChanges.listen(
        (user) {
          if (user != null) {
            debugPrint(
                'DEBUG: Usuario autenticado, iniciando sync em background');
            syncService
                .syncFromCloud()
                .catchError((e) => debugPrint('Erro na sincronizacao: $e'));
          }
        },
        onError: (e) => debugPrint('Erro no listener de auth: $e'),
      );
      ref.onDispose(subscription.cancel);
    } catch (e) {
      debugPrint('Erro ao configurar listener de auth: $e');
    }
  }

  // 4) Liberar UI imediatamente
  ref.read(initializationMessageProvider.notifier).state =
      'Pronto! Graca e Paz.';
  ref.read(importProgressProvider.notifier).state = 1.0;
  startupWatch.stop();
  debugPrint(
      'DEBUG: Startup critico concluido em ${startupWatch.elapsedMilliseconds}ms');

  // 5) Tarefas pesadas em background (nao bloqueiam abertura)
  unawaited(() async {
    final postInitWatch = Stopwatch()..start();

    // 5.1) Consolidacao one-time de dados de estudo
    try {
      final migrationDone = await bibleRepo.isVerseAnchoredMigrationDone();
      if (!migrationDone) {
        await bibleRepo.migrateVerseAnchoredData().timeout(
          const Duration(seconds: 30),
          onTimeout: () {
            debugPrint(
                'AVISO: Migracao de dados de estudo demorou, continuando...');
          },
        );
        await bibleRepo.setVerseAnchoredMigrationDone(true);
        debugPrint('DEBUG: Migracao de dados concluida');
      }
    } catch (e) {
      debugPrint('Erro na migracao de dados de estudo: $e');
    }

    // 5.2) Referencias cruzadas em background
    try {
      final hasCrossRefs = await bibleDao.hasAnyCrossReference().timeout(
            const Duration(seconds: 5),
            onTimeout: () => false,
          );
      if (!hasCrossRefs) {
        final imported = await crossRefImport
            .importFromNumberedAssets('assets/referencias', 1, 32)
            .timeout(
              const Duration(seconds: 45),
              onTimeout: () => false,
            );

        if (imported) {
          final count = await bibleDao.countCrossReferences().timeout(
                const Duration(seconds: 5),
                onTimeout: () => 0,
              );
          if (count > 0) {
            debugPrint('DEBUG: Referencias instaladas em background: $count');
          } else {
            await crossRefImport.seedBasicReferences();
          }
        }
      }
    } catch (e) {
      debugPrint('Erro ao importar referencias: $e');
    }

    // 5.3) Hinarios em background
    try {
      await hymnRepo
          .initImportJson('assets/hinarios/harpa/harpa_crista.json', 'HARPA')
          .timeout(
            const Duration(seconds: 15),
            onTimeout: () => debugPrint('AVISO: Carregamento HARPA demorou'),
          );
      await hymnRepo
          .initImportJson(
              'assets/hinarios/novo_cantico/-novo_cantico.json', 'NOVO_CANTICO')
          .timeout(
            const Duration(seconds: 15),
            onTimeout: () =>
                debugPrint('AVISO: Carregamento NOVO_CANTICO demorou'),
          );

      final cleaned = await hymnRepo.cleanStoredLyricsArtifacts().timeout(
            const Duration(seconds: 15),
            onTimeout: () => 0,
          );
      if (cleaned > 0) {
        debugPrint(
            'DEBUG: Limpeza de letras dos hinos aplicada em $cleaned registros');
      }
    } catch (e) {
      debugPrint('Erro ao carregar hinarios: $e');
    }

    // 5.4) Promessa diaria em background
    try {
      final randomVerse = await bibleRepo.getRandomVerse('NAA').timeout(
            const Duration(seconds: 10),
            onTimeout: () => null,
          );
      if (randomVerse != null) {
        await NotificationService.instance.scheduleDailyPromisse(
          verseText: randomVerse.text,
          reference:
              '${randomVerse.bookName} ${randomVerse.chapter}:${randomVerse.verse}',
        );
      }
    } catch (e) {
      debugPrint('Erro ao agendar notificacao: $e');
    }

    postInitWatch.stop();
    debugPrint(
        'DEBUG: Pos-init concluido em ${postInitWatch.elapsedMilliseconds}ms');
  }());
});
