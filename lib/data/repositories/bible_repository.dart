import '../database/daos.dart';
import '../database/mappers.dart';
import '../models/bible_verse.dart';
import '../models/study_models.dart';
import '../../logic/firebase_sync_service.dart';

class BibleRepository {
  final BibleDao bibleDao;
  FirebaseSyncService? _syncService;

  BibleRepository(this.bibleDao);

  void setSyncService(FirebaseSyncService service) {
    _syncService = service;
  }

  // --- BIBLE CONTENT ---

  Future<List<BibleVerse>> getChapter(String versionId, int bookId, int chapter) async {
    final driftVerses = await bibleDao.getChapter(versionId, bookId, chapter);
    return driftVerses.map((v) => v.toIsar()).toList();
  }

  Future<List<BibleVerse>> searchVerses(String versionId, String query) async {
    final driftVerses = await bibleDao.searchVerses(versionId, query);
    return driftVerses.map((v) => v.toIsar()).toList();
  }

  Future<void> toggleFavorite(String verseKey) async {
    await bibleDao.toggleFavorite(verseKey);

    final verse = await bibleDao.getVerseByKey(verseKey);
    if (verse != null) {
      final isarVerse = verse.toIsar();
      // Use version-agnostic canonical key for cloud sync
      final canonicalKey = '${isarVerse.bookId}_${isarVerse.chapter}_${isarVerse.verse}';
      if (isarVerse.isFavorite) {
        _syncService?.uploadFavorite(isarVerse);
      } else {
        _syncService?.removeFavoriteFromCloud(canonicalKey);
      }
    }
  }

  Future<void> setFavorite(String verseKey, bool isFavorite) async {
    await bibleDao.setFavorite(verseKey, isFavorite);

    final verse = await bibleDao.getVerseByKey(verseKey);
    if (verse != null) {
      final isarVerse = verse.toIsar();
      // Use version-agnostic canonical key for cloud sync
      final canonicalKey = '${isarVerse.bookId}_${isarVerse.chapter}_${isarVerse.verse}';
      if (isFavorite) {
        _syncService?.uploadFavorite(isarVerse);
      } else {
        _syncService?.removeFavoriteFromCloud(canonicalKey);
      }
    }
  }

  Future<void> setFavoriteByPosition(
      int bookId, int chapter, int verse, bool isFavorite) async {
    await bibleDao.setFavoriteByPosition(bookId, chapter, verse, isFavorite);
  }

  Stream<List<BibleVerse>> watchFavorites(String versionId) {
    return bibleDao.watchFavorites(versionId).map((list) => list.map((v) => v.toIsar()).toList());
  }

  Future<List<BibleVerse>> getFavoriteVerses(String versionId) async {
    final driftVerses = await bibleDao.getFavoriteVerses(versionId);
    return driftVerses.map((v) => v.toIsar()).toList();
  }

  // --- FAVORITE BLOCKS ---
  
  Future<void> saveFavoriteBlock(FavoriteBlock block) async {
    await bibleDao.saveFavoriteBlock(block.toCompanion());
    _syncService?.uploadFavoriteBlock(block);
  }

  Future<List<FavoriteBlock>> getAllFavoriteBlocks(String versionId) async {
    final driftBlocks = await bibleDao.getAllFavoriteBlocks(versionId);
    return driftBlocks.map((b) => b.toIsar()).toList();
  }

  Stream<List<FavoriteBlock>> watchFavoriteBlocks(String versionId) {
    return bibleDao.watchFavoriteBlocks(versionId).map((list) => list.map((b) => b.toIsar()).toList());
  }

  Future<void> deleteFavoriteBlock(int id) async {
    final block = await bibleDao.getFavoriteBlock(id);
    if (block != null) {
      final isarBlock = block.toIsar();
      await bibleDao.deleteFavoriteBlock(id);
      _syncService?.removeFavoriteBlockFromCloud(isarBlock.blockKey);
    }
  }

  Future<void> markChapterAsRead(String versionId, int bookId, int chapter, bool isRead) async {
    await bibleDao.markChapterAsRead(versionId, bookId, chapter, isRead);
    
    // Use version-agnostic canonical key for cloud sync
    final chapterKey = '${bookId}_$chapter';
    if (isRead) {
      _syncService?.uploadReadingProgress(chapterKey);
    } else {
      _syncService?.removeReadingProgressFromCloud(chapterKey);
    }
  }

  Future<void> markChapterReadByPosition(
      int bookId, int chapter, bool isRead) async {
    await bibleDao.markChapterReadByPosition(bookId, chapter, isRead);
  }

  Future<void> markAsRead(String verseKey, bool isRead) async {
    await bibleDao.markAsRead(verseKey, isRead);
  }

  Future<bool> isChapterFullyRead(String versionId, int bookId, int chapter) async {
    return await bibleDao.isChapterFullyRead(versionId, bookId, chapter);
  }

