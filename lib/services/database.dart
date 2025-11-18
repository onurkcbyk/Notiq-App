import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../data/models.dart';

class NotesDB {
  NotesDB._();
  static final NotesDB db = NotesDB._();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'notes.db');

    return await openDatabase(
      path,
      version: 2, // ✅ VERSİYON 2
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE Notes (
            _id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            content TEXT,
            date TEXT,
            isImportant INTEGER,
            category INTEGER DEFAULT 1
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        // ✅ ESKİ KULLANICILAR İÇİN UPDATE
        if (oldVersion < 2) {
          await db.execute('ALTER TABLE Notes ADD COLUMN category INTEGER DEFAULT 1');
        }
      },
    );
  }

  Future<List<NoteEntry>> getNotesFromDB() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('Notes');
    return List.generate(maps.length, (i) {
      try {
        return NoteEntry.fromMap(maps[i]);
      } catch (e) {
        final map = maps[i];
        return NoteEntry(
          id: map['_id'],
          title: map['title'] ?? '',
          content: map['content'] ?? '',
          isImportant: map['isImportant'] == 1,
          date: DateTime.parse(map['date']),
          category: NoteCategory.values[map['category'] ?? 1],
        );
      }
    });
  }

  Future<void> updateNoteInDB(NoteEntry note) async {
    final db = await database;
    await db.update(
        'Notes',
        note.toMap(),
        where: '_id = ?',
        whereArgs: [note.id],
        conflictAlgorithm: ConflictAlgorithm.replace
    );
  }

  Future<void> deleteNoteInDB(NoteEntry note) async {
    final db = await database;
    await db.delete('Notes', where: '_id = ?', whereArgs: [note.id]);
  }

  Future<NoteEntry> addNoteInDB(NoteEntry note) async {
    final db = await database;

    // ✅ BAŞLIK KONTROLÜ
    if (note.title.trim().isEmpty) {
      note = NoteEntry(
        id: note.id,
        title: 'Untitled Note',
        content: note.content,
        isImportant: note.isImportant,
        date: note.date,
        category: note.category,
      );
    }

    final id = await db.insert(
        'Notes',
        note.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace
    );

    // ✅ YENİ ID İLE NOTU DÖNDÜR
    return NoteEntry(
      id: id,
      title: note.title,
      content: note.content,
      isImportant: note.isImportant,
      date: note.date,
      category: note.category,
    );
  }
}