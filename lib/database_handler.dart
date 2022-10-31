import 'dart:core';
import 'timer.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHandler {
  String DBNAME = 'Pomodoro Timer';
  String TABLE_NAME = 'Pomodoro';
  String COLUMN_ID = 'ID';
  String COLUMN_TITLE = 'Title';
  String COLUMN_TIMER = 'Time';
  static Database _database = DatabaseHandler._database;
  static DatabaseHandler handler = DatabaseHandler(handler);
  
  DatabaseHandler._createInstance();
  factory DatabaseHandler(handler) {
    if (handler! == null) {
      handler = DatabaseHandler._createInstance();
    }
    return handler;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initDatabase();
    }
    return _database;
  }

  Future<String> get databasePath async{
    return await getDatabasesPath();
  }

  Future<Database> initDatabase() async{
    String dir = await getDatabasesPath();
    String path = join(dir,'DBNAME');
    return openDatabase(path,version: 1,onCreate: createDatabase);
  }

  void createDatabase(Database db,int index){
    String sql =
        'CREATE TABLE $TABLE_NAME($COLUMN_ID INTEGER PRIMARY KEY,$COLUMN_TITLE TEXT,$COLUMN_TIMER TEXT);';
    db.execute(sql);
  }
  Future<int> insertData(Timer timer) async {
    var db = await database;
    return await db.insert(TABLE_NAME, timer.toMap());
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
    var db = await database;
    var result = await db.query(TABLE_NAME);

    List<Timer> alltimer = result.map((e) => Timer.fromMap(e)).toList();
    return alltimer;
  }
}
