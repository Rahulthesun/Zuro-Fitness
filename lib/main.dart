import 'package:flutter/material.dart';
import 'app.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gym Booking App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFF0a0a0a),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF00ff88),
          brightness: Brightness.dark,
        ),
      ),
      home: const MainScreen(),
    );
  }
}