import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  // --- Constructor & Fields ---
  // This is the data we'll store for each user in the 'users' collection
  AppUser({
    required this.uid,
    required this.email,
    required this.displayName,
    this.notificationReminders = true,
    this.emailUpdates = false,
  });

  final String uid; // This will be the Document ID from Firebase Auth
  final String email;
  final String displayName;

  // Settings fields
  final bool notificationReminders;
  final bool emailUpdates;

  // --- Firestore Conversion
  /// Converts an [AppUser] object into a [Map<String, dynamic>]
  /// for writing to Firestore.
  Map<String, dynamic> toFirestore() {
    return {
      "uid": uid, // Storing the UID is good for queries
      "email": email,
      "displayName": displayName,
      "settings": {
        "notificationReminders": notificationReminders,
        "emailUpdates": emailUpdates,
      },
    };
  }

  /// Creates an [AppUser] instance from a Firestore [DocumentSnapshot].
  factory AppUser.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    // Get data from snapshot
    final data = snapshot.data();

    // Safely read the nested settings map
    final settings = data?['settings'] as Map<String, dynamic>? ?? {};

    // Create the AppUser instance
    return AppUser(
      uid: snapshot.id, 
      email: data?['email'] ?? '',
      displayName: data?['displayName'] ?? '',
      notificationReminders: settings['notificationReminders'] ?? true,
      emailUpdates: settings['emailUpdates'] ?? false,
    );
  }
}
