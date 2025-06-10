import 'package:final_year_project/screens/adminDashboard.dart';
import 'package:final_year_project/screens/adminDashboard.dart';
import 'package:final_year_project/screens/dashboard_screen.dart';
import 'package:final_year_project/screens/login_screen.dart';
import 'package:final_year_project/screens/signup_screen.dart';
import 'package:final_year_project/screens/splash_screen.dart';
import 'package:final_year_project/screens/onboarding_screen.dart';  // <-- added
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyAVsRZV5hOIpXfyKAiILthBAjbZA4sdYUw",
      appId: "1:142788282617:android:2f3f0110bfb20a4d097a28",
      messagingSenderId: "142788282617",
      storageBucket: "travelapp-e6a9c.appspot.com",
      projectId: "travelapp-e6a9c",
    ),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color.fromRGBO(64, 147, 206, 100),
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/onboarding': (context) => const OnboardingScreen(),  // <-- added
        '/login': (context) => const LoginPage(),
        '/signup': (context) => const SignUpPage(),
        '/dashboard': (context) => const DashboardScreen(),
        '/admin': (context) => const AdminDashboardScreen (),
      },
    );
  }
}
