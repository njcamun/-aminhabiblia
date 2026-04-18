import 'package:drift/drift.dart';
import 'database.dart';
import 'tables.dart';
import 'dart:convert';

part 'daos.g.dart';

@DriftAccessor(tables: [
  BibleVerses,
  FavoriteBlocks,
  UserNotes,
  CrossReferences,
  Reflections,
  AppSettingsTable,
])
class BibleDao extends DatabaseAccessor<AppDatabase> with _$BibleDaoMixin {
  BibleDao(super.db);

  String? _canonicalVerseKeyFromAny(String verseKey) {
    final parts = verseKey.split('_');

    if (parts.length == 4) {
      final bookId = int.tryParse(parts[1]);
      final chapter = int.tryParse(parts[2]);
      final verse = int.tryParse(parts[3]);
      if (bookId == null || chapter == null || verse == null) {
        return null;
      }
      return '${bookId}_${chapter}_$verse';
    }

    if (parts.length == 3) {
      final bookId = int.tryParse(parts[0]);
      final chapter = int.tryParse(parts[1]);
      final verse = int.tryParse(parts[2]);
      if (bookId == null || chapter == null || verse == null) {
        return null;
      }
      return '${bookId}_${chapter}_$verse';
    }

    return null;
  }

  // Bible Content
  Future<List<DriftBibleVerse>> getChapter(
      String versionId, int bookId, int chapter) {
    return (select(bibleVerses)
          ..where((t) =>
              t.versionId.equals(versionId) &
              t.bookId.equals(bookId) &
              t.chapter.equals(chapter))
          ..orderBy([(t) => OrderingTerm.asc(t.verse)]))
        .get();
  }

  Future<List<DriftBibleVerse>> searchVerses(String versionId, String query) {
    return (select(bibleVerses)
          ..where((t) =>
              t.versionId.equals(versionId) & t.verseText.contains(query)))
        .get();
  }

  Future<void> toggleFavorite(String verseKey) async {
    final verse = await getVerseByKey(verseKey);
    if (verse != null) {
      // Toggle across ALL imported versions so favorites are version-agnostic
      await (update(bibleVerses)
            ..where((t) =>
                t.bookId.equals(verse.bookId) &
                t.chapter.equals(verse.chapter) &
                t.verse.equals(verse.verse)))
          .write(BibleVersesCompanion(isFavorite: Value(!verse.isFavorite)));
    }
  }

  Future<void> setFavorite(String verseKey, bool isFavorite) async {
    final verse = await getVerseByKey(verseKey);
    if (verse != null) {
      // Update ALL imported versions so favorites are version-agnostic
      await (update(bibleVerses)
            ..where((t) =>
                t.bookId.equals(verse.bookId) &
                t.chapter.equals(verse.chapter) &
                t.verse.equals(verse.verse)))
          .write(BibleVersesCompanion(isFavorite: Value(isFavorite)));
    }
  }

  Future<void> setFavoriteByPosition(
      int bookId, int chapter, int verse, bool isFavorite) async {
    await (update(bibleVerses)
          ..where((t) =>
              t.bookId.equals(bookId) &
              t.chapter.equals(chapter) &
              t.verse.equals(verse)))
        .write(BibleVersesCompanion(isFavorite: Value(isFavorite)));
  }

  Stream<List<DriftBibleVerse>> watchFavorites(String versionId) {
    return (select(bibleVerses)
          ..where(
              (t) => t.versionId.equals(versionId) & t.isFavorite.equals(true)))
        .watch();
  }

  Future<List<DriftBibleVerse>> getFavoriteVerses(String versionId) {
    return (select(bibleVerses)
          ..where(
              (t) => t.versionId.equals(versionId) & t.isFavorite.equals(true)))
        .get();
  }

  // Favorite Blocks
  Future<void> saveFavoriteBlock(FavoriteBlocksCompanion companion) {
    return into(favoriteBlocks)
        .insert(companion, mode: InsertMode.insertOrReplace);
  }

  Future<List<DriftFavoriteBlock>> getAllFavoriteBlocks(String versionId) {
    return (select(favoriteBlocks)
          ..where((t) => t.versionId.equals(versionId))
          ..orderBy([(t) => OrderingTerm.desc(t.timestamp)]))
        .get();
  }

