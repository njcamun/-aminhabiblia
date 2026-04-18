import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

QueryExecutor connect() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final driftDir = Directory(p.join(dbFolder.path, 'drift_db'));
    
    if (!await driftDir.exists()) {
      await driftDir.create(recursive: true);
    }
    
    final file = File(p.join(driftDir.path, 'biblia_app.db'));

    return NativeDatabase(file, setup: (db) {
      db.execute('PRAGMA busy_timeout = 5000;');
      db.execute('PRAGMA page_size = 16384;');
      db.execute('PRAGMA journal_mode = WAL;');
      db.execute('PRAGMA synchronous = NORMAL;');
    });
  });
}
