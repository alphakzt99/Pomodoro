import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class StorageHandler {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> uploadFile(String filePath, String fileName) async {
    if (_auth.currentUser == null) throw 'User not authenticated';

    try {
      final ref = _storage
          .ref()
          .child('users')
          .child(_auth.currentUser!.uid)
          .child(filePath);

      final uploadTask = await ref.putFile(File(filePath));
      return await uploadTask.ref.getDownloadURL();
    } catch (e) {
      rethrow;
    }
  }

  Future<String> getDownloadURL(String filePath, String fileName) async {
    if (_auth.currentUser == null) throw 'User not authenticated';

    try {
      final ref = _storage
          .ref()
          .child('users')
          .child(_auth.currentUser!.uid)
          .child(filePath);
      return await ref.getDownloadURL();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteFile(String filePath, String fileName) async {
    if (_auth.currentUser == null) throw 'User not authenticated';

    try {
      final ref = _storage
          .ref()
          .child('users')
          .child(_auth.currentUser!.uid)
          .child(filePath);
      await ref.delete();
    } catch (e) {
      rethrow;
    }
  }
}
