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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    return MaterialApp(
      title: 'BookSwap App',
      theme: primaryTheme,
      debugShowCheckedModeBanner: false,
      home: authState.when(
        data: (user) {
          // No user -> go to welcome screen
          if (user == null) return const WelcomeScreen();

          // User exists but not verified
          if (!user.emailVerified) return const VerifyScreen();

          // Verified -> show main app
          return const Browse();
        },
        loading: () => const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
        error: (err, _) => Scaffold(
          body: Center(child: Text('Error: $err')),
        ),
      ),
    );
  }
}
