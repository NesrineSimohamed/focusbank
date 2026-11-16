import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:device_preview/presets.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:focusbank/firebase_options.dart';
import 'package:focusbank/screens/welcome_screen.dart';
import 'package:focusbank/theme/app_theme.dart';

Future<void> main() async {
  DevicePreview.enable();
  await DevicePreview.controller.applyPreset(DevicePresets.galaxyS25);

  // Connect to Firebase before the app starts.
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const FocusbankApp());
}

class FocusbankApp extends StatelessWidget {
  const FocusbankApp({super.key});

  @override
  Widget build(BuildContext context) {
    // No "const" before MaterialApp anymore: AppTheme.darkTheme is
    // computed while the app runs, so it isn't a compile-time constant.
    return MaterialApp(
      title: 'Focusbank',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme, // her theme: her screens depend on it
      home: const WelcomeScreen(),
    );
  }
}