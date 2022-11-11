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

  late DatabaseHandler handler;

  late Database _database;

  Future<Database> initDatabase() async {
    var path = await getDatabasesPath();
    _database = await openDatabase(join(path, DBNAME), version: 1,
        onCreate: ((db, version) async {
      String sql =
          'CREATE TABLE $TABLE_NAME($COLUMN_ID INTEGER PRIMARY KEY,$COLUMN_TITLE TEXT NOT NULL,$COLUMN_TIMER TEXT NOT NULL)';
      await db.execute(sql);
    }));
    return _database;
  }

  Future<int> insertData(Timer timer) async {
    await initDatabase();
    return await _database.insert(TABLE_NAME, timer.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<int> deleteData(int id) async {
    await initDatabase();
    return await _database.delete(TABLE_NAME, where: 'id = ?', whereArgs: [id]);
  }

  Future<int> updateData(Timer time) async {
    await initDatabase();
    return await _database.update(TABLE_NAME, time.toMap(),
        where: 'id = ?', whereArgs: [time.id]);
  }

  Future<void> deleteDatabase(String path) =>
      databaseFactory.deleteDatabase(path);

  Future<List<Timer>> selectAllTimer() async {
    await initDatabase();
    var result = await _database.query(TABLE_NAME);

    List<Timer> alltimer = result.map((e) => Timer.fromMap(e)).toList();
    return alltimer;
  }
}
