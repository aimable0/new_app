import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:new_app/models/app_user.dart';

class FirestoreService {
  // --- Database Interaction (Your requested logic) ---

  /// This allows us to interact with [AppUser] objects directly.
  static final ref = FirebaseFirestore.instance
      .collection('users') // Changed from 'characters'
      .withConverter(
        fromFirestore: AppUser.fromFirestore, // Changed from 'Character'
        toFirestore: (AppUser user, _) =>
            user.toFirestore(), // Changed from 'Character'
      );

  /// Creates or updates a user's profile in the database
  static Future<void> addUserProfile(AppUser user) async {
    // matches the Firebase Auth UID. This is CRITICAL.
    await ref.doc(user.uid).set(user);
  }

  /// Fetches a single user's profile from Firestore.
  static Future<DocumentSnapshot<AppUser>> getUserProfile(String uid) {
    return ref.doc(uid).get(); // Returns a single user document
  }
}
