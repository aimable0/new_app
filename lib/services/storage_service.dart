import 'dart:io'; // Required to work with the 'File' type
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  // Get an instance of Firebase Storage
  static final FirebaseStorage _storage = FirebaseStorage.instance;

  /// Uploads a book cover image file to Firebase Storage.
  ///
  /// [imageFile] is the file picked by the user.
  /// [userId] is the ID of the user uploading the file, to keep things organized.
  ///
  /// Returns the public [downloadURL] of the uploaded image.
  static Future<String> uploadBookCover(File imageFile, String userId) async {
    try {
      // 1. Create a unique file name for the image.
      // Using a timestamp ensures every filename is unique.
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();

      // 2. Define the path in Firebase Storage.
      // e.g., 'book_covers/abc123xyz/1678886400000.jpg'
      String filePath = 'book_covers/$userId/$fileName';

      // 3. Get a reference to that path.
      Reference ref = _storage.ref().child(filePath);

      // 4. Upload the file.
      UploadTask uploadTask = ref.putFile(imageFile);

      // 5. Wait for the upload to complete.
      TaskSnapshot snapshot = await uploadTask;

      // 6. Get the public Download URL.
      String downloadUrl = await snapshot.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      // Handle any errors (e.g., permission denied)
      print("Error uploading image: $e");
      rethrow; // Re-throw the error to be handled by the UI
    }
  }
}