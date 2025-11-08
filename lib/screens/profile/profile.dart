import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:new_app/models/app_user.dart';
import 'package:new_app/services/auth_service.dart';
import 'package:new_app/shared/styled_button.dart';
import 'package:new_app/shared/styled_text.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key, required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const StyledAppBarText('Your Profile'),
        backgroundColor: Colors.blue[500],
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const StyledHeading('Profile'),
            const SizedBox(height: 16),

            // output user email here later#
            StyledBodyText('Welcome to your profile, ${user.email}'),
            const SizedBox(height: 16),

            StyledButton(
              onPressed: () {
                AuthService.signOut();
              } ,
              child: const StyledButtonText('Log out'),
            )
          ],
        ),
      ),
    );
  }
}