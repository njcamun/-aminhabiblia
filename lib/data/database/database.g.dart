// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $BibleVersesTable extends BibleVerses
    with TableInfo<$BibleVersesTable, DriftBibleVerse> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BibleVersesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _versionIdMeta =
      const VerificationMeta('versionId');
  @override
  late final GeneratedColumn<String> versionId = GeneratedColumn<String>(
      'version_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _bookIdMeta = const VerificationMeta('bookId');
  @override
  late final GeneratedColumn<int> bookId = GeneratedColumn<int>(
      'book_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _bookNameMeta =
      const VerificationMeta('bookName');
  @override
  late final GeneratedColumn<String> bookName = GeneratedColumn<String>(
      'book_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _chapterMeta =
      const VerificationMeta('chapter');
  @override
  late final GeneratedColumn<int> chapter = GeneratedColumn<int>(
      'chapter', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _verseMeta = const VerificationMeta('verse');
  @override
  late final GeneratedColumn<int> verse = GeneratedColumn<int>(
      'verse', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _verseTextMeta =
      const VerificationMeta('verseText');
  @override
  late final GeneratedColumn<String> verseText = GeneratedColumn<String>(
      'text', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _isFavoriteMeta =
      const VerificationMeta('isFavorite');
  @override
  late final GeneratedColumn<bool> isFavorite = GeneratedColumn<bool>(
      'is_favorite', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_favorite" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _isReadMeta = const VerificationMeta('isRead');
  @override
  late final GeneratedColumn<bool> isRead = GeneratedColumn<bool>(
      'is_read', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_read" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _highlightColorMeta =
      const VerificationMeta('highlightColor');
  @override
  late final GeneratedColumn<int> highlightColor = GeneratedColumn<int>(
      'highlight_color', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _verseKeyMeta =
      const VerificationMeta('verseKey');
  @override
  late final GeneratedColumn<String> verseKey = GeneratedColumn<String>(
      'verse_key', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        versionId,
        bookId,
        bookName,
        chapter,
        verse,
        verseText,
        isFavorite,
        isRead,
        highlightColor,
        verseKey
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'bible_verses';
  @override
  VerificationContext validateIntegrity(Insertable<DriftBibleVerse> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('version_id')) {
      context.handle(_versionIdMeta,
          versionId.isAcceptableOrUnknown(data['version_id']!, _versionIdMeta));
    } else if (isInserting) {
      context.missing(_versionIdMeta);
    }
    if (data.containsKey('book_id')) {
      context.handle(_bookIdMeta,
          bookId.isAcceptableOrUnknown(data['book_id']!, _bookIdMeta));
    } else if (isInserting) {
      context.missing(_bookIdMeta);
    }
    if (data.containsKey('book_name')) {
      context.handle(_bookNameMeta,
          bookName.isAcceptableOrUnknown(data['book_name']!, _bookNameMeta));
    } else if (isInserting) {
      context.missing(_bookNameMeta);
    }
    if (data.containsKey('chapter')) {
      context.handle(_chapterMeta,
          chapter.isAcceptableOrUnknown(data['chapter']!, _chapterMeta));
    } else if (isInserting) {
      context.missing(_chapterMeta);
    }
    if (data.containsKey('verse')) {
      context.handle(
          _verseMeta, verse.isAcceptableOrUnknown(data['verse']!, _verseMeta));
    } else if (isInserting) {
      context.missing(_verseMeta);
    }
    if (data.containsKey('text')) {
      context.handle(_verseTextMeta,
          verseText.isAcceptableOrUnknown(data['text']!, _verseTextMeta));
    } else if (isInserting) {
      context.missing(_verseTextMeta);
    }
    if (data.containsKey('is_favorite')) {
      context.handle(
          _isFavoriteMeta,
          isFavorite.isAcceptableOrUnknown(
              data['is_favorite']!, _isFavoriteMeta));
    }
    if (data.containsKey('is_read')) {
      context.handle(_isReadMeta,
          isRead.isAcceptableOrUnknown(data['is_read']!, _isReadMeta));
    }
    if (data.containsKey('highlight_color')) {
      context.handle(
          _highlightColorMeta,
          highlightColor.isAcceptableOrUnknown(
              data['highlight_color']!, _highlightColorMeta));
    }
    if (data.containsKey('verse_key')) {
      context.handle(_verseKeyMeta,
          verseKey.isAcceptableOrUnknown(data['verse_key']!, _verseKeyMeta));
    } else if (isInserting) {
      context.missing(_verseKeyMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DriftBibleVerse map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DriftBibleVerse(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      versionId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}version_id'])!,
      bookId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}book_id'])!,
      bookName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}book_name'])!,
      chapter: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}chapter'])!,
      verse: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}verse'])!,
      verseText: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}text'])!,
      isFavorite: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_favorite'])!,
      isRead: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_read'])!,
      highlightColor: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}highlight_color']),
      verseKey: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}verse_key'])!,
    );
  }

  @override
  $BibleVersesTable createAlias(String alias) {
    return $BibleVersesTable(attachedDatabase, alias);
  }
}

class DriftBibleVerse extends DataClass implements Insertable<DriftBibleVerse> {
  final int id;
  final String versionId;
  final int bookId;
  final String bookName;
  final int chapter;
  final int verse;
  final String verseText;
  final bool isFavorite;
  final bool isRead;
  final int? highlightColor;
  final String verseKey;
  const DriftBibleVerse(
      {required this.id,
      required this.versionId,
      required this.bookId,
      required this.bookName,
      required this.chapter,
      required this.verse,
      required this.verseText,
      required this.isFavorite,
      required this.isRead,
      this.highlightColor,
      required this.verseKey});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['version_id'] = Variable<String>(versionId);
    map['book_id'] = Variable<int>(bookId);
    map['book_name'] = Variable<String>(bookName);
    map['chapter'] = Variable<int>(chapter);
    map['verse'] = Variable<int>(verse);
    map['text'] = Variable<String>(verseText);
    map['is_favorite'] = Variable<bool>(isFavorite);
    map['is_read'] = Variable<bool>(isRead);
    if (!nullToAbsent || highlightColor != null) {
      map['highlight_color'] = Variable<int>(highlightColor);
    }
    map['verse_key'] = Variable<String>(verseKey);
    return map;
  }

  BibleVersesCompanion toCompanion(bool nullToAbsent) {
    return BibleVersesCompanion(
      id: Value(id),
      versionId: Value(versionId),
      bookId: Value(bookId),
      bookName: Value(bookName),
      chapter: Value(chapter),
      verse: Value(verse),
      verseText: Value(verseText),
      isFavorite: Value(isFavorite),
      isRead: Value(isRead),
      highlightColor: highlightColor == null && nullToAbsent
          ? const Value.absent()
          : Value(highlightColor),
      verseKey: Value(verseKey),
    );
  }

  factory DriftBibleVerse.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DriftBibleVerse(
      id: serializer.fromJson<int>(json['id']),
      versionId: serializer.fromJson<String>(json['versionId']),
      bookId: serializer.fromJson<int>(json['bookId']),
      bookName: serializer.fromJson<String>(json['bookName']),
      chapter: serializer.fromJson<int>(json['chapter']),
      verse: serializer.fromJson<int>(json['verse']),
      verseText: serializer.fromJson<String>(json['verseText']),
      isFavorite: serializer.fromJson<bool>(json['isFavorite']),
      isRead: serializer.fromJson<bool>(json['isRead']),
      highlightColor: serializer.fromJson<int?>(json['highlightColor']),
      verseKey: serializer.fromJson<String>(json['verseKey']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'versionId': serializer.toJson<String>(versionId),
      'bookId': serializer.toJson<int>(bookId),
      'bookName': serializer.toJson<String>(bookName),
      'chapter': serializer.toJson<int>(chapter),
      'verse': serializer.toJson<int>(verse),
      'verseText': serializer.toJson<String>(verseText),
      'isFavorite': serializer.toJson<bool>(isFavorite),
      'isRead': serializer.toJson<bool>(isRead),
      'highlightColor': serializer.toJson<int?>(highlightColor),
      'verseKey': serializer.toJson<String>(verseKey),
    };
  }

  DriftBibleVerse copyWith(
          {int? id,
          String? versionId,
          int? bookId,
          String? bookName,
          int? chapter,
          int? verse,
          String? verseText,
          bool? isFavorite,
          bool? isRead,
          Value<int?> highlightColor = const Value.absent(),
          String? verseKey}) =>
      DriftBibleVerse(
        id: id ?? this.id,
        versionId: versionId ?? this.versionId,
        bookId: bookId ?? this.bookId,
        bookName: bookName ?? this.bookName,
        chapter: chapter ?? this.chapter,
        verse: verse ?? this.verse,
        verseText: verseText ?? this.verseText,
        isFavorite: isFavorite ?? this.isFavorite,
        isRead: isRead ?? this.isRead,
        highlightColor:
            highlightColor.present ? highlightColor.value : this.highlightColor,
        verseKey: verseKey ?? this.verseKey,
      );
  DriftBibleVerse copyWithCompanion(BibleVersesCompanion data) {
    return DriftBibleVerse(
      id: data.id.present ? data.id.value : this.id,
      versionId: data.versionId.present ? data.versionId.value : this.versionId,
      bookId: data.bookId.present ? data.bookId.value : this.bookId,
      bookName: data.bookName.present ? data.bookName.value : this.bookName,
      chapter: data.chapter.present ? data.chapter.value : this.chapter,
      verse: data.verse.present ? data.verse.value : this.verse,
      verseText: data.verseText.present ? data.verseText.value : this.verseText,
      isFavorite:
          data.isFavorite.present ? data.isFavorite.value : this.isFavorite,
      isRead: data.isRead.present ? data.isRead.value : this.isRead,
      highlightColor: data.highlightColor.present
          ? data.highlightColor.value
          : this.highlightColor,
      verseKey: data.verseKey.present ? data.verseKey.value : this.verseKey,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DriftBibleVerse(')
          ..write('id: $id, ')
          ..write('versionId: $versionId, ')
          ..write('bookId: $bookId, ')
          ..write('bookName: $bookName, ')
          ..write('chapter: $chapter, ')
          ..write('verse: $verse, ')
          ..write('verseText: $verseText, ')
          ..write('isFavorite: $isFavorite, ')
          ..write('isRead: $isRead, ')
          ..write('highlightColor: $highlightColor, ')
          ..write('verseKey: $verseKey')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, versionId, bookId, bookName, chapter,
      verse, verseText, isFavorite, isRead, highlightColor, verseKey);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DriftBibleVerse &&
          other.id == this.id &&
          other.versionId == this.versionId &&
          other.bookId == this.bookId &&
          other.bookName == this.bookName &&
          other.chapter == this.chapter &&
          other.verse == this.verse &&
          other.verseText == this.verseText &&
          other.isFavorite == this.isFavorite &&
          other.isRead == this.isRead &&
          other.highlightColor == this.highlightColor &&
          other.verseKey == this.verseKey);
}

class BibleVersesCompanion extends UpdateCompanion<DriftBibleVerse> {
  final Value<int> id;
  final Value<String> versionId;
  final Value<int> bookId;
  final Value<String> bookName;
  final Value<int> chapter;
  final Value<int> verse;
  final Value<String> verseText;
  final Value<bool> isFavorite;
  final Value<bool> isRead;
  final Value<int?> highlightColor;
  final Value<String> verseKey;
  const BibleVersesCompanion({
    this.id = const Value.absent(),
    this.versionId = const Value.absent(),
    this.bookId = const Value.absent(),
    this.bookName = const Value.absent(),
    this.chapter = const Value.absent(),
    this.verse = const Value.absent(),
    this.verseText = const Value.absent(),
    this.isFavorite = const Value.absent(),
    this.isRead = const Value.absent(),
    this.highlightColor = const Value.absent(),
    this.verseKey = const Value.absent(),
  });
  BibleVersesCompanion.insert({
    this.id = const Value.absent(),
    required String versionId,
    required int bookId,
    required String bookName,
    required int chapter,
    required int verse,
    required String verseText,
    this.isFavorite = const Value.absent(),
    this.isRead = const Value.absent(),
    this.highlightColor = const Value.absent(),
    required String verseKey,
  })  : versionId = Value(versionId),
        bookId = Value(bookId),
        bookName = Value(bookName),
        chapter = Value(chapter),
        verse = Value(verse),
        verseText = Value(verseText),
        verseKey = Value(verseKey);
  static Insertable<DriftBibleVerse> custom({
    Expression<int>? id,
    Expression<String>? versionId,
    Expression<int>? bookId,
    Expression<String>? bookName,
    Expression<int>? chapter,
    Expression<int>? verse,
    Expression<String>? verseText,
    Expression<bool>? isFavorite,
    Expression<bool>? isRead,
    Expression<int>? highlightColor,
    Expression<String>? verseKey,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (versionId != null) 'version_id': versionId,
      if (bookId != null) 'book_id': bookId,
      if (bookName != null) 'book_name': bookName,
      if (chapter != null) 'chapter': chapter,
      if (verse != null) 'verse': verse,
      if (verseText != null) 'text': verseText,
      if (isFavorite != null) 'is_favorite': isFavorite,
      if (isRead != null) 'is_read': isRead,
      if (highlightColor != null) 'highlight_color': highlightColor,
      if (verseKey != null) 'verse_key': verseKey,
    });
  }

  BibleVersesCompanion copyWith(
      {Value<int>? id,
      Value<String>? versionId,
      Value<int>? bookId,
      Value<String>? bookName,
      Value<int>? chapter,
      Value<int>? verse,
      Value<String>? verseText,
      Value<bool>? isFavorite,
      Value<bool>? isRead,
      Value<int?>? highlightColor,
      Value<String>? verseKey}) {
    return BibleVersesCompanion(
      id: id ?? this.id,
      versionId: versionId ?? this.versionId,
      bookId: bookId ?? this.bookId,
      bookName: bookName ?? this.bookName,
      chapter: chapter ?? this.chapter,
      verse: verse ?? this.verse,
      verseText: verseText ?? this.verseText,
      isFavorite: isFavorite ?? this.isFavorite,
      isRead: isRead ?? this.isRead,
      highlightColor: highlightColor ?? this.highlightColor,
      verseKey: verseKey ?? this.verseKey,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (versionId.present) {
      map['version_id'] = Variable<String>(versionId.value);
    }
    if (bookId.present) {
      map['book_id'] = Variable<int>(bookId.value);
    }
    if (bookName.present) {
      map['book_name'] = Variable<String>(bookName.value);
    }
    if (chapter.present) {
      map['chapter'] = Variable<int>(chapter.value);
    }
    if (verse.present) {
      map['verse'] = Variable<int>(verse.value);
    }
    if (verseText.present) {
      map['text'] = Variable<String>(verseText.value);
    }
    if (isFavorite.present) {
      map['is_favorite'] = Variable<bool>(isFavorite.value);
    }
    if (isRead.present) {
      map['is_read'] = Variable<bool>(isRead.value);
    }
    if (highlightColor.present) {
      map['highlight_color'] = Variable<int>(highlightColor.value);
    }
    if (verseKey.present) {
      map['verse_key'] = Variable<String>(verseKey.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BibleVersesCompanion(')
          ..write('id: $id, ')
          ..write('versionId: $versionId, ')
          ..write('bookId: $bookId, ')
          ..write('bookName: $bookName, ')
          ..write('chapter: $chapter, ')
          ..write('verse: $verse, ')
          ..write('verseText: $verseText, ')
          ..write('isFavorite: $isFavorite, ')
          ..write('isRead: $isRead, ')
          ..write('highlightColor: $highlightColor, ')
          ..write('verseKey: $verseKey')
          ..write(')'))
        .toString();
  }
}

class $HymnsTable extends Hymns with TableInfo<$HymnsTable, DriftHymn> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $HymnsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _categoryMeta =
      const VerificationMeta('category');
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
      'category', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _numberMeta = const VerificationMeta('number');
  @override
  late final GeneratedColumn<int> number = GeneratedColumn<int>(
      'number', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _lyricsMeta = const VerificationMeta('lyrics');
  @override
  late final GeneratedColumn<String> lyrics = GeneratedColumn<String>(
      'lyrics', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _audioUrlMeta =
      const VerificationMeta('audioUrl');
  @override
  late final GeneratedColumn<String> audioUrl = GeneratedColumn<String>(
      'audio_url', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _localPathMeta =
      const VerificationMeta('localPath');
  @override
  late final GeneratedColumn<String> localPath = GeneratedColumn<String>(
      'local_path', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _isFavoriteMeta =
      const VerificationMeta('isFavorite');
  @override
  late final GeneratedColumn<bool> isFavorite = GeneratedColumn<bool>(
      'is_favorite', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_favorite" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns =>
      [id, category, number, title, lyrics, audioUrl, localPath, isFavorite];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'hymns';
  @override
  VerificationContext validateIntegrity(Insertable<DriftHymn> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta,
          category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('number')) {
      context.handle(_numberMeta,
          number.isAcceptableOrUnknown(data['number']!, _numberMeta));
    } else if (isInserting) {
      context.missing(_numberMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('lyrics')) {
      context.handle(_lyricsMeta,
          lyrics.isAcceptableOrUnknown(data['lyrics']!, _lyricsMeta));
    } else if (isInserting) {
      context.missing(_lyricsMeta);
    }
    if (data.containsKey('audio_url')) {
      context.handle(_audioUrlMeta,
          audioUrl.isAcceptableOrUnknown(data['audio_url']!, _audioUrlMeta));
    }
    if (data.containsKey('local_path')) {
      context.handle(_localPathMeta,
          localPath.isAcceptableOrUnknown(data['local_path']!, _localPathMeta));
    }
    if (data.containsKey('is_favorite')) {
      context.handle(
          _isFavoriteMeta,
          isFavorite.isAcceptableOrUnknown(
              data['is_favorite']!, _isFavoriteMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DriftHymn map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DriftHymn(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      category: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category'])!,
      number: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}number'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      lyrics: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}lyrics'])!,
      audioUrl: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}audio_url']),
      localPath: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}local_path']),
      isFavorite: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_favorite'])!,
    );
  }

  @override
  $HymnsTable createAlias(String alias) {
    return $HymnsTable(attachedDatabase, alias);
  }
}

class DriftHymn extends DataClass implements Insertable<DriftHymn> {
  final int id;
  final String category;
  final int number;
  final String title;
  final String lyrics;
  final String? audioUrl;
  final String? localPath;
  final bool isFavorite;
  const DriftHymn(
      {required this.id,
      required this.category,
      required this.number,
      required this.title,
      required this.lyrics,
      this.audioUrl,
      this.localPath,
      required this.isFavorite});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['category'] = Variable<String>(category);
    map['number'] = Variable<int>(number);
    map['title'] = Variable<String>(title);
    map['lyrics'] = Variable<String>(lyrics);
    if (!nullToAbsent || audioUrl != null) {
      map['audio_url'] = Variable<String>(audioUrl);
    }
    if (!nullToAbsent || localPath != null) {
      map['local_path'] = Variable<String>(localPath);
    }
    map['is_favorite'] = Variable<bool>(isFavorite);
    return map;
  }

  HymnsCompanion toCompanion(bool nullToAbsent) {
    return HymnsCompanion(
      id: Value(id),
      category: Value(category),
      number: Value(number),
      title: Value(title),
      lyrics: Value(lyrics),
      audioUrl: audioUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(audioUrl),
      localPath: localPath == null && nullToAbsent
          ? const Value.absent()
          : Value(localPath),
      isFavorite: Value(isFavorite),
    );
  }

  factory DriftHymn.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DriftHymn(
      id: serializer.fromJson<int>(json['id']),
      category: serializer.fromJson<String>(json['category']),
      number: serializer.fromJson<int>(json['number']),
      title: serializer.fromJson<String>(json['title']),
      lyrics: serializer.fromJson<String>(json['lyrics']),
      audioUrl: serializer.fromJson<String?>(json['audioUrl']),
      localPath: serializer.fromJson<String?>(json['localPath']),
      isFavorite: serializer.fromJson<bool>(json['isFavorite']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'category': serializer.toJson<String>(category),
      'number': serializer.toJson<int>(number),
      'title': serializer.toJson<String>(title),
      'lyrics': serializer.toJson<String>(lyrics),
      'audioUrl': serializer.toJson<String?>(audioUrl),
      'localPath': serializer.toJson<String?>(localPath),
      'isFavorite': serializer.toJson<bool>(isFavorite),
    };
  }

  DriftHymn copyWith(
          {int? id,
          String? category,
          int? number,
          String? title,
          String? lyrics,
          Value<String?> audioUrl = const Value.absent(),
          Value<String?> localPath = const Value.absent(),
          bool? isFavorite}) =>
      DriftHymn(
        id: id ?? this.id,
        category: category ?? this.category,
        number: number ?? this.number,
        title: title ?? this.title,
        lyrics: lyrics ?? this.lyrics,
        audioUrl: audioUrl.present ? audioUrl.value : this.audioUrl,
        localPath: localPath.present ? localPath.value : this.localPath,
        isFavorite: isFavorite ?? this.isFavorite,
      );
  DriftHymn copyWithCompanion(HymnsCompanion data) {
    return DriftHymn(
      id: data.id.present ? data.id.value : this.id,
      category: data.category.present ? data.category.value : this.category,
      number: data.number.present ? data.number.value : this.number,
      title: data.title.present ? data.title.value : this.title,
      lyrics: data.lyrics.present ? data.lyrics.value : this.lyrics,
      audioUrl: data.audioUrl.present ? data.audioUrl.value : this.audioUrl,
      localPath: data.localPath.present ? data.localPath.value : this.localPath,
      isFavorite:
          data.isFavorite.present ? data.isFavorite.value : this.isFavorite,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DriftHymn(')
          ..write('id: $id, ')
          ..write('category: $category, ')
          ..write('number: $number, ')
          ..write('title: $title, ')
          ..write('lyrics: $lyrics, ')
          ..write('audioUrl: $audioUrl, ')
          ..write('localPath: $localPath, ')
          ..write('isFavorite: $isFavorite')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, category, number, title, lyrics, audioUrl, localPath, isFavorite);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DriftHymn &&
          other.id == this.id &&
          other.category == this.category &&
          other.number == this.number &&
          other.title == this.title &&
          other.lyrics == this.lyrics &&
          other.audioUrl == this.audioUrl &&
          other.localPath == this.localPath &&
          other.isFavorite == this.isFavorite);
}

class HymnsCompanion extends UpdateCompanion<DriftHymn> {
  final Value<int> id;
  final Value<String> category;
  final Value<int> number;
  final Value<String> title;
  final Value<String> lyrics;
  final Value<String?> audioUrl;
  final Value<String?> localPath;
  final Value<bool> isFavorite;
  const HymnsCompanion({
    this.id = const Value.absent(),
    this.category = const Value.absent(),
    this.number = const Value.absent(),
    this.title = const Value.absent(),
    this.lyrics = const Value.absent(),
    this.audioUrl = const Value.absent(),
    this.localPath = const Value.absent(),
    this.isFavorite = const Value.absent(),
  });
  HymnsCompanion.insert({
    this.id = const Value.absent(),
    required String category,
    required int number,
    required String title,
    required String lyrics,
    this.audioUrl = const Value.absent(),
    this.localPath = const Value.absent(),
    this.isFavorite = const Value.absent(),
  })  : category = Value(category),
        number = Value(number),
        title = Value(title),
        lyrics = Value(lyrics);
  static Insertable<DriftHymn> custom({
    Expression<int>? id,
    Expression<String>? category,
    Expression<int>? number,
    Expression<String>? title,
    Expression<String>? lyrics,
    Expression<String>? audioUrl,
    Expression<String>? localPath,
    Expression<bool>? isFavorite,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (category != null) 'category': category,
      if (number != null) 'number': number,
      if (title != null) 'title': title,
      if (lyrics != null) 'lyrics': lyrics,
      if (audioUrl != null) 'audio_url': audioUrl,
      if (localPath != null) 'local_path': localPath,
      if (isFavorite != null) 'is_favorite': isFavorite,
    });
  }

  HymnsCompanion copyWith(
      {Value<int>? id,
      Value<String>? category,
      Value<int>? number,
      Value<String>? title,
      Value<String>? lyrics,
      Value<String?>? audioUrl,
      Value<String?>? localPath,
      Value<bool>? isFavorite}) {
    return HymnsCompanion(
      id: id ?? this.id,
      category: category ?? this.category,
      number: number ?? this.number,
      title: title ?? this.title,
      lyrics: lyrics ?? this.lyrics,
      audioUrl: audioUrl ?? this.audioUrl,
      localPath: localPath ?? this.localPath,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (number.present) {
      map['number'] = Variable<int>(number.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (lyrics.present) {
      map['lyrics'] = Variable<String>(lyrics.value);
    }
    if (audioUrl.present) {
      map['audio_url'] = Variable<String>(audioUrl.value);
    }
    if (localPath.present) {
      map['local_path'] = Variable<String>(localPath.value);
    }
    if (isFavorite.present) {
      map['is_favorite'] = Variable<bool>(isFavorite.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('HymnsCompanion(')
          ..write('id: $id, ')
          ..write('category: $category, ')
          ..write('number: $number, ')
          ..write('title: $title, ')
          ..write('lyrics: $lyrics, ')
          ..write('audioUrl: $audioUrl, ')
          ..write('localPath: $localPath, ')
          ..write('isFavorite: $isFavorite')
          ..write(')'))
        .toString();
  }
}

class $CrossReferencesTable extends CrossReferences
    with TableInfo<$CrossReferencesTable, DriftCrossReference> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CrossReferencesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _sourceVerseIdMeta =
      const VerificationMeta('sourceVerseId');
  @override
  late final GeneratedColumn<int> sourceVerseId = GeneratedColumn<int>(
      'source_verse_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _targetVerseIdMeta =
      const VerificationMeta('targetVerseId');
  @override
  late final GeneratedColumn<int> targetVerseId = GeneratedColumn<int>(
      'target_verse_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _sourceKeyMeta =
      const VerificationMeta('sourceKey');
  @override
  late final GeneratedColumn<String> sourceKey = GeneratedColumn<String>(
      'source_key', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _targetKeyMeta =
      const VerificationMeta('targetKey');
  @override
  late final GeneratedColumn<String> targetKey = GeneratedColumn<String>(
      'target_key', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, sourceVerseId, targetVerseId, sourceKey, targetKey];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cross_references';
  @override
  VerificationContext validateIntegrity(
      Insertable<DriftCrossReference> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('source_verse_id')) {
      context.handle(
          _sourceVerseIdMeta,
          sourceVerseId.isAcceptableOrUnknown(
              data['source_verse_id']!, _sourceVerseIdMeta));
    } else if (isInserting) {
      context.missing(_sourceVerseIdMeta);
    }
    if (data.containsKey('target_verse_id')) {
      context.handle(
          _targetVerseIdMeta,
          targetVerseId.isAcceptableOrUnknown(
              data['target_verse_id']!, _targetVerseIdMeta));
    } else if (isInserting) {
      context.missing(_targetVerseIdMeta);
    }
    if (data.containsKey('source_key')) {
      context.handle(_sourceKeyMeta,
          sourceKey.isAcceptableOrUnknown(data['source_key']!, _sourceKeyMeta));
    } else if (isInserting) {
      context.missing(_sourceKeyMeta);
    }
    if (data.containsKey('target_key')) {
      context.handle(_targetKeyMeta,
          targetKey.isAcceptableOrUnknown(data['target_key']!, _targetKeyMeta));
    } else if (isInserting) {
      context.missing(_targetKeyMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DriftCrossReference map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DriftCrossReference(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      sourceVerseId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}source_verse_id'])!,
      targetVerseId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}target_verse_id'])!,
      sourceKey: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}source_key'])!,
      targetKey: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}target_key'])!,
    );
  }

  @override
  $CrossReferencesTable createAlias(String alias) {
    return $CrossReferencesTable(attachedDatabase, alias);
  }
}

class DriftCrossReference extends DataClass
    implements Insertable<DriftCrossReference> {
  final int id;
  final int sourceVerseId;
  final int targetVerseId;
  final String sourceKey;
  final String targetKey;
  const DriftCrossReference(
      {required this.id,
      required this.sourceVerseId,
      required this.targetVerseId,
      required this.sourceKey,
      required this.targetKey});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['source_verse_id'] = Variable<int>(sourceVerseId);
    map['target_verse_id'] = Variable<int>(targetVerseId);
    map['source_key'] = Variable<String>(sourceKey);
    map['target_key'] = Variable<String>(targetKey);
    return map;
  }

  CrossReferencesCompanion toCompanion(bool nullToAbsent) {
    return CrossReferencesCompanion(
      id: Value(id),
      sourceVerseId: Value(sourceVerseId),
      targetVerseId: Value(targetVerseId),
      sourceKey: Value(sourceKey),
      targetKey: Value(targetKey),
    );
  }

  factory DriftCrossReference.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DriftCrossReference(
      id: serializer.fromJson<int>(json['id']),
      sourceVerseId: serializer.fromJson<int>(json['sourceVerseId']),
      targetVerseId: serializer.fromJson<int>(json['targetVerseId']),
      sourceKey: serializer.fromJson<String>(json['sourceKey']),
      targetKey: serializer.fromJson<String>(json['targetKey']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'sourceVerseId': serializer.toJson<int>(sourceVerseId),
      'targetVerseId': serializer.toJson<int>(targetVerseId),
      'sourceKey': serializer.toJson<String>(sourceKey),
      'targetKey': serializer.toJson<String>(targetKey),
    };
  }

  DriftCrossReference copyWith(
          {int? id,
          int? sourceVerseId,
          int? targetVerseId,
          String? sourceKey,
          String? targetKey}) =>
      DriftCrossReference(
        id: id ?? this.id,
        sourceVerseId: sourceVerseId ?? this.sourceVerseId,
        targetVerseId: targetVerseId ?? this.targetVerseId,
        sourceKey: sourceKey ?? this.sourceKey,
        targetKey: targetKey ?? this.targetKey,
      );
  DriftCrossReference copyWithCompanion(CrossReferencesCompanion data) {
    return DriftCrossReference(
      id: data.id.present ? data.id.value : this.id,
      sourceVerseId: data.sourceVerseId.present
          ? data.sourceVerseId.value
          : this.sourceVerseId,
      targetVerseId: data.targetVerseId.present
          ? data.targetVerseId.value
          : this.targetVerseId,
      sourceKey: data.sourceKey.present ? data.sourceKey.value : this.sourceKey,
      targetKey: data.targetKey.present ? data.targetKey.value : this.targetKey,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DriftCrossReference(')
          ..write('id: $id, ')
          ..write('sourceVerseId: $sourceVerseId, ')
          ..write('targetVerseId: $targetVerseId, ')
          ..write('sourceKey: $sourceKey, ')
          ..write('targetKey: $targetKey')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, sourceVerseId, targetVerseId, sourceKey, targetKey);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DriftCrossReference &&
          other.id == this.id &&
          other.sourceVerseId == this.sourceVerseId &&
          other.targetVerseId == this.targetVerseId &&
          other.sourceKey == this.sourceKey &&
          other.targetKey == this.targetKey);
}

class CrossReferencesCompanion extends UpdateCompanion<DriftCrossReference> {
  final Value<int> id;
  final Value<int> sourceVerseId;
  final Value<int> targetVerseId;
  final Value<String> sourceKey;
  final Value<String> targetKey;
  const CrossReferencesCompanion({
    this.id = const Value.absent(),
    this.sourceVerseId = const Value.absent(),
    this.targetVerseId = const Value.absent(),
    this.sourceKey = const Value.absent(),
    this.targetKey = const Value.absent(),
  });
  CrossReferencesCompanion.insert({
    this.id = const Value.absent(),
    required int sourceVerseId,
    required int targetVerseId,
    required String sourceKey,
    required String targetKey,
  })  : sourceVerseId = Value(sourceVerseId),
        targetVerseId = Value(targetVerseId),
        sourceKey = Value(sourceKey),
        targetKey = Value(targetKey);
  static Insertable<DriftCrossReference> custom({
    Expression<int>? id,
    Expression<int>? sourceVerseId,
    Expression<int>? targetVerseId,
    Expression<String>? sourceKey,
    Expression<String>? targetKey,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sourceVerseId != null) 'source_verse_id': sourceVerseId,
      if (targetVerseId != null) 'target_verse_id': targetVerseId,
      if (sourceKey != null) 'source_key': sourceKey,
      if (targetKey != null) 'target_key': targetKey,
    });
  }

  CrossReferencesCompanion copyWith(
      {Value<int>? id,
      Value<int>? sourceVerseId,
      Value<int>? targetVerseId,
      Value<String>? sourceKey,
      Value<String>? targetKey}) {
    return CrossReferencesCompanion(
      id: id ?? this.id,
      sourceVerseId: sourceVerseId ?? this.sourceVerseId,
      targetVerseId: targetVerseId ?? this.targetVerseId,
      sourceKey: sourceKey ?? this.sourceKey,
      targetKey: targetKey ?? this.targetKey,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (sourceVerseId.present) {
      map['source_verse_id'] = Variable<int>(sourceVerseId.value);
    }
    if (targetVerseId.present) {
      map['target_verse_id'] = Variable<int>(targetVerseId.value);
    }
    if (sourceKey.present) {
      map['source_key'] = Variable<String>(sourceKey.value);
    }
    if (targetKey.present) {
      map['target_key'] = Variable<String>(targetKey.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CrossReferencesCompanion(')
          ..write('id: $id, ')
          ..write('sourceVerseId: $sourceVerseId, ')
          ..write('targetVerseId: $targetVerseId, ')
          ..write('sourceKey: $sourceKey, ')
          ..write('targetKey: $targetKey')
          ..write(')'))
        .toString();
  }
}

class $UserNotesTable extends UserNotes
    with TableInfo<$UserNotesTable, DriftUserNote> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserNotesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _contentMeta =
      const VerificationMeta('content');
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
      'content', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _lastModifiedMeta =
      const VerificationMeta('lastModified');
  @override
  late final GeneratedColumn<DateTime> lastModified = GeneratedColumn<DateTime>(
      'last_modified', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _tagsMeta = const VerificationMeta('tags');
  @override
  late final GeneratedColumn<String> tags = GeneratedColumn<String>(
      'tags', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _verseIdMeta =
      const VerificationMeta('verseId');
  @override
  late final GeneratedColumn<int> verseId = GeneratedColumn<int>(
      'verse_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _verseKeyMeta =
      const VerificationMeta('verseKey');
  @override
  late final GeneratedColumn<String> verseKey = GeneratedColumn<String>(
      'verse_key', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, title, content, lastModified, tags, verseId, verseKey];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_notes';
  @override
  VerificationContext validateIntegrity(Insertable<DriftUserNote> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    }
    if (data.containsKey('content')) {
      context.handle(_contentMeta,
          content.isAcceptableOrUnknown(data['content']!, _contentMeta));
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('last_modified')) {
      context.handle(
          _lastModifiedMeta,
          lastModified.isAcceptableOrUnknown(
              data['last_modified']!, _lastModifiedMeta));
    } else if (isInserting) {
      context.missing(_lastModifiedMeta);
    }
    if (data.containsKey('tags')) {
      context.handle(
          _tagsMeta, tags.isAcceptableOrUnknown(data['tags']!, _tagsMeta));
    } else if (isInserting) {
      context.missing(_tagsMeta);
    }
    if (data.containsKey('verse_id')) {
      context.handle(_verseIdMeta,
          verseId.isAcceptableOrUnknown(data['verse_id']!, _verseIdMeta));
    } else if (isInserting) {
      context.missing(_verseIdMeta);
    }
    if (data.containsKey('verse_key')) {
      context.handle(_verseKeyMeta,
          verseKey.isAcceptableOrUnknown(data['verse_key']!, _verseKeyMeta));
    } else if (isInserting) {
      context.missing(_verseKeyMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DriftUserNote map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DriftUserNote(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title']),
      content: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}content'])!,
      lastModified: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}last_modified'])!,
      tags: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}tags'])!,
      verseId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}verse_id'])!,
      verseKey: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}verse_key'])!,
    );
  }

  @override
  $UserNotesTable createAlias(String alias) {
    return $UserNotesTable(attachedDatabase, alias);
  }
}

class DriftUserNote extends DataClass implements Insertable<DriftUserNote> {
  final int id;
  final String? title;
  final String content;
  final DateTime lastModified;
  final String tags;
  final int verseId;
  final String verseKey;
  const DriftUserNote(
      {required this.id,
      this.title,
      required this.content,
      required this.lastModified,
      required this.tags,
      required this.verseId,
      required this.verseKey});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || title != null) {
      map['title'] = Variable<String>(title);
    }
    map['content'] = Variable<String>(content);
    map['last_modified'] = Variable<DateTime>(lastModified);
    map['tags'] = Variable<String>(tags);
    map['verse_id'] = Variable<int>(verseId);
    map['verse_key'] = Variable<String>(verseKey);
    return map;
  }

  UserNotesCompanion toCompanion(bool nullToAbsent) {
    return UserNotesCompanion(
      id: Value(id),
      title:
          title == null && nullToAbsent ? const Value.absent() : Value(title),
      content: Value(content),
      lastModified: Value(lastModified),
      tags: Value(tags),
      verseId: Value(verseId),
      verseKey: Value(verseKey),
    );
  }

  factory DriftUserNote.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DriftUserNote(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String?>(json['title']),
      content: serializer.fromJson<String>(json['content']),
      lastModified: serializer.fromJson<DateTime>(json['lastModified']),
      tags: serializer.fromJson<String>(json['tags']),
      verseId: serializer.fromJson<int>(json['verseId']),
      verseKey: serializer.fromJson<String>(json['verseKey']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String?>(title),
      'content': serializer.toJson<String>(content),
      'lastModified': serializer.toJson<DateTime>(lastModified),
      'tags': serializer.toJson<String>(tags),
      'verseId': serializer.toJson<int>(verseId),
      'verseKey': serializer.toJson<String>(verseKey),
    };
  }

  DriftUserNote copyWith(
          {int? id,
          Value<String?> title = const Value.absent(),
          String? content,
          DateTime? lastModified,
          String? tags,
          int? verseId,
          String? verseKey}) =>
      DriftUserNote(
        id: id ?? this.id,
        title: title.present ? title.value : this.title,
        content: content ?? this.content,
        lastModified: lastModified ?? this.lastModified,
        tags: tags ?? this.tags,
        verseId: verseId ?? this.verseId,
        verseKey: verseKey ?? this.verseKey,
      );
  DriftUserNote copyWithCompanion(UserNotesCompanion data) {
    return DriftUserNote(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      content: data.content.present ? data.content.value : this.content,
      lastModified: data.lastModified.present
          ? data.lastModified.value
          : this.lastModified,
      tags: data.tags.present ? data.tags.value : this.tags,
      verseId: data.verseId.present ? data.verseId.value : this.verseId,
      verseKey: data.verseKey.present ? data.verseKey.value : this.verseKey,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DriftUserNote(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('content: $content, ')
          ..write('lastModified: $lastModified, ')
          ..write('tags: $tags, ')
          ..write('verseId: $verseId, ')
          ..write('verseKey: $verseKey')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, title, content, lastModified, tags, verseId, verseKey);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DriftUserNote &&
          other.id == this.id &&
          other.title == this.title &&
          other.content == this.content &&
          other.lastModified == this.lastModified &&
          other.tags == this.tags &&
          other.verseId == this.verseId &&
          other.verseKey == this.verseKey);
}

class UserNotesCompanion extends UpdateCompanion<DriftUserNote> {
  final Value<int> id;
  final Value<String?> title;
  final Value<String> content;
  final Value<DateTime> lastModified;
  final Value<String> tags;
  final Value<int> verseId;
  final Value<String> verseKey;
  const UserNotesCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.content = const Value.absent(),
    this.lastModified = const Value.absent(),
    this.tags = const Value.absent(),
    this.verseId = const Value.absent(),
    this.verseKey = const Value.absent(),
  });
  UserNotesCompanion.insert({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    required String content,
    required DateTime lastModified,
    required String tags,
    required int verseId,
    required String verseKey,
  })  : content = Value(content),
        lastModified = Value(lastModified),
        tags = Value(tags),
        verseId = Value(verseId),
        verseKey = Value(verseKey);
  static Insertable<DriftUserNote> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<String>? content,
    Expression<DateTime>? lastModified,
    Expression<String>? tags,
    Expression<int>? verseId,
    Expression<String>? verseKey,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (content != null) 'content': content,
      if (lastModified != null) 'last_modified': lastModified,
      if (tags != null) 'tags': tags,
      if (verseId != null) 'verse_id': verseId,
      if (verseKey != null) 'verse_key': verseKey,
    });
  }

  UserNotesCompanion copyWith(
      {Value<int>? id,
      Value<String?>? title,
      Value<String>? content,
      Value<DateTime>? lastModified,
      Value<String>? tags,
      Value<int>? verseId,
      Value<String>? verseKey}) {
    return UserNotesCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      lastModified: lastModified ?? this.lastModified,
      tags: tags ?? this.tags,
      verseId: verseId ?? this.verseId,
      verseKey: verseKey ?? this.verseKey,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (lastModified.present) {
      map['last_modified'] = Variable<DateTime>(lastModified.value);
    }
    if (tags.present) {
      map['tags'] = Variable<String>(tags.value);
    }
    if (verseId.present) {
      map['verse_id'] = Variable<int>(verseId.value);
    }
    if (verseKey.present) {
      map['verse_key'] = Variable<String>(verseKey.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserNotesCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('content: $content, ')
          ..write('lastModified: $lastModified, ')
          ..write('tags: $tags, ')
          ..write('verseId: $verseId, ')
          ..write('verseKey: $verseKey')
          ..write(')'))
        .toString();
  }
}

class $ReflectionsTable extends Reflections
    with TableInfo<$ReflectionsTable, DriftReflection> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReflectionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _authorMeta = const VerificationMeta('author');
  @override
  late final GeneratedColumn<String> author = GeneratedColumn<String>(
      'author', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _contentMeta =
      const VerificationMeta('content');
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
      'content', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _associatedChapterKeyMeta =
      const VerificationMeta('associatedChapterKey');
  @override
  late final GeneratedColumn<String> associatedChapterKey =
      GeneratedColumn<String>('associated_chapter_key', aliasedName, false,
          type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, author, content, associatedChapterKey, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'reflections';
  @override
  VerificationContext validateIntegrity(Insertable<DriftReflection> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('author')) {
      context.handle(_authorMeta,
          author.isAcceptableOrUnknown(data['author']!, _authorMeta));
    } else if (isInserting) {
      context.missing(_authorMeta);
    }
    if (data.containsKey('content')) {
      context.handle(_contentMeta,
          content.isAcceptableOrUnknown(data['content']!, _contentMeta));
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('associated_chapter_key')) {
      context.handle(
          _associatedChapterKeyMeta,
          associatedChapterKey.isAcceptableOrUnknown(
              data['associated_chapter_key']!, _associatedChapterKeyMeta));
    } else if (isInserting) {
      context.missing(_associatedChapterKeyMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DriftReflection map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DriftReflection(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      author: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}author'])!,
      content: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}content'])!,
      associatedChapterKey: attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}associated_chapter_key'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $ReflectionsTable createAlias(String alias) {
    return $ReflectionsTable(attachedDatabase, alias);
  }
}

class DriftReflection extends DataClass implements Insertable<DriftReflection> {
  final int id;
  final String author;
  final String content;
  final String associatedChapterKey;
  final DateTime createdAt;
  const DriftReflection(
      {required this.id,
      required this.author,
      required this.content,
      required this.associatedChapterKey,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['author'] = Variable<String>(author);
    map['content'] = Variable<String>(content);
    map['associated_chapter_key'] = Variable<String>(associatedChapterKey);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ReflectionsCompanion toCompanion(bool nullToAbsent) {
    return ReflectionsCompanion(
      id: Value(id),
      author: Value(author),
      content: Value(content),
      associatedChapterKey: Value(associatedChapterKey),
      createdAt: Value(createdAt),
    );
  }

  factory DriftReflection.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DriftReflection(
      id: serializer.fromJson<int>(json['id']),
      author: serializer.fromJson<String>(json['author']),
      content: serializer.fromJson<String>(json['content']),
      associatedChapterKey:
          serializer.fromJson<String>(json['associatedChapterKey']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'author': serializer.toJson<String>(author),
      'content': serializer.toJson<String>(content),
      'associatedChapterKey': serializer.toJson<String>(associatedChapterKey),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  DriftReflection copyWith(
          {int? id,
          String? author,
          String? content,
          String? associatedChapterKey,
          DateTime? createdAt}) =>
      DriftReflection(
        id: id ?? this.id,
        author: author ?? this.author,
        content: content ?? this.content,
        associatedChapterKey: associatedChapterKey ?? this.associatedChapterKey,
        createdAt: createdAt ?? this.createdAt,
      );
  DriftReflection copyWithCompanion(ReflectionsCompanion data) {
    return DriftReflection(
      id: data.id.present ? data.id.value : this.id,
      author: data.author.present ? data.author.value : this.author,
      content: data.content.present ? data.content.value : this.content,
      associatedChapterKey: data.associatedChapterKey.present
          ? data.associatedChapterKey.value
          : this.associatedChapterKey,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DriftReflection(')
          ..write('id: $id, ')
          ..write('author: $author, ')
          ..write('content: $content, ')
          ..write('associatedChapterKey: $associatedChapterKey, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, author, content, associatedChapterKey, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DriftReflection &&
          other.id == this.id &&
          other.author == this.author &&
          other.content == this.content &&
          other.associatedChapterKey == this.associatedChapterKey &&
          other.createdAt == this.createdAt);
}

class ReflectionsCompanion extends UpdateCompanion<DriftReflection> {
  final Value<int> id;
  final Value<String> author;
  final Value<String> content;
  final Value<String> associatedChapterKey;
  final Value<DateTime> createdAt;
  const ReflectionsCompanion({
    this.id = const Value.absent(),
    this.author = const Value.absent(),
    this.content = const Value.absent(),
    this.associatedChapterKey = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  ReflectionsCompanion.insert({
    this.id = const Value.absent(),
    required String author,
    required String content,
    required String associatedChapterKey,
    required DateTime createdAt,
  })  : author = Value(author),
        content = Value(content),
        associatedChapterKey = Value(associatedChapterKey),
        createdAt = Value(createdAt);
  static Insertable<DriftReflection> custom({
    Expression<int>? id,
    Expression<String>? author,
    Expression<String>? content,
    Expression<String>? associatedChapterKey,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (author != null) 'author': author,
      if (content != null) 'content': content,
      if (associatedChapterKey != null)
        'associated_chapter_key': associatedChapterKey,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  ReflectionsCompanion copyWith(
      {Value<int>? id,
      Value<String>? author,
      Value<String>? content,
      Value<String>? associatedChapterKey,
      Value<DateTime>? createdAt}) {
    return ReflectionsCompanion(
      id: id ?? this.id,
      author: author ?? this.author,
      content: content ?? this.content,
      associatedChapterKey: associatedChapterKey ?? this.associatedChapterKey,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (author.present) {
      map['author'] = Variable<String>(author.value);
    }
    if (content.present) {
      map['content'] = Variable<String>(content.value);
    }
    if (associatedChapterKey.present) {
      map['associated_chapter_key'] =
          Variable<String>(associatedChapterKey.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReflectionsCompanion(')
          ..write('id: $id, ')
          ..write('author: $author, ')
          ..write('content: $content, ')
          ..write('associatedChapterKey: $associatedChapterKey, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $FavoriteBlocksTable extends FavoriteBlocks
    with TableInfo<$FavoriteBlocksTable, DriftFavoriteBlock> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FavoriteBlocksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _versionIdMeta =
      const VerificationMeta('versionId');
  @override
  late final GeneratedColumn<String> versionId = GeneratedColumn<String>(
      'version_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _bookIdMeta = const VerificationMeta('bookId');
  @override
  late final GeneratedColumn<int> bookId = GeneratedColumn<int>(
      'book_id', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _bookNameMeta =
      const VerificationMeta('bookName');
  @override
  late final GeneratedColumn<String> bookName = GeneratedColumn<String>(
      'book_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _chapterMeta =
      const VerificationMeta('chapter');
  @override
  late final GeneratedColumn<int> chapter = GeneratedColumn<int>(
      'chapter', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _versesMeta = const VerificationMeta('verses');
  @override
  late final GeneratedColumn<String> verses = GeneratedColumn<String>(
      'verses', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _verseTextMeta =
      const VerificationMeta('verseText');
  @override
  late final GeneratedColumn<String> verseText = GeneratedColumn<String>(
      'text', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _timestampMeta =
      const VerificationMeta('timestamp');
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
      'timestamp', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, versionId, bookId, bookName, chapter, verses, verseText, timestamp];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'favorite_blocks';
  @override
  VerificationContext validateIntegrity(Insertable<DriftFavoriteBlock> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('version_id')) {
      context.handle(_versionIdMeta,
          versionId.isAcceptableOrUnknown(data['version_id']!, _versionIdMeta));
    } else if (isInserting) {
      context.missing(_versionIdMeta);
    }
    if (data.containsKey('book_id')) {
      context.handle(_bookIdMeta,
          bookId.isAcceptableOrUnknown(data['book_id']!, _bookIdMeta));
    } else if (isInserting) {
      context.missing(_bookIdMeta);
    }
    if (data.containsKey('book_name')) {
      context.handle(_bookNameMeta,
          bookName.isAcceptableOrUnknown(data['book_name']!, _bookNameMeta));
    } else if (isInserting) {
      context.missing(_bookNameMeta);
    }
    if (data.containsKey('chapter')) {
      context.handle(_chapterMeta,
          chapter.isAcceptableOrUnknown(data['chapter']!, _chapterMeta));
    } else if (isInserting) {
      context.missing(_chapterMeta);
    }
    if (data.containsKey('verses')) {
      context.handle(_versesMeta,
          verses.isAcceptableOrUnknown(data['verses']!, _versesMeta));
    } else if (isInserting) {
      context.missing(_versesMeta);
    }
    if (data.containsKey('text')) {
      context.handle(_verseTextMeta,
          verseText.isAcceptableOrUnknown(data['text']!, _verseTextMeta));
    } else if (isInserting) {
      context.missing(_verseTextMeta);
    }
    if (data.containsKey('timestamp')) {
      context.handle(_timestampMeta,
          timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta));
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DriftFavoriteBlock map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DriftFavoriteBlock(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      versionId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}version_id'])!,
      bookId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}book_id'])!,
      bookName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}book_name'])!,
      chapter: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}chapter'])!,
      verses: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}verses'])!,
      verseText: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}text'])!,
      timestamp: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}timestamp'])!,
    );
  }

  @override
  $FavoriteBlocksTable createAlias(String alias) {
    return $FavoriteBlocksTable(attachedDatabase, alias);
  }
}

class DriftFavoriteBlock extends DataClass
    implements Insertable<DriftFavoriteBlock> {
  final int id;
  final String versionId;
  final int bookId;
  final String bookName;
  final int chapter;
  final String verses;
  final String verseText;
  final DateTime timestamp;
  const DriftFavoriteBlock(
      {required this.id,
      required this.versionId,
      required this.bookId,
      required this.bookName,
      required this.chapter,
      required this.verses,
      required this.verseText,
      required this.timestamp});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['version_id'] = Variable<String>(versionId);
    map['book_id'] = Variable<int>(bookId);
    map['book_name'] = Variable<String>(bookName);
    map['chapter'] = Variable<int>(chapter);
    map['verses'] = Variable<String>(verses);
    map['text'] = Variable<String>(verseText);
    map['timestamp'] = Variable<DateTime>(timestamp);
    return map;
  }

  FavoriteBlocksCompanion toCompanion(bool nullToAbsent) {
    return FavoriteBlocksCompanion(
      id: Value(id),
      versionId: Value(versionId),
      bookId: Value(bookId),
      bookName: Value(bookName),
      chapter: Value(chapter),
      verses: Value(verses),
      verseText: Value(verseText),
      timestamp: Value(timestamp),
    );
  }

  factory DriftFavoriteBlock.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DriftFavoriteBlock(
      id: serializer.fromJson<int>(json['id']),
      versionId: serializer.fromJson<String>(json['versionId']),
      bookId: serializer.fromJson<int>(json['bookId']),
      bookName: serializer.fromJson<String>(json['bookName']),
      chapter: serializer.fromJson<int>(json['chapter']),
      verses: serializer.fromJson<String>(json['verses']),
      verseText: serializer.fromJson<String>(json['verseText']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'versionId': serializer.toJson<String>(versionId),
      'bookId': serializer.toJson<int>(bookId),
      'bookName': serializer.toJson<String>(bookName),
      'chapter': serializer.toJson<int>(chapter),
      'verses': serializer.toJson<String>(verses),
      'verseText': serializer.toJson<String>(verseText),
      'timestamp': serializer.toJson<DateTime>(timestamp),
    };
  }

  DriftFavoriteBlock copyWith(
          {int? id,
          String? versionId,
          int? bookId,
          String? bookName,
          int? chapter,
          String? verses,
          String? verseText,
          DateTime? timestamp}) =>
      DriftFavoriteBlock(
        id: id ?? this.id,
        versionId: versionId ?? this.versionId,
        bookId: bookId ?? this.bookId,
        bookName: bookName ?? this.bookName,
        chapter: chapter ?? this.chapter,
        verses: verses ?? this.verses,
        verseText: verseText ?? this.verseText,
        timestamp: timestamp ?? this.timestamp,
      );
  DriftFavoriteBlock copyWithCompanion(FavoriteBlocksCompanion data) {
    return DriftFavoriteBlock(
      id: data.id.present ? data.id.value : this.id,
      versionId: data.versionId.present ? data.versionId.value : this.versionId,
      bookId: data.bookId.present ? data.bookId.value : this.bookId,
      bookName: data.bookName.present ? data.bookName.value : this.bookName,
      chapter: data.chapter.present ? data.chapter.value : this.chapter,
      verses: data.verses.present ? data.verses.value : this.verses,
      verseText: data.verseText.present ? data.verseText.value : this.verseText,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DriftFavoriteBlock(')
          ..write('id: $id, ')
          ..write('versionId: $versionId, ')
          ..write('bookId: $bookId, ')
          ..write('bookName: $bookName, ')
          ..write('chapter: $chapter, ')
          ..write('verses: $verses, ')
          ..write('verseText: $verseText, ')
          ..write('timestamp: $timestamp')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, versionId, bookId, bookName, chapter, verses, verseText, timestamp);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DriftFavoriteBlock &&
          other.id == this.id &&
          other.versionId == this.versionId &&
          other.bookId == this.bookId &&
          other.bookName == this.bookName &&
          other.chapter == this.chapter &&
          other.verses == this.verses &&
          other.verseText == this.verseText &&
          other.timestamp == this.timestamp);
}

class FavoriteBlocksCompanion extends UpdateCompanion<DriftFavoriteBlock> {
  final Value<int> id;
  final Value<String> versionId;
  final Value<int> bookId;
  final Value<String> bookName;
  final Value<int> chapter;
  final Value<String> verses;
  final Value<String> verseText;
  final Value<DateTime> timestamp;
  const FavoriteBlocksCompanion({
    this.id = const Value.absent(),
    this.versionId = const Value.absent(),
    this.bookId = const Value.absent(),
    this.bookName = const Value.absent(),
    this.chapter = const Value.absent(),
    this.verses = const Value.absent(),
    this.verseText = const Value.absent(),
    this.timestamp = const Value.absent(),
  });
  FavoriteBlocksCompanion.insert({
    this.id = const Value.absent(),
    required String versionId,
    required int bookId,
    required String bookName,
    required int chapter,
    required String verses,
    required String verseText,
    required DateTime timestamp,
  })  : versionId = Value(versionId),
        bookId = Value(bookId),
        bookName = Value(bookName),
        chapter = Value(chapter),
        verses = Value(verses),
        verseText = Value(verseText),
        timestamp = Value(timestamp);
  static Insertable<DriftFavoriteBlock> custom({
    Expression<int>? id,
    Expression<String>? versionId,
    Expression<int>? bookId,
    Expression<String>? bookName,
    Expression<int>? chapter,
    Expression<String>? verses,
    Expression<String>? verseText,
    Expression<DateTime>? timestamp,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (versionId != null) 'version_id': versionId,
      if (bookId != null) 'book_id': bookId,
      if (bookName != null) 'book_name': bookName,
      if (chapter != null) 'chapter': chapter,
      if (verses != null) 'verses': verses,
      if (verseText != null) 'text': verseText,
      if (timestamp != null) 'timestamp': timestamp,
    });
  }

  FavoriteBlocksCompanion copyWith(
      {Value<int>? id,
      Value<String>? versionId,
      Value<int>? bookId,
      Value<String>? bookName,
      Value<int>? chapter,
      Value<String>? verses,
      Value<String>? verseText,
      Value<DateTime>? timestamp}) {
    return FavoriteBlocksCompanion(
      id: id ?? this.id,
      versionId: versionId ?? this.versionId,
      bookId: bookId ?? this.bookId,
      bookName: bookName ?? this.bookName,
      chapter: chapter ?? this.chapter,
      verses: verses ?? this.verses,
      verseText: verseText ?? this.verseText,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (versionId.present) {
      map['version_id'] = Variable<String>(versionId.value);
    }
    if (bookId.present) {
      map['book_id'] = Variable<int>(bookId.value);
    }
    if (bookName.present) {
      map['book_name'] = Variable<String>(bookName.value);
    }
    if (chapter.present) {
      map['chapter'] = Variable<int>(chapter.value);
    }
    if (verses.present) {
      map['verses'] = Variable<String>(verses.value);
    }
    if (verseText.present) {
      map['text'] = Variable<String>(verseText.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FavoriteBlocksCompanion(')
          ..write('id: $id, ')
          ..write('versionId: $versionId, ')
          ..write('bookId: $bookId, ')
          ..write('bookName: $bookName, ')
          ..write('chapter: $chapter, ')
          ..write('verses: $verses, ')
          ..write('verseText: $verseText, ')
          ..write('timestamp: $timestamp')
          ..write(')'))
        .toString();
  }
}

class $AppSettingsTableTable extends AppSettingsTable
    with TableInfo<$AppSettingsTableTable, DriftAppSettings> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppSettingsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _lastVersionMeta =
      const VerificationMeta('lastVersion');
  @override
  late final GeneratedColumn<String> lastVersion = GeneratedColumn<String>(
      'last_version', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _lastBookIdMeta =
      const VerificationMeta('lastBookId');
  @override
  late final GeneratedColumn<int> lastBookId = GeneratedColumn<int>(
      'last_book_id', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _lastChapterMeta =
      const VerificationMeta('lastChapter');
  @override
  late final GeneratedColumn<int> lastChapter = GeneratedColumn<int>(
      'last_chapter', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _readingThemeMeta =
      const VerificationMeta('readingTheme');
  @override
  late final GeneratedColumn<String> readingTheme = GeneratedColumn<String>(
      'reading_theme', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('light'));
  static const VerificationMeta _lastRouteMeta =
      const VerificationMeta('lastRoute');
  @override
  late final GeneratedColumn<String> lastRoute = GeneratedColumn<String>(
      'last_route', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _migrationDoneMeta =
      const VerificationMeta('migrationDone');
  @override
  late final GeneratedColumn<bool> migrationDone = GeneratedColumn<bool>(
      'migration_done', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("migration_done" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        lastVersion,
        lastBookId,
        lastChapter,
        readingTheme,
        lastRoute,
        migrationDone
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_settings_table';
  @override
  VerificationContext validateIntegrity(Insertable<DriftAppSettings> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('last_version')) {
      context.handle(
          _lastVersionMeta,
          lastVersion.isAcceptableOrUnknown(
              data['last_version']!, _lastVersionMeta));
    } else if (isInserting) {
      context.missing(_lastVersionMeta);
    }
    if (data.containsKey('last_book_id')) {
      context.handle(
          _lastBookIdMeta,
          lastBookId.isAcceptableOrUnknown(
              data['last_book_id']!, _lastBookIdMeta));
    }
    if (data.containsKey('last_chapter')) {
      context.handle(
          _lastChapterMeta,
          lastChapter.isAcceptableOrUnknown(
              data['last_chapter']!, _lastChapterMeta));
    }
    if (data.containsKey('reading_theme')) {
      context.handle(
          _readingThemeMeta,
          readingTheme.isAcceptableOrUnknown(
              data['reading_theme']!, _readingThemeMeta));
    }
    if (data.containsKey('last_route')) {
      context.handle(_lastRouteMeta,
          lastRoute.isAcceptableOrUnknown(data['last_route']!, _lastRouteMeta));
    }
    if (data.containsKey('migration_done')) {
      context.handle(
          _migrationDoneMeta,
          migrationDone.isAcceptableOrUnknown(
              data['migration_done']!, _migrationDoneMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DriftAppSettings map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DriftAppSettings(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      lastVersion: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}last_version'])!,
      lastBookId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}last_book_id']),
      lastChapter: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}last_chapter']),
      readingTheme: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}reading_theme'])!,
      lastRoute: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}last_route']),
      migrationDone: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}migration_done'])!,
    );
  }

  @override
  $AppSettingsTableTable createAlias(String alias) {
    return $AppSettingsTableTable(attachedDatabase, alias);
  }
}

class DriftAppSettings extends DataClass
    implements Insertable<DriftAppSettings> {
  final int id;
  final String lastVersion;
  final int? lastBookId;
  final int? lastChapter;
  final String readingTheme;
  final String? lastRoute;
  final bool migrationDone;
  const DriftAppSettings(
      {required this.id,
      required this.lastVersion,
      this.lastBookId,
      this.lastChapter,
      required this.readingTheme,
      this.lastRoute,
      required this.migrationDone});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['last_version'] = Variable<String>(lastVersion);
    if (!nullToAbsent || lastBookId != null) {
      map['last_book_id'] = Variable<int>(lastBookId);
    }
    if (!nullToAbsent || lastChapter != null) {
      map['last_chapter'] = Variable<int>(lastChapter);
    }
    map['reading_theme'] = Variable<String>(readingTheme);
    if (!nullToAbsent || lastRoute != null) {
      map['last_route'] = Variable<String>(lastRoute);
    }
    map['migration_done'] = Variable<bool>(migrationDone);
    return map;
  }

  AppSettingsTableCompanion toCompanion(bool nullToAbsent) {
    return AppSettingsTableCompanion(
      id: Value(id),
      lastVersion: Value(lastVersion),
      lastBookId: lastBookId == null && nullToAbsent
          ? const Value.absent()
          : Value(lastBookId),
      lastChapter: lastChapter == null && nullToAbsent
          ? const Value.absent()
          : Value(lastChapter),
      readingTheme: Value(readingTheme),
      lastRoute: lastRoute == null && nullToAbsent
          ? const Value.absent()
          : Value(lastRoute),
      migrationDone: Value(migrationDone),
    );
  }

  factory DriftAppSettings.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DriftAppSettings(
      id: serializer.fromJson<int>(json['id']),
      lastVersion: serializer.fromJson<String>(json['lastVersion']),
      lastBookId: serializer.fromJson<int?>(json['lastBookId']),
      lastChapter: serializer.fromJson<int?>(json['lastChapter']),
      readingTheme: serializer.fromJson<String>(json['readingTheme']),
      lastRoute: serializer.fromJson<String?>(json['lastRoute']),
      migrationDone: serializer.fromJson<bool>(json['migrationDone']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'lastVersion': serializer.toJson<String>(lastVersion),
      'lastBookId': serializer.toJson<int?>(lastBookId),
      'lastChapter': serializer.toJson<int?>(lastChapter),
      'readingTheme': serializer.toJson<String>(readingTheme),
      'lastRoute': serializer.toJson<String?>(lastRoute),
      'migrationDone': serializer.toJson<bool>(migrationDone),
    };
  }

  DriftAppSettings copyWith(
          {int? id,
          String? lastVersion,
          Value<int?> lastBookId = const Value.absent(),
          Value<int?> lastChapter = const Value.absent(),
          String? readingTheme,
          Value<String?> lastRoute = const Value.absent(),
          bool? migrationDone}) =>
      DriftAppSettings(
        id: id ?? this.id,
        lastVersion: lastVersion ?? this.lastVersion,
        lastBookId: lastBookId.present ? lastBookId.value : this.lastBookId,
        lastChapter: lastChapter.present ? lastChapter.value : this.lastChapter,
        readingTheme: readingTheme ?? this.readingTheme,
        lastRoute: lastRoute.present ? lastRoute.value : this.lastRoute,
        migrationDone: migrationDone ?? this.migrationDone,
      );
  DriftAppSettings copyWithCompanion(AppSettingsTableCompanion data) {
    return DriftAppSettings(
      id: data.id.present ? data.id.value : this.id,
      lastVersion:
          data.lastVersion.present ? data.lastVersion.value : this.lastVersion,
      lastBookId:
          data.lastBookId.present ? data.lastBookId.value : this.lastBookId,
      lastChapter:
          data.lastChapter.present ? data.lastChapter.value : this.lastChapter,
      readingTheme: data.readingTheme.present
          ? data.readingTheme.value
          : this.readingTheme,
      lastRoute: data.lastRoute.present ? data.lastRoute.value : this.lastRoute,
      migrationDone: data.migrationDone.present
          ? data.migrationDone.value
          : this.migrationDone,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DriftAppSettings(')
          ..write('id: $id, ')
          ..write('lastVersion: $lastVersion, ')
          ..write('lastBookId: $lastBookId, ')
          ..write('lastChapter: $lastChapter, ')
          ..write('readingTheme: $readingTheme, ')
          ..write('lastRoute: $lastRoute, ')
          ..write('migrationDone: $migrationDone')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, lastVersion, lastBookId, lastChapter,
      readingTheme, lastRoute, migrationDone);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DriftAppSettings &&
          other.id == this.id &&
          other.lastVersion == this.lastVersion &&
          other.lastBookId == this.lastBookId &&
          other.lastChapter == this.lastChapter &&
          other.readingTheme == this.readingTheme &&
          other.lastRoute == this.lastRoute &&
          other.migrationDone == this.migrationDone);
}

class AppSettingsTableCompanion extends UpdateCompanion<DriftAppSettings> {
  final Value<int> id;
  final Value<String> lastVersion;
  final Value<int?> lastBookId;
  final Value<int?> lastChapter;
  final Value<String> readingTheme;
  final Value<String?> lastRoute;
  final Value<bool> migrationDone;
  const AppSettingsTableCompanion({
    this.id = const Value.absent(),
    this.lastVersion = const Value.absent(),
    this.lastBookId = const Value.absent(),
    this.lastChapter = const Value.absent(),
    this.readingTheme = const Value.absent(),
    this.lastRoute = const Value.absent(),
    this.migrationDone = const Value.absent(),
  });
  AppSettingsTableCompanion.insert({
    this.id = const Value.absent(),
    required String lastVersion,
    this.lastBookId = const Value.absent(),
    this.lastChapter = const Value.absent(),
    this.readingTheme = const Value.absent(),
    this.lastRoute = const Value.absent(),
    this.migrationDone = const Value.absent(),
  }) : lastVersion = Value(lastVersion);
  static Insertable<DriftAppSettings> custom({
    Expression<int>? id,
    Expression<String>? lastVersion,
    Expression<int>? lastBookId,
    Expression<int>? lastChapter,
    Expression<String>? readingTheme,
    Expression<String>? lastRoute,
    Expression<bool>? migrationDone,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (lastVersion != null) 'last_version': lastVersion,
      if (lastBookId != null) 'last_book_id': lastBookId,
      if (lastChapter != null) 'last_chapter': lastChapter,
      if (readingTheme != null) 'reading_theme': readingTheme,
      if (lastRoute != null) 'last_route': lastRoute,
      if (migrationDone != null) 'migration_done': migrationDone,
    });
  }

  AppSettingsTableCompanion copyWith(
      {Value<int>? id,
      Value<String>? lastVersion,
      Value<int?>? lastBookId,
      Value<int?>? lastChapter,
      Value<String>? readingTheme,
      Value<String?>? lastRoute,
      Value<bool>? migrationDone}) {
    return AppSettingsTableCompanion(
      id: id ?? this.id,
      lastVersion: lastVersion ?? this.lastVersion,
      lastBookId: lastBookId ?? this.lastBookId,
      lastChapter: lastChapter ?? this.lastChapter,
      readingTheme: readingTheme ?? this.readingTheme,
      lastRoute: lastRoute ?? this.lastRoute,
      migrationDone: migrationDone ?? this.migrationDone,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (lastVersion.present) {
      map['last_version'] = Variable<String>(lastVersion.value);
    }
    if (lastBookId.present) {
      map['last_book_id'] = Variable<int>(lastBookId.value);
    }
    if (lastChapter.present) {
      map['last_chapter'] = Variable<int>(lastChapter.value);
    }
    if (readingTheme.present) {
      map['reading_theme'] = Variable<String>(readingTheme.value);
    }
    if (lastRoute.present) {
      map['last_route'] = Variable<String>(lastRoute.value);
    }
    if (migrationDone.present) {
      map['migration_done'] = Variable<bool>(migrationDone.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingsTableCompanion(')
          ..write('id: $id, ')
          ..write('lastVersion: $lastVersion, ')
          ..write('lastBookId: $lastBookId, ')
          ..write('lastChapter: $lastChapter, ')
          ..write('readingTheme: $readingTheme, ')
          ..write('lastRoute: $lastRoute, ')
          ..write('migrationDone: $migrationDone')
          ..write(')'))
        .toString();
  }
}

class $SermonsTable extends Sermons with TableInfo<$SermonsTable, DriftSermon> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SermonsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _tagsMeta = const VerificationMeta('tags');
  @override
  late final GeneratedColumn<String> tags = GeneratedColumn<String>(
      'tags', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _segmentsMeta =
      const VerificationMeta('segments');
  @override
  late final GeneratedColumn<String> segments = GeneratedColumn<String>(
      'segments', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _lastModifiedMeta =
      const VerificationMeta('lastModified');
  @override
  late final GeneratedColumn<DateTime> lastModified = GeneratedColumn<DateTime>(
      'last_modified', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _isFavoriteMeta =
      const VerificationMeta('isFavorite');
  @override
  late final GeneratedColumn<bool> isFavorite = GeneratedColumn<bool>(
      'is_favorite', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_favorite" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _mainHymnKeyMeta =
      const VerificationMeta('mainHymnKey');
  @override
  late final GeneratedColumn<String> mainHymnKey = GeneratedColumn<String>(
      'main_hymn_key', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns =>
      [id, title, tags, segments, lastModified, isFavorite, mainHymnKey];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sermons';
  @override
  VerificationContext validateIntegrity(Insertable<DriftSermon> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('tags')) {
      context.handle(
          _tagsMeta, tags.isAcceptableOrUnknown(data['tags']!, _tagsMeta));
    } else if (isInserting) {
      context.missing(_tagsMeta);
    }
    if (data.containsKey('segments')) {
      context.handle(_segmentsMeta,
          segments.isAcceptableOrUnknown(data['segments']!, _segmentsMeta));
    } else if (isInserting) {
      context.missing(_segmentsMeta);
    }
    if (data.containsKey('last_modified')) {
      context.handle(
          _lastModifiedMeta,
          lastModified.isAcceptableOrUnknown(
              data['last_modified']!, _lastModifiedMeta));
    } else if (isInserting) {
      context.missing(_lastModifiedMeta);
    }
    if (data.containsKey('is_favorite')) {
      context.handle(
          _isFavoriteMeta,
          isFavorite.isAcceptableOrUnknown(
              data['is_favorite']!, _isFavoriteMeta));
    }
    if (data.containsKey('main_hymn_key')) {
      context.handle(
          _mainHymnKeyMeta,
          mainHymnKey.isAcceptableOrUnknown(
              data['main_hymn_key']!, _mainHymnKeyMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DriftSermon map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DriftSermon(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      tags: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}tags'])!,
      segments: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}segments'])!,
      lastModified: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}last_modified'])!,
      isFavorite: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_favorite'])!,
      mainHymnKey: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}main_hymn_key']),
    );
  }

  @override
  $SermonsTable createAlias(String alias) {
    return $SermonsTable(attachedDatabase, alias);
  }
}

class DriftSermon extends DataClass implements Insertable<DriftSermon> {
  final int id;
  final String title;
  final String tags;
  final String segments;
  final DateTime lastModified;
  final bool isFavorite;
  final String? mainHymnKey;
  const DriftSermon(
      {required this.id,
      required this.title,
      required this.tags,
      required this.segments,
      required this.lastModified,
      required this.isFavorite,
      this.mainHymnKey});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    map['tags'] = Variable<String>(tags);
    map['segments'] = Variable<String>(segments);
    map['last_modified'] = Variable<DateTime>(lastModified);
    map['is_favorite'] = Variable<bool>(isFavorite);
    if (!nullToAbsent || mainHymnKey != null) {
      map['main_hymn_key'] = Variable<String>(mainHymnKey);
    }
    return map;
  }

  SermonsCompanion toCompanion(bool nullToAbsent) {
    return SermonsCompanion(
      id: Value(id),
      title: Value(title),
      tags: Value(tags),
      segments: Value(segments),
      lastModified: Value(lastModified),
      isFavorite: Value(isFavorite),
      mainHymnKey: mainHymnKey == null && nullToAbsent
          ? const Value.absent()
          : Value(mainHymnKey),
    );
  }

  factory DriftSermon.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DriftSermon(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      tags: serializer.fromJson<String>(json['tags']),
      segments: serializer.fromJson<String>(json['segments']),
      lastModified: serializer.fromJson<DateTime>(json['lastModified']),
      isFavorite: serializer.fromJson<bool>(json['isFavorite']),
      mainHymnKey: serializer.fromJson<String?>(json['mainHymnKey']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'tags': serializer.toJson<String>(tags),
      'segments': serializer.toJson<String>(segments),
      'lastModified': serializer.toJson<DateTime>(lastModified),
      'isFavorite': serializer.toJson<bool>(isFavorite),
      'mainHymnKey': serializer.toJson<String?>(mainHymnKey),
    };
  }

  DriftSermon copyWith(
          {int? id,
          String? title,
          String? tags,
          String? segments,
          DateTime? lastModified,
          bool? isFavorite,
          Value<String?> mainHymnKey = const Value.absent()}) =>
      DriftSermon(
        id: id ?? this.id,
        title: title ?? this.title,
        tags: tags ?? this.tags,
        segments: segments ?? this.segments,
        lastModified: lastModified ?? this.lastModified,
        isFavorite: isFavorite ?? this.isFavorite,
        mainHymnKey: mainHymnKey.present ? mainHymnKey.value : this.mainHymnKey,
      );
  DriftSermon copyWithCompanion(SermonsCompanion data) {
    return DriftSermon(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      tags: data.tags.present ? data.tags.value : this.tags,
      segments: data.segments.present ? data.segments.value : this.segments,
      lastModified: data.lastModified.present
          ? data.lastModified.value
          : this.lastModified,
      isFavorite:
          data.isFavorite.present ? data.isFavorite.value : this.isFavorite,
      mainHymnKey:
          data.mainHymnKey.present ? data.mainHymnKey.value : this.mainHymnKey,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DriftSermon(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('tags: $tags, ')
          ..write('segments: $segments, ')
          ..write('lastModified: $lastModified, ')
          ..write('isFavorite: $isFavorite, ')
          ..write('mainHymnKey: $mainHymnKey')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, title, tags, segments, lastModified, isFavorite, mainHymnKey);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DriftSermon &&
          other.id == this.id &&
          other.title == this.title &&
          other.tags == this.tags &&
          other.segments == this.segments &&
          other.lastModified == this.lastModified &&
          other.isFavorite == this.isFavorite &&
          other.mainHymnKey == this.mainHymnKey);
}

class SermonsCompanion extends UpdateCompanion<DriftSermon> {
  final Value<int> id;
  final Value<String> title;
  final Value<String> tags;
  final Value<String> segments;
  final Value<DateTime> lastModified;
  final Value<bool> isFavorite;
  final Value<String?> mainHymnKey;
  const SermonsCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.tags = const Value.absent(),
    this.segments = const Value.absent(),
    this.lastModified = const Value.absent(),
    this.isFavorite = const Value.absent(),
    this.mainHymnKey = const Value.absent(),
  });
  SermonsCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    required String tags,
    required String segments,
    required DateTime lastModified,
    this.isFavorite = const Value.absent(),
    this.mainHymnKey = const Value.absent(),
  })  : title = Value(title),
        tags = Value(tags),
        segments = Value(segments),
        lastModified = Value(lastModified);
  static Insertable<DriftSermon> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<String>? tags,
    Expression<String>? segments,
    Expression<DateTime>? lastModified,
    Expression<bool>? isFavorite,
    Expression<String>? mainHymnKey,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (tags != null) 'tags': tags,
      if (segments != null) 'segments': segments,
      if (lastModified != null) 'last_modified': lastModified,
      if (isFavorite != null) 'is_favorite': isFavorite,
      if (mainHymnKey != null) 'main_hymn_key': mainHymnKey,
    });
  }

  SermonsCompanion copyWith(
      {Value<int>? id,
      Value<String>? title,
      Value<String>? tags,
      Value<String>? segments,
      Value<DateTime>? lastModified,
      Value<bool>? isFavorite,
      Value<String?>? mainHymnKey}) {
    return SermonsCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      tags: tags ?? this.tags,
      segments: segments ?? this.segments,
      lastModified: lastModified ?? this.lastModified,
      isFavorite: isFavorite ?? this.isFavorite,
      mainHymnKey: mainHymnKey ?? this.mainHymnKey,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (tags.present) {
      map['tags'] = Variable<String>(tags.value);
    }
    if (segments.present) {
      map['segments'] = Variable<String>(segments.value);
    }
    if (lastModified.present) {
      map['last_modified'] = Variable<DateTime>(lastModified.value);
    }
    if (isFavorite.present) {
      map['is_favorite'] = Variable<bool>(isFavorite.value);
    }
    if (mainHymnKey.present) {
      map['main_hymn_key'] = Variable<String>(mainHymnKey.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SermonsCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('tags: $tags, ')
          ..write('segments: $segments, ')
          ..write('lastModified: $lastModified, ')
          ..write('isFavorite: $isFavorite, ')
          ..write('mainHymnKey: $mainHymnKey')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $BibleVersesTable bibleVerses = $BibleVersesTable(this);
  late final $HymnsTable hymns = $HymnsTable(this);
  late final $CrossReferencesTable crossReferences =
      $CrossReferencesTable(this);
  late final $UserNotesTable userNotes = $UserNotesTable(this);
  late final $ReflectionsTable reflections = $ReflectionsTable(this);
  late final $FavoriteBlocksTable favoriteBlocks = $FavoriteBlocksTable(this);
  late final $AppSettingsTableTable appSettingsTable =
      $AppSettingsTableTable(this);
  late final $SermonsTable sermons = $SermonsTable(this);
  late final BibleDao bibleDao = BibleDao(this as AppDatabase);
  late final HymnDao hymnDao = HymnDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
        bibleVerses,
        hymns,
        crossReferences,
        userNotes,
        reflections,
        favoriteBlocks,
        appSettingsTable,
        sermons
      ];
}

typedef $$BibleVersesTableCreateCompanionBuilder = BibleVersesCompanion
    Function({
  Value<int> id,
  required String versionId,
  required int bookId,
  required String bookName,
  required int chapter,
  required int verse,
  required String verseText,
  Value<bool> isFavorite,
  Value<bool> isRead,
  Value<int?> highlightColor,
  required String verseKey,
});
typedef $$BibleVersesTableUpdateCompanionBuilder = BibleVersesCompanion
    Function({
  Value<int> id,
  Value<String> versionId,
  Value<int> bookId,
  Value<String> bookName,
  Value<int> chapter,
  Value<int> verse,
  Value<String> verseText,
  Value<bool> isFavorite,
  Value<bool> isRead,
  Value<int?> highlightColor,
  Value<String> verseKey,
});

class $$BibleVersesTableFilterComposer
    extends Composer<_$AppDatabase, $BibleVersesTable> {
  $$BibleVersesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get versionId => $composableBuilder(
      column: $table.versionId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get bookId => $composableBuilder(
      column: $table.bookId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get bookName => $composableBuilder(
      column: $table.bookName, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get chapter => $composableBuilder(
      column: $table.chapter, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get verse => $composableBuilder(
      column: $table.verse, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get verseText => $composableBuilder(
      column: $table.verseText, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isFavorite => $composableBuilder(
      column: $table.isFavorite, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isRead => $composableBuilder(
      column: $table.isRead, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get highlightColor => $composableBuilder(
      column: $table.highlightColor,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get verseKey => $composableBuilder(
      column: $table.verseKey, builder: (column) => ColumnFilters(column));
}

class $$BibleVersesTableOrderingComposer
    extends Composer<_$AppDatabase, $BibleVersesTable> {
  $$BibleVersesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get versionId => $composableBuilder(
      column: $table.versionId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get bookId => $composableBuilder(
      column: $table.bookId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get bookName => $composableBuilder(
      column: $table.bookName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get chapter => $composableBuilder(
      column: $table.chapter, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get verse => $composableBuilder(
      column: $table.verse, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get verseText => $composableBuilder(
      column: $table.verseText, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isFavorite => $composableBuilder(
      column: $table.isFavorite, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isRead => $composableBuilder(
      column: $table.isRead, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get highlightColor => $composableBuilder(
      column: $table.highlightColor,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get verseKey => $composableBuilder(
      column: $table.verseKey, builder: (column) => ColumnOrderings(column));
}

class $$BibleVersesTableAnnotationComposer
    extends Composer<_$AppDatabase, $BibleVersesTable> {
  $$BibleVersesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get versionId =>
      $composableBuilder(column: $table.versionId, builder: (column) => column);

  GeneratedColumn<int> get bookId =>
      $composableBuilder(column: $table.bookId, builder: (column) => column);

  GeneratedColumn<String> get bookName =>
      $composableBuilder(column: $table.bookName, builder: (column) => column);

  GeneratedColumn<int> get chapter =>
      $composableBuilder(column: $table.chapter, builder: (column) => column);

  GeneratedColumn<int> get verse =>
      $composableBuilder(column: $table.verse, builder: (column) => column);

  GeneratedColumn<String> get verseText =>
      $composableBuilder(column: $table.verseText, builder: (column) => column);

  GeneratedColumn<bool> get isFavorite => $composableBuilder(
      column: $table.isFavorite, builder: (column) => column);

  GeneratedColumn<bool> get isRead =>
      $composableBuilder(column: $table.isRead, builder: (column) => column);

  GeneratedColumn<int> get highlightColor => $composableBuilder(
      column: $table.highlightColor, builder: (column) => column);

  GeneratedColumn<String> get verseKey =>
      $composableBuilder(column: $table.verseKey, builder: (column) => column);
}

class $$BibleVersesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $BibleVersesTable,
    DriftBibleVerse,
    $$BibleVersesTableFilterComposer,
    $$BibleVersesTableOrderingComposer,
    $$BibleVersesTableAnnotationComposer,
    $$BibleVersesTableCreateCompanionBuilder,
    $$BibleVersesTableUpdateCompanionBuilder,
    (
      DriftBibleVerse,
      BaseReferences<_$AppDatabase, $BibleVersesTable, DriftBibleVerse>
    ),
    DriftBibleVerse,
    PrefetchHooks Function()> {
  $$BibleVersesTableTableManager(_$AppDatabase db, $BibleVersesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BibleVersesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BibleVersesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BibleVersesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> versionId = const Value.absent(),
            Value<int> bookId = const Value.absent(),
            Value<String> bookName = const Value.absent(),
            Value<int> chapter = const Value.absent(),
            Value<int> verse = const Value.absent(),
            Value<String> verseText = const Value.absent(),
            Value<bool> isFavorite = const Value.absent(),
            Value<bool> isRead = const Value.absent(),
            Value<int?> highlightColor = const Value.absent(),
            Value<String> verseKey = const Value.absent(),
          }) =>
              BibleVersesCompanion(
            id: id,
            versionId: versionId,
            bookId: bookId,
            bookName: bookName,
            chapter: chapter,
            verse: verse,
            verseText: verseText,
            isFavorite: isFavorite,
            isRead: isRead,
            highlightColor: highlightColor,
            verseKey: verseKey,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String versionId,
            required int bookId,
            required String bookName,
            required int chapter,
            required int verse,
            required String verseText,
            Value<bool> isFavorite = const Value.absent(),
            Value<bool> isRead = const Value.absent(),
            Value<int?> highlightColor = const Value.absent(),
            required String verseKey,
          }) =>
              BibleVersesCompanion.insert(
            id: id,
            versionId: versionId,
            bookId: bookId,
            bookName: bookName,
            chapter: chapter,
            verse: verse,
            verseText: verseText,
            isFavorite: isFavorite,
            isRead: isRead,
            highlightColor: highlightColor,
            verseKey: verseKey,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$BibleVersesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $BibleVersesTable,
    DriftBibleVerse,
    $$BibleVersesTableFilterComposer,
    $$BibleVersesTableOrderingComposer,
    $$BibleVersesTableAnnotationComposer,
    $$BibleVersesTableCreateCompanionBuilder,
    $$BibleVersesTableUpdateCompanionBuilder,
    (
      DriftBibleVerse,
      BaseReferences<_$AppDatabase, $BibleVersesTable, DriftBibleVerse>
    ),
    DriftBibleVerse,
    PrefetchHooks Function()>;
typedef $$HymnsTableCreateCompanionBuilder = HymnsCompanion Function({
  Value<int> id,
  required String category,
  required int number,
  required String title,
  required String lyrics,
  Value<String?> audioUrl,
  Value<String?> localPath,
  Value<bool> isFavorite,
});
typedef $$HymnsTableUpdateCompanionBuilder = HymnsCompanion Function({
  Value<int> id,
  Value<String> category,
  Value<int> number,
  Value<String> title,
  Value<String> lyrics,
  Value<String?> audioUrl,
  Value<String?> localPath,
  Value<bool> isFavorite,
});

class $$HymnsTableFilterComposer extends Composer<_$AppDatabase, $HymnsTable> {
  $$HymnsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get number => $composableBuilder(
      column: $table.number, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get lyrics => $composableBuilder(
      column: $table.lyrics, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get audioUrl => $composableBuilder(
      column: $table.audioUrl, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get localPath => $composableBuilder(
      column: $table.localPath, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isFavorite => $composableBuilder(
      column: $table.isFavorite, builder: (column) => ColumnFilters(column));
}

class $$HymnsTableOrderingComposer
    extends Composer<_$AppDatabase, $HymnsTable> {
  $$HymnsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get number => $composableBuilder(
      column: $table.number, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get lyrics => $composableBuilder(
      column: $table.lyrics, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get audioUrl => $composableBuilder(
      column: $table.audioUrl, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get localPath => $composableBuilder(
      column: $table.localPath, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isFavorite => $composableBuilder(
      column: $table.isFavorite, builder: (column) => ColumnOrderings(column));
}

class $$HymnsTableAnnotationComposer
    extends Composer<_$AppDatabase, $HymnsTable> {
  $$HymnsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<int> get number =>
      $composableBuilder(column: $table.number, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get lyrics =>
      $composableBuilder(column: $table.lyrics, builder: (column) => column);

  GeneratedColumn<String> get audioUrl =>
      $composableBuilder(column: $table.audioUrl, builder: (column) => column);

  GeneratedColumn<String> get localPath =>
      $composableBuilder(column: $table.localPath, builder: (column) => column);

  GeneratedColumn<bool> get isFavorite => $composableBuilder(
      column: $table.isFavorite, builder: (column) => column);
}

class $$HymnsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $HymnsTable,
    DriftHymn,
    $$HymnsTableFilterComposer,
    $$HymnsTableOrderingComposer,
    $$HymnsTableAnnotationComposer,
    $$HymnsTableCreateCompanionBuilder,
    $$HymnsTableUpdateCompanionBuilder,
    (DriftHymn, BaseReferences<_$AppDatabase, $HymnsTable, DriftHymn>),
    DriftHymn,
    PrefetchHooks Function()> {
  $$HymnsTableTableManager(_$AppDatabase db, $HymnsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$HymnsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$HymnsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$HymnsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> category = const Value.absent(),
            Value<int> number = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String> lyrics = const Value.absent(),
            Value<String?> audioUrl = const Value.absent(),
            Value<String?> localPath = const Value.absent(),
            Value<bool> isFavorite = const Value.absent(),
          }) =>
              HymnsCompanion(
            id: id,
            category: category,
            number: number,
            title: title,
            lyrics: lyrics,
            audioUrl: audioUrl,
            localPath: localPath,
            isFavorite: isFavorite,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String category,
            required int number,
            required String title,
            required String lyrics,
            Value<String?> audioUrl = const Value.absent(),
            Value<String?> localPath = const Value.absent(),
            Value<bool> isFavorite = const Value.absent(),
          }) =>
              HymnsCompanion.insert(
            id: id,
            category: category,
            number: number,
            title: title,
            lyrics: lyrics,
            audioUrl: audioUrl,
            localPath: localPath,
            isFavorite: isFavorite,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$HymnsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $HymnsTable,
    DriftHymn,
    $$HymnsTableFilterComposer,
    $$HymnsTableOrderingComposer,
    $$HymnsTableAnnotationComposer,
    $$HymnsTableCreateCompanionBuilder,
    $$HymnsTableUpdateCompanionBuilder,
    (DriftHymn, BaseReferences<_$AppDatabase, $HymnsTable, DriftHymn>),
    DriftHymn,
    PrefetchHooks Function()>;
typedef $$CrossReferencesTableCreateCompanionBuilder = CrossReferencesCompanion
    Function({
  Value<int> id,
  required int sourceVerseId,
  required int targetVerseId,
  required String sourceKey,
  required String targetKey,
});
typedef $$CrossReferencesTableUpdateCompanionBuilder = CrossReferencesCompanion
    Function({
  Value<int> id,
  Value<int> sourceVerseId,
  Value<int> targetVerseId,
  Value<String> sourceKey,
  Value<String> targetKey,
});

class $$CrossReferencesTableFilterComposer
    extends Composer<_$AppDatabase, $CrossReferencesTable> {
  $$CrossReferencesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get sourceVerseId => $composableBuilder(
      column: $table.sourceVerseId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get targetVerseId => $composableBuilder(
      column: $table.targetVerseId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get sourceKey => $composableBuilder(
      column: $table.sourceKey, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get targetKey => $composableBuilder(
      column: $table.targetKey, builder: (column) => ColumnFilters(column));
}

class $$CrossReferencesTableOrderingComposer
    extends Composer<_$AppDatabase, $CrossReferencesTable> {
  $$CrossReferencesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get sourceVerseId => $composableBuilder(
      column: $table.sourceVerseId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get targetVerseId => $composableBuilder(
      column: $table.targetVerseId,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get sourceKey => $composableBuilder(
      column: $table.sourceKey, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get targetKey => $composableBuilder(
      column: $table.targetKey, builder: (column) => ColumnOrderings(column));
}

class $$CrossReferencesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CrossReferencesTable> {
  $$CrossReferencesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get sourceVerseId => $composableBuilder(
      column: $table.sourceVerseId, builder: (column) => column);

  GeneratedColumn<int> get targetVerseId => $composableBuilder(
      column: $table.targetVerseId, builder: (column) => column);

  GeneratedColumn<String> get sourceKey =>
      $composableBuilder(column: $table.sourceKey, builder: (column) => column);

  GeneratedColumn<String> get targetKey =>
      $composableBuilder(column: $table.targetKey, builder: (column) => column);
}

class $$CrossReferencesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $CrossReferencesTable,
    DriftCrossReference,
    $$CrossReferencesTableFilterComposer,
    $$CrossReferencesTableOrderingComposer,
    $$CrossReferencesTableAnnotationComposer,
    $$CrossReferencesTableCreateCompanionBuilder,
    $$CrossReferencesTableUpdateCompanionBuilder,
    (
      DriftCrossReference,
      BaseReferences<_$AppDatabase, $CrossReferencesTable, DriftCrossReference>
    ),
    DriftCrossReference,
    PrefetchHooks Function()> {
  $$CrossReferencesTableTableManager(
      _$AppDatabase db, $CrossReferencesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CrossReferencesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CrossReferencesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CrossReferencesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> sourceVerseId = const Value.absent(),
            Value<int> targetVerseId = const Value.absent(),
            Value<String> sourceKey = const Value.absent(),
            Value<String> targetKey = const Value.absent(),
          }) =>
              CrossReferencesCompanion(
            id: id,
            sourceVerseId: sourceVerseId,
            targetVerseId: targetVerseId,
            sourceKey: sourceKey,
            targetKey: targetKey,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int sourceVerseId,
            required int targetVerseId,
            required String sourceKey,
            required String targetKey,
          }) =>
              CrossReferencesCompanion.insert(
            id: id,
            sourceVerseId: sourceVerseId,
            targetVerseId: targetVerseId,
            sourceKey: sourceKey,
            targetKey: targetKey,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$CrossReferencesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $CrossReferencesTable,
    DriftCrossReference,
    $$CrossReferencesTableFilterComposer,
    $$CrossReferencesTableOrderingComposer,
    $$CrossReferencesTableAnnotationComposer,
    $$CrossReferencesTableCreateCompanionBuilder,
    $$CrossReferencesTableUpdateCompanionBuilder,
    (
      DriftCrossReference,
      BaseReferences<_$AppDatabase, $CrossReferencesTable, DriftCrossReference>
    ),
    DriftCrossReference,
    PrefetchHooks Function()>;
typedef $$UserNotesTableCreateCompanionBuilder = UserNotesCompanion Function({
  Value<int> id,
  Value<String?> title,
  required String content,
  required DateTime lastModified,
  required String tags,
  required int verseId,
  required String verseKey,
});
typedef $$UserNotesTableUpdateCompanionBuilder = UserNotesCompanion Function({
  Value<int> id,
  Value<String?> title,
  Value<String> content,
  Value<DateTime> lastModified,
  Value<String> tags,
  Value<int> verseId,
  Value<String> verseKey,
});

class $$UserNotesTableFilterComposer
    extends Composer<_$AppDatabase, $UserNotesTable> {
  $$UserNotesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get content => $composableBuilder(
      column: $table.content, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastModified => $composableBuilder(
      column: $table.lastModified, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get tags => $composableBuilder(
      column: $table.tags, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get verseId => $composableBuilder(
      column: $table.verseId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get verseKey => $composableBuilder(
      column: $table.verseKey, builder: (column) => ColumnFilters(column));
}

class $$UserNotesTableOrderingComposer
    extends Composer<_$AppDatabase, $UserNotesTable> {
  $$UserNotesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get content => $composableBuilder(
      column: $table.content, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastModified => $composableBuilder(
      column: $table.lastModified,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get tags => $composableBuilder(
      column: $table.tags, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get verseId => $composableBuilder(
      column: $table.verseId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get verseKey => $composableBuilder(
      column: $table.verseKey, builder: (column) => ColumnOrderings(column));
}

class $$UserNotesTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserNotesTable> {
  $$UserNotesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<DateTime> get lastModified => $composableBuilder(
      column: $table.lastModified, builder: (column) => column);

  GeneratedColumn<String> get tags =>
      $composableBuilder(column: $table.tags, builder: (column) => column);

  GeneratedColumn<int> get verseId =>
      $composableBuilder(column: $table.verseId, builder: (column) => column);

  GeneratedColumn<String> get verseKey =>
      $composableBuilder(column: $table.verseKey, builder: (column) => column);
}

class $$UserNotesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $UserNotesTable,
    DriftUserNote,
    $$UserNotesTableFilterComposer,
    $$UserNotesTableOrderingComposer,
    $$UserNotesTableAnnotationComposer,
    $$UserNotesTableCreateCompanionBuilder,
    $$UserNotesTableUpdateCompanionBuilder,
    (
      DriftUserNote,
      BaseReferences<_$AppDatabase, $UserNotesTable, DriftUserNote>
    ),
    DriftUserNote,
    PrefetchHooks Function()> {
  $$UserNotesTableTableManager(_$AppDatabase db, $UserNotesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserNotesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserNotesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserNotesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String?> title = const Value.absent(),
            Value<String> content = const Value.absent(),
            Value<DateTime> lastModified = const Value.absent(),
            Value<String> tags = const Value.absent(),
            Value<int> verseId = const Value.absent(),
            Value<String> verseKey = const Value.absent(),
          }) =>
              UserNotesCompanion(
            id: id,
            title: title,
            content: content,
            lastModified: lastModified,
            tags: tags,
            verseId: verseId,
            verseKey: verseKey,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String?> title = const Value.absent(),
            required String content,
            required DateTime lastModified,
            required String tags,
            required int verseId,
            required String verseKey,
          }) =>
              UserNotesCompanion.insert(
            id: id,
            title: title,
            content: content,
            lastModified: lastModified,
            tags: tags,
            verseId: verseId,
            verseKey: verseKey,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$UserNotesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $UserNotesTable,
    DriftUserNote,
    $$UserNotesTableFilterComposer,
    $$UserNotesTableOrderingComposer,
    $$UserNotesTableAnnotationComposer,
    $$UserNotesTableCreateCompanionBuilder,
    $$UserNotesTableUpdateCompanionBuilder,
    (
      DriftUserNote,
      BaseReferences<_$AppDatabase, $UserNotesTable, DriftUserNote>
    ),
    DriftUserNote,
    PrefetchHooks Function()>;
typedef $$ReflectionsTableCreateCompanionBuilder = ReflectionsCompanion
    Function({
  Value<int> id,
  required String author,
  required String content,
  required String associatedChapterKey,
  required DateTime createdAt,
});
typedef $$ReflectionsTableUpdateCompanionBuilder = ReflectionsCompanion
    Function({
  Value<int> id,
  Value<String> author,
  Value<String> content,
  Value<String> associatedChapterKey,
  Value<DateTime> createdAt,
});

class $$ReflectionsTableFilterComposer
    extends Composer<_$AppDatabase, $ReflectionsTable> {
  $$ReflectionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get author => $composableBuilder(
      column: $table.author, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get content => $composableBuilder(
      column: $table.content, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get associatedChapterKey => $composableBuilder(
      column: $table.associatedChapterKey,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$ReflectionsTableOrderingComposer
    extends Composer<_$AppDatabase, $ReflectionsTable> {
  $$ReflectionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get author => $composableBuilder(
      column: $table.author, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get content => $composableBuilder(
      column: $table.content, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get associatedChapterKey => $composableBuilder(
      column: $table.associatedChapterKey,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$ReflectionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ReflectionsTable> {
  $$ReflectionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get author =>
      $composableBuilder(column: $table.author, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<String> get associatedChapterKey => $composableBuilder(
      column: $table.associatedChapterKey, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$ReflectionsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ReflectionsTable,
    DriftReflection,
    $$ReflectionsTableFilterComposer,
    $$ReflectionsTableOrderingComposer,
    $$ReflectionsTableAnnotationComposer,
    $$ReflectionsTableCreateCompanionBuilder,
    $$ReflectionsTableUpdateCompanionBuilder,
    (
      DriftReflection,
      BaseReferences<_$AppDatabase, $ReflectionsTable, DriftReflection>
    ),
    DriftReflection,
    PrefetchHooks Function()> {
  $$ReflectionsTableTableManager(_$AppDatabase db, $ReflectionsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ReflectionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ReflectionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ReflectionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> author = const Value.absent(),
            Value<String> content = const Value.absent(),
            Value<String> associatedChapterKey = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
          }) =>
              ReflectionsCompanion(
            id: id,
            author: author,
            content: content,
            associatedChapterKey: associatedChapterKey,
            createdAt: createdAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String author,
            required String content,
            required String associatedChapterKey,
            required DateTime createdAt,
          }) =>
              ReflectionsCompanion.insert(
            id: id,
            author: author,
            content: content,
            associatedChapterKey: associatedChapterKey,
            createdAt: createdAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ReflectionsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ReflectionsTable,
    DriftReflection,
    $$ReflectionsTableFilterComposer,
    $$ReflectionsTableOrderingComposer,
    $$ReflectionsTableAnnotationComposer,
    $$ReflectionsTableCreateCompanionBuilder,
    $$ReflectionsTableUpdateCompanionBuilder,
    (
      DriftReflection,
      BaseReferences<_$AppDatabase, $ReflectionsTable, DriftReflection>
    ),
    DriftReflection,
    PrefetchHooks Function()>;
typedef $$FavoriteBlocksTableCreateCompanionBuilder = FavoriteBlocksCompanion
    Function({
  Value<int> id,
  required String versionId,
  required int bookId,
  required String bookName,
  required int chapter,
  required String verses,
  required String verseText,
  required DateTime timestamp,
});
typedef $$FavoriteBlocksTableUpdateCompanionBuilder = FavoriteBlocksCompanion
    Function({
  Value<int> id,
  Value<String> versionId,
  Value<int> bookId,
  Value<String> bookName,
  Value<int> chapter,
  Value<String> verses,
  Value<String> verseText,
  Value<DateTime> timestamp,
});

class $$FavoriteBlocksTableFilterComposer
    extends Composer<_$AppDatabase, $FavoriteBlocksTable> {
  $$FavoriteBlocksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get versionId => $composableBuilder(
      column: $table.versionId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get bookId => $composableBuilder(
      column: $table.bookId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get bookName => $composableBuilder(
      column: $table.bookName, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get chapter => $composableBuilder(
      column: $table.chapter, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get verses => $composableBuilder(
      column: $table.verses, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get verseText => $composableBuilder(
      column: $table.verseText, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get timestamp => $composableBuilder(
      column: $table.timestamp, builder: (column) => ColumnFilters(column));
}

class $$FavoriteBlocksTableOrderingComposer
    extends Composer<_$AppDatabase, $FavoriteBlocksTable> {
  $$FavoriteBlocksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get versionId => $composableBuilder(
      column: $table.versionId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get bookId => $composableBuilder(
      column: $table.bookId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get bookName => $composableBuilder(
      column: $table.bookName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get chapter => $composableBuilder(
      column: $table.chapter, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get verses => $composableBuilder(
      column: $table.verses, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get verseText => $composableBuilder(
      column: $table.verseText, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get timestamp => $composableBuilder(
      column: $table.timestamp, builder: (column) => ColumnOrderings(column));
}

class $$FavoriteBlocksTableAnnotationComposer
    extends Composer<_$AppDatabase, $FavoriteBlocksTable> {
  $$FavoriteBlocksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get versionId =>
      $composableBuilder(column: $table.versionId, builder: (column) => column);

  GeneratedColumn<int> get bookId =>
      $composableBuilder(column: $table.bookId, builder: (column) => column);

  GeneratedColumn<String> get bookName =>
      $composableBuilder(column: $table.bookName, builder: (column) => column);

  GeneratedColumn<int> get chapter =>
      $composableBuilder(column: $table.chapter, builder: (column) => column);

  GeneratedColumn<String> get verses =>
      $composableBuilder(column: $table.verses, builder: (column) => column);

  GeneratedColumn<String> get verseText =>
      $composableBuilder(column: $table.verseText, builder: (column) => column);

  GeneratedColumn<DateTime> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);
}

class $$FavoriteBlocksTableTableManager extends RootTableManager<
    _$AppDatabase,
    $FavoriteBlocksTable,
    DriftFavoriteBlock,
    $$FavoriteBlocksTableFilterComposer,
    $$FavoriteBlocksTableOrderingComposer,
    $$FavoriteBlocksTableAnnotationComposer,
    $$FavoriteBlocksTableCreateCompanionBuilder,
    $$FavoriteBlocksTableUpdateCompanionBuilder,
    (
      DriftFavoriteBlock,
      BaseReferences<_$AppDatabase, $FavoriteBlocksTable, DriftFavoriteBlock>
    ),
    DriftFavoriteBlock,
    PrefetchHooks Function()> {
  $$FavoriteBlocksTableTableManager(
      _$AppDatabase db, $FavoriteBlocksTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FavoriteBlocksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FavoriteBlocksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FavoriteBlocksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> versionId = const Value.absent(),
            Value<int> bookId = const Value.absent(),
            Value<String> bookName = const Value.absent(),
            Value<int> chapter = const Value.absent(),
            Value<String> verses = const Value.absent(),
            Value<String> verseText = const Value.absent(),
            Value<DateTime> timestamp = const Value.absent(),
          }) =>
              FavoriteBlocksCompanion(
            id: id,
            versionId: versionId,
            bookId: bookId,
            bookName: bookName,
            chapter: chapter,
            verses: verses,
            verseText: verseText,
            timestamp: timestamp,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String versionId,
            required int bookId,
            required String bookName,
            required int chapter,
            required String verses,
            required String verseText,
            required DateTime timestamp,
          }) =>
              FavoriteBlocksCompanion.insert(
            id: id,
            versionId: versionId,
            bookId: bookId,
            bookName: bookName,
            chapter: chapter,
            verses: verses,
            verseText: verseText,
            timestamp: timestamp,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$FavoriteBlocksTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $FavoriteBlocksTable,
    DriftFavoriteBlock,
    $$FavoriteBlocksTableFilterComposer,
    $$FavoriteBlocksTableOrderingComposer,
    $$FavoriteBlocksTableAnnotationComposer,
    $$FavoriteBlocksTableCreateCompanionBuilder,
    $$FavoriteBlocksTableUpdateCompanionBuilder,
    (
      DriftFavoriteBlock,
      BaseReferences<_$AppDatabase, $FavoriteBlocksTable, DriftFavoriteBlock>
    ),
    DriftFavoriteBlock,
    PrefetchHooks Function()>;
typedef $$AppSettingsTableTableCreateCompanionBuilder
    = AppSettingsTableCompanion Function({
  Value<int> id,
  required String lastVersion,
  Value<int?> lastBookId,
  Value<int?> lastChapter,
  Value<String> readingTheme,
  Value<String?> lastRoute,
  Value<bool> migrationDone,
});
typedef $$AppSettingsTableTableUpdateCompanionBuilder
    = AppSettingsTableCompanion Function({
  Value<int> id,
  Value<String> lastVersion,
  Value<int?> lastBookId,
  Value<int?> lastChapter,
  Value<String> readingTheme,
  Value<String?> lastRoute,
  Value<bool> migrationDone,
});

class $$AppSettingsTableTableFilterComposer
    extends Composer<_$AppDatabase, $AppSettingsTableTable> {
  $$AppSettingsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get lastVersion => $composableBuilder(
      column: $table.lastVersion, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get lastBookId => $composableBuilder(
      column: $table.lastBookId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get lastChapter => $composableBuilder(
      column: $table.lastChapter, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get readingTheme => $composableBuilder(
      column: $table.readingTheme, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get lastRoute => $composableBuilder(
      column: $table.lastRoute, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get migrationDone => $composableBuilder(
      column: $table.migrationDone, builder: (column) => ColumnFilters(column));
}

class $$AppSettingsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $AppSettingsTableTable> {
  $$AppSettingsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get lastVersion => $composableBuilder(
      column: $table.lastVersion, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get lastBookId => $composableBuilder(
      column: $table.lastBookId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get lastChapter => $composableBuilder(
      column: $table.lastChapter, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get readingTheme => $composableBuilder(
      column: $table.readingTheme,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get lastRoute => $composableBuilder(
      column: $table.lastRoute, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get migrationDone => $composableBuilder(
      column: $table.migrationDone,
      builder: (column) => ColumnOrderings(column));
}

class $$AppSettingsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppSettingsTableTable> {
  $$AppSettingsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get lastVersion => $composableBuilder(
      column: $table.lastVersion, builder: (column) => column);

  GeneratedColumn<int> get lastBookId => $composableBuilder(
      column: $table.lastBookId, builder: (column) => column);

  GeneratedColumn<int> get lastChapter => $composableBuilder(
      column: $table.lastChapter, builder: (column) => column);

  GeneratedColumn<String> get readingTheme => $composableBuilder(
      column: $table.readingTheme, builder: (column) => column);

  GeneratedColumn<String> get lastRoute =>
      $composableBuilder(column: $table.lastRoute, builder: (column) => column);

  GeneratedColumn<bool> get migrationDone => $composableBuilder(
      column: $table.migrationDone, builder: (column) => column);
}

class $$AppSettingsTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AppSettingsTableTable,
    DriftAppSettings,
    $$AppSettingsTableTableFilterComposer,
    $$AppSettingsTableTableOrderingComposer,
    $$AppSettingsTableTableAnnotationComposer,
    $$AppSettingsTableTableCreateCompanionBuilder,
    $$AppSettingsTableTableUpdateCompanionBuilder,
    (
      DriftAppSettings,
      BaseReferences<_$AppDatabase, $AppSettingsTableTable, DriftAppSettings>
    ),
    DriftAppSettings,
    PrefetchHooks Function()> {
  $$AppSettingsTableTableTableManager(
      _$AppDatabase db, $AppSettingsTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppSettingsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppSettingsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppSettingsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> lastVersion = const Value.absent(),
            Value<int?> lastBookId = const Value.absent(),
            Value<int?> lastChapter = const Value.absent(),
            Value<String> readingTheme = const Value.absent(),
            Value<String?> lastRoute = const Value.absent(),
            Value<bool> migrationDone = const Value.absent(),
          }) =>
              AppSettingsTableCompanion(
            id: id,
            lastVersion: lastVersion,
            lastBookId: lastBookId,
            lastChapter: lastChapter,
            readingTheme: readingTheme,
            lastRoute: lastRoute,
            migrationDone: migrationDone,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String lastVersion,
            Value<int?> lastBookId = const Value.absent(),
            Value<int?> lastChapter = const Value.absent(),
            Value<String> readingTheme = const Value.absent(),
            Value<String?> lastRoute = const Value.absent(),
            Value<bool> migrationDone = const Value.absent(),
          }) =>
              AppSettingsTableCompanion.insert(
            id: id,
            lastVersion: lastVersion,
            lastBookId: lastBookId,
            lastChapter: lastChapter,
            readingTheme: readingTheme,
            lastRoute: lastRoute,
            migrationDone: migrationDone,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$AppSettingsTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $AppSettingsTableTable,
    DriftAppSettings,
    $$AppSettingsTableTableFilterComposer,
    $$AppSettingsTableTableOrderingComposer,
    $$AppSettingsTableTableAnnotationComposer,
    $$AppSettingsTableTableCreateCompanionBuilder,
    $$AppSettingsTableTableUpdateCompanionBuilder,
    (
      DriftAppSettings,
      BaseReferences<_$AppDatabase, $AppSettingsTableTable, DriftAppSettings>
    ),
    DriftAppSettings,
    PrefetchHooks Function()>;
typedef $$SermonsTableCreateCompanionBuilder = SermonsCompanion Function({
  Value<int> id,
  required String title,
  required String tags,
  required String segments,
  required DateTime lastModified,
  Value<bool> isFavorite,
  Value<String?> mainHymnKey,
});
typedef $$SermonsTableUpdateCompanionBuilder = SermonsCompanion Function({
  Value<int> id,
  Value<String> title,
  Value<String> tags,
  Value<String> segments,
  Value<DateTime> lastModified,
  Value<bool> isFavorite,
  Value<String?> mainHymnKey,
});

class $$SermonsTableFilterComposer
    extends Composer<_$AppDatabase, $SermonsTable> {
  $$SermonsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get tags => $composableBuilder(
      column: $table.tags, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get segments => $composableBuilder(
      column: $table.segments, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get lastModified => $composableBuilder(
      column: $table.lastModified, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isFavorite => $composableBuilder(
      column: $table.isFavorite, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get mainHymnKey => $composableBuilder(
      column: $table.mainHymnKey, builder: (column) => ColumnFilters(column));
}

class $$SermonsTableOrderingComposer
    extends Composer<_$AppDatabase, $SermonsTable> {
  $$SermonsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get tags => $composableBuilder(
      column: $table.tags, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get segments => $composableBuilder(
      column: $table.segments, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get lastModified => $composableBuilder(
      column: $table.lastModified,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isFavorite => $composableBuilder(
      column: $table.isFavorite, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get mainHymnKey => $composableBuilder(
      column: $table.mainHymnKey, builder: (column) => ColumnOrderings(column));
}

class $$SermonsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SermonsTable> {
  $$SermonsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get tags =>
      $composableBuilder(column: $table.tags, builder: (column) => column);

  GeneratedColumn<String> get segments =>
      $composableBuilder(column: $table.segments, builder: (column) => column);

  GeneratedColumn<DateTime> get lastModified => $composableBuilder(
      column: $table.lastModified, builder: (column) => column);

  GeneratedColumn<bool> get isFavorite => $composableBuilder(
      column: $table.isFavorite, builder: (column) => column);

  GeneratedColumn<String> get mainHymnKey => $composableBuilder(
      column: $table.mainHymnKey, builder: (column) => column);
}

class $$SermonsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SermonsTable,
    DriftSermon,
    $$SermonsTableFilterComposer,
    $$SermonsTableOrderingComposer,
    $$SermonsTableAnnotationComposer,
    $$SermonsTableCreateCompanionBuilder,
    $$SermonsTableUpdateCompanionBuilder,
    (DriftSermon, BaseReferences<_$AppDatabase, $SermonsTable, DriftSermon>),
    DriftSermon,
    PrefetchHooks Function()> {
  $$SermonsTableTableManager(_$AppDatabase db, $SermonsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SermonsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SermonsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SermonsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String> tags = const Value.absent(),
            Value<String> segments = const Value.absent(),
            Value<DateTime> lastModified = const Value.absent(),
            Value<bool> isFavorite = const Value.absent(),
            Value<String?> mainHymnKey = const Value.absent(),
          }) =>
              SermonsCompanion(
            id: id,
            title: title,
            tags: tags,
            segments: segments,
            lastModified: lastModified,
            isFavorite: isFavorite,
            mainHymnKey: mainHymnKey,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String title,
            required String tags,
            required String segments,
            required DateTime lastModified,
            Value<bool> isFavorite = const Value.absent(),
            Value<String?> mainHymnKey = const Value.absent(),
          }) =>
              SermonsCompanion.insert(
            id: id,
            title: title,
            tags: tags,
            segments: segments,
            lastModified: lastModified,
            isFavorite: isFavorite,
            mainHymnKey: mainHymnKey,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$SermonsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SermonsTable,
    DriftSermon,
    $$SermonsTableFilterComposer,
    $$SermonsTableOrderingComposer,
    $$SermonsTableAnnotationComposer,
    $$SermonsTableCreateCompanionBuilder,
    $$SermonsTableUpdateCompanionBuilder,
    (DriftSermon, BaseReferences<_$AppDatabase, $SermonsTable, DriftSermon>),
    DriftSermon,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$BibleVersesTableTableManager get bibleVerses =>
      $$BibleVersesTableTableManager(_db, _db.bibleVerses);
  $$HymnsTableTableManager get hymns =>
      $$HymnsTableTableManager(_db, _db.hymns);
  $$CrossReferencesTableTableManager get crossReferences =>
      $$CrossReferencesTableTableManager(_db, _db.crossReferences);
  $$UserNotesTableTableManager get userNotes =>
      $$UserNotesTableTableManager(_db, _db.userNotes);
  $$ReflectionsTableTableManager get reflections =>
      $$ReflectionsTableTableManager(_db, _db.reflections);
  $$FavoriteBlocksTableTableManager get favoriteBlocks =>
      $$FavoriteBlocksTableTableManager(_db, _db.favoriteBlocks);
  $$AppSettingsTableTableTableManager get appSettingsTable =>
      $$AppSettingsTableTableTableManager(_db, _db.appSettingsTable);
  $$SermonsTableTableManager get sermons =>
      $$SermonsTableTableManager(_db, _db.sermons);
}
