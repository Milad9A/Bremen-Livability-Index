import 'package:flutter/material.dart';
import 'screens/map_screen.dart';

void main() {
  runApp(const BremenLivabilityApp());
}

class BremenLivabilityApp extends StatelessWidget {
  const BremenLivabilityApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bremen Livability Index',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: const MapScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
