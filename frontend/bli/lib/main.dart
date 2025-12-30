import 'package:flutter/material.dart';
import 'screens/map_screen.dart';
import 'theme/app_theme.dart';

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
      home: const MapScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
