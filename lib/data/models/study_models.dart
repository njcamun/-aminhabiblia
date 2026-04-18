class CrossReference {
  int id = 0;
  late String sourceKey;
  late String targetKey;
}

class UserNote {
  int id = 0;
  String? title;
  late String content;
  late DateTime lastModified;
  late List<String> tags;
  late String verseKey;
}

class Reflection {
  int id = 0;
  late String author;
  late String content;
  late String associatedChapterKey;
  late DateTime createdAt;
}

class FavoriteBlock {
  int id = 0;
  late String versionId;
  late int bookId;
  late String bookName;
  late int chapter;
  late List<int> verses; 
  late String text;
  late DateTime timestamp;

  String get blockKey => '${versionId}_${bookId}_${chapter}_${verses.join(',')}';
}

class AppSettings {
  int id = 0;
  String lastVersion = 'NAA';
  int? lastBookId;
  int? lastChapter;
  String readingTheme = 'light';
  String? lastRoute;
}

class Sermon {
  int id = 0;
  late String title;
  late List<String> tags;
  late List<SermonSegment> segments;
  late DateTime lastModified;
  bool isFavorite = false;
  String? mainHymnKey;
}

class SermonSegment {
  late String type; 
  String? content; 
  String? verseKey; 
  String? noteKey; 
  double? fontSize;
}
