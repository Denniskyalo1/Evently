import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  static final _storage = FlutterSecureStorage();

  static Future<String?> getToken() async {
    return await _storage.read(key: 'authToken');
  }

  static Future<Map<String, dynamic>?> getUser() async {
    String? userData = await _storage.read(key: 'userData');
    if (userData == null) return null;
    return jsonDecode(userData);
  }

  static Future<void> saveToken(String token) async {
    await _storage.write(key: 'authToken', value: token);
  }
  static Future<void> saveUser(Map<String, dynamic> user) async {
    await _storage.write(key: 'userData', value: jsonEncode(user));
  }

  static Future<void> logout() async {
    await _storage.deleteAll();
  }
}
