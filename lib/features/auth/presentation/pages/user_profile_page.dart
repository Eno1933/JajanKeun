import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      };
    });
  }

  Widget buildUserInfo(String label, String? value) {
    return ListTile(
      leading: const Icon(Icons.person),
      title: Text(label),
      subtitle: Text(value ?? '-'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Pengguna'),
        backgroundColor: const Color(0xFF25523B),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Center(
            child: CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/images/user.png'),
            ),
          ),
          const SizedBox(height: 16),
          buildUserInfo('Nama', userData['name']),
          buildUserInfo('Username', userData['username']),
          buildUserInfo('Email', userData['email']),
          buildUserInfo('Telepon', userData['phone']),
          buildUserInfo('Alamat', userData['address']),
          buildUserInfo('Role', userData['role']),
        ],
      ),
    );
  }
}
