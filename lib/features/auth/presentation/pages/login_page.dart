// lib/features/auth/presentation/pages/login_page.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/services/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    final response = await AuthService.login(
      username: _usernameController.text.trim(),
      password: _passwordController.text.trim(),
    );
    setState(() => _isLoading = false);

    if (response['success'] == true) {
      final data = response['data'] as Map<String, dynamic>;
      final role = (data['role'] as String).toLowerCase();
      final prefs = await SharedPreferences.getInstance();

      // ✅ Simpan data pengguna ke SharedPreferences
      await prefs.setBool('is_logged_in', true);
      await prefs.setString('user_name', data['name'] as String);
      await prefs.setString('user_photo', data['photo'] ?? '');
      await prefs.setString('user_role', role); // ⬅ penting

      // ✅ Arahkan ke dashboard sesuai role
      String targetRoute;
      if (role == 'admin') {
        targetRoute = '/admin_dashboard';
      } else {
        targetRoute = '/user_dashboard';
      }

      Navigator.pushReplacementNamed(context, targetRoute);
    } else {
      final msg = response['message'] ?? 'Login gagal';
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Ilustrasi atas
              SizedBox(
                width: double.infinity,
                height: 180,
                child: Image.asset(
                  'assets/images/login_illustration.png',
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 30),

              // Tab Create / Login
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () =>
                          Navigator.pushReplacementNamed(context, '/register'),
                      child: const Text(
                        'Create Account',
                        style: TextStyle(
                            color: Colors.black54, fontWeight: FontWeight.w500),
                      ),
                    ),
                    const Spacer(),
                    Column(
                      children: [
                        const Text(
                          'Login',
                          style: TextStyle(
                              color: Color(0xFF25523B),
                              fontWeight: FontWeight.bold),
                        ),
                        Container(
                          height: 3,
                          width: 40,
                          margin: const EdgeInsets.only(top: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFF25523B),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Form
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Username or Email",
                          style: TextStyle(fontSize: 14)),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _usernameController,
                        validator: (v) => (v == null || v.isEmpty)
                            ? 'Please enter username or email'
                            : null,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.person),
                          hintText: 'Enter username or email',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text("Password", style: TextStyle(fontSize: 14)),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        validator: (v) => (v == null || v.isEmpty)
                            ? 'Please enter password'
                            : null,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.lock),
                          suffixIcon: IconButton(
                            icon: Icon(_obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility),
                            onPressed: () {
                              setState(
                                  () => _obscurePassword = !_obscurePassword);
                            },
                          ),
                          hintText: 'Enter password',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {}, // TODO: implement forget password
                          child: const Text("Forget Password?",
                              style: TextStyle(color: Colors.black54)),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Login Button
                      Center(
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _login,
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: const Color(0xFF25523B),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 120,
                              vertical: 20,
                            ),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                      color: Colors.white, strokeWidth: 2),
                                )
                              : const Text("Login",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  )),
                        ),
                      ),
                      const SizedBox(height: 15),

                      // Separator
                      Center(
                          child: Container(
                              width: 148, height: 1, color: Colors.black26)),
                      const SizedBox(height: 15),

                      // Google Login (placeholder)
                      Center(
                        child: OutlinedButton.icon(
                          onPressed: () {}, // TODO: implement Google login
                          icon: Image.asset('assets/icons/ic_google.png',
                              height: 20),
                          label: const Text("Login with Google"),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.black,
                            backgroundColor: Colors.grey.shade100,
                            side: const BorderSide(color: Colors.black12),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 66,
                              vertical: 20,
                            ),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
