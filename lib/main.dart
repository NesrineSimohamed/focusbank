import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:device_preview/presets.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:focusbank/firebase_options.dart';
import 'package:focusbank/screens/welcome_screen.dart';

Future<void> main() async {
  // Required when you "await" something BEFORE runApp.
  DevicePreview.enable();
  await DevicePreview.controller.applyPreset(DevicePresets.galaxyS25);

  // 2) Only then connect to Firebase (it needs the binding to exist).
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const FocusbankApp());
}

class FocusbankApp extends StatelessWidget {
  const FocusbankApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Focusbank',
      debugShowCheckedModeBanner: false,
      home: WelcomeScreen(),
    );
  }
}
