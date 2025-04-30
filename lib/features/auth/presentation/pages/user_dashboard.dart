import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserDashboard extends StatelessWidget {
  const UserDashboard({super.key});

  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Hapus semua data sesi/login
    Navigator.pushReplacementNamed(context, '/login'); // Kembali ke login
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Dashboard'),
        backgroundColor: const Color(0xFF25523B),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _logout(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF25523B),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text(
            "Logout",
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
