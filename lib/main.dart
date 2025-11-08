import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:new_app/providers/auth_provider.dart';
import 'package:new_app/screens/profile/browse.dart';
import 'package:new_app/theme.dart';
import 'firebase_options.dart';

import 'screens/welcome/welcome.dart';
import 'screens/welcome/verify.dart';
import 'screens/profile/profile.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BookSwap App',
      theme: primaryTheme,
      home: Consumer(
        builder: (context, ref, child) {
          final authState = ref.watch(authProvider);

          return authState.when(
            data: (user) {
              if (user == null) return const WelcomeScreen();

              if (!user.emailVerified) return const VerifyScreen();

              return Browse();
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, _) =>
                Center(child: Text('Error loading auth status: $err')),
          );
        },
      ),
    );
  }
}
