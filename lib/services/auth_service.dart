import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Sign up and add user to Firestore collection
  static Future<User?> signUp(String email, String password) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = cred.user;

      if (user != null) {
        // Add user to Firestore 'users' collection if not exists
        final userDoc = _db.collection('users').doc(user.uid);
        final docSnapshot = await userDoc.get();
        if (!docSnapshot.exists) {
          await userDoc.set({
            'email': user.email,
            'displayName': user.displayName,
            'joinedAt': FieldValue.serverTimestamp(),
          });
        }

        // Send verification email
        if (!user.emailVerified) {
          await user.sendEmailVerification();
        }

        return user;
      }
    } catch (e) {
      print('Signup error: $e');
    }
    return null;
  }

  /// Sign in
  static Future<User?> signIn(String email, String password) async {
    try {
      // Debug: log the email used for sign-in attempts
      // ignore: avoid_print
      print('AuthService.signIn() - attempting sign in for email=$email');

      final cred = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // ignore: avoid_print
      print(
        'AuthService.signIn() - signInWithEmailAndPassword succeeded uid=${cred.user?.uid}',
      );

      return cred.user;
    } catch (e, st) {
      // ignore: avoid_print
      print('SignIn error: $e');
      // ignore: avoid_print
      print('SignIn stack: $st');
    }
    return null;
  }

  /// Sign out
  static Future<void> signOut() async {
    try {
      // Debug: print current user before sign out
      final before = _auth.currentUser;
      // ignore: avoid_print
      print('AuthService.signOut() - before signOut, user=${before?.uid}');

      await _auth.signOut();

      // small delay to allow internal state to update across platforms
      await Future.delayed(const Duration(milliseconds: 200));

      final after = _auth.currentUser;
      // ignore: avoid_print
      print('AuthService.signOut() - after signOut, user=${after?.uid}');
    } catch (e, st) {
      // ignore: avoid_print
      print('AuthService.signOut() error: $e\n$st');
      rethrow;
    }
  }
}
