import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/home/home_screen.dart';
import 'providers/weather_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => WeatherProvider(),
      child: const BreezeApp(),
    ),
  );
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
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
        ),
      ),

      home: const HomeScreen(),
    );
  }
}


