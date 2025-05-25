import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({Key? key}) : super(key: key);

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  Map<String, String?> userData = {
    'name': '',
    'username': '',
    'email': '',
    'phone': '',
    'address': '',
    'role': '',
    'photo': '',
  };

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userData = {
        'name': prefs.getString('name'),
        'username': prefs.getString('username'),
        'email': prefs.getString('email'),
        'phone': prefs.getString('phone'),
        'address': prefs.getString('address'),
        'role': prefs.getString('role'),
        'photo': prefs.getString('photo'),
      };
    });
  }

  Future<void> _pickAndUploadImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked == null) return;

    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('user_id') ?? '';

    final req = http.MultipartRequest(
      'POST',
      Uri.parse('http://192.168.222.44/jajankeun_api/update_photo.php'),
    );
    req.fields['user_id'] = userId;
    req.files.add(await http.MultipartFile.fromPath('photo', picked.path));

    final resp = await req.send();
    if (resp.statusCode == 200) {
      final body = await resp.stream.bytesToString();
      final json = jsonDecode(body);
      if (json['success'] == true) {
        final newPhoto = json['photo'] as String;
        await prefs.setString('photo', newPhoto);
        setState(() => userData['photo'] = newPhoto);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Foto profil berhasil diperbarui')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(json['message'] ?? 'Upload gagal')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal mengunggah foto')),
      );
    }
  }

  Widget buildInfoCard(String title, Map<String, String?> items) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600, fontSize: 16)),
          const SizedBox(height: 10),
          ...items.entries.map((e) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(e.key,
                        style: GoogleFonts.poppins(color: Colors.grey[700])),
                    Text(e.value ?? '-',
                        style:
                            GoogleFonts.poppins(fontWeight: FontWeight.w500)),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  void _onNavTap(int index) {
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/user_dashboard');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/cart');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/orders');
        break;
      case 3:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context, true), // <- kembalikan true
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 4)
                ],
              ),
              child: IconButton(
                icon: const Icon(Icons.notifications, color: Colors.black),
                onPressed: () {},
              ),
            ),
          )
        ],
      ),
      body: ListView(
        children: [
          const SizedBox(height: 16),
          Center(
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: userData['photo'] != null &&
                          userData['photo']!.isNotEmpty
                      ? NetworkImage(
                          'http://192.168.222.44/jajankeun_api/uploads/profile/${userData['photo']}?v=${DateTime.now().millisecondsSinceEpoch}')
                      : const AssetImage('assets/images/user.png')
                          as ImageProvider,
                ),
                Positioned(
                  bottom: 0,
                  right: 4,
                  child: GestureDetector(
                    onTap: _pickAndUploadImage,
                    child: const CircleAvatar(
                      radius: 16,
                      backgroundColor: Colors.white,
                      child:
                          Icon(Icons.edit, color: Color(0xFF25523B), size: 18),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: Text(userData['name'] ?? '',
                style: GoogleFonts.poppins(
                    fontSize: 20, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 4),
          Center(
            child: Text(
              (userData['role'] ?? '').toUpperCase(),
              style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey),
            ),
          ),
          const SizedBox(height: 24),
          buildInfoCard("Personal Info", {
            "Nama Lengkap": userData['name'],
            "Alamat": userData['address'],
            "Role": userData['role']?.toLowerCase() == 'siswa'
                ? 'Siswa'
                : userData['role'],
          }),
          buildInfoCard("Contact Info", {
            "No Handphone": userData['phone'],
            "Email": userData['email'],
          }),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ElevatedButton(
              onPressed: () async {
                final result =
                    await Navigator.pushNamed(context, '/edit-profile');
                if (result == true) {
                  loadUserData(); // Refresh data user setelah edit
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF25523B),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: Text("Edit",
                  style: GoogleFonts.poppins(
                      color: Colors.white, fontWeight: FontWeight.w600)),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 3,
        onTap: _onNavTap,
        selectedItemColor: const Color(0xFF25523B),
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart), label: 'Cart'),
          BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long), label: 'Orders'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
