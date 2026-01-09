import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class StorageHandler {
  static const String defaultDirectory = 'public';

  Future<String> getImageUrl(String image,
      {String directory = defaultDirectory}) async {
    try {
      Reference ref = FirebaseStorage.instance.ref();
      var fileReference = ref.child('$directory/$image');
      return await fileReference.getDownloadURL();
    } on FirebaseException catch (e) {
      return '';
    }
  }

  Future<bool> uploadFile() async {
    return false;
  }
}
