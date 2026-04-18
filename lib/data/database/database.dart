import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'tables.dart';
import 'daos.dart';

part 'database.g.dart';

@DriftDatabase(
  tables: [
    BibleVerses,
    Hymns,
    CrossReferences,
    UserNotes,
    Reflections,
    FavoriteBlocks,
    AppSettingsTable,
    Sermons,
    // BibleVerseFts,
    // HymnFts,
  ],
  daos: [BibleDao, HymnDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  Future<void> _createPerformanceIndexes() async {
    await customStatement('CREATE INDEX IF NOT EXISTS idx_version_id ON bible_verses(version_id)');
    await customStatement('CREATE INDEX IF NOT EXISTS idx_verse_position ON bible_verses(book_id, chapter, verse)');
    await customStatement('CREATE INDEX IF NOT EXISTS idx_verse_key ON bible_verses(verse_key)');
    await customStatement('CREATE INDEX IF NOT EXISTS idx_version_position ON bible_verses(version_id, book_id, chapter, verse)');
    await customStatement('CREATE INDEX IF NOT EXISTS idx_user_notes_verse_key ON user_notes(verse_key)');
    await customStatement('CREATE INDEX IF NOT EXISTS idx_hymn_category_number ON hymns(category, number)');
    await customStatement('CREATE INDEX IF NOT EXISTS idx_cross_ref_source_key ON cross_references(source_key)');
    await customStatement('CREATE INDEX IF NOT EXISTS idx_cross_ref_target_key ON cross_references(target_key)');
  }

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) => m.createAll(),
      onUpgrade: (Migrator m, int from, int to) async {
        // Versão 2 -> 3: Adicionar índices para otimização
        if (from < 3) {
          try {
            await _createPerformanceIndexes();
            debugPrint('DEBUG: Índices de banco de dados criados com sucesso');
          } catch (e) {
            debugPrint('AVISO: Erro ao criar índices: $e');
          }
        }
      },
      beforeOpen: (details) async {
        try {
          await _createPerformanceIndexes();
        } catch (e) {
          debugPrint('AVISO: Erro ao garantir índices: $e');
        }
      },
    );
  }
}
