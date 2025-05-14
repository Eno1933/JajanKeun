import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String baseUrl = "http://192.168.12.44/jajankeun_api";

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
        await prefs.setString('user_id', data['data']['id'].toString());
        await prefs.setString('name', data['data']['name']);
        await prefs.setString('username', data['data']['username']);
        // Simpan data lain jika dibutuhkan
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
