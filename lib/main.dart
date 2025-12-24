// import 'package:flutter/material.dart';
import 'app.dart';
import 'firebase_options.dart';
//   runApp(const MyApp());
// }

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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