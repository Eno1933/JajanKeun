import 'package:flutter/material.dart';
import '../../data/services/auth_service.dart'; // Import service yang nanti dibuat

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // Text controllers
  final TextEditingController nameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  bool isLoading = false;

  void register() async {
    if (passwordController.text != confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password dan Confirm Password tidak sama')),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    final response = await AuthService.register(
      name: nameController.text,
      username: usernameController.text,
      email: emailController.text,
      password: passwordController.text,
      phone: phoneController.text,
      address: addressController.text,
    );

    setState(() {
      isLoading = false;
    });

    if (response['success']) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response['message'])),
      );
      Navigator.pushReplacementNamed(context, '/login'); // atau ke halaman login
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response['message'] ?? 'Register gagal')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
             // Gambar ilustrasi atas (bisa ganti asset sesuai kebutuhan)
            SizedBox(
              width: double.infinity,
              height: 180,
              child: Image.asset(
                'assets/images/login_illustration.png',
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
              ),
            ),

            const SizedBox(height: 30),

            // Tab Create Account & Login
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  Column(
                    children: [
                      const Text(
                        'Create Account',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF25523B),
                        ),
                      ),
                      Container(
                        height: 3,
                        width: 100,
                        margin: const EdgeInsets.only(top: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF25523B),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      )
                    ],
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacementNamed(context, '/login');
                    },
                    child: const Text(
                      'Login',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // (Bagian ilustrasi dan tab Create/Login tetap)
            // .... [SKIP] ....

            const SizedBox(height: 24),

            // Form Register
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name
                    const Text("Name", style: TextStyle(fontFamily: 'Poppins', fontSize: 14)),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(
                        hintStyle: const TextStyle(fontFamily: 'Poppins'),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),

                    const SizedBox(height: 16),
                    // Username
                    const Text("Username", style: TextStyle(fontFamily: 'Poppins', fontSize: 14)),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: usernameController,
                      decoration: InputDecoration(
                        hintStyle: const TextStyle(fontFamily: 'Poppins'),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),

                    const SizedBox(height: 16),
                    // Email
                    const Text("Email address", style: TextStyle(fontFamily: 'Poppins', fontSize: 14)),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintStyle: const TextStyle(fontFamily: 'Poppins'),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),

                    const SizedBox(height: 16),
                    // Password
                    const Text("Password", style: TextStyle(fontFamily: 'Poppins', fontSize: 14)),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintStyle: const TextStyle(fontFamily: 'Poppins'),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),

                    const SizedBox(height: 16),
                    // Confirm Password
                    const Text("Confirm Password", style: TextStyle(fontFamily: 'Poppins', fontSize: 14)),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: confirmPasswordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintStyle: const TextStyle(fontFamily: 'Poppins'),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),

                    const SizedBox(height: 16),
                    // Phone
                    const Text("Phone", style: TextStyle(fontFamily: 'Poppins', fontSize: 14)),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        hintStyle: const TextStyle(fontFamily: 'Poppins'),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),

                    const SizedBox(height: 16),
                    // Address
                    const Text("Address", style: TextStyle(fontFamily: 'Poppins', fontSize: 14)),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: addressController,
                      maxLines: 3,
                      decoration: InputDecoration(

                        hintStyle: const TextStyle(fontFamily: 'Poppins'),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Register Button
                    Center(
                      child: ElevatedButton(
                        onPressed: isLoading ? null : register,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF25523B),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 20),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: Text(
                          isLoading ? "Loading..." : "Register",
                          style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