  Future<double> getBookProgress(String versionId, int bookId) async {
    return await bibleDao.getBookProgress(versionId, bookId);
  }

  Future<Map<int, double>> getAllBookProgresses(String versionId) async {
    return await bibleDao.getAllBookProgresses(versionId);
  }

  Future<Map<int, bool>> getBookChapterStatuses(String versionId, int bookId) async {
    return await bibleDao.getBookChapterStatuses(versionId, bookId);
  }

  Future<BibleVerse?> getVerseByKey(String verseKey) async {
    final driftVerse = await bibleDao.getVerseByKey(verseKey);
    if (driftVerse != null) {
      return driftVerse.toIsar();
    }

    final parsed = _parseVerseKey(verseKey);
    if (parsed == null) {
      return null;
    }

    final fallback = await bibleDao.getVerseByPosition(
      parsed.bookId,
      parsed.chapter,
      parsed.verse,
      preferredVersionId: parsed.versionId,
    );

    return fallback?.toIsar();
  }

  _ParsedVerseKey? _parseVerseKey(String verseKey) {
    final parts = verseKey.split('_');

    if (parts.length == 4) {
      final bookId = int.tryParse(parts[1]);
      final chapter = int.tryParse(parts[2]);
      final verse = int.tryParse(parts[3]);

      if (bookId == null || chapter == null || verse == null) {
        return null;
      }

      return _ParsedVerseKey(
        versionId: parts[0],
        bookId: bookId,
        chapter: chapter,
        verse: verse,
      );
    }

    if (parts.length == 3) {
      final bookId = int.tryParse(parts[0]);
      final chapter = int.tryParse(parts[1]);
      final verse = int.tryParse(parts[2]);

      if (bookId == null || chapter == null || verse == null) {
        return null;
      }

      return _ParsedVerseKey(
        versionId: null,
        bookId: bookId,
        chapter: chapter,
        verse: verse,
      );
    }

    return null;
  }

  String _canonicalVerseKeyFromAny(String verseKey) {
    final parsed = _parseVerseKey(verseKey);
    if (parsed == null) return verseKey;
    return '${parsed.bookId}_${parsed.chapter}_${parsed.verse}';
  }

  Future<List<String>> _noteLookupKeys(String verseKey) async {
    final parsed = _parseVerseKey(verseKey);
    if (parsed == null) {
      return [verseKey];
    }

    final canonical = '${parsed.bookId}_${parsed.chapter}_${parsed.verse}';
    final keys = <String>{canonical};

    final importedVersions = await bibleDao.getImportedVersions();
    for (final version in importedVersions) {
      keys.add('${version}_${parsed.bookId}_${parsed.chapter}_${parsed.verse}');
    }

    if (parsed.versionId != null) {
      keys.add('${parsed.versionId}_${parsed.bookId}_${parsed.chapter}_${parsed.verse}');
    }

    return keys.toList();
  }

  Future<void> updateHighlightColor(String verseKey, int? color) async {
    await bibleDao.updateHighlightColor(verseKey, color);
  }

  Future<List<String>> getImportedVersions() async {
    return await bibleDao.getImportedVersions();
  }

  Future<bool> isVersionImported(String versionId) async {
    return await bibleDao.isVersionImported(versionId);
  }

  Future<void> deleteVersion(String versionId) async {
    if (versionId == 'NAA') {
      throw StateError('A versão padrão NAA não pode ser desinstalada.');
    }
    await bibleDao.deleteVersion(versionId);
  }

  // --- STUDY SYSTEM (NOTES / DEVOCIONAIS) ---

  Stream<UserNote?> watchNote(String verseKey) {
    final parsed = _parseVerseKey(verseKey);
    if (parsed == null) {
      return bibleDao.watchNote(verseKey).map((n) => n?.toIsar());
    }

    final canonical = '${parsed.bookId}_${parsed.chapter}_${parsed.verse}';
    return bibleDao.watchNoteByKeys([canonical, verseKey]).map((n) => n?.toIsar());
  }

  Future<UserNote?> getNoteSync(String verseKey) async {
    final keys = await _noteLookupKeys(verseKey);
    final driftNote = await bibleDao.getNoteSyncByKeys(keys);
    return driftNote?.toIsar();
  }

  Future<void> saveNote(String verseKey, String content, {String? title}) async {
    final canonicalKey = _canonicalVerseKeyFromAny(verseKey);
    final legacyKeys = await _noteLookupKeys(verseKey);
    await bibleDao.deleteNotesByKeys(legacyKeys.where((k) => k != canonicalKey).toList());

    await bibleDao.saveNote(canonicalKey, content, title: title);
    final note = await bibleDao.getNoteSync(canonicalKey);
    if (note != null) {
      _syncService?.uploadNote(note.toIsar());
    }
  }

