import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:focusbank/firebase_options.dart';
import 'package:focusbank/screens/welcome_screen.dart';
import 'package:focusbank/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Connect to Firebase before the app starts.
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const FocusbankApp());
}

class FocusbankApp extends StatelessWidget {
  const FocusbankApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Focusbank',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const WelcomeScreen(),
    );
  }
}