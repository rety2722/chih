import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  static final SecureStorage _instance = SecureStorage._internal();
  factory SecureStorage() => _instance;

  SecureStorage._internal();

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<void> write(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  Future<String?> read(String key) async {
    return await _storage.read(key: key);
  }

  Future<void> delete(String key) async {
    await _storage.delete(key: key);
  }

  Future<void> deleteAll() async {
    await _storage.deleteAll();
  }

  Future<Map<String, String>> readAll() async {
    return await _storage.readAll();
  }
}

class RememberMe {
  static final RememberMe _instance = RememberMe._internal();
  factory RememberMe() => _instance;

  RememberMe._internal();

  bool _rememberMe = false;

  void setRememberMe(bool value) {
    _rememberMe =  value;
  }

  bool getRememberMeValue() {
    return _rememberMe;
  }
}