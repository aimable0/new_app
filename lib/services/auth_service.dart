import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Sign up and add user to Firestore collection
  static Future<User?> signUp(String email, String password) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      final user = cred.user;

      if (user != null) {
        // Add user to Firestore 'users' collection if not exists
        final userDoc = _db.collection('users').doc(user.uid);
        final docSnapshot = await userDoc.get();
        if (!docSnapshot.exists) {
          await userDoc.set({
            'email': user.email,
            'displayName': '',
            'joinedAt': FieldValue.serverTimestamp(),
            // add any other fields here
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
      final cred = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return cred.user;
    } catch (e) {
      print('SignIn error: $e');
    }
    return null;
  }

  /// Sign out
  static Future<void> signOut() async {
    await _auth.signOut();
  }
}
