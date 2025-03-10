import 'dart:core';
import 'package:intl/intl.dart' show DateFormat;

import 'timer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class DatabaseHandler {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();

  User? get currentUser => _auth.currentUser;

  Future<String?> signUp(String email, String password) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;
      if (user != null) {
        await _dbRef.child('users').child(user.uid).set({
          'email': email,
          'createdAt': ServerValue.timestamp,
        });
        return user.uid;
      }
      return null;
    } on FirebaseAuthException catch (e) {
      print("Sign-up error: $e");
      return null;
    } catch (e) {
      print("Sign-up error: $e");
      return null;
    }
  }

  Future<String?> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user?.uid;
    } catch (e) {
      print("Sign-in error: $e");
      return null;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<String?> addTimer(Timer timer) async {
    User? user = _auth.currentUser;
    if (user != null) {
      try {
        DatabaseReference databaseReference =
            _dbRef.child('users').child(user.uid).child('timers').push();

        await databaseReference.set(timer.toMap());

        return databaseReference.key;
      } catch (e) {
        print("Error adding timer: $e");
      }
    } else {
      throw Exception("User not authenticated");
    }
    return null;
  }

  Future<List<MapEntry<String, Timer>>> getTimers() async {
    User? user = _auth.currentUser;
    if (user != null) {
      try {
        final snapshot =
            await _dbRef.child('users').child(user.uid).child('timers').get();
        if (snapshot.exists) {
          Map<dynamic, dynamic> timersMap =
              snapshot.value as Map<dynamic, dynamic>;
          List<MapEntry<String, Timer>> timers = timersMap.entries
              .map((entry) => MapEntry(entry.key as String,
                  Timer.fromMap(Map<String, dynamic>.from(entry.value))))
              .toList();

          quickSort(timers, 0, timers.length - 1);
          return timers;
        }
        return [];
      } catch (e) {
        print("Error fetching timers: $e");
        return [];
      }
    } else {
      throw Exception("User not authenticated");
    }
  }

  Map<String, Map<int, int>> groupTimersbyMonth(List<MapEntry<String, Timer>> timers) {
    Map<String, Map<int, int>> groupedTimers = {};
    for (var timer in timers) {
      
      DateTime dateTime = DateFormat.yMMMEd().parse(timer.value.datetime);
      String month = DateFormat("MMMM").format(dateTime);
    
      int day = dateTime.day;
      if (groupedTimers.containsKey(month)) {
        groupedTimers[month]![day] = (groupedTimers[month]![day] ?? 0) + 1;
      } else {
        groupedTimers[month] = {day: 1};
      }
    }
    return groupedTimers;
  }


  void quickSort(List<MapEntry<String, Timer>> timers, int left, int right) {
    if (left < right) {
      int partitionIndex = partition(timers, left, right);
      quickSort(timers, left, partitionIndex - 1);
      quickSort(timers, partitionIndex + 1, right);
    }
  }

  int partition(List<MapEntry<String, Timer>> timers, int left, int right) {
    Timer pivot = timers[right].value;
    int i = left - 1;
    for (int j = left; j < right; j++) {
      if (timers[j].value.datetime.compareTo(pivot.datetime) < 0) {
        i++;
        MapEntry<String, Timer> temp = timers[i];
        timers[i] = timers[j];
        timers[j] = temp;
      }
    }
    MapEntry<String, Timer> temp = timers[i + 1];
    timers[i + 1] = timers[right];
    timers[right] = temp;
    return i + 1;
  }

  Future<void> updateTimer(String timerKey, Timer updatedTimer) async {
    User? user = _auth.currentUser;
    if (user != null) {
      try {
        await _dbRef
            .child('users')
            .child(user.uid)
            .child('timers')
            .child(timerKey)
            .update(updatedTimer.toMap());
      } catch (e) {
        print("Error updating timer: $e");
      }
    } else {
      throw Exception("User not authenticated");
    }
  }

  Future<void> deleteTimer(String timerKey) async {
    User? user = _auth.currentUser;
    if (user != null) {
      try {
        await _dbRef
            .child('users')
            .child(user.uid)
            .child('timers')
            .child(timerKey)
            .remove();
      } catch (e) {
        print("Error deleting timer: $e");
      }
    } else {
      throw Exception("User not authenticated");
    }
  }

  Stream<List<MapEntry<String, Timer>>> listenToTimers() {
    User? user = _auth.currentUser;
    List<MapEntry<String, Timer>> timers = [];
    if (user != null) {
      return _dbRef
          .child('users')
          .child(user.uid)
          .child('timers')
          .onValue
          .map((event) {
        final data = event.snapshot.value;
        if (data != null && data is Map) {
          timers = data.entries
              .map((entry) => MapEntry(entry.key as String,
                  Timer.fromMap(Map<String, dynamic>.from(entry.value))))
              .toList();
          quickSort(timers, 0, timers.length - 1);
        }
        return timers;
      });
    } else {
      throw Exception("User not authenticated");
    }
  }
}
