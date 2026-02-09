import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  Future<String> uploadImage(File file) async {
    final ref = FirebaseStorage.instance
        .ref("reports/${DateTime.now().millisecondsSinceEpoch}.jpg");

    await ref.putFile(file);
    return await ref.getDownloadURL();
  }
}
