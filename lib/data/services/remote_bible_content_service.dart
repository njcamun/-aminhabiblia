import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class BibleVersionCatalogItem {
  final String id;
  final String name;
  final String storagePath;
  final int? sizeBytes;

  const BibleVersionCatalogItem({
    required this.id,
    required this.name,
    required this.storagePath,
    this.sizeBytes,
  });
}

class RemoteBibleContentService {
  static const String _catalogCollection = 'bible_versions';
  static const Map<String, BibleVersionCatalogItem> _fallbackCatalog = {
    'ACF': BibleVersionCatalogItem(
      id: 'ACF',
      name: 'Almeida Corrigida Fiel',
      storagePath: 'bibles/ACF.json',
      sizeBytes: 3993954,
    ),
    'ARA': BibleVersionCatalogItem(
      id: 'ARA',
      name: 'Almeida Revista e Atualizada',
      storagePath: 'bibles/ARA.json',
      sizeBytes: 3956092,
    ),
    'ARC': BibleVersionCatalogItem(
      id: 'ARC',
      name: 'Almeida Revista e Corrigida',
      storagePath: 'bibles/ARC.json',
      sizeBytes: 3993142,
    ),
    'KJF': BibleVersionCatalogItem(
      id: 'KJF',
      name: 'King James Faithful',
      storagePath: 'bibles/KJF.json',
      sizeBytes: 4146402,
    ),
    'NVI': BibleVersionCatalogItem(
      id: 'NVI',
      name: 'Nova Versão Internacional',
      storagePath: 'bibles/NVI.json',
      sizeBytes: 4010291,
    ),
    'NVT': BibleVersionCatalogItem(
      id: 'NVT',
      name: 'Nova Versão Transformadora',
      storagePath: 'bibles/NVT.json',
      sizeBytes: 4087414,
    ),
    'NTLH': BibleVersionCatalogItem(
      id: 'NTLH',
      name: 'Nova Tradução na Linguagem de Hoje',
      storagePath: 'bibles/NTLH.json',
      sizeBytes: 4739210,
    ),
  };

  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;

  RemoteBibleContentService({
    FirebaseFirestore? firestore,
    FirebaseStorage? storage,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _storage = storage ?? FirebaseStorage.instance;

  Future<BibleVersionCatalogItem> getBibleVersionCatalogItem(String versionId) async {
    try {
      final doc = await _firestore.collection(_catalogCollection).doc(versionId).get();

      if (doc.exists && doc.data() != null) {
        final data = doc.data()!;
        return BibleVersionCatalogItem(
          id: versionId,
          name: (data['name'] as String?) ?? versionId,
          storagePath: (data['storagePath'] as String?) ?? 'bibles/$versionId.json',
          sizeBytes: data['sizeBytes'] as int?,
        );
      }
    } catch (_) {
      // Fallback local mantém a app funcional se catálogo remoto não estiver pronto.
    }

    return _fallbackCatalog[versionId] ??
        BibleVersionCatalogItem(
          id: versionId,
          name: versionId,
          storagePath: 'bibles/$versionId.json',
        );
  }

  Future<String> downloadBibleVersionJson(
    String versionId, {
    required void Function(double progress) onProgress,
  }) async {
    final item = await getBibleVersionCatalogItem(versionId);

    final tempDir = await getTemporaryDirectory();
    final targetFile = File(p.join(tempDir.path, 'bible_${item.id}.json'));

    if (await targetFile.exists()) {
      await targetFile.delete();
    }

    final storageRef = _storage.ref(item.storagePath);
    final task = storageRef.writeToFile(targetFile);

    final StreamSubscription<TaskSnapshot> subscription = task.snapshotEvents.listen((snapshot) {
      final total = snapshot.totalBytes;
      if (total <= 0) {
        return;
      }
      final progress = snapshot.bytesTransferred / total;
      onProgress(progress.clamp(0, 1));
    });

    try {
      await task;
      onProgress(1.0);
    } finally {
      await subscription.cancel();
    }

    return targetFile.path;
  }
}
