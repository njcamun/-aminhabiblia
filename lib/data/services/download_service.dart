import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import '../database/daos.dart';
import '../models/hymn.dart';

class DownloadService {
  final Dio _dio = Dio();
  final HymnDao hymnDao;

  DownloadService(this.hymnDao);

  /// Faz o download de um hino e guarda o path local no banco de dados
  Future<void> downloadHymn(Hymn hymn, Function(double) onProgress) async {
    if (hymn.audioUrl == null || !_isLikelyDirectAudioUrl(hymn.audioUrl!)) {
      throw Exception("URL de áudio não é direta/reproduzível para download.");
    }

    try {
      final dir = await getApplicationDocumentsDirectory();
      final String fileName = "${hymn.category}_${hymn.number}.mp3";
      final String savePath = "${dir.path}/audios/$fileName";

      // Criar diretório se não existir
      await Directory("${dir.path}/audios").create(recursive: true);

      await _dio.download(
        hymn.audioUrl!,
        savePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            onProgress(received / total);
          }
        },
      );

      // Atualizar o path local no banco de dados
      await hymnDao.updateHymnPath(hymn.id, savePath);
      hymn.localPath = savePath;
    } catch (e) {
      throw Exception("Erro ao baixar áudio: $e");
    }
  }

  bool _isLikelyDirectAudioUrl(String url) {
    final lower = url.toLowerCase();
    if (lower.contains('soundcloud.com/search/')) return false;
    if (lower.contains('novocantico.com.br/hino/') && lower.endsWith('.mp3')) return false;
    return lower.endsWith('.mp3') ||
        lower.endsWith('.m4a') ||
        lower.endsWith('.aac') ||
        lower.endsWith('.ogg') ||
        lower.endsWith('.wav');
  }

  /// Remove o áudio local
  Future<void> deleteDownloadedAudio(Hymn hymn) async {
    if (hymn.localPath != null) {
      final file = File(hymn.localPath!);
      if (await file.exists()) {
        await file.delete();
      }
      await hymnDao.updateHymnPath(hymn.id, null);
      hymn.localPath = null;
    }
  }
}
