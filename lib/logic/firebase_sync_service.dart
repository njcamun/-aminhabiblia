import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../data/repositories/bible_repository.dart';
import '../data/repositories/hymn_repository.dart';
import '../data/models/bible_verse.dart';
import '../data/models/hymn.dart';
import '../data/models/study_models.dart';

class FirebaseSyncService {
  final BibleRepository repository;
  final HymnRepository? hymnRepository;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  // CORREÇÃO: Removido os scopes extras que causam erro de segurança se não configurados no Cloud Console
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  bool _uploadInProgress = false;
  bool _syncInProgress = false;

  FirebaseSyncService(this.repository, {this.hymnRepository});

  String? get _uid => _auth.currentUser?.uid;
  bool get isAuthenticated => _auth.currentUser != null;
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<List<QueryDocumentSnapshot<Map<String, dynamic>>>> _legacyUserScopedDocs(
    String collection,
    String uid,
  ) async {
    try {
      final snapshot = await _firestore
          .collection(collection)
          .where('userId', isEqualTo: uid)
          .get();
      return snapshot.docs;
    } catch (e) {
      debugPrint('Coleção legada indisponível ($collection): $e');
      return const [];
    }
  }

  // --- AUTHENTICATION ---
  
  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      debugPrint("Login bem sucedido: ${userCredential.user?.email}");
      
