import 'dart:core';
import 'dart:io' show Directory;
import 'timer.dart';
import 'dart:async';
import 'package:path/path.dart' show join;
import 'package:sqflite/sqflite.dart';

class DatabaseHandler {
  String DBNAME = 'Pomodoro.db';
  String TABLE_NAME = 'Pomodoro';
  String COLUMN_ID = 'id';
  String COLUMN_TITLE = 'title';
  String COLUMN_TIMER = 'timer';
  static late Database _database;
  Future get database async {
    _database ??= await initDatabase();
    return _database;
  }

  Future<Database> initDatabase() async {
    var dir = await getDatabasesPath();
    return openDatabase(join(dir, DBNAME),
        version: 1, onCreate: createDatabase);
  }

  Future createDatabase(Database db, int version) async {
    String sql =
        'CREATE TABLE $TABLE_NAME($COLUMN_ID INTEGER PRIMARY KEY,$COLUMN_TITLE TEXT NOT NULL,$COLUMN_TIMER TEXT NOT NULL)';
    await db.execute(sql);
  }

  Future<int> insertData(Timer timer) async {
    var db = await database;
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

  Future<List<Timer>> selectAllbooks() async {
    var db = await initDatabase();
    var result = await db.query(TABLE_NAME, orderBy: COLUMN_ID);

    List<Timer> alltimer = result.map((e) => Timer.fromMap(e)).toList();
    return alltimer;
  }
}
