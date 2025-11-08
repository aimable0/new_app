import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:new_app/models/book/book_enums.dart'; // Import your enums

class Book {
  // -----------------------------------------------------------------
  // --- Constructor & Fields ---
  // -----------------------------------------------------------------

  Book({
    required this.id, // Firestore document ID
    required this.title,
    required this.author,
    required this.condition,
    required this.swapFor,
    required this.ownerId, // The UID of the user who posted it
    required this.status,
    required this.postedAt,
    this.coverImageUrl, // Optional
    this.ownerName, // Optional, but nice for the UI
  });

  final String id;
  final String title;
  final String author;
  final String swapFor;
  final String? coverImageUrl;
  final String ownerId;
  final String? ownerName; // Denormalized name for easy display
  final Timestamp postedAt; // So we can sort by "newest"
  final BookCondition condition;
  final BookStatus status;

  // -----------------------------------------------------------------
  // --- Firestore Conversion (Your requested logic) ---
  // -----------------------------------------------------------------

  /// Converts a [Book] object into a [Map<String, dynamic>]
  /// for writing to Firestore.
  Map<String, dynamic> toFirestore() {
    return {
      "title": title,
      "author": author,
      "coverImageUrl": coverImageUrl,
      "swapFor": swapFor,
      "ownerId": ownerId,
      "ownerName": ownerName,
      "postedAt": postedAt,
      // Convert enums to simple strings for Firestore
      "condition": condition.name, // e.g., "LikeNew"
      "status": status.name, // e.g., "available"
    };
  }

  /// Creates a [Book] instance from a Firestore [DocumentSnapshot].
  factory Book.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    // Get data from snapshot
    final data = snapshot.data();

    // Helper function to safely parse enums from strings
    // This prevents errors if the data is bad.
    T _safeEnumParse<T>(List<T> enumValues, String value, T defaultValue) {
      try {
        return enumValues.firstWhere(
          (e) => e.toString().split('.').last == value,
        );
      } catch (e) {
        return defaultValue;
      }
    }

    // Create the Book instance
    return Book(
      id: snapshot.id, // The document ID
      title: data?['title'] ?? '',
      author: data?['author'] ?? '',
      swapFor: data?['swapFor'] ?? '',
      coverImageUrl: data?['coverImageUrl'],
      ownerId: data?['ownerId'] ?? '',
      ownerName: data?['ownerName'],
      postedAt: data?['postedAt'] ?? Timestamp.now(),
      // Parse strings back into enums
      condition: _safeEnumParse(
        BookCondition.values,
        data?['condition'] ?? '',
        BookCondition.Used, // Default
      ),
      status: _safeEnumParse(
        BookStatus.values,
        data?['status'] ?? '',
        BookStatus.available, // Default
      ),
    );
  }
}
