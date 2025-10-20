import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/user_model.dart';

/// Storage Service for Local Data Persistence
/// Uses SharedPreferences to store user data, auth tokens, and app settings
class StorageService {
  // Storage keys
  static const String _keyUser = 'user';
  static const String _keyToken = 'token';
  static const String _keySavedEmail = 'saved_email';
  static const String _keyIsLoggedIn = 'is_logged_in';

  /// Save user data to local storage
  static Future<bool> saveUser(User user) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = jsonEncode(user.toJson());
      await prefs.setString(_keyUser, userJson);
      
      // Save token separately for easy access
      if (user.token != null) {
        await prefs.setString(_keyToken, user.token!);
      }
      
      // Mark user as logged in
      await prefs.setBool(_keyIsLoggedIn, true);
      
      return true;
    } catch (e) {
      print('Error saving user: $e');
      return false;
    }
  }

  /// Get user data from local storage
  static Future<User?> getUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString(_keyUser);
      
      if (userJson != null) {
        final userMap = jsonDecode(userJson) as Map<String, dynamic>;
        return User.fromJson(userMap);
      }
      
      return null;
    } catch (e) {
      print('Error getting user: $e');
      return null;
    }
  }

  /// Get auth token from local storage
  static Future<String?> getToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_keyToken);
    } catch (e) {
      print('Error getting token: $e');
      return null;
    }
  }

  /// Check if user is logged in
  static Future<bool> isLoggedIn() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_keyIsLoggedIn) ?? false;
    } catch (e) {
      print('Error checking login status: $e');
      return false;
    }
  }

  /// Save email for "Remember Me" feature
  static Future<bool> saveEmail(String email) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_keySavedEmail, email);
      return true;
    } catch (e) {
      print('Error saving email: $e');
      return false;
    }
  }

  /// Get saved email for "Remember Me" feature
  static Future<String?> getSavedEmail() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_keySavedEmail);
    } catch (e) {
      print('Error getting saved email: $e');
      return null;
    }
  }

  /// Clear saved email
  static Future<bool> clearSavedEmail() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_keySavedEmail);
      return true;
    } catch (e) {
      print('Error clearing saved email: $e');
      return false;
    }
  }

  /// Clear all user data (logout)
  static Future<bool> clearUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_keyUser);
      await prefs.remove(_keyToken);
      await prefs.setBool(_keyIsLoggedIn, false);
      return true;
    } catch (e) {
      print('Error clearing user data: $e');
      return false;
    }
  }

  /// Clear all data from storage
  static Future<bool> clearAll() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      return true;
    } catch (e) {
      print('Error clearing all data: $e');
      return false;
    }
  }
}

