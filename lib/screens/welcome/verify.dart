import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class VerifyScreen extends StatefulWidget {
  const VerifyScreen({super.key});

  @override
  State<VerifyScreen> createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  User? user;
  bool emailSent = false;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser;

    if (user != null && !user!.emailVerified) {
      sendVerificationEmail();
    }
  }

  Future<void> sendVerificationEmail() async {
    try {
      await user!.sendEmailVerification();
      setState(() => emailSent = true);
    } catch (e) {
      print('Error sending verification email: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text(
                  'Failed to send verification email. Try again later.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          emailSent
              ? 'Verification email sent to ${user!.email}. Please check your inbox.'
              : 'Sending verification email...',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
