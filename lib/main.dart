import 'package:flutter/material.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/auth/presentation/pages/splash_screen.dart';
import 'features/auth/presentation/pages/onboarding_screen.dart';
import 'features/auth/presentation/pages/register_page.dart';
import 'features/auth/presentation/pages/user_dashboard.dart';

void main() {
  runApp(const JajanKeunApp());
}

class JajanKeunApp extends StatelessWidget {
  const JajanKeunApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JajanKeun',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      initialRoute: '/',
      routes: {
        '/': (_) => const SplashScreen(),
        '/onboarding': (_) => const OnboardingScreen(),
        '/login': (_) => const LoginPage(),
        '/register': (_) => const RegisterPage(),
        '/user_dashboard': (_) => const UserDashboard(), // ✅ gunakan underscore
      },
    );
  }
}
