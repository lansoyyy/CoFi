import 'package:cofi/screens/auth/landing_screen.dart';
import 'package:flutter/material.dart';
import 'screens/auth/splash_screen.dart';
import 'screens/auth/signup_screen.dart';
import 'screens/subscreens/cafe_details_screen.dart';
import 'utils/colors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cofi',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: primary),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
      routes: {
        '/cafeDetails': (context) => const CafeDetailsScreen(),
      },
    );
  }
}