      // Sincronização imediata após o login
      await uploadLocalDataToCloud();
      await syncFromCloud();
    } catch (e) {
      debugPrint("Erro no Google Sign-In: $e");
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
    } catch (e) {
      debugPrint("Erro ao deslogar: $e");
    }
  }

  // --- MÉTODOS DE SYNC ---

  Future<void> uploadLocalDataToCloud() async {
    final uid = _uid;
    if (uid == null) return;
    if (_uploadInProgress) {
      debugPrint("Upload local->cloud ignorado: já em execução.");
      return;
    }

    _uploadInProgress = true;
    
    try {
      debugPrint("Iniciando upload de dados locais para o UID: $uid");
      
      int uploadedFavorites = 0;
      int uploadedNotes = 0;
      int uploadedProgress = 0;
      int uploadedBlocks = 0;
      int uploadedHymns = 0;

      final versions = await repository.getImportedVersions();
      for (var version in versions) {
        final favorites = await repository.getFavoriteVerses(version);
        for (var fav in favorites) {
          await uploadFavorite(fav);
          uploadedFavorites++;
        }
      }

      final notes = await repository.getAllNotes();
      for (var note in notes) {
        await uploadNote(note);
        uploadedNotes++;
      }

      final readChapters = await repository.getReadChapterKeys();
      for (var chapterKey in readChapters) {
        await uploadReadingProgress(chapterKey);
        uploadedProgress++;
      }

      for (var version in versions) {
        final blocks = await repository.getAllFavoriteBlocks(version);
        for (var block in blocks) {
          await uploadFavoriteBlock(block);
          uploadedBlocks++;
        }
      }

      if (hymnRepository != null) {
        for (var category in ['HARPA', 'NOVO_CANTICO']) {
          final favHymns = await hymnRepository!.getFavoriteHymns(category);
          for (var hymn in favHymns) {
            await uploadHymnFavorite(hymn);
            uploadedHymns++;
          }
        }
      }

      debugPrint(
        "Upload concluído. favoritos=$uploadedFavorites, notas=$uploadedNotes, progresso=$uploadedProgress, blocos=$uploadedBlocks, hinos=$uploadedHymns",
      );
    } finally {
      _uploadInProgress = false;
    }
  }

  Future<void> uploadFavorite(BibleVerse verse) async {
    final uid = _uid;
    if (uid == null) return;
    try {
      // Use version-agnostic canonical key: bookId_chapter_verse
      final canonicalKey = '${verse.bookId}_${verse.chapter}_${verse.verse}';
      await _firestore.collection('users').doc(uid).collection('favorites').doc(canonicalKey).set({
        'verseKey': canonicalKey,
        'bookName': verse.bookName,
        'chapter': verse.chapter,
        'verse': verse.verse,
        'text': verse.text,
        'isFavorite': verse.isFavorite,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint("Erro ao enviar favorito: $e");
    }
  }

  Future<void> removeFavoriteFromCloud(String verseKey) async {
    final uid = _uid;
    if (uid == null) return;
    try {
      await _firestore.collection('users').doc(uid).collection('favorites').doc(verseKey).delete();
    } catch (e) {
      debugPrint("Erro ao remover favorito: $e");
    }
  }

  Future<void> uploadFavoriteBlock(FavoriteBlock block) async {
    final uid = _uid;
    if (uid == null) return;
    try {
      await _firestore.collection('users').doc(uid).collection('favorite_blocks').doc(block.blockKey).set({
        'versionId': block.versionId,
        'bookId': block.bookId,
        'bookName': block.bookName,
        'chapter': block.chapter,
        'verses': block.verses,
        'text': block.text,
        'timestamp': block.timestamp.toIso8601String(),
        'cloudTimestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint("Erro ao enviar bloco favorito: $e");
    }
  }

  Future<void> removeFavoriteBlockFromCloud(String blockKey) async {
    final uid = _uid;
    if (uid == null) return;
    try {
      await _firestore.collection('users').doc(uid).collection('favorite_blocks').doc(blockKey).delete();
    } catch (e) {
      debugPrint("Erro ao remover bloco favorito: $e");
    }
  }

  Future<void> uploadHymnFavorite(Hymn hymn) async {
    final uid = _uid;
    if (uid == null) return;
    try {
      final String docId = "${hymn.category}_${hymn.number}";
      await _firestore.collection('users').doc(uid).collection('hymn_favorites').doc(docId).set({
        'category': hymn.category,
        'number': hymn.number,
        'title': hymn.title,
        'isFavorite': hymn.isFavorite,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint("Erro ao enviar hino favorito: $e");
    }
  }

  Future<void> removeHymnFavoriteFromCloud(String category, int number) async {
    final uid = _uid;
    if (uid == null) return;
    try {
      final String docId = "${category}_$number";
      await _firestore.collection('users').doc(uid).collection('hymn_favorites').doc(docId).delete();
    } catch (e) {
      debugPrint("Erro ao remover hino favorito: $e");
    }
  }

  Future<void> uploadNote(UserNote note) async {
    final uid = _uid;
    if (uid == null) return;
    try {
      await _firestore.collection('users').doc(uid).collection('notes').doc(note.verseKey).set({
        'verseKey': note.verseKey,
        'title': note.title,
        'content': note.content,
        'lastModified': note.lastModified.toIso8601String(),
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint("Erro ao enviar devocional: $e");
    }
  }

  Future<void> removeNoteFromCloud(String verseKey) async {
    final uid = _uid;
    if (uid == null) return;
    try {
      await _firestore.collection('users').doc(uid).collection('notes').doc(verseKey).delete();
    } catch (e) {
      debugPrint("Erro ao remover devocional da cloud: $e");
    }
  }

  // --- READING PROGRESS SYNC ---

  Future<void> uploadReadingProgress(String chapterKey) async {
    final uid = _uid;
    if (uid == null) return;
    try {
      await _firestore.collection('users').doc(uid).collection('reading_progress').doc(chapterKey).set({
        'chapterKey': chapterKey,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      debugPrint("Erro ao enviar progresso de leitura: $e");
    }
  }

  Future<void> removeReadingProgressFromCloud(String chapterKey) async {
    final uid = _uid;
    if (uid == null) return;
    try {
      await _firestore.collection('users').doc(uid).collection('reading_progress').doc(chapterKey).delete();
    } catch (e) {
      debugPrint("Erro ao remover progresso de leitura: $e");
    }
  }

  Future<void> syncFromCloud() async {
    final uid = _uid;
    if (uid == null) return;
    if (_syncInProgress) {
      debugPrint("Sync cloud->local ignorado: já em execução.");
      return;
    }

    _syncInProgress = true;

    try {
      debugPrint("Iniciando sincronização da Cloud para o UID: $uid");
      int syncedFavorites = 0;
      int syncedBlocks = 0;
      int syncedHymns = 0;
      int syncedNotes = 0;
      int syncedProgress = 0;
      int cloudHymnDocs = 0;

      final favSnapshot = await _firestore.collection('users').doc(uid).collection('favorites').get();
      final effectiveFavDocs = favSnapshot.docs.isNotEmpty
          ? favSnapshot.docs
          : await _legacyUserScopedDocs('favorites', uid);
      for (var doc in effectiveFavDocs) {
        final data = doc.data();
        final rawVerseKey = data['verseKey'] as String?;
        if (rawVerseKey == null || rawVerseKey.isEmpty) {
          continue;
        }
        final keyParts = rawVerseKey.split('_');
        int bookId = 0, chapter = 0, verse = 0;
        if (keyParts.length == 3) {
          // Canonical format: bookId_chapter_verse
          bookId = int.tryParse(keyParts[0]) ?? 0;
          chapter = int.tryParse(keyParts[1]) ?? 0;
          verse = int.tryParse(keyParts[2]) ?? 0;
        } else if (keyParts.length == 4) {
          // Legacy format: versionId_bookId_chapter_verse
          bookId = int.tryParse(keyParts[1]) ?? 0;
          chapter = int.tryParse(keyParts[2]) ?? 0;
          verse = int.tryParse(keyParts[3]) ?? 0;
        }
        if (bookId > 0 && chapter > 0 && verse > 0) {
          await repository.setFavoriteByPosition(bookId, chapter, verse, true);
          syncedFavorites++;
        }
      }

      final blockSnapshot = await _firestore.collection('users').doc(uid).collection('favorite_blocks').get();
      final effectiveBlockDocs = blockSnapshot.docs.isNotEmpty
          ? blockSnapshot.docs
          : await _legacyUserScopedDocs('favorite_blocks', uid);
      for (var doc in effectiveBlockDocs) {
        final data = doc.data();
        final block = FavoriteBlock()
          ..versionId = data['versionId']
          ..bookId = data['bookId']
          ..bookName = data['bookName']
          ..chapter = data['chapter']
          ..verses = List<int>.from(data['verses'])
          ..text = data['text']
          ..timestamp = DateTime.parse(data['timestamp']);
        
        await repository.saveFavoriteBlock(block);
        syncedBlocks++;
      }

      if (hymnRepository != null) {
        final hymnFavSnapshot = await _firestore.collection('users').doc(uid).collection('hymn_favorites').get();
        final effectiveHymnDocs = hymnFavSnapshot.docs.isNotEmpty
            ? hymnFavSnapshot.docs
            : await _legacyUserScopedDocs('hymn_favorites', uid);
        cloudHymnDocs = effectiveHymnDocs.length;
        for (var doc in effectiveHymnDocs) {
          final data = doc.data();
          final hymn = await hymnRepository!.getHymnByNumber(data['category'], data['number']);
          if (hymn != null && !hymn.isFavorite) {
            await hymnRepository!.setFavorite(hymn.id, true);
            syncedHymns++;
          }
        }
      }

      final notesSnapshot = await _firestore.collection('users').doc(uid).collection('notes').get();
      final effectiveNotesDocs = notesSnapshot.docs.isNotEmpty
          ? notesSnapshot.docs
          : await _legacyUserScopedDocs('notes', uid);
      for (var doc in effectiveNotesDocs) {
        final data = doc.data();
        final verseKey = data['verseKey'] as String?;
        final content = data['content'] as String?;
        if (verseKey == null || content == null) {
          continue;
        }

        await repository.saveNote(verseKey, content, title: data['title']);
        syncedNotes++;
      }

      final progressSnapshot = await _firestore.collection('users').doc(uid).collection('reading_progress').get();
      final effectiveProgressDocs = progressSnapshot.docs.isNotEmpty
          ? progressSnapshot.docs
          : await _legacyUserScopedDocs('reading_progress', uid);
      for (var doc in effectiveProgressDocs) {
        final data = doc.data();
        final rawChapterKey = data['chapterKey'] as String?;
        if (rawChapterKey == null || rawChapterKey.isEmpty) {
          continue;
        }
        final keyParts = rawChapterKey.split('_');
        int bookId = 0, chapter = 0;
        if (keyParts.length == 2) {
          // Canonical format: bookId_chapter
          bookId = int.tryParse(keyParts[0]) ?? 0;
          chapter = int.tryParse(keyParts[1]) ?? 0;
        } else if (keyParts.length == 3) {
          // Legacy format: versionId_bookId_chapter
          bookId = int.tryParse(keyParts[1]) ?? 0;
          chapter = int.tryParse(keyParts[2]) ?? 0;
        }
        if (bookId > 0 && chapter > 0) {
          await repository.markChapterReadByPosition(bookId, chapter, true);
          syncedProgress++;
        }
      }

      debugPrint(
        "Sync concluído. favoritos=$syncedFavorites, notas=$syncedNotes, progresso=$syncedProgress, blocos=$syncedBlocks, hinos=$syncedHymns",
      );
      debugPrint(
        "Cloud snapshots. favoritos=${effectiveFavDocs.length}, notas=${effectiveNotesDocs.length}, progresso=${effectiveProgressDocs.length}, blocos=${effectiveBlockDocs.length}, hinos=$cloudHymnDocs",
      );
    } catch (e) {
      debugPrint("Erro ao sincronizar dados: $e");
    } finally {
      _syncInProgress = false;
    }
  }
}
