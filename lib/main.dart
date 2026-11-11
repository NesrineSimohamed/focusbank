
import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:device_preview/presets.dart';
import 'package:focusbank/screens/welcome_screen.dart';

Future<void> main() async {
  DevicePreview.enable();

  await DevicePreview.controller.applyPreset(
    DevicePresets.galaxyS25,
  );

  runApp(const FocusbankApp());
}

// The root widget of the app.
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
