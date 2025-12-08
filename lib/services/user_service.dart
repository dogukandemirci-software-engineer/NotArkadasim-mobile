import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class UserService {
  static final UserService _instance = UserService._internal();
  factory UserService() => _instance;
  UserService._internal();

  static const String _userKey = 'user_data';
  static const String _isLoggedInKey = 'is_logged_in';

  // Kullanıcı bilgilerini sakla
  Future<void> saveUser(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, jsonEncode(user.toJson()));
    await prefs.setBool(_isLoggedInKey, true);
  }

  // Sadece tokenları güncelle
  Future<void> updateTokens(String accessToken, String refreshToken) async {
    final user = await getUser();
    if (user != null) {
      final updatedUser = user.copyWith(
        accessToken: accessToken,
        refreshToken: refreshToken,
      );
      await saveUser(updatedUser);
    }
  }

  // Kullanıcı bilgilerini al
  Future<UserModel?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString(_userKey);
    
    if (userData != null) {
      final userJson = jsonDecode(userData);
      return UserModel.fromJson(userJson);
    }
    
    return null;
  }

  // Kullanıcı adını al
  Future<String?> getUsername() async {
    final user = await getUser();
    return user?.username;
  }

  // Kullanıcı oturumunu kapat
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
    await prefs.setBool(_isLoggedInKey, false);
  }

  // Kullanıcı giriş yapmış mı?
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  // Access Token'ı al
  Future<String?> getAccessToken() async {
    final user = await getUser();
    return user?.accessToken;
  }
  
  // Refresh Token'ı al
  Future<String?> getRefreshToken() async {
    final user = await getUser();
    return user?.refreshToken;
  }

  // Kullanıcı e-postasını al
  Future<String?> getEmail() async {
    final user = await getUser();
    return user?.email;
  }

  // Kullanıcı adını ve soyadını al
  Future<String?> getFullName() async {
    final user = await getUser();
    return user?.fullName;
  }
}