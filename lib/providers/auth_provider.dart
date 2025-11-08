import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

final authProvider = StreamProvider.autoDispose<User?>((ref) async* {
  final auth = FirebaseAuth.instance;

  await for (final user in auth.authStateChanges()) {
    if (user != null) {
      // reload to update emailVerified
      await user.reload();
      yield auth.currentUser;

      // Periodic check if not verified using an async loop (can yield here)
      var cancelled = false;
      ref.onDispose(() => cancelled = true);

      if (!user.emailVerified) {
        while (!cancelled && !user.emailVerified) {
          await Future.delayed(const Duration(seconds: 5));
          await user.reload();
          yield auth.currentUser;
        }
      }
    } else {
      yield null;
    }
  }
});
