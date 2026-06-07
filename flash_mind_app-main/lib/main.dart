import 'package:flutter/material.dart';
import 'Screens/splash_screen.dart'; // Sahi casing (Screens) ke sath import

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flashcard Quiz App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(brightness: Brightness.dark, useMaterial3: true),
      home: const SplashScreen(),
    );
  }
}
