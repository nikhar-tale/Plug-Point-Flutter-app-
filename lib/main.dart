// lib/main.dart
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'presentation/views/onboarding_screen.dart';
// ignore: unused_import
import 'utils/text_theme_extensions.dart'; // Import the extension

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EV Charging App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        // Optionally, you can also define your textTheme here.
      ),
      home: OnboardingScreen(),
    );
  }
}