  Future<DriftFavoriteBlock?> getFavoriteBlock(int id) {
    return (select(favoriteBlocks)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
  }

  Future<void> deleteFavoriteBlock(int id) {
    return (delete(favoriteBlocks)..where((t) => t.id.equals(id))).go();
  }

  Stream<List<DriftFavoriteBlock>> watchFavoriteBlocks(String versionId) {
    return (select(favoriteBlocks)
          ..where((t) => t.versionId.equals(versionId))
          ..orderBy([(t) => OrderingTerm.desc(t.timestamp)]))
        .watch();
  }

  // Reading Progress
  Future<void> markChapterAsRead(
      String versionId, int bookId, int chapter, bool isRead) async {
    // Mark across ALL imported versions so reading progress is version-agnostic
    await (update(bibleVerses)
          ..where((t) => t.bookId.equals(bookId) & t.chapter.equals(chapter)))
        .write(BibleVersesCompanion(isRead: Value(isRead)));
  }

  Future<void> markChapterReadByPosition(
      int bookId, int chapter, bool isRead) async {
    await (update(bibleVerses)
          ..where((t) => t.bookId.equals(bookId) & t.chapter.equals(chapter)))
        .write(BibleVersesCompanion(isRead: Value(isRead)));
  }

  Future<void> markAsRead(String verseKey, bool isRead) async {
    await (update(bibleVerses)..where((t) => t.verseKey.equals(verseKey)))
        .write(BibleVersesCompanion(isRead: Value(isRead)));
  }

  Future<bool> isChapterFullyRead(
      String versionId, int bookId, int chapter) async {
    final verses = await (select(bibleVerses)
          ..where((t) =>
              t.versionId.equals(versionId) &
              t.bookId.equals(bookId) &
              t.chapter.equals(chapter)))
        .get();
    if (verses.isEmpty) return false;
    return verses.every((v) => v.isRead);
  }

  Future<double> getBookProgress(String versionId, int bookId) async {
    final verses = await (select(bibleVerses)
          ..where(
              (t) => t.versionId.equals(versionId) & t.bookId.equals(bookId)))
        .get();
    if (verses.isEmpty) return 0.0;
    final readCount = verses.where((v) => v.isRead).length;
    return readCount / verses.length;
  }

  Future<Map<int, double>> getAllBookProgresses(String versionId) async {
    final query = selectOnly(bibleVerses)
      ..addColumns([bibleVerses.bookId, bibleVerses.isRead])
      ..where(bibleVerses.versionId.equals(versionId));
    final result = await query.get();
    final Map<int, int> totalVerses = {};
    final Map<int, int> readVerses = {};
    for (var row in result) {
      final bookId = row.read(bibleVerses.bookId)!;
      totalVerses[bookId] = (totalVerses[bookId] ?? 0) + 1;
      if (row.read(bibleVerses.isRead)!) {
        readVerses[bookId] = (readVerses[bookId] ?? 0) + 1;
      }
    }
    return totalVerses.map(
        (bookId, total) => MapEntry(bookId, (readVerses[bookId] ?? 0) / total));
  }

  Future<void> clearBookProgress(int bookId) async {
    await (update(bibleVerses)..where((t) => t.bookId.equals(bookId)))
        .write(const BibleVersesCompanion(isRead: Value(false)));
  }

  Future<void> clearAllProgress() async {
    await (update(bibleVerses))
        .write(const BibleVersesCompanion(isRead: Value(false)));
  }

  Future<Map<int, bool>> getBookChapterStatuses(
      String versionId, int bookId) async {
    final query = selectOnly(bibleVerses)
      ..addColumns([bibleVerses.chapter, bibleVerses.isRead])
      ..where(bibleVerses.versionId.equals(versionId) &
          bibleVerses.bookId.equals(bookId));
    final result = await query.get();
    final Map<int, bool> statuses = {};
    for (var row in result) {
      final chapter = row.read(bibleVerses.chapter)!;
      final isRead = row.read(bibleVerses.isRead)!;
      statuses[chapter] = (statuses[chapter] ?? true) && isRead;
    }
    return statuses;
  }

  Future<DriftBibleVerse?> getVerseByKey(String verseKey) {
    return (select(bibleVerses)..where((t) => t.verseKey.equals(verseKey)))
        .getSingleOrNull();
  }

  Future<DriftBibleVerse?> getVerseByPosition(
    int bookId,
    int chapter,
    int verse, {
    String? preferredVersionId,
  }) async {
    final verses = await (select(bibleVerses)
          ..where((t) =>
              t.bookId.equals(bookId) &
              t.chapter.equals(chapter) &
              t.verse.equals(verse)))
        .get();

    if (verses.isEmpty) return null;

    if (preferredVersionId != null) {
      for (final v in verses) {
        if (v.versionId == preferredVersionId) {
          return v;
        }
      }
    }

    for (final v in verses) {
      if (v.versionId == 'NAA') {
        return v;
      }
    }

    return verses.first;
  }

  Future<void> updateHighlightColor(String verseKey, int? color) async {
    await (update(bibleVerses)..where((t) => t.verseKey.equals(verseKey)))
        .write(BibleVersesCompanion(highlightColor: Value(color)));
  }

  Future<List<String>> getImportedVersions() async {
    final query = selectOnly(bibleVerses, distinct: true)
      ..addColumns([bibleVerses.versionId]);
    final result = await query.get();
    return result.map((row) => row.read(bibleVerses.versionId)!).toList();
  }

  Future<bool> isVersionImported(String versionId) async {
    final result = await (select(bibleVerses)
          ..where((t) => t.versionId.equals(versionId))
          ..limit(1))
        .getSingleOrNull();
    return result != null;
  }

  Future<int> countVerses(String versionId) async {
    final query = selectOnly(bibleVerses)..addColumns([bibleVerses.id.count()]);
    query.where(bibleVerses.versionId.equals(versionId));
    final result = await query
        .map((row) => row.read(bibleVerses.id.count()) ?? 0)
        .getSingle();
    return result;
  }

  Future<void> deleteVersion(String versionId) {
    if (versionId == 'NAA') {
      throw StateError('A versão padrão NAA não pode ser desinstalada.');
    }
    return (delete(bibleVerses)..where((t) => t.versionId.equals(versionId)))
        .go();
  }

  // Notes
  Stream<DriftUserNote?> watchNote(String verseKey) {
    return (select(userNotes)..where((t) => t.verseKey.equals(verseKey)))
        .watchSingleOrNull();
  }

  Future<DriftUserNote?> getNoteSync(String verseKey) {
    return (select(userNotes)..where((t) => t.verseKey.equals(verseKey)))
        .getSingleOrNull();
  }

  Stream<DriftUserNote?> watchNoteByKeys(List<String> keys) {
    if (keys.isEmpty) {
      return Stream.value(null);
    }

    return (select(userNotes)..where((t) => t.verseKey.isIn(keys)))
        .watch()
        .map((rows) {
      if (rows.isEmpty) return null;
      rows.sort((a, b) =>
          keys.indexOf(a.verseKey).compareTo(keys.indexOf(b.verseKey)));
      return rows.first;
    });
  }

  Future<DriftUserNote?> getNoteSyncByKeys(List<String> keys) async {
    if (keys.isEmpty) return null;

    final rows =
        await (select(userNotes)..where((t) => t.verseKey.isIn(keys))).get();
    if (rows.isEmpty) return null;
    rows.sort(
        (a, b) => keys.indexOf(a.verseKey).compareTo(keys.indexOf(b.verseKey)));
    return rows.first;
  }

  Future<void> saveNote(String verseKey, String content,
      {String? title}) async {
    final existing = await getNoteSync(verseKey);
    if (existing != null) {
      await update(userNotes).replace(UserNotesCompanion(
        id: Value(existing.id),
        title: Value(title),
        content: Value(content),
        // Preserve original date to behave as creation date in devotional UI
        lastModified: Value(existing.lastModified),
        tags: Value(existing.tags),
        verseId: Value(existing.verseId),
        verseKey: Value(existing.verseKey),
      ));
    } else {
      await into(userNotes).insert(UserNotesCompanion.insert(
        verseKey: verseKey,
        title: Value(title),
        content: content,
        lastModified: DateTime.now(),
        tags: jsonEncode([]),
        verseId: 0,
      ));
    }
  }

  Future<void> deleteNote(String verseKey) {
    return (delete(userNotes)..where((t) => t.verseKey.equals(verseKey))).go();
  }

  Future<void> deleteNotesByKeys(List<String> keys) async {
    if (keys.isEmpty) return;
    await (delete(userNotes)..where((t) => t.verseKey.isIn(keys))).go();
  }

  Future<List<DriftUserNote>> getAllNotes() {
    return select(userNotes).get();
  }

  Stream<List<DriftUserNote>> watchAllNotes() {
    return (select(userNotes)
          ..orderBy([(t) => OrderingTerm.desc(t.lastModified)]))
        .watch();
  }

  // Cross References
  Future<List<DriftCrossReference>> getCrossReferences(String sourceKey) {
    return (select(crossReferences)
          ..where((t) => t.sourceKey.equals(sourceKey)))
        .get();
  }

  // Reflections
  Stream<List<DriftReflection>> watchReflections(String chapterKey) {
    return (select(reflections)
          ..where((t) => t.associatedChapterKey.equals(chapterKey))
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .watch();
  }

  // Settings
  Future<void> saveLastPosition(String version, int bookId, int chapter) async {
    final existing = await select(appSettingsTable).getSingleOrNull();
    if (existing != null) {
      await update(appSettingsTable).replace(AppSettingsTableCompanion(
        id: Value(existing.id),
        lastVersion: Value(version),
        lastBookId: Value(bookId),
        lastChapter: Value(chapter),
      ));
    } else {
      await into(appSettingsTable).insert(AppSettingsTableCompanion.insert(
        lastVersion: version,
        lastBookId: Value(bookId),
        lastChapter: Value(chapter),
      ));
    }
  }

  Future<void> updateReadingTheme(String theme) async {
    final existing = await select(appSettingsTable).getSingleOrNull();
    if (existing != null) {
      await update(appSettingsTable).replace(AppSettingsTableCompanion(
        id: Value(existing.id),
        readingTheme: Value(theme),
      ));
    } else {
      await into(appSettingsTable).insert(AppSettingsTableCompanion.insert(
        lastVersion: 'ARC', // Default
        readingTheme: Value(theme),
      ));
    }
  }

  Stream<String> watchReadingTheme() {
    return select(appSettingsTable)
        .watchSingleOrNull()
        .map((settings) => settings?.readingTheme ?? 'light');
  }

  Future<DriftAppSettings?> getSettings() {
    return select(appSettingsTable).getSingleOrNull();
  }

  Future<bool> isVerseAnchoredMigrationDone() async {
    final settings = await getSettings();
    return settings?.migrationDone ?? false;
  }

  Future<void> setVerseAnchoredMigrationDone(bool done) async {
    final existing = await getSettings();
    if (existing != null) {
      await (update(appSettingsTable)..where((t) => t.id.equals(existing.id)))
          .write(
        AppSettingsTableCompanion(migrationDone: Value(done)),
      );
      return;
    }

    await into(appSettingsTable).insert(
      AppSettingsTableCompanion.insert(
        lastVersion: 'NAA',
        migrationDone: Value(done),
      ),
    );
  }

  Future<DriftBibleVerse?> getRandomVerse(String versionId) async {
    final query = select(bibleVerses)
      ..where((t) => t.versionId.equals(versionId))
      ..orderBy([(t) => OrderingTerm.random()])
      ..limit(1);
    return query.getSingleOrNull();
  }

  Future<List<String>> getReadChapterKeys() async {
    // Return version-agnostic keys (bookId_chapter) to avoid duplicates
    final query = selectOnly(bibleVerses, distinct: true)
      ..addColumns([bibleVerses.bookId, bibleVerses.chapter])
      ..where(bibleVerses.isRead.equals(true));
    final result = await query.get();
    final Set<String> keys = {};
    for (var row in result) {
      final bId = row.read(bibleVerses.bookId);
      final cId = row.read(bibleVerses.chapter);
      keys.add('${bId}_$cId');
    }
    return keys.toList();
  }

  Future<int> countCrossReferences() async {
    final countExp = crossReferences.id.count();
    final query = selectOnly(crossReferences)..addColumns([countExp]);
    final result = await query.getSingle();
    return result.read(countExp) ?? 0;
  }

  Future<bool> hasAnyCrossReference() async {
    final row = await (select(crossReferences)..limit(1)).getSingleOrNull();
    return row != null;
  }

  Future<void> propagateFavoritesToVersion(String versionId) async {
    await customStatement(
      '''
      UPDATE bible_verses AS target
      SET is_favorite = 1
      WHERE target.version_id = ?
        AND EXISTS (
          SELECT 1
          FROM bible_verses AS src
          WHERE src.book_id = target.book_id
            AND src.chapter = target.chapter
            AND src.verse = target.verse
            AND src.is_favorite = 1
        )
      ''',
      [versionId],
    );
  }

  Future<void> normalizeFavoritesAcrossVersions() async {
    await customStatement('''
      UPDATE bible_verses AS target
      SET is_favorite = 1
      WHERE EXISTS (
        SELECT 1
        FROM bible_verses AS src
        WHERE src.book_id = target.book_id
          AND src.chapter = target.chapter
          AND src.verse = target.verse
          AND src.is_favorite = 1
      )
    ''');
  }

  Future<void> propagateReadProgressToVersion(String versionId) async {
    await customStatement(
      '''
      UPDATE bible_verses AS target
      SET is_read = 1
      WHERE target.version_id = ?
        AND EXISTS (
          SELECT 1
          FROM bible_verses AS src
          WHERE src.book_id = target.book_id
            AND src.chapter = target.chapter
            AND src.verse = target.verse
            AND src.is_read = 1
        )
      ''',
      [versionId],
    );
  }

  Future<void> normalizeReadProgressAcrossVersions() async {
    await customStatement('''
      UPDATE bible_verses AS target
      SET is_read = 1
      WHERE EXISTS (
        SELECT 1
        FROM bible_verses AS src
        WHERE src.book_id = target.book_id
          AND src.chapter = target.chapter
          AND src.verse = target.verse
          AND src.is_read = 1
      )
    ''');
  }

  Future<void> migrateNotesToCanonicalKeys() async {
    final notes = await select(userNotes).get();
    if (notes.isEmpty) return;

    final Map<String, DriftUserNote> canonicalByKey = {
      for (final note in notes)
        if (_canonicalVerseKeyFromAny(note.verseKey) == note.verseKey)
          note.verseKey: note,
    };

    for (final note in notes) {
      final canonicalKey = _canonicalVerseKeyFromAny(note.verseKey);
      if (canonicalKey == null || canonicalKey == note.verseKey) {
        continue;
      }

      final canonicalExisting = canonicalByKey[canonicalKey];
      if (canonicalExisting == null) {
        await (update(userNotes)..where((t) => t.id.equals(note.id))).write(
          UserNotesCompanion(verseKey: Value(canonicalKey)),
        );
        canonicalByKey[canonicalKey] = note.copyWith(verseKey: canonicalKey);
        continue;
      }

      if (note.lastModified.isAfter(canonicalExisting.lastModified)) {
        await (update(userNotes)
              ..where((t) => t.id.equals(canonicalExisting.id)))
            .write(
          UserNotesCompanion(
            title: Value(note.title),
            content: Value(note.content),
            lastModified: Value(note.lastModified),
            tags: Value(note.tags),
          ),
        );

        canonicalByKey[canonicalKey] = canonicalExisting.copyWith(
          title: Value(note.title),
          content: note.content,
          lastModified: note.lastModified,
          tags: note.tags,
        );
      }

      await (delete(userNotes)..where((t) => t.id.equals(note.id))).go();
    }
  }

  // Insert methods
  Future<int> insertVerse(DriftBibleVerse verse) {
    return into(bibleVerses).insert(BibleVersesCompanion.insert(
      versionId: verse.versionId,
      bookId: verse.bookId,
      bookName: verse.bookName,
      chapter: verse.chapter,
      verse: verse.verse,
      verseText: verse.verseText,
      isFavorite: Value(verse.isFavorite),
      isRead: Value(verse.isRead),
      highlightColor: Value(verse.highlightColor),
      verseKey: verse.verseKey,
    ));
  }

  Future<void> insertVerses(List<BibleVersesCompanion> companions) {
    return batch((batch) {
      batch.insertAll(bibleVerses, companions);
    });
  }

  Future<void> insertReflection(DriftReflection reflection) {
    return into(reflections).insert(ReflectionsCompanion.insert(
      author: reflection.author,
      content: reflection.content,
      associatedChapterKey: reflection.associatedChapterKey,
      createdAt: reflection.createdAt,
    ));
  }

  Future<void> insertCrossReference(DriftCrossReference ref) {
    return into(crossReferences).insert(CrossReferencesCompanion.insert(
      sourceVerseId: ref.sourceVerseId,
      targetVerseId: ref.targetVerseId,
      sourceKey: ref.sourceKey,
      targetKey: ref.targetKey,
    ));
  }

  Future<void> insertCrossReferences(
      List<CrossReferencesCompanion> companions) {
    return batch((batch) {
      batch.insertAll(crossReferences, companions);
    });
  }
}

@DriftAccessor(tables: [Hymns])
class HymnDao extends DatabaseAccessor<AppDatabase> with _$HymnDaoMixin {
  HymnDao(super.db);

  Future<List<DriftHymn>> getHymns(String category) {
    return (select(hymns)
          ..where((t) => t.category.equals(category))
          ..orderBy([(t) => OrderingTerm.asc(t.number)]))
        .get();
  }

  Future<DriftHymn?> getHymn(String category, int number) {
    return (select(hymns)
          ..where((t) => t.category.equals(category) & t.number.equals(number)))
        .getSingleOrNull();
  }

  Future<DriftHymn?> getHymnById(int id) {
    return (select(hymns)..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  Future<List<DriftHymn>> searchHymns(String query) {
    return (select(hymns)
          ..where((t) => t.title.contains(query) | t.lyrics.contains(query)))
        .get();
  }

  Future<List<DriftHymn>> searchHymnsByCategory(String category, String query) {
    return (select(hymns)
          ..where((t) =>
              t.category.equals(category) &
              (t.title.contains(query) |
                  t.lyrics.contains(query) |
                  t.number.equals(int.tryParse(query) ?? -1))))
        .get();
  }

  Future<void> toggleFavoriteHymn(int id) async {
    final hymn = await getHymnById(id);
    if (hymn != null) {
      await (update(hymns)..where((t) => t.id.equals(id)))
          .write(HymnsCompanion(isFavorite: Value(!hymn.isFavorite)));
    }
  }

  Future<void> setFavoriteHymn(int id, bool isFavorite) async {
    await (update(hymns)..where((t) => t.id.equals(id)))
        .write(HymnsCompanion(isFavorite: Value(isFavorite)));
  }

  Future<List<DriftHymn>> getFavoriteHymns() {
    return (select(hymns)..where((t) => t.isFavorite.equals(true))).get();
  }

  Future<List<DriftHymn>> getFavoriteHymnsByCategory(String category) {
    return (select(hymns)
          ..where(
              (t) => t.category.equals(category) & t.isFavorite.equals(true))
          ..orderBy([(t) => OrderingTerm.asc(t.number)]))
        .get();
  }

  Future<int> insertHymn(DriftHymn hymn) {
    return into(hymns).insert(HymnsCompanion.insert(
      category: hymn.category,
      number: hymn.number,
      title: hymn.title,
      lyrics: hymn.lyrics,
      audioUrl: Value(hymn.audioUrl),
      localPath: Value(hymn.localPath),
      isFavorite: Value(hymn.isFavorite),
    ));
  }

  Future<void> updateHymnPath(int id, String? localPath) {
    return (update(hymns)..where((t) => t.id.equals(id)))
        .write(HymnsCompanion(localPath: Value(localPath)));
  }

  Future<void> updateHymnLyrics(int id, String lyrics) {
    return (update(hymns)..where((t) => t.id.equals(id)))
        .write(HymnsCompanion(lyrics: Value(lyrics)));
  }

  Future<int> countHymns(String category) async {
    final countExp = hymns.id.count();
    final query = selectOnly(hymns)
      ..addColumns([countExp])
      ..where(hymns.category.equals(category));
    final result = await query.getSingle();
    return result.read(countExp) ?? 0;
  }

  Future<void> batchInsertHymns(List<HymnsCompanion> companions) {
    return batch((batch) {
      batch.insertAll(hymns, companions);
    });
  }
}
