import 'package:cofi/firebase_options.dart';
import 'package:cofi/screens/auth/landing_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'screens/auth/splash_screen.dart';
import 'screens/auth/signup_screen.dart';
import 'screens/home_screen.dart';
import 'screens/subscreens/cafe_details_screen.dart';
import 'screens/subscreens/your_reviews_screen.dart';
import 'screens/subscreens/visited_cafes_screen.dart';
import 'screens/subscreens/submit_shop_screen.dart';
import 'screens/subscreens/business_screen.dart';
import 'screens/subscreens/business_profile_screen.dart';
import 'screens/subscreens/map_view_screen.dart';
import 'utils/colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    name: 'cofi-3e5f4',
    options: DefaultFirebaseOptions.currentPlatform,
  );

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
      home: const AuthGate(),
      routes: {
        '/cafeDetails': (context) => const CafeDetailsScreen(),
        '/yourReviews': (context) => const YourReviewsScreen(),
        '/visitedCafes': (context) => const VisitedCafesScreen(),
        '/submitShop': (context) => const SubmitShopScreen(),
        '/business': (context) => const BusinessScreen(),
        '/businessProfile': (context) => const BusinessProfileScreen(),
        '/mapView': (context) => const MapViewScreen(),
      },
    );
  }
}

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // While initializing or waiting for auth state, show splash
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SplashScreen();
        }

        final user = snapshot.data;
        if (user == null) {
          // Not signed in -> show landing/login entry
          return const LandingScreen();
        }

        // Signed in -> go home
        return const HomeScreen();
      },
    );
  }
}
