import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/auth/presentation/pages/splash_screen.dart';
import 'features/auth/presentation/pages/onboarding_screen.dart';
import 'features/auth/presentation/pages/register_page.dart';
import 'features/auth/presentation/pages/user_dashboard.dart';
import 'features/auth/presentation/pages/settings_page.dart';
import 'features/auth/presentation/pages/user_profile_page.dart';

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
        textTheme: GoogleFonts.poppinsTextTheme(),
        scaffoldBackgroundColor: Colors.white,
        primarySwatch: Colors.orange,
      ),
      initialRoute: '/',
      routes: {
        '/': (_) => const SplashScreen(),
        '/onboarding': (_) => const OnboardingScreen(),
        '/login': (_) => const LoginPage(),
        '/register': (_) => const RegisterPage(),
        '/settings': (context) => const SettingsPage(),
        '/user_dashboard': (_) => UserDashboard(), // ✅ gunakan underscore
        '/orders': (context) => const OrdersPage(),
        '/profile': (context) => const UserProfilePage(),
        '/edit-profile': (context) => const EditProfilePage(),
      },
    );
  }
}
