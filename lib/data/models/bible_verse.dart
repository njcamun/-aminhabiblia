class BibleVerse {
  int id = 0;
  late String versionId;
  late int bookId;
  late String bookName;
  late int chapter;
  late int verse;
  late String text;

  bool isFavorite = false;
  bool isRead = false;
  int? highlightColor;

  String get verseKey => '${versionId}_${bookId}_${chapter}_$verse';
  String get uniqueKey => verseKey;
}
