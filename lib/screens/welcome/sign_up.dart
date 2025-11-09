import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:new_app/models/app_user.dart';
import 'package:new_app/services/auth_service.dart';
import 'package:new_app/services/firestore_service.dart';
import 'package:new_app/shared/styled_button.dart';
import 'package:new_app/shared/styled_text.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordController2 = TextEditingController();
  final TextEditingController _displayName = TextEditingController();

  String? _errorFeedback;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // intro text
            const Center(child: StyledBodyText("Let's get started!")),
            const SizedBox(height: 16.0),

            // username
            TextFormField(
              style: GoogleFonts.poppins(),
              controller: _displayName,
              decoration: InputDecoration(
                labelText: 'Full name',
                labelStyle: GoogleFonts.poppins(),
                helperStyle: GoogleFonts.poppins(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a username';
                }
                return null;
              },
            ),
            const SizedBox(height: 16.0),

            // email address
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Email',
                labelStyle: GoogleFonts.poppins(),
                helperStyle: GoogleFonts.poppins(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                }
                return null;
              },
            ),
            const SizedBox(height: 16.0),

            TextFormField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
                labelStyle: GoogleFonts.poppins(),
                helperStyle: GoogleFonts.poppins(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please make a password';
                }
                if (value.length < 8) {
                  return 'Password must be at least 8 chars long';
                }
                return null;
              },
            ),

            const SizedBox(height: 16.0),
            TextFormField(
              controller: _passwordController2,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Re-Enter Password',
                labelStyle: GoogleFonts.poppins(),
                helperStyle: GoogleFonts.poppins(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please make a password';
                }
                if (value.length < 8) {
                  return 'Password must be at least 8 chars long';
                }
                if (_passwordController.text.trim() !=
                    _passwordController2.text.trim()) {
                  return 'Password do not match';
                }
                return null;
              },
            ),
            const SizedBox(height: 16.0),

            // error feedback
            if (_errorFeedback != null)
              Text(_errorFeedback!, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 16.0),

            // submit button
            StyledButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  setState(() {
                    _errorFeedback = null;
                  });

                  final email = _emailController.text.trim();
                  final password = _passwordController.text.trim();

                  final user = await AuthService.signUp(email, password);

                  // error feedback here later
                  if (user == null) {
                    setState(() {
                      _errorFeedback = 'Could not sign up with those details.';
                    });
                  } else {
                    // save user to db
                    FirestoreService.addUserProfile(
                      AppUser(
                        uid: user.uid,
                        email: user.email!,
                        displayName: _displayName.text,
                        notificationReminders: true,
                        emailUpdates: false,
                      ),
                    );
                  }
                }
              },
              child: const StyledButtonText('Sign Up'),
            ),
          ],
        ),
      ),
    );
  }
}
