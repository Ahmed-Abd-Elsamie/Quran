import 'dart:io';
import 'package:path/path.dart';
import 'package:quran/models/mark.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  static final _databaseName = "quranDb.db";
  static final _databaseVersion = 1;

  // make this a singleton class
  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // only have a single app-wide reference to the database
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database!;
  }

  // this opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    // marks table
    await db.execute('''
          create table marks (
            id integer primary key autoincrement, 
            page_num integer not null,
            surah text not null,
            type integer not null,
            created_at text not null
            )
          ''');
  }

  Future<Mark> insertMark(Mark mark) async {
    print("MMMM : " + mark.type.toString());
    Database db = await instance.database;
    mark.id = await db.insert('marks', mark.toMap());
    return mark;
  }

  Future<List<Mark>?> getAllMarks() async {
    Database db = await instance.database;
    List<Map<String, Object?>> marks = await db.query('marks',
        columns: ['id', 'page_num', 'surah', 'type', 'created_at']);
    if (marks.length > 0) {
      return List<Mark>.from(marks.map((c) => Mark.fromJson(c)));
    }
    return [];
  }

  Future<int> deleteMark(int id) async {
    Database db = await instance.database;
    return await db.delete('marks', where: 'id = ?', whereArgs: [id]);
  }
}
