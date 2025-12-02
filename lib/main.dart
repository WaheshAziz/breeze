import 'package:flutter/material.dart';
import 'screens/home/home_screen.dart';

void main() {
  runApp(const BreezeApp());
}

class BreezeApp extends StatelessWidget {
  const BreezeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Breeze',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(),
    );
  }
}
