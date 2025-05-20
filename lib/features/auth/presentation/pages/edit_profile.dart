import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      nameController.text = prefs.getString('name') ?? '';
      addressController.text = prefs.getString('address') ?? '';
    });
  }

  Future<void> updateProfile() async {
  final prefs = await SharedPreferences.getInstance();
  final userId = prefs.getString('user_id') ?? '';

  final response = await http.post(
    Uri.parse('http://192.168.12.44/jajankeun_api/update_profile.php'),
    body: {
      'user_id': userId,
      'name'   : nameController.text,
      'address': addressController.text,
    },
  );

  // Cetak untuk debugging
  print('Status code: ${response.statusCode}');
  print('Response body: ${response.body}');

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body) as Map<String, dynamic>;

    if (data['success'] == true) {
      // Simpan data ke lokal
      await prefs.setString('name', nameController.text);
      await prefs.setString('address', addressController.text);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(data['message'] ?? 'Profil berhasil diperbarui')),
      );
      Navigator.pop(context, true); // kembalikan data 'true' agar profil tahu harus refresh
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(data['message'] ?? 'Gagal memperbarui profil')),
      );
    }
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Terjadi kesalahan server: ${response.statusCode}')),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Profil", style: GoogleFonts.poppins()),
        backgroundColor: const Color(0xFF25523B),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Nama Lengkap'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: addressController,
                decoration: const InputDecoration(labelText: 'Alamat'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Alamat tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    updateProfile();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF25523B),
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                ),
                child: Text('Simpan', style: GoogleFonts.poppins(color: Colors.white)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
