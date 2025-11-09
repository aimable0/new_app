import 'package:google_fonts/google_fonts.dart';
import 'package:new_app/screens/welcome/sign_in.dart';
import 'package:new_app/screens/welcome/sign_up.dart';
import 'package:new_app/shared/styled_button.dart';
import 'package:new_app/shared/styled_text.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool isSignUpForm = true;

  void toggleIsSignUp() {
    isSignUpForm = !isSignUpForm;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 30,),
              StyledHeading('BookSwap'),
              const SizedBox(height: 20,),
              StyledBodyText2('  Swap Your Books\nWith Other Students'),
              const SizedBox(height: 25,),

              // sign up screen
              if (isSignUpForm)
                Column(
                  children: [
                    SignUpForm(),
                    StyledBodyText('Already have an account?'),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          isSignUpForm = !isSignUpForm;
                        });
                      },
                      child: Text(
                        'Sign In instead',
                        style: GoogleFonts.poppins(),
                      ),
                    ),
                  ],
                ),

              // sign in screen
              if (!isSignUpForm)
                Column(
                  children: [
                    SignInForm(),
                    StyledBodyText('Dont have an account?'),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          isSignUpForm = !isSignUpForm;
                        });
                      },
                      child: Text(
                        'Sign Up instead',
                        style: GoogleFonts.poppins(),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
