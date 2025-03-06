import 'dart:core';
import 'timer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';


class DatabaseHandler {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();

  
  User? get currentUser => _auth.currentUser;

  
  Future<String?> signUp(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
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
        DatabaseReference databaseReference = _dbRef
        .child('users')
        .child(user.uid)
        .child('timers')
        .push();

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
          return timersMap.entries
              .map((entry) => MapEntry(entry.key as String, Timer.fromMap(Map<String, dynamic>.from(entry.value))))
              .toList();
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
    if (user != null) {
      return _dbRef
          .child('users')
          .child(user.uid)
          .child('timers')
          .onValue
          .map((event) {
        final data = event.snapshot.value;
        if (data != null && data is Map) {
          return data.entries
              .map((entry) => MapEntry(entry.key as String, Timer.fromMap(Map<String, dynamic>.from(entry.value))))
              .toList();
        }
        return [];
      });
    } else {
      throw Exception("User not authenticated");
    }
  }
}


