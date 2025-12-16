import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/foundation.dart';

class StorageService {
  final firebase_storage.FirebaseStorage _storage = firebase_storage.FirebaseStorage.instance;

  /// Uploads an image file to Firebase Storage and returns the download URL.
  ///
  /// [filePath] is the path of the file on the device.
  /// [destinationPath] is the desired path in Firebase Storage (e.g., 'profile_images/user_id.jpg').
  Future<String> uploadImage(String filePath, String destinationPath) async {
    final file = File(filePath);

    try {
      // Create a reference to the location you want to upload to
      final ref = _storage.ref(destinationPath);

      // Upload the file
      final uploadTask = ref.putFile(file);

      // Wait for the upload to complete
      final snapshot = await uploadTask.whenComplete(() => {});

      // Get the download URL
      final downloadUrl = await snapshot.ref.getDownloadURL();

      debugPrint("File uploaded successfully. URL: $downloadUrl");
      return downloadUrl;

    } on firebase_storage.FirebaseException catch (e) {
      // Handle potential errors like permission denied
      debugPrint("Failed to upload image: $e");
      throw Exception('Storage Error: Could not upload file.');
    } catch (e) {
      debugPrint("An unexpected error occurred during upload: $e");
      throw Exception('An unexpected error occurred.');
    }
  }
}
