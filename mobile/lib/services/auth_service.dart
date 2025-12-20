import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import 'local_database_service.dart';

class AuthService {
  static const String userKey = 'user_data';
  static const String tokenKey = 'auth_token';
  static const String baseUrl = 'http://localhost:3000/api';

  static Future<User?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString(userKey);
    if (userData != null) {
      return User.fromJson(jsonDecode(userData));
    }
    return null;
  }

  static Future<bool> isLoggedIn() async {
    final user = await getCurrentUser();
    return user != null;
  }

  static Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      print('🌐 Attempting online login for: $email');
      
      // Try online login first
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      ).timeout(const Duration(seconds: 15));
      
      print('📡 Server response: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final prefs = await SharedPreferences.getInstance();
        
        // Store token and user data
        await prefs.setString(tokenKey, data['token']);
        await prefs.setString(userKey, jsonEncode(data['user']));
        
        print('✅ Online login successful');
        return {'success': true, 'user': User.fromJson(data['user'])};
      } else {
        final error = jsonDecode(response.body);
        print('❌ Online login failed: ${error['error']}');
        return {'success': false, 'error': error['error']};
      }
    } catch (e) {
      print('⚠️ Online login failed, trying local database: $e');
      
      // Fallback to local database (only for admin)
      final result = await LocalDatabaseService.loginUser(email, password);
      
      if (result['success']) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(userKey, jsonEncode(result['user'].toJson()));
        
        // Add note about offline mode
        final user = result['user'] as User;
        if (user.isAdmin) {
          print('✅ Admin offline login successful');
        } else {
          print('⚠️ Customer offline login - limited functionality');
        }
      }
      
      return result;
    }
  }

  static Future<Map<String, dynamic>> register(
    String username,
    String email,
    String password, {
    String role = 'user',
  }) async {
    try {
      print('🌐 Attempting online registration for: $email');
      
      // ONLINE-ONLY registration - no offline fallback for customers
      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'email': email,
          'password': password,
          'role': role,
        }),
      ).timeout(const Duration(seconds: 15));
      
      print('📡 Server response: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('✅ Online registration successful');
        return {
          'success': true, 
          'message': 'Account created successfully! Please wait for admin approval. You will be notified once approved.'
        };
      } else {
        final error = jsonDecode(response.body);
        print('❌ Online registration failed: ${error['error']}');
        return {'success': false, 'error': error['error']};
      }
    } catch (e) {
      print('❌ Online registration failed: $e');
      
      // NO OFFLINE FALLBACK - require internet connection
      return {
        'success': false, 
        'error': 'Registration requires internet connection. Please check your connection and try again.'
      };
    }
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(userKey);
    await prefs.remove(tokenKey);
  }

  static Future<Map<String, String>> getAuthHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(tokenKey);
    
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // Helper method to get current user ID
  static Future<int?> getCurrentUserId() async {
    final user = await getCurrentUser();
    return user?.id;
  }

  // Helper method to check if current user is admin
  static Future<bool> isCurrentUserAdmin() async {
    final user = await getCurrentUser();
    return user?.role == 'admin';
  }
}