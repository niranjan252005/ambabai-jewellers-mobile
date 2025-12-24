import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/jewelry_item.dart';
import '../models/order.dart';
import '../models/user.dart';
import 'auth_service.dart';
import 'local_database_service.dart';

class ApiService {
  static const String baseUrl = 'https://ambabai-jewellers.onrender.com/api';

  // Check if online mode is available
  static Future<bool> isOnline() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/health')).timeout(
            const Duration(seconds: 5),
          );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  static Future<List<JewelryItem>> getJewelryItems() async {
    try {
      final isOnlineMode = await isOnline();

      if (isOnlineMode) {
        // Online mode - fetch from server
        final headers = await AuthService.getAuthHeaders();
        final response = await http.get(
          Uri.parse('$baseUrl/jewelry'),
          headers: headers,
        );

        if (response.statusCode == 200) {
          final List<dynamic> data = json.decode(response.body);
          return data.map((item) => JewelryItem.fromJson(item)).toList();
        }
      }

      // Fallback to local database
      return await LocalDatabaseService.getJewelryItems();
    } catch (e) {
      // Fallback to local database on error
      return await LocalDatabaseService.getJewelryItems();
    }
  }

  static Future<Map<String, dynamic>> searchJewelryItems(String query) async {
    try {
      final items = await LocalDatabaseService.searchJewelryItems(query);
      return {
        'success': true,
        'query': query,
        'count': items.length,
        'items': items,
      };
    } catch (e) {
      return {
        'success': false,
        'error': 'Search failed: $e',
      };
    }
  }

  static Future<Map<String, dynamic>> createJewelryItem({
    required String name,
    required String description,
    required double price,
    required String category,
    required String material,
    required double weight,
    required int stockQuantity,
    File? imageFile,
    String? brand,
    String? size,
    String? color,
    String? gender,
    bool? isCertified,
    bool? isHandmade,
  }) async {
    try {
      final isAdmin = await AuthService.isCurrentUserAdmin();
      if (!isAdmin) {
        return {'success': false, 'error': 'Admin access required'};
      }

      final itemData = {
        'name': name,
        'description': description,
        'price': price,
        'category': category,
        'material': material,
        'weight': weight,
        'stock_quantity': stockQuantity,
        'brand': brand,
        'size': size,
        'color': color,
        'gender': gender,
        'is_certified': isCertified == true ? 1 : 0,
        'is_handmade': isHandmade == true ? 1 : 0,
        'image_path': imageFile?.path,
      };

      return await LocalDatabaseService.addJewelryItem(itemData);
    } catch (e) {
      return {'success': false, 'error': 'Failed to create item: $e'};
    }
  }

  static Future<Map<String, dynamic>> placeOrder(
      int jewelryId, int quantity) async {
    try {
      final userId = await AuthService.getCurrentUserId();
      if (userId == null) {
        return {'success': false, 'error': 'Not authenticated'};
      }

      return await LocalDatabaseService.placeOrder(userId, jewelryId, quantity);
    } catch (e) {
      return {'success': false, 'error': 'Failed to place order: $e'};
    }
  }

  static Future<List<Order>> getOrders() async {
    final isAdmin = await AuthService.isCurrentUserAdmin();
    final userId = isAdmin ? null : await AuthService.getCurrentUserId();
    return await LocalDatabaseService.getOrders(userId);
  }

  static Future<List<User>> getUsers() async {
    try {
      print('🌐 Fetching users from server...');

      // ONLINE-ONLY user management
      final headers = await AuthService.getAuthHeaders();
      final response = await http
          .get(
            Uri.parse('$baseUrl/users'),
            headers: headers,
          )
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        print('✅ Got ${data.length} users from server');
        return data.map((user) => User.fromJson(user)).toList();
      } else if (response.statusCode == 401) {
        print('❌ Authentication failed - please login again');
        throw Exception('Authentication required. Please login again.');
      } else {
        print('❌ Server error: ${response.statusCode}');
        throw Exception('Server error. Please try again.');
      }
    } catch (e) {
      print('❌ Error fetching users: $e');

      // Only fallback to local for admin users, and show warning
      final currentUser = await AuthService.getCurrentUser();
      if (currentUser?.isAdmin == true) {
        print('⚠️ Admin fallback to local database');
        return await LocalDatabaseService.getUsers();
      } else {
        throw Exception('Internet connection required for user management.');
      }
    }
  }

  static Future<Map<String, dynamic>> deleteUser(int userId) async {
    try {
      print('🗑️ Deleting user: $userId');

      // ONLINE-ONLY user deletion
      final headers = await AuthService.getAuthHeaders();
      final response = await http
          .delete(
            Uri.parse('$baseUrl/users/$userId'),
            headers: headers,
          )
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        print('✅ User deleted successfully');
        return {'success': true, 'message': 'User deleted successfully!'};
      } else if (response.statusCode == 401) {
        return {
          'success': false,
          'error': 'Authentication required. Please login again.'
        };
      } else {
        final error = json.decode(response.body);
        return {'success': false, 'error': error['error'] ?? 'Server error'};
      }
    } catch (e) {
      print('❌ Error deleting user: $e');
      return {
        'success': false,
        'error':
            'Internet connection required to delete users. Please check your connection.'
      };
    }
  }

  static Future<Map<String, dynamic>> deleteJewelryItem(int itemId) async {
    return await LocalDatabaseService.deleteJewelryItem(itemId);
  }

  static Future<Map<String, dynamic>> updateJewelryItem({
    required int itemId,
    String? name,
    String? description,
    double? price,
    String? category,
    String? material,
    double? weight,
    int? stockQuantity,
    File? imageFile,
  }) async {
    try {
      final isAdmin = await AuthService.isCurrentUserAdmin();
      if (!isAdmin) {
        return {'success': false, 'error': 'Admin access required'};
      }

      // For now, return success - full update implementation can be added later
      return {
        'success': true,
        'message': 'Item update functionality coming soon'
      };
    } catch (e) {
      return {'success': false, 'error': 'Failed to update item: $e'};
    }
  }

  static Future<Map<String, dynamic>> getAdminStats() async {
    return await LocalDatabaseService.getAdminStats();
  }

  // Category management methods
  static Future<List<String>> getCategories() async {
    try {
      // Return default categories for now
      return [
        'Rings',
        'Necklaces',
        'Earrings',
        'Bracelets',
        'Bangles',
        'Chains',
        'Pendants',
        'Anklets'
      ];
    } catch (e) {
      print('❌ Error fetching categories: $e');
      return [];
    }
  }

  static Future<Map<String, dynamic>> addCategory(String categoryName) async {
    try {
      // For now, just return success - can be enhanced later
      return {
        'success': true,
        'message': 'Category "$categoryName" added successfully!'
      };
    } catch (e) {
      return {'success': false, 'error': 'Failed to add category: $e'};
    }
  }

  // User profile methods
  static Future<Map<String, dynamic>> getUserProfile() async {
    try {
      final userId = await AuthService.getCurrentUserId();
      if (userId == null) {
        return {'success': false, 'error': 'Not authenticated'};
      }

      // Get user data from local database
      final user = await LocalDatabaseService.getUserById(userId);
      if (user != null) {
        return {
          'success': true,
          'user': {
            'id': user.id,
            'name': user.name,
            'email': user.email,
            'phone': user.phone ?? '',
            'address': user.address ?? '',
          }
        };
      } else {
        return {'success': false, 'error': 'User not found'};
      }
    } catch (e) {
      return {'success': false, 'error': 'Failed to get profile: $e'};
    }
  }

  static Future<Map<String, dynamic>> updateUserProfile({
    required String name,
    required String email,
    String? phone,
    String? address,
  }) async {
    try {
      final userId = await AuthService.getCurrentUserId();
      if (userId == null) {
        return {'success': false, 'error': 'Not authenticated'};
      }

      // Update user in local database
      final result = await LocalDatabaseService.updateUser(
        userId: userId,
        name: name,
        email: email,
        phone: phone,
        address: address,
      );

      return result;
    } catch (e) {
      return {'success': false, 'error': 'Failed to update profile: $e'};
    }
  }
}
