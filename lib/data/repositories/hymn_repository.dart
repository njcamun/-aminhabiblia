import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:drift/drift.dart';
import '../database/database.dart';
import '../database/daos.dart';
import '../database/mappers.dart';
import '../models/hymn.dart';
import '../../logic/firebase_sync_service.dart';

class HymnRepository {
  final HymnDao hymnDao;
  FirebaseSyncService? _syncService;

  HymnRepository(this.hymnDao);

  void setSyncService(FirebaseSyncService service) {
    _syncService = service;
  }

  // Buscar todos os hinos de um hinário específico
  Future<List<Hymn>> getHymns(String category) async {
    final driftHymns = await hymnDao.getHymns(category);
    return driftHymns.map((h) => h.toIsar()).toList();
  }

  // Buscar hinos favoritos
  Future<List<Hymn>> getFavoriteHymns(String category) async {
    final driftHymns = await hymnDao.getFavoriteHymnsByCategory(category);
    return driftHymns.map((h) => h.toIsar()).toList();
  }

  Stream<List<Hymn>> watchFavoriteHymns(String category) {
    return (hymnDao.select(hymnDao.hymns)
          ..where(
              (t) => t.category.equals(category) & t.isFavorite.equals(true))
          ..orderBy([(t) => OrderingTerm.asc(t.number)]))
        .watch()
        .map((rows) => rows.map((h) => h.toIsar()).toList());
  }

  // Buscar hinos por número, título ou letra
  Future<List<Hymn>> searchHymns(String category, String query) async {
    final driftHymns = await hymnDao.searchHymnsByCategory(category, query);
    return driftHymns.map((h) => h.toIsar()).toList();
  }

  Future<void> toggleFavorite(int id) async {
    await hymnDao.toggleFavoriteHymn(id);
    final hymn = await hymnDao.getHymnById(id);
    if (hymn != null) {
      final isarHymn = hymn.toIsar();
      if (isarHymn.isFavorite) {
        _syncService?.uploadHymnFavorite(isarHymn);
      } else {
        _syncService?.removeHymnFavoriteFromCloud(
            isarHymn.category, isarHymn.number);
      }
    }
  }

  Future<void> setFavorite(int id, bool isFavorite) async {
    await hymnDao.setFavoriteHymn(id, isFavorite);
    final hymn = await hymnDao.getHymnById(id);
    if (hymn != null) {
      final isarHymn = hymn.toIsar();
      if (isFavorite) {
        _syncService?.uploadHymnFavorite(isarHymn);
      } else {
        _syncService?.removeHymnFavoriteFromCloud(
            isarHymn.category, isarHymn.number);
      }
    }
  }

  Future<Hymn?> getHymnByNumber(String category, int number) async {
    final driftHymn = await hymnDao.getHymn(category, number);
    return driftHymn?.toIsar();
  }

  String _sanitizeLyricsArtifacts(String content) {
    final lines = content.split('\n');
    final cleanedLines = <String>[];

    for (final rawLine in lines) {
      String line = rawLine;
      line =
          line.replaceAll(RegExp(r'(?<=\S)\s+\d{1,2}(?=(\s|[.,;:!?]|$))'), '');
      line = line.replaceAll(RegExp(r'\s{2,}'), ' ').trimRight();

      if (line.trim().isEmpty || RegExp(r'^\d+$').hasMatch(line.trim())) {
        continue;
      }

      cleanedLines.add(line);
    }

    return cleanedLines.join('\n').trim();
  }

  Future<int> cleanStoredLyricsArtifacts() async {
    int updatedCount = 0;
    const categories = ['HARPA', 'NOVO_CANTICO'];

    for (final category in categories) {
      final hymns = await hymnDao.getHymns(category);
      for (final hymn in hymns) {
        final cleaned = _sanitizeLyricsArtifacts(hymn.lyrics);
        if (cleaned != hymn.lyrics) {
          await hymnDao.updateHymnLyrics(hymn.id, cleaned);
          updatedCount++;
        }
      }
    }

    return updatedCount;
  }

  // Método para importação inicial de hinos do JSON
  Future<void> initImportJson(String assetPath, String category,
      {bool force = false}) async {
    // 1. Verificação rápida (sem carregar objetos)
    final count = await hymnDao.countHymns(category);
    if (count > 0 && !force) return;

    try {
      final jsonString = await rootBundle.loadString(assetPath);
      // O jsonDecode é pesado, mas para hinários (~600 itens) é aceitável na UI thread.
      // Se fosse maior, usaríamos compute().
      final dynamic jsonData = jsonDecode(jsonString);

      final List<HymnsCompanion> companions = [];

      if (jsonData is Map) {
        jsonData.forEach((key, value) {
          if (key == "-1") return;
          final int? number = int.tryParse(key);
          if (number == null) return;

          final String fullTitle = value['hino'] ?? value['titulo'] ?? '';
          String title = fullTitle;
          if (fullTitle.contains(' - ')) {
            title = fullTitle.split(' - ').sublist(1).join(' - ');
          }

          final Map<String, dynamic>? verses = value['verses'];
          String lyrics = '';
          if (verses != null) {
            final keys = verses.keys.toList();
            // Ordenação: "1" -> "coro" -> demais
            keys.sort((a, b) {
              if (a == '1') return -1;
              if (b == '1') return 1;
              if (a == 'coro' || a == 'CORO') return -1;
              if (b == 'coro' || b == 'CORO') return 1;
              return a.compareTo(b);
            });

            for (var vKey in keys) {
              final vText = verses[vKey];
              final cleanText = vText
                  .toString()
                  .replaceAll('<br>', '\n')
                  .replaceAll('<br />', '\n');
              final marker = (vKey.toLowerCase() == 'coro') ? 'CORO' : vKey;
              lyrics += '[$marker]\n$cleanText\n\n';
            }
          }

          final sanitizedLyrics = _sanitizeLyricsArtifacts(lyrics.trim());

          companions.add(HymnsCompanion.insert(
            category: category,
            number: number,
            title: title,
            lyrics: sanitizedLyrics,
            audioUrl:
                Value(value['audio_url'] ?? value['soundcloud_search_url']),
            isFavorite: const Value(false),
          ));
        });
      }

      // Inserção em lote (batch) já otimizada no DAO
      await hymnDao.batchInsertHymns(companions);
      print("Importados $category: ${companions.length} hinos.");
    } catch (e) {
      print('Erro ao importar hinos ($category): $e');
    }
  }
}
