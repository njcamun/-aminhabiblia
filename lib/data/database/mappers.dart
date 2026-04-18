import 'dart:convert';
import 'package:drift/drift.dart';
import '../models/bible_verse.dart';
import '../models/study_models.dart';
import '../models/hymn.dart';
import 'database.dart';

extension DriftBibleVerseMapper on DriftBibleVerse {
  BibleVerse toIsar() {
    return BibleVerse()
      ..id = id
      ..versionId = versionId
      ..bookId = bookId
      ..bookName = bookName
      ..chapter = chapter
      ..verse = verse
      ..text = verseText
      ..isFavorite = isFavorite
      ..isRead = isRead
      ..highlightColor = highlightColor;
  }
}

extension BibleVerseMapper on BibleVerse {
  BibleVersesCompanion toCompanion() {
    return BibleVersesCompanion.insert(
      versionId: versionId,
      bookId: bookId,
      bookName: bookName,
      chapter: chapter,
      verse: verse,
      verseText: text,
      isFavorite: Value(isFavorite),
      isRead: Value(isRead),
      highlightColor: Value(highlightColor),
      verseKey: verseKey,
    );
  }
}

extension DriftHymnMapper on DriftHymn {
  Hymn toIsar() {
    return Hymn()
      ..id = id
      ..category = category
      ..number = number
      ..title = title
      ..lyrics = lyrics
      ..audioUrl = audioUrl
      ..localPath = localPath
      ..isFavorite = isFavorite;
  }
}

extension HymnMapper on Hymn {
  HymnsCompanion toCompanion() {
    return HymnsCompanion.insert(
      category: category,
      number: number,
      title: title,
      lyrics: lyrics,
      audioUrl: Value(audioUrl),
      localPath: Value(localPath),
      isFavorite: Value(isFavorite),
    );
  }
}

extension DriftUserNoteMapper on DriftUserNote {
  UserNote toIsar() {
    return UserNote()
      ..id = id
      ..title = title
      ..content = content
      ..lastModified = lastModified
      ..tags = (jsonDecode(tags) as List).cast<String>()
      ..verseKey = verseKey;
  }
}

extension DriftReflectionMapper on DriftReflection {
  Reflection toIsar() {
    return Reflection()
      ..id = id
      ..author = author
      ..content = content
      ..associatedChapterKey = associatedChapterKey
      ..createdAt = createdAt;
  }
}

extension DriftFavoriteBlockMapper on DriftFavoriteBlock {
  FavoriteBlock toIsar() {
    return FavoriteBlock()
      ..id = id
      ..versionId = versionId
      ..bookId = bookId
      ..bookName = bookName
      ..chapter = chapter
      ..verses = (jsonDecode(verses) as List).cast<int>()
      ..text = verseText
      ..timestamp = timestamp;
  }
}

extension FavoriteBlockMapper on FavoriteBlock {
  FavoriteBlocksCompanion toCompanion() {
    return FavoriteBlocksCompanion.insert(
      versionId: versionId,
      bookId: bookId,
      bookName: bookName,
      chapter: chapter,
      verses: jsonEncode(verses),
      verseText: text,
      timestamp: timestamp,
    );
  }
}

extension SermonMapper on Sermon {
  SermonsCompanion toCompanion() {
    return SermonsCompanion.insert(
      title: title,
      tags: jsonEncode(tags),
      segments: jsonEncode(segments.map((s) => {
        'type': s.type,
        'content': s.content,
        'verseKey': s.verseKey,
        'noteKey': s.noteKey,
        'fontSize': s.fontSize,
      }).toList()),
      lastModified: lastModified,
      isFavorite: Value(isFavorite),
      mainHymnKey: Value(mainHymnKey),
    );
  }
}
