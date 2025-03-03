import 'dart:core';
import 'package:path/path.dart' show join;
import 'package:sqflite/sqflite.dart';
import 'timer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseHandler {
  String DBNAME = 'Pomo.db';
  String TABLE_NAME = 'Pomodoro';
  String COLUMN_ID = 'id';
  String COLUMN_TITLE = 'title';
  String COLUMN_TIMER = 'timer';

  String COLUMN_DATETIME = 'dateTime';

  late DatabaseHandler handler;

  late Database _database;

  Future<Database> initDatabase() async {
    var path = await getDatabasesPath();
    _database = await openDatabase(join(path, DBNAME), version: 1,
        onCreate: ((db, version) async {
      String sql =
          'CREATE TABLE $TABLE_NAME($COLUMN_ID INTEGER PRIMARY KEY,$COLUMN_TITLE TEXT NOT NULL,$COLUMN_TIMER TEXT NOT NULL,$COLUMN_DATETIME TEXT NOT NULL)';

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

class FirestoreDatabaseHandler {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // Get current user
  User? get currentUser => _auth.currentUser;

  // Save pomodoro session
  Future<void> saveSession({
    required int duration,
    required String type,
    required bool completed,
  }) async {
    if (currentUser == null) return;

    await _firestore
        .collection('users')
        .doc(currentUser!.uid)
        .collection('sessions')
        .add({
      'duration': duration,
      'type': type,
      'completed': completed,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  // Get user statistics
  Future<Map<String, dynamic>> getUserStats() async {
    if (currentUser == null) {
      return {};
    }

    final userDoc =
        await _firestore.collection('users').doc(currentUser!.uid).get();

    return userDoc.data() ?? {};
  }

  // Update user settings
  Future<void> updateSettings({
    required int workDuration,
    required int breakDuration,
    required int longBreakDuration,
    required int sessionsBeforeLongBreak,
  }) async {
    if (currentUser == null) return;

    await _firestore.collection('users').doc(currentUser!.uid).set({
      'settings': {
        'workDuration': workDuration,
        'breakDuration': breakDuration,
        'longBreakDuration': longBreakDuration,
        'sessionsBeforeLongBreak': sessionsBeforeLongBreak,
      }
    }, SetOptions(merge: true));
  }

  // Get user settings
  Future<Map<String, dynamic>> getSettings() async {
    if (currentUser == null) {
      return {};
    }

    final userDoc =
        await _firestore.collection('users').doc(currentUser!.uid).get();

    return (userDoc.data()?['settings'] as Map<String, dynamic>?) ?? {};
  }
}
