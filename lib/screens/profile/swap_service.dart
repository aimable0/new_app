import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:new_app/models/book/book.dart';
import 'package:new_app/models/book/book_enums.dart'; // Make sure this path is correct

// 1. Create a provider for your service
final swapServiceProvider = Provider((ref) => SwapService());

class SwapService {
  final _firestore = FirebaseFirestore.instance;

  /// Initiates a swap by creating a 'swap' doc and updating the book status.
  /// Returns the ID of the new swap document (which is the chat room ID).
  Future<String> initiateSwap({
    required Book book,
    required User sender,
  }) async {
    try {
      // 1. Create the new swap document in the 'swaps' collection
      final newSwapDoc = _firestore.collection('swaps').doc();

      // This is the data for your new chat room
      final swapData = {
        'status': 'pending', // The status of the *swap*, not the book
        'bookId': book.id,
        'bookTitle': book.title, // Denormalized for easy access
        'bookCoverUrl': book.coverImageUrl, // Denormalized
        'senderId': sender.uid,
        'senderName': sender.displayName ?? 'Sender',
        'receiverId': book.ownerId,
        'receiverName': book.ownerName ?? 'Owner',
        'createdAt': FieldValue.serverTimestamp(),
        'participants': [sender.uid, book.ownerId],
      };

      // 2. Write the new swap document
      await newSwapDoc.set(swapData);

      // 3. Update the book's status to 'pending'
      await _firestore
          .collection('books')
          .doc(book.id)
          .update({'status': BookStatus.pending.name}); // 'pending'

      // 4. Return the new swap ID
      return newSwapDoc.id;
    } catch (e) {
      print("Error initiating swap: $e");
      rethrow;
    }
  }
}