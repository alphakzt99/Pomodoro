import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:postgres/postgres.dart';
import 'timer.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/services.dart' show rootBundle;

class PostgresHandler {
  Connection? connection;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  PostgresHandler(){
    _initializeConnection();
  }

  Future<List<int>> _loadAsset(String path) async {
    final byteData = await rootBundle.load(path);
    return byteData.buffer.asUint8List();
  }
  Future<void> _initializeConnection() async {
    await dotenv.load();
    final serverCA = await _loadAsset('client/server-ca.pem');
    final clientCert = await _loadAsset('client/client-cert.pem');
    final clientKey = await _loadAsset('client/client-key.pem');

    final securityContext = SecurityContext()
      ..useCertificateChainBytes(clientCert)
      ..usePrivateKeyBytes(clientKey)
      ..setTrustedCertificatesBytes(serverCA);
    

    connection = await Connection.open(
      Endpoint(
        port: int.parse(dotenv.env['POSTGRES_PORT'] ?? '5432'),
        database: dotenv.env['POSTGRES_DB'] ?? 'postPomo',
        host: dotenv.env['POSTGRES_HOST'] ?? 'localhost',
        username: dotenv.env['POSTGRES_USER'] ?? 'postgres',
        password: dotenv.env['POSTGRES_PASSWORD'] ?? 'postgres',
      ),
      settings: ConnectionSettings(
        sslMode: SslMode.verifyFull,
        securityContext: securityContext,
        applicationName: 'Pomodoro',
        timeZone: 'UTC',
        connectTimeout: Duration(seconds: 30),
        queryTimeout: Duration(seconds: 10)
      ),
    );

    await connection!.execute('''
      CREATE TABLE IF NOT EXISTS users (
        id VARCHAR(255) PRIMARY KEY,
        email VARCHAR(255) NOT NULL
      )
    ''');
    await connection!.execute('''
      CREATE TABLE IF NOT EXISTS pomodoro (
        id SERIAL PRIMARY KEY,
        user_id VARCHAR(255) NOT NULL,
        title TEXT NOT NULL,
        timer TEXT NOT NULL,
        date_time TEXT NOT NULL,
        FOREIGN KEY (user_id) REFERENCES users(id)
      )
    ''');
    print("Connected to Postgres");
  }

  Future<void> closeConnection() async {
    await connection!.close();
    print("Closed connection to Postgres");
  }


  Future<void> _ensureUserExists() async {
    if (_auth.currentUser == null) return;
    await connection!.execute(
      Sql.named('INSERT INTO users (id, email) VALUES (@id, @email) ON CONFLICT (id) DO NOTHING'),
      parameters: {
        'id': _auth.currentUser!.uid,
        'email': _auth.currentUser!.email ?? '',
      },
    );
  }

  Future<int> insertData(Timer timer) async {
    if (_auth.currentUser == null) throw 'User not authenticated';
    await _initializeConnection();
    await _ensureUserExists();
    
    final result = await connection!.execute(
      Sql.named('INSERT INTO pomodoro (user_id, title, timer, date_time) VALUES (@user_id, @title, @timer, @date_time) RETURNING id'),
      parameters: {
        'user_id': _auth.currentUser!.uid,
        'title': timer.title,
        'timer': timer.timer,
        'date_time': timer.datetime,
      },
    );
    return result.first[0] as int;
  }

  Future<int> deleteData(int id) async {
    if (_auth.currentUser == null) throw 'User not authenticated';
    await _initializeConnection();
    
    final result = await connection!.execute(
      Sql.named('DELETE FROM pomodoro WHERE id = @id AND user_id = @user_id'),
      parameters: {
        'id': id,
        'user_id': _auth.currentUser!.uid,
      },
    );
    return result.first[0] as int; 
  }

  
  Future<int> updateData(Timer timer) async {
    if (_auth.currentUser == null) throw 'User not authenticated';
    await _initializeConnection();
    
    final result = await connection!.execute(
      Sql.named('UPDATE pomodoro SET title = @title, timer = @timer, date_time = @date_time WHERE id = @id AND user_id = @user_id'),
      parameters: {
        'id': timer.id,
        'title': timer.title,
        'timer': timer.timer,
        'date_time': timer.datetime,
        'user_id': _auth.currentUser!.uid,
      },
    );
    return result.first[0] as int; 
  }

  Future<List<Timer>> selectAllTimer() async {
    if (_auth.currentUser == null) throw 'User not authenticated';
    await _initializeConnection();
    
    final results = await connection!.execute(
      Sql.named('SELECT * FROM pomodoro WHERE user_id = @user_id'),
      parameters: {'user_id': _auth.currentUser!.uid},
    );
    
    return results.map((row) {
      return Timer.fromMap({
        'id': row[0],
        'title': row[1],
        'timer': row[2],
        'date_time': row[3]
      });
    }).toList();
  }

  Future<void> close() async {
    if(connection != null) {
      await connection!.close();
      print("Closed connection to Postgres");
    }
  }
}

