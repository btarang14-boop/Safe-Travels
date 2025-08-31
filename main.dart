
import 'package:flutter/material.dart';
import 'screens/start_trip.dart';

void main() {
  runApp(const SafetyMvpApp());
}

class SafetyMvpApp extends StatelessWidget {
  const SafetyMvpApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Safety MVP',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2563EB)),
        useMaterial3: true,
      ),
      home: const StartTripScreen(),
    );
  }
}
