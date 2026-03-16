import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  static final FlutterSecureStorage _storage = const FlutterSecureStorage();

  // Save password
  static Future<void> savePassword(String password) async {
    await _storage.write(key: 'password', value: password);
  }

  // Read password
  static Future<String?> getPassword() async {
    return await _storage.read(key: 'password');
  }

  // Clear password
  static Future<void> clearPassword() async {
    await _storage.delete(key: 'password');
  }
}
