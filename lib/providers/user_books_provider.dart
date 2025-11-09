import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:new_app/models/book/book.dart';
import 'package:new_app/services/firestore_service.dart';

final userBooksProvider = StreamProvider<List<Book>>((ref) {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return const Stream.empty();

  return FirestoreService.getMyBooksStream(user.uid)
      .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
});

// delete book from database
