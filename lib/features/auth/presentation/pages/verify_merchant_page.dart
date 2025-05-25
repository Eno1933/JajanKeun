import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class VerifyMerchantProfilePage extends StatefulWidget {
  const VerifyMerchantProfilePage({Key? key}) : super(key: key);

  @override
  State<VerifyMerchantProfilePage> createState() => _VerifyMerchantProfilePageState();
}

class _VerifyMerchantProfilePageState extends State<VerifyMerchantProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _nikController = TextEditingController();
  final _businessNameController = TextEditingController();

  File? _ktpImage;
  File? _stallImage;
  bool _isLoading = false;

  Future<void> _pickImage(bool isKtp) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery, imageQuality: 75);
    if (picked == null) return;
    setState(() {
      if (isKtp) _ktpImage = File(picked.path);
      else _stallImage = File(picked.path);
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_ktpImage == null || _stallImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Harap upload foto KTP dan foto lapak')),
      );
      return;
    }
    setState(() => _isLoading = true);

    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('user_id') ?? '';

    final uri = Uri.parse('http://192.168.222.44/jajankeun_api/verify_merchant.php');
    final req = http.MultipartRequest('POST', uri)
      ..fields['user_id'] = userId
      ..fields['nik'] = _nikController.text.trim()
      ..fields['business_name'] = _businessNameController.text.trim()
      ..files.add(await http.MultipartFile.fromPath('ktp_photo', _ktpImage!.path))
      ..files.add(await http.MultipartFile.fromPath('stall_photo', _stallImage!.path));

    final resp = await req.send();
    final body = await resp.stream.bytesToString();
    setState(() => _isLoading = false);

    if (resp.statusCode == 200) {
      // asumsikan API kembalikan JSON { success: bool, message: String }
      final data = body.contains('"success":true');
      if (data) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data dikirim. Tunggu verifikasi admin.')),
        );
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal: $body')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error server: ${resp.statusCode}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verifikasi Pedagang'),
        backgroundColor: const Color(0xFF25523B),
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('NIK', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _nikController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Masukkan NIK',
                      ),
                      validator: (v) => (v == null || v.isEmpty) ? 'Wajib diisi' : null,
                    ),
                    const SizedBox(height: 16),
                    Text('Nama Usaha', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _businessNameController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Masukkan nama usaha',
                      ),
                      validator: (v) => (v == null || v.isEmpty) ? 'Wajib diisi' : null,
                    ),
                    const SizedBox(height: 16),
                    Text('Foto KTP', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () => _pickImage(true),
                      child: _ktpImage == null
                          ? DottedBorderPlaceholder(text: 'Upload KTP')
                          : Image.file(_ktpImage!, height: 150, fit: BoxFit.cover),
                    ),
                    const SizedBox(height: 16),
                    Text('Foto Lapak', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () => _pickImage(false),
                      child: _stallImage == null
                          ? DottedBorderPlaceholder(text: 'Upload Lapak')
                          : Image.file(_stallImage!, height: 150, fit: BoxFit.cover),
                    ),
                    const SizedBox(height: 24),
                    Center(
                      child: ElevatedButton(
                        onPressed: _submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF25523B),
                          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        child: Text('Kirim Verifikasi', style: GoogleFonts.poppins(color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

// Simple placeholder widget for upload area
class DottedBorderPlaceholder extends StatelessWidget {
  final String text;
  const DottedBorderPlaceholder({required this.text, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey),
      ),
      child: Center(child: Text(text, style: TextStyle(color: Colors.grey))),
    );
  }
}
