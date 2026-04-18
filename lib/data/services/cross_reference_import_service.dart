import 'dart:convert';
import 'package:flutter/services.dart';
import '../database/daos.dart';
import '../database/database.dart';

class CrossReferenceImportService {
  final BibleDao bibleDao;

  CrossReferenceImportService(this.bibleDao);

  static const Map<String, int> bookMap = {
    'GEN': 1, 'EXO': 2, 'LEV': 3, 'NUM': 4, 'DEU': 5,
    'JOS': 6, 'JDG': 7, 'RUT': 8, '1SA': 9, '2SA': 10,
    '1KI': 11, '2KI': 12, '1CH': 13, '2CH': 14, 'EZR': 15,
    'NEH': 16, 'EST': 17, 'JOB': 18, 'PSA': 19, 'PRO': 20,
    'ECC': 21, 'SOS': 22, 'ISA': 23, 'JER': 24, 'LAM': 25,
    'EZE': 26, 'DAN': 27, 'HOS': 28, 'JOE': 29, 'AMO': 30,
    'OBA': 31, 'JON': 32, 'MIC': 33, 'NAH': 34, 'HAB': 35,
    'ZEP': 36, 'HAG': 37, 'ZEC': 38, 'MAL': 39,
    'MAT': 40, 'MAR': 41, 'LUK': 42, 'JOH': 43, 'ACT': 44,
    'ROM': 45, '1CO': 46, '2CO': 47, 'GAL': 48, 'EPH': 49,
    'PHP': 50, 'COL': 51, '1TH': 52, '2TH': 53, '1TI': 54,
    '2TI': 55, 'TIT': 56, 'PHM': 57, 'HEB': 58, 'JAM': 59,
    '1PE': 60, '2PE': 61, '1JO': 62, '2JO': 63, '3JO': 64,
    'JDE': 65, 'REV': 66
  };

  String? _formatKey(String tskRef, String version) {
    final parts = tskRef.split(' ');
    if (parts.length < 3) return null;
    
    final bookAbbrev = parts[0];
    final chapter = parts[1];
    final verse = parts[2];
    
    final bookId = bookMap[bookAbbrev];
    if (bookId == null) return null;
    
    return '${version.trim()}_${bookId}_${chapter.trim()}_${verse.trim()}';
  }

  Future<bool> importFromNumberedAssets(String folder, int start, int end) async {
    try {
      // 1. Verificar se já existem referências para não repetir o trabalho pesado
      final count = await bibleDao.countCrossReferences();
      if (count > 50000) { 
        return true;
      }

      const version = 'ACF';
      bool anySuccess = false;

      for (int i = start; i <= end; i++) {
        try {
          final String assetPath = '$folder/$i.json';
          final String jsonString = await rootBundle.loadString(assetPath);
          final Map<String, dynamic> data = jsonDecode(jsonString);
          
          final List<CrossReferencesCompanion> companions = [];

          data.forEach((id, content) {
            final String? sourceRaw = content['v']; 
            if (sourceRaw == null) return;

            final sourceKey = _formatKey(sourceRaw, version);
            
            if (sourceKey != null && content['r'] != null) {
              final Map<String, dynamic> relations = content['r'];
              relations.forEach((relId, targetRaw) {
                final targetKey = _formatKey(targetRaw, version);
                if (targetKey != null) {
                  companions.add(
                    CrossReferencesCompanion.insert(
                      sourceVerseId: 0,
                      targetVerseId: 0,
                      sourceKey: sourceKey,
                      targetKey: targetKey,
                    )
                  );
                }
              });
            }
          });

          if (companions.isNotEmpty) {
            await bibleDao.insertCrossReferences(companions);
            anySuccess = true;
          }
        } catch (e) {
          // Silencioso para não travar a UI
        }
      }
      
      return anySuccess;
    } catch (e) {
      return false;
    }
  }

  Future<void> seedBasicReferences() async {
    final companions = [
      CrossReferencesCompanion.insert(sourceVerseId: 0, targetVerseId: 0, sourceKey: "ACF_43_3_16", targetKey: "ACF_45_5_8"),
      CrossReferencesCompanion.insert(sourceVerseId: 0, targetVerseId: 0, sourceKey: "ACF_1_1_1", targetKey: "ACF_43_1_1"),
    ];
    await bibleDao.insertCrossReferences(companions);
  }
}
