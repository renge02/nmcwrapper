import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  //  Singleton
  static final SecureStorage _instance = SecureStorage._internal();
  factory SecureStorage() => _instance;

  SecureStorage._internal();

  final _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(),
  );

  // Keys
  static const String _tokenKey = "auth_token";
  static const String _refreshTokenKey = "refresh_token";
  static const String _userDataKey = "user_data";
  static const String _userIdsKey = "user_ids";
  static const String _userNameKey = "userName";
  static const String _userMobileNumberKey = "mobileNumber";

  // Save token
  Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  // Get token
  Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  // Save refresh token
  Future<void> saveRefreshToken(String token) async {
    await _storage.write(key: _refreshTokenKey, value: token);
  }

  Future<String?> getRefreshToken() async {
    return await _storage.read(key: _refreshTokenKey);
  }

  // Save User Data (JSON string)
  Future<void> saveUserData(String jsonData) async {
    await _storage.write(key: _userDataKey, value: jsonData);
  }

  Future<String?> getUserData() async {
    return await _storage.read(key: _userDataKey);
  }

  Future<void> saveUserIds(String id) async {
    await _storage.write(key: _userIdsKey, value: id);
  }

  Future<String?> getUserIds() async {
    return await _storage.read(key: _userIdsKey);
  }
  Future<void> saveUserName(String id) async {
    await _storage.write(key: _userNameKey, value: id);
  }

  Future<String?> getUserName() async {
    return await _storage.read(key: _userNameKey);
  }
  Future<void> saveUserMobileNumber(String id) async {
    await _storage.write(key: _userMobileNumberKey, value: id);
  }

  Future<String?> getUserMobileNumber() async {
    return await _storage.read(key: _userMobileNumberKey);
  }

  // Delete specific key
  Future<void> delete(String key) async {
    await _storage.delete(key: key);
  }

  // Clear all data (use on logout)
  Future<void> deleteAll() async {
    await _storage.deleteAll();
  }
}