  Future<void> deleteNote(String verseKey) async {
    final keys = await _noteLookupKeys(verseKey);
    await bibleDao.deleteNotesByKeys(keys);

    for (final key in keys) {
      _syncService?.removeNoteFromCloud(key);
    }
  }

  Future<void> migrateVerseAnchoredData() async {
    await bibleDao.normalizeFavoritesAcrossVersions();
    await bibleDao.normalizeReadProgressAcrossVersions();
    await bibleDao.migrateNotesToCanonicalKeys();
  }

  Future<bool> isVerseAnchoredMigrationDone() async {
    return bibleDao.isVerseAnchoredMigrationDone();
  }

  Future<void> setVerseAnchoredMigrationDone(bool done) async {
    await bibleDao.setVerseAnchoredMigrationDone(done);
  }

  Future<void> propagateFavoritesToVersion(String versionId) async {
    await bibleDao.propagateFavoritesToVersion(versionId);
  }

  Future<void> clearBookProgress(int bookId) async {
    await bibleDao.clearBookProgress(bookId);
  }

  Future<void> clearAllProgress() async {
    await bibleDao.clearAllProgress();
  }

  Future<List<UserNote>> getAllNotes() async {
    final driftNotes = await bibleDao.getAllNotes();
    return driftNotes.map((n) => n.toIsar()).toList();
  }

  // --- STUDY SYSTEM (CROSS REFERENCES & REFLECTIONS) ---

  Future<List<BibleVerse>> getCrossReferences(String sourceKey, {String? preferredVersionId}) async {
    final Set<String> candidateKeys = {sourceKey};
    final parsed = _parseVerseKey(sourceKey);
    final resolvedPreferredVersion = preferredVersionId ?? parsed?.versionId;

    if (parsed != null) {
      final importedVersions = await bibleDao.getImportedVersions();
      for (final version in importedVersions) {
        candidateKeys.add('${version}_${parsed.bookId}_${parsed.chapter}_${parsed.verse}');
      }

      // Keep a canonical fallback because cross-reference assets are keyed as ACF.
      candidateKeys.add('ACF_${parsed.bookId}_${parsed.chapter}_${parsed.verse}');
      candidateKeys.add('NAA_${parsed.bookId}_${parsed.chapter}_${parsed.verse}');
    }

    final Set<String> targetKeys = {};
    for (final key in candidateKeys) {
      final refs = await bibleDao.getCrossReferences(key);
      for (final ref in refs) {
        targetKeys.add(ref.targetKey);
      }
    }

    final List<BibleVerse> targetVerses = [];
    final Set<String> seenVerseKeys = {};
    for (final targetKey in targetKeys) {
      final parsedTarget = _parseVerseKey(targetKey);
      final target = parsedTarget != null
          ? (await bibleDao.getVerseByPosition(
              parsedTarget.bookId,
              parsedTarget.chapter,
              parsedTarget.verse,
              preferredVersionId: resolvedPreferredVersion,
            ))
              ?.toIsar()
          : await getVerseByKey(targetKey);

      if (target != null && seenVerseKeys.add(target.verseKey)) {
        targetVerses.add(target);
      }
    }

    return targetVerses;
  }

  Future<int> getCrossReferenceCount() async {
    return await bibleDao.countCrossReferences();
  }

  Stream<List<Reflection>> watchReflections(String versionId, int bookId, int chapter) {
    final chapterKey = '${versionId}_${bookId}_$chapter';
    return bibleDao.watchReflections(chapterKey).map((list) => list.map((r) => r.toIsar()).toList());
  }

  // --- SETTINGS & THEMES ---

  Future<void> saveLastPosition(String version, int bookId, int chapter) async {
    await bibleDao.saveLastPosition(version, bookId, chapter);
  }

  Future<void> updateReadingTheme(String theme) async {
    await bibleDao.updateReadingTheme(theme);
  }

  Stream<String> watchReadingTheme() {
    return bibleDao.watchReadingTheme();
  }

  Future<AppSettings> getSettings() async {
    final driftSettings = await bibleDao.getSettings();
    if (driftSettings != null) {
      return AppSettings()
        ..lastVersion = driftSettings.lastVersion
        ..lastBookId = driftSettings.lastBookId
        ..lastChapter = driftSettings.lastChapter
        ..readingTheme = driftSettings.readingTheme
        ..lastRoute = driftSettings.lastRoute;
    }
    return AppSettings();
  }

  Future<BibleVerse?> getRandomVerse(String versionId) async {
    final driftVerse = await bibleDao.getRandomVerse(versionId);
    return driftVerse?.toIsar();
  }

  Future<List<String>> getReadChapterKeys() async {
    return await bibleDao.getReadChapterKeys();
  }
}

class _ParsedVerseKey {
  final String? versionId;
  final int bookId;
  final int chapter;
  final int verse;

  const _ParsedVerseKey({
    required this.versionId,
    required this.bookId,
    required this.chapter,
    required this.verse,
  });
}
