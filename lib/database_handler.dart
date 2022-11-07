import 'dart:core';
import 'dart:io';
import 'package:path/path.dart' show join;
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'timer.dart';

class DatabaseHandler {
  String DBNAME = 'Pomo.db';
  String TABLE_NAME = 'Pomodoro';
  String COLUMN_ID = 'id';
  String COLUMN_TITLE = 'title';
  String COLUMN_TIMER = 'timer';
  DatabaseHandler._createInstance();
  static DatabaseHandler _handler = DatabaseHandler._createInstance();
  Future<Directory?>? path;
  Future get database async {
    if (_database != null) {
      return _database;
    }
    _database = await initDatabase();
    return _database;
  }

  factory DatabaseHandler() {
    if (_handler != null) {
      return _handler = DatabaseHandler._createInstance();
    }
    return _handler;
  }
  static Database? _database = null;
  Future<Database> initDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    Database _database = await openDatabase(join(directory.path, DBNAME),
        version: 1, onCreate: createDatabase);

    return _database;
  }

  Future createDatabase(Database db, int version) async {
    String sql =
        'CREATE TABLE $TABLE_NAME($COLUMN_ID INTEGER PRIMARY KEY,$COLUMN_TITLE TEXT NOT NULL,$COLUMN_TIMER TEXT NOT NULL);';
    await db.execute(sql);
  }

  Future<int> insertData(Timer timer) async {
    final Database db = await database;
    return await db.insert(TABLE_NAME, timer.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<int> deleteData(int id) async {
    var db = await database;
    return await db.delete(TABLE_NAME, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> updateData(Timer time) async {
    var db = await database;
    return await db.update(TABLE_NAME, time.toMap(),
        where: 'id = ?', whereArgs: [time.id]);
  }

  Future<List<Timer>> selectAllTimer() async {
    var db = await initDatabase();
    var result = await db.query(TABLE_NAME);

    List<Timer> alltimer = result.map((e) => Timer.fromMap(e)).toList();
    return alltimer;
  }
}
