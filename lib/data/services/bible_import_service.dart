import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:drift/drift.dart';
import '../database/daos.dart';
import '../database/database.dart';

List<Map<String, Object>> _flattenBibleJson(String jsonString) {
  final List<dynamic> booksJson = jsonDecode(jsonString) as List<dynamic>;
  final List<Map<String, Object>> rows = <Map<String, Object>>[];

  for (int b = 0; b < booksJson.length; b++) {
    final book = booksJson[b] as Map<String, dynamic>;
    final String bookName = (book['name'] ?? '').toString();
    final List<dynamic> chapters = (book['chapters'] ?? <dynamic>[]) as List<dynamic>;

    for (int c = 0; c < chapters.length; c++) {
      final List<dynamic> verses = chapters[c] as List<dynamic>;
      for (int v = 0; v < verses.length; v++) {
        rows.add(<String, Object>{
          'bookId': b + 1,
          'bookName': bookName,
          'chapter': c + 1,
          'verse': v + 1,
          'text': verses[v].toString(),
        });
      }
    }
  }

  return rows;
}

class BibleImportService {
  final BibleDao bibleDao;

  BibleImportService(this.bibleDao);

  Future<void> importFromJsonString(
    String versionId,
    String jsonString, {
    bool force = false,
    Function(double)? onProgress,
  }) async {
    await _importFromJsonContent(
      versionId,
      jsonString,
      force: force,
      onProgress: onProgress,
    );
  }

  Future<void> importFromJson(
    String versionId, 
    String assetPath, 
    {bool force = false, Function(double)? onProgress}
  ) async {
    final String jsonString = await rootBundle.loadString(assetPath);
    await _importFromJsonContent(
      versionId,
      jsonString,
      force: force,
      onProgress: onProgress,
    );
  }

  Future<void> _importFromJsonContent(
    String versionId,
    String jsonString, {
    bool force = false,
    Function(double)? onProgress,
  }) async {
    try {
      final isImported = await bibleDao.isVersionImported(versionId);
      
      if (isImported) {
        if (force) {
          await bibleDao.deleteVersion(versionId);
        } else {
          onProgress?.call(1.0);
          return;
        }
      }

      // 1. Parsear fora da UI isolate para reduzir frame drops no primeiro arranque.
      final List<Map<String, Object>> flattenedRows = await compute(
        _flattenBibleJson,
        jsonString,
      );

      // 2. Inserir em lotes menores para manter responsividade.
      final List<BibleVersesCompanion> batch = [];
      const int batchSize = 4000;
      final int totalRows = flattenedRows.length;

      for (int i = 0; i < totalRows; i++) {
        final row = flattenedRows[i];
        final int bookId = row['bookId']! as int;
        final int chapterNum = row['chapter']! as int;
        final int verseNum = row['verse']! as int;

        batch.add(BibleVersesCompanion.insert(
          versionId: versionId,
          bookId: bookId,
          bookName: row['bookName']! as String,
          chapter: chapterNum,
          verse: verseNum,
          verseText: row['text']! as String,
          verseKey: '${versionId}_${bookId}_${chapterNum}_$verseNum',
          isFavorite: const Value(false),
          isRead: const Value(false),
        ));

        if (batch.length >= batchSize) {
          await bibleDao.insertVerses(batch);
          batch.clear();
          await Future<void>.delayed(Duration.zero);
        }

        if (i % 1200 == 0) {
          onProgress?.call(i / totalRows);
        }
      }

      // 3. Inserir o resto
      if (batch.isNotEmpty) {
        await bibleDao.insertVerses(batch);
      }

      // Keep favorites version-agnostic even for newly installed versions.
      await bibleDao.propagateFavoritesToVersion(versionId);

      // Keep reading progress version-agnostic for newly installed versions.
      await bibleDao.propagateReadProgressToVersion(versionId);
      
      onProgress?.call(1.0);
    } catch (e) {
      debugPrint('Erro crítico ao importar Bíblia ($versionId): $e');
    }
  }
}
