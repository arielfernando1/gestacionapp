import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class Storage {
  final firebaseStorage = FirebaseStorage.instance;
  Future<void> uploadFile(String filePath, String fileName) async {
    final file = File(filePath);
    try {
      await firebaseStorage.ref('test/$fileName').putFile(file);
    } on FirebaseException {
      // e.g, e.code == 'canceled'
    }
  }

  // list all files
  Future<List<String>> listAll() async {
    final result = await firebaseStorage.ref('test').listAll();
    final urls = <String>[];
    for (final ref in result.items) {
      final url = await ref.getDownloadURL();
      urls.add(url);
    }
    return urls;
  }
}
