import 'package:drift/drift.dart';

@DataClassName('DriftBibleVerse')
class BibleVerses extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get versionId => text()();
  IntColumn get bookId => integer()();
  TextColumn get bookName => text()();
  IntColumn get chapter => integer()();
  IntColumn get verse => integer()();
  TextColumn get verseText => text().named('text')();
  BoolColumn get isFavorite => boolean().withDefault(const Constant(false))();
  BoolColumn get isRead => boolean().withDefault(const Constant(false))();
  IntColumn get highlightColor => integer().nullable()();
  TextColumn get verseKey => text()();
}

@DataClassName('DriftHymn')
class Hymns extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get category => text()();
  IntColumn get number => integer()();
  TextColumn get title => text()();
  TextColumn get lyrics => text()();
  TextColumn get audioUrl => text().nullable()();
  TextColumn get localPath => text().nullable()();
  BoolColumn get isFavorite => boolean().withDefault(const Constant(false))();
}

@DataClassName('DriftCrossReference')
class CrossReferences extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get sourceVerseId => integer()();
  IntColumn get targetVerseId => integer()();
  TextColumn get sourceKey => text()();
  TextColumn get targetKey => text()();
}

@DataClassName('DriftUserNote')
class UserNotes extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text().nullable()();
  TextColumn get content => text()();
  DateTimeColumn get lastModified => dateTime()();
  TextColumn get tags => text()(); // JSON encoded list
  IntColumn get verseId => integer()();
  TextColumn get verseKey => text()();
}

@DataClassName('DriftReflection')
class Reflections extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get author => text()();
  TextColumn get content => text()();
  TextColumn get associatedChapterKey => text()();
  DateTimeColumn get createdAt => dateTime()();
}

@DataClassName('DriftFavoriteBlock')
class FavoriteBlocks extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get versionId => text()();
  IntColumn get bookId => integer()();
  TextColumn get bookName => text()();
  IntColumn get chapter => integer()();
  TextColumn get verses => text()(); // JSON encoded list
  TextColumn get verseText => text().named('text')();
  DateTimeColumn get timestamp => dateTime()();
}

@DataClassName('DriftAppSettings')
class AppSettingsTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get lastVersion => text()();
  IntColumn get lastBookId => integer().nullable()();
  IntColumn get lastChapter => integer().nullable()();
  TextColumn get readingTheme => text().withDefault(const Constant('light'))();
  TextColumn get lastRoute => text().nullable()();
  BoolColumn get migrationDone => boolean().withDefault(const Constant(false))();
}

@DataClassName('DriftSermon')
class Sermons extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  TextColumn get tags => text()(); // JSON encoded list
  TextColumn get segments => text()(); // JSON encoded list
  DateTimeColumn get lastModified => dateTime()();
  BoolColumn get isFavorite => boolean().withDefault(const Constant(false))();
  TextColumn get mainHymnKey => text().nullable()();
}
