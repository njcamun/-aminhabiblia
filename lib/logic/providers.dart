import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' hide Column;
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:biblia_app/data/database/database.dart';
import 'package:biblia_app/data/database/daos.dart';
import 'package:biblia_app/data/models/hymn.dart';
import 'package:biblia_app/data/models/bible_verse.dart';
import 'package:biblia_app/data/models/study_models.dart';
import 'package:biblia_app/data/repositories/hymn_repository.dart';
import 'package:biblia_app/data/repositories/bible_repository.dart';
import 'package:biblia_app/logic/quiz_generator_service.dart';
import 'package:biblia_app/logic/firebase_sync_service.dart';
import 'package:biblia_app/data/database/mappers.dart';

/// Provider para a instância do AppDatabase (Drift)
final databaseProvider = Provider<AppDatabase>((ref) {
  final executor = LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final driftDir = Directory(p.join(dbFolder.path, 'drift_db'));
    
    if (!await driftDir.exists()) {
      await driftDir.create(recursive: true);
    }
    
    final file = File(p.join(driftDir.path, 'biblia_app.db'));

    // SOLUÇÃO PARA O ERRO 16KB: 
    // Se o ficheiro tiver exatamente 16384 bytes e estiver a falhar, pode estar corrompido.
    // No entanto, vamos focar na configuração robusta de abertura.

    return NativeDatabase(file, setup: (db) {
      // 1. Aumentar o timeout para evitar bloqueios imediatos
      db.execute('PRAGMA busy_timeout = 5000;');
      
      // 2. Configurar o tamanho da página para compatibilidade com kernels de 16KB (Android 15+)
      db.execute('PRAGMA page_size = 16384;');
      
      // 3. Ativar WAL e sincronização segura
      db.execute('PRAGMA journal_mode = WAL;');
      db.execute('PRAGMA synchronous = NORMAL;');
    });
  });
  
  final db = AppDatabase(executor);
  ref.onDispose(() => db.close());
  return db;
});

/// Provider para o BibleDao
final bibleDaoProvider = Provider<BibleDao>((ref) {
  return ref.watch(databaseProvider).bibleDao;
});

/// Provider para o HymnDao
final hymnDaoProvider = Provider<HymnDao>((ref) {
  return ref.watch(databaseProvider).hymnDao;
});

/// Provider para o Repositório de Hinos
final hymnRepositoryProvider = Provider<HymnRepository>((ref) {
  final dao = ref.watch(hymnDaoProvider);
  return HymnRepository(dao);
});

/// Provider para o FirebaseSyncService
final firebaseSyncServiceProvider = Provider<FirebaseSyncService?>((ref) {
  final bibleRepo = ref.watch(bibleRepositoryProvider);
  final hymnRepo = ref.watch(hymnRepositoryProvider);
  final service = FirebaseSyncService(bibleRepo, hymnRepository: hymnRepo);
  bibleRepo.setSyncService(service);
  hymnRepo.setSyncService(service);
  return service;
});

/// Provider para o Repositório da Bíblia (utilizado pela UI)
final bibleRepositoryProvider = Provider<BibleRepository>((ref) {
  final dao = ref.watch(bibleDaoProvider);
  return BibleRepository(dao);
});

/// --- STREAM PROVIDERS PARA DADOS REATIVOS (EVITA ERROS DE MULTI-LISTEN) ---

/// Provider para observar todos as notas do utilizador
final userNotesProvider = StreamProvider<List<UserNote>>((ref) {
  final dao = ref.watch(bibleDaoProvider);
  return dao.watchAllNotes().map((notes) => notes.map((n) => n.toIsar()).toList());
});

/// Provider para observar os favoritos de uma versão específica
final favoriteVersesProvider = StreamProvider.family<List<BibleVerse>, String>((ref, versionId) {
  final repo = ref.watch(bibleRepositoryProvider);
  return repo.watchFavorites(versionId);
});

/// Provider para observar os hinos favoritos
final favoriteHymnsProvider = StreamProvider.family<List<Hymn>, String>((ref, category) {
  final repo = ref.watch(hymnRepositoryProvider);
  return repo.watchFavoriteHymns(category);
});

/// Provider para observar os blocos favoritos de uma versão específica
final favoriteBlocksProvider = StreamProvider.family<List<FavoriteBlock>, String>((ref, versionId) {
  final repo = ref.watch(bibleRepositoryProvider);
  return repo.watchFavoriteBlocks(versionId);
});

/// Provider para observar a nota de um versículo específico
final verseNoteProvider = StreamProvider.family<UserNote?, String>((ref, verseKey) {
  final repo = ref.watch(bibleRepositoryProvider);
  return repo.watchNote(verseKey);
});

/// Provider para observar o tema de leitura
final readingThemeProvider = StreamProvider<String>((ref) {
  final repo = ref.watch(bibleRepositoryProvider);
  return repo.watchReadingTheme();
});

/// Provider para observar as reflexões de um capítulo específico
final reflectionsProvider = StreamProvider.family<List<Reflection>, String>((ref, chapterKey) {
  final repo = ref.watch(bibleRepositoryProvider);

  final parts = chapterKey.split('_');
  if (parts.length < 3) return const Stream.empty();
  
  return repo.watchReflections(parts[0], int.parse(parts[1]), int.parse(parts[2]));
});

/// Provider para os progressos de todos os livros de uma versão
final allBookProgressesProvider = FutureProvider.family<Map<int, double>, String>((ref, versionId) {
  final repo = ref.watch(bibleRepositoryProvider);
  return repo.getAllBookProgresses(versionId);
});

/// StateProviders
final activeBibleVersionProvider = StateProvider<String>((ref) => 'NAA');
final selectedVerseKeyProvider = StateProvider<String?>((ref) => null);
final activeHymnalProvider = StateProvider<String>((ref) => 'HARPA');
final importProgressProvider = StateProvider<double>((ref) => 0.0);

/// Status da inicialização (mensagem amigável para a Splash Screen)
final initializationMessageProvider = StateProvider<String>((ref) => 'A preparar o ambiente...');

/// Novo provider para o status das referências cruzadas
final crossRefStatusProvider = StateProvider<String?>((ref) => null);

/// Provedor para o QuizGeneratorService
final quizGeneratorServiceProvider = Provider<QuizGeneratorService?>((ref) {
  final repo = ref.watch(bibleRepositoryProvider);
  return QuizGeneratorService(repo);
});
