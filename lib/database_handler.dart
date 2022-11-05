import 'dart:core';
import 'dart:io' show Directory;
import 'timer.dart';
import 'dart:async';
import 'package:path/path.dart' show join;
import 'package:sqflite/sqflite.dart';


class DatabaseHandler {
  String DBNAME = 'Pomodoro.db';
  String TABLE_NAME = 'Pomodoro';
  String COLUMN_ID = 'ID';
  String COLUMN_TITLE = 'Title';
  String COLUMN_TIMER = 'Time';
  static late Database _database = DatabaseHandler._database;

  Future<Database> get database async {
    if (_database != null) {
      return _database;
    }
    _database = await initDatabase();
    return _database;
  }

  Future<Database> initDatabase() async {
   
    var dir = await getDatabasesPath();
    String path = join(dir, DBNAME);
    return openDatabase(path, version: 1, onCreate: createDatabase);
  }

  Future createDatabase(Database db, int version) async{
    String sql =
        'CREATE TABLE $TABLE_NAME($COLUMN_ID INTEGER PRIMARY KEY AUTOINCREMENT,$COLUMN_TITLE TEXT NOT NULL,$COLUMN_TIMER TEXT NOT NULL)';
    await db.execute(sql);
  }

  Future<int> insertData(String title, String time) async {
    var db = await database;
    return await db.rawInsert(
        'INSERT INTO $TABLE_NAME'
        '($COLUMN_TITLE, $COLUMN_TIMER)'
        'VALUES(?, ?)',
        [title, time]);
    ;
  }

  Future<int> deleteData(int id) async {
    var db = await database;
    return await db.delete(TABLE_NAME, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> updateData(Timer timer) async {
    var db = await database;
    return await db.update(TABLE_NAME, timer.toMap(),
        where: 'id = ?', whereArgs: [timer.id]);
  }

  Future<List<Timer>> selectAllbooks() async {
    var db = await initDatabase();
    var result = await db.query(TABLE_NAME);

    List<Timer> alltimer = result.map((e) => Timer.fromMap(e)).toList();
    return alltimer;
  }
}
