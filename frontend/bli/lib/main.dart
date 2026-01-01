import 'package:bli/screens/start_screen.dart';
import 'package:bli/theme/app_theme.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const BremenLivabilityApp());
}

class BremenLivabilityApp extends StatelessWidget {
  const BremenLivabilityApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bremen Livability Index',
      theme: AppTheme.lightTheme,
      home: const StartScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
