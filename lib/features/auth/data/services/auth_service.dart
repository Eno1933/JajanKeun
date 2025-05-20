import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String baseUrl = "http://10.11.13.12/jajankeun_api";

  // LOGIN
  static Future<Map<String, dynamic>> login({
    required String username,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/login.php"),
        body: {
          'username': username,
          'password': password,
        },
      );

      final data = jsonDecode(response.body);

      if (data['success'] == true) {
        final prefs = await SharedPreferences.getInstance();
        final userData = data['data'];

        await prefs.setString('user_id', userData['id'].toString());
        await prefs.setString('name', userData['name']);
        await prefs.setString('username', userData['username']);
        await prefs.setString('email', userData['email'] ?? '');
        await prefs.setString('phone', userData['phone'] ?? '');
        await prefs.setString('address', userData['address'] ?? '');
        await prefs.setString('role', userData['role'] ?? '');
        await prefs.setString('photo', userData['photo'] ?? ''); // Tambahan penting!
      }

      return data;
    } catch (e) {
      return {
        "success": false,
        "message": "Terjadi kesalahan: ${e.toString()}",
      };
    }
  }

  // REGISTER
  static Future<Map<String, dynamic>> register({
    required String name,
    required String username,
    required String email,
    required String password,
    required String phone,
    required String address,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/register.php"),
        body: {
          'name': name,
          'username': username,
          'email': email,
          'password': password,
          'phone': phone,
          'address': address,
        },
      );

      final data = jsonDecode(response.body);
      return data;
    } catch (e) {
      return {
        "success": false,
        "message": "Terjadi kesalahan: ${e.toString()}",
      };
    }
  }
}
