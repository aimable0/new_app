import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:new_app/models/app_user.dart';
import 'package:new_app/models/book/book.dart';
import 'package:new_app/models/book/book_enums.dart';

class FirestoreService {
  // A reference to 'users' collection.
  static final refUsers = FirebaseFirestore.instance
      .collection('users') // Changed from 'characters'
      .withConverter(
        fromFirestore: AppUser.fromFirestore, // Changed from 'Character'
        toFirestore: (AppUser user, _) =>
            user.toFirestore(), // Changed from 'Character'
      );

  // A reference to the  'books' collection.
  static final refBooks = FirebaseFirestore.instance
      .collection('books') // This is the 'global' books collection
      .withConverter(
        fromFirestore: Book.fromFirestore,
        toFirestore: (Book book, _) => book.toFirestore(),
      );

  /***********************************************************************
   *  LOGIC FOR HANDLING THE 'USERS' COLLECTION
   */

  /// Creates or updates a user's profile in the database
  static Future<void> addUserProfile(AppUser user) async {
    await refUsers.doc(user.uid).set(user);
  }

  /// Fetches a single user's profile from Firestore.
  static Future<DocumentSnapshot<AppUser>> getUserProfile(String uid) {
    return refUsers.doc(uid).get(); // Returns a single user document
  }



  /***********************************************************************
   *  LOGIC FOR HANDLING THE 'BOOKS' COLLECTION
   */
  /// Posts a new book to Firestore.
  /// We let Firestore generate the document ID.
  static Future<DocumentReference<Book>> postBook(Book book) async {
    // We use .add() here because Firestore can create the ID for us.
    // We'll have to update our book object with the new ID,
    // or just pass in a book *without* an ID.
    //
    // A simpler way for 'postBook' is to pass the data, not a full object.
    // But to follow your pattern:
    return refBooks.add(book);
  }

  /// Updates an existing book (e.g., to set status to 'pending')
  static Future<void> updateBook(Book book) async {
    await refBooks.doc(book.id).set(book, SetOptions(merge: true));
  }

  /// Deletes a book
  static Future<void> deleteBook(String bookId) async {
    await refBooks.doc(bookId).delete();
  }

  /// Gets a real-time stream of *all available* books.
  /// This is for your "Browse Listings" feed.
  static Stream<QuerySnapshot<Book>> getAvailableBooksStream(String currentUserId) {
    return refBooks
        .where('status', isEqualTo: BookStatus.available.name)
        .where('ownerId', isNotEqualTo: currentUserId)
        .orderBy('postedAt', descending: true)
        .snapshots(); // .snapshots() gives us the real-time stream
  }

  /// Gets a real-time stream of *only* the current user's books.
  /// This is for your "My Listings" screen.
  static Stream<QuerySnapshot<Book>> getMyBooksStream(String userId) {
    return refBooks
        .where('ownerId', isEqualTo: userId)
        .orderBy('postedAt', descending: true)
        .snapshots();
  }
}
