import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:crypto/crypto.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/jewelry_item.dart';
import '../models/order.dart';
import '../models/user.dart';
import '../config/app_config.dart';

class LocalDatabaseService {
  static Database? _database;
  static const String _databaseName = 'jewelry_app.db';
  static const int _databaseVersion = 1;

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  static Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  static Future<void> _onCreate(Database db, int version) async {
    // Users table
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT UNIQUE NOT NULL,
        email TEXT UNIQUE NOT NULL,
        password TEXT NOT NULL,
        role TEXT DEFAULT 'user',
        is_approved INTEGER DEFAULT 0,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP
      )
    ''');

    // Jewelry items table
    await db.execute('''
      CREATE TABLE jewelry_items (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        description TEXT,
        price REAL NOT NULL,
        category TEXT NOT NULL,
        material TEXT NOT NULL,
        weight REAL,
        stock_quantity INTEGER DEFAULT 0,
        image_path TEXT,
        brand TEXT,
        size TEXT,
        color TEXT,
        gender TEXT,
        is_certified INTEGER DEFAULT 0,
        is_handmade INTEGER DEFAULT 0,
        sku TEXT UNIQUE,
        purity TEXT,
        karat INTEGER,
        melting_weight REAL,
        melting_value REAL,
        wastage_percentage REAL,
        making_charges REAL,
        supplier TEXT,
        purchase_price REAL,
        margin_percentage REAL,
        stone_details TEXT,
        warranty_period TEXT,
        is_featured INTEGER DEFAULT 0,
        is_bestseller INTEGER DEFAULT 0,
        is_new_arrival INTEGER DEFAULT 0,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP
      )
    ''');

    // Orders table
    await db.execute('''
      CREATE TABLE orders (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        jewelry_id INTEGER NOT NULL,
        quantity INTEGER NOT NULL,
        total_price REAL NOT NULL,
        status TEXT DEFAULT 'pending',
        created_at TEXT DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (user_id) REFERENCES users (id),
        FOREIGN KEY (jewelry_id) REFERENCES jewelry_items (id)
      )
    ''');

    // Insert default admin user
    String hashedPassword = _hashPassword(AppConfig.defaultAdminPassword);
    await db.insert('users', {
      'username': AppConfig.defaultAdminUsername,
      'email': AppConfig.defaultAdminEmail,
      'password': hashedPassword,
      'role': 'admin',
      'is_approved': 1,
    });

    // Insert sample jewelry items
    await _insertSampleJewelryItems(db);
  }

  static String _hashPassword(String password) {
    var bytes = utf8.encode(password);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }

  static Future<void> _insertSampleJewelryItems(Database db) async {
    final sampleItems = [
      {
        'name': 'Diamond Engagement Ring',
        'description':
            'Beautiful 18k gold diamond engagement ring with certified diamonds',
        'price': 125000.0,
        'category': 'Rings',
        'material': 'Gold',
        'weight': 5.2,
        'stock_quantity': 3,
        'brand': 'Luxury Gold',
        'size': '6',
        'color': 'White Gold',
        'gender': 'Female',
        'is_certified': 1,
        'is_handmade': 1,
        'sku': 'LG-DER-001',
        'purity': '18K',
        'karat': 18,
        'melting_weight': 4.8,
        'melting_value': 28800.0,
        'wastage_percentage': 8.0,
        'making_charges': 15000.0,
        'supplier': 'Diamond House Ltd',
        'purchase_price': 95000.0,
        'margin_percentage': 31.6,
        'stone_details': '1 carat center diamond, VS1 clarity',
        'warranty_period': '2 years',
        'is_featured': 1,
        'is_bestseller': 1,
      },
      {
        'name': 'Gold Chain Necklace',
        'description': 'Elegant 22k gold chain necklace perfect for daily wear',
        'price': 45000.0,
        'category': 'Necklaces',
        'material': 'Gold',
        'weight': 12.5,
        'stock_quantity': 8,
        'brand': 'Traditional Gold',
        'size': '18 inches',
        'color': 'Yellow Gold',
        'gender': 'Unisex',
        'is_certified': 1,
        'is_handmade': 0,
        'sku': 'TG-GCN-002',
        'purity': '22K',
        'karat': 22,
        'melting_weight': 12.0,
        'melting_value': 72000.0,
        'wastage_percentage': 4.0,
        'making_charges': 8000.0,
        'supplier': 'Gold Craft Industries',
        'purchase_price': 38000.0,
        'margin_percentage': 18.4,
        'stone_details': 'No stones',
        'warranty_period': '1 year',
        'is_featured': 0,
        'is_bestseller': 1,
      },
      {
        'name': 'Silver Bracelet',
        'description': 'Stylish sterling silver bracelet with intricate design',
        'price': 3500.0,
        'category': 'Bracelets',
        'material': 'Silver',
        'weight': 25.0,
        'stock_quantity': 15,
        'brand': 'Silver Craft',
        'size': '7 inches',
        'color': 'Silver',
        'gender': 'Female',
        'is_certified': 1,
        'is_handmade': 1,
        'sku': 'SC-SB-003',
        'purity': '925 Sterling',
        'karat': 0,
        'melting_weight': 24.0,
        'melting_value': 1800.0,
        'wastage_percentage': 4.0,
        'making_charges': 800.0,
        'supplier': 'Silver Works Ltd',
        'purchase_price': 2800.0,
        'margin_percentage': 25.0,
        'stone_details': 'Small cubic zirconia accents',
        'warranty_period': '6 months',
        'is_featured': 0,
        'is_new_arrival': 1,
      },
      {
        'name': 'Pearl Earrings',
        'description': 'Classic freshwater pearl earrings in gold setting',
        'price': 8500.0,
        'category': 'Earrings',
        'material': 'Gold',
        'weight': 3.2,
        'stock_quantity': 12,
        'brand': 'Pearl Paradise',
        'size': '8mm pearls',
        'color': 'White Gold',
        'gender': 'Female',
        'is_certified': 1,
        'is_handmade': 0,
        'sku': 'PP-PE-004',
        'purity': '14K',
        'karat': 14,
        'melting_weight': 2.8,
        'melting_value': 11200.0,
        'wastage_percentage': 12.5,
        'making_charges': 2000.0,
        'supplier': 'Pearl Imports Co',
        'purchase_price': 6500.0,
        'margin_percentage': 30.8,
        'stone_details': 'AAA grade freshwater pearls',
        'warranty_period': '1 year',
        'is_featured': 1,
        'is_new_arrival': 1,
      },
      {
        'name': 'Diamond Tennis Bracelet',
        'description': 'Stunning diamond tennis bracelet with 50 diamonds',
        'price': 285000.0,
        'category': 'Bracelets',
        'material': 'Gold',
        'weight': 18.5,
        'stock_quantity': 2,
        'brand': 'Luxury Diamond Co',
        'size': '7.5 inches',
        'color': 'White Gold',
        'gender': 'Female',
        'is_certified': 1,
        'is_handmade': 1,
        'sku': 'LDC-DTB-005',
        'purity': '18K',
        'karat': 18,
        'melting_weight': 17.2,
        'melting_value': 103200.0,
        'wastage_percentage': 7.0,
        'making_charges': 45000.0,
        'supplier': 'Diamond Elite Ltd',
        'purchase_price': 225000.0,
        'margin_percentage': 26.7,
        'stone_details': '50 round brilliant diamonds, 5 carats total',
        'warranty_period': '3 years',
        'is_featured': 1,
        'is_bestseller': 0,
      },
    ];

    for (var item in sampleItems) {
      await db.insert('jewelry_items', item);
    }
  }

  // User operations
  static Future<Map<String, dynamic>> registerUser({
    required String username,
    required String email,
    required String password,
    String role = 'user',
  }) async {
    try {
      final db = await database;

      // Check if user already exists (case insensitive email)
      final existingUser = await db.query(
        'users',
        where: 'LOWER(email) = ? OR username = ?',
        whereArgs: [email.toLowerCase(), username],
      );

      if (existingUser.isNotEmpty) {
        return {
          'success': false,
          'error': 'User with this email or username already exists',
        };
      }

      // Check admin limit
      if (role == 'admin') {
        // Get max admin limit from settings
        final prefs = await SharedPreferences.getInstance();
        final maxAdmins = prefs.getInt('max_admins') ?? 3;

        final adminCount = await db.rawQuery(
          'SELECT COUNT(*) as count FROM users WHERE role = ?',
          ['admin'],
        );
        if (adminCount.first['count'] as int >= maxAdmins) {
          return {
            'success': false,
            'error': 'Maximum number of admin accounts ($maxAdmins) reached',
          };
        }
      }

      String hashedPassword = _hashPassword(password);

      await db.insert('users', {
        'username': username,
        'email': email.toLowerCase(), // Store email in lowercase
        'password': hashedPassword,
        'role': role,
        'is_approved': role == 'admin' ? 1 : 0,
      });

      return {
        'success': true,
        'message': role == 'admin'
            ? 'Admin account created successfully'
            : 'Account created successfully. Please wait for admin approval.',
      };
    } catch (e) {
      return {
        'success': false,
        'error': 'Registration failed: $e',
      };
    }
  }

  static Future<Map<String, dynamic>> loginUser(
      String email, String password) async {
    try {
      final db = await database;
      String hashedPassword = _hashPassword(password);

      final result = await db.query(
        'users',
        where: 'LOWER(email) = ? AND password = ?',
        whereArgs: [email.toLowerCase(), hashedPassword],
      );

      if (result.isEmpty) {
        return {
          'success': false,
          'error': 'Invalid email or password',
        };
      }

      final userData = result.first;

      if (userData['is_approved'] == 0 && userData['role'] != 'admin') {
        return {
          'success': false,
          'error': 'Your account is pending admin approval',
        };
      }

      return {
        'success': true,
        'user': User.fromJson(Map<String, dynamic>.from(userData)),
      };
    } catch (e) {
      return {
        'success': false,
        'error': 'Login failed: $e',
      };
    }
  }

  // Jewelry operations
  static Future<List<JewelryItem>> getJewelryItems() async {
    final db = await database;
    final result = await db.query('jewelry_items', orderBy: 'created_at DESC');
    return result.map((item) => JewelryItem.fromJson(item)).toList();
  }

  static Future<List<JewelryItem>> searchJewelryItems(String query) async {
    final db = await database;
    final result = await db.query(
      'jewelry_items',
      where: '''
        name LIKE ? OR 
        sku LIKE ? OR 
        category LIKE ? OR 
        material LIKE ? OR 
        brand LIKE ? OR 
        description LIKE ?
      ''',
      whereArgs: List.filled(6, '%$query%'),
      orderBy: '''
        CASE 
          WHEN sku LIKE ? THEN 1
          WHEN name LIKE ? THEN 2
          WHEN category LIKE ? THEN 3
          ELSE 4
        END, name ASC
      ''',
    );
    return result.map((item) => JewelryItem.fromJson(item)).toList();
  }

  static Future<Map<String, dynamic>> addJewelryItem(
      Map<String, dynamic> itemData) async {
    try {
      final db = await database;

      // Generate SKU if not provided
      if (itemData['sku'] == null || itemData['sku'].isEmpty) {
        itemData['sku'] =
            await _generateSKU(db, itemData['category'], itemData['material']);
      }

      final id = await db.insert('jewelry_items', itemData);
      return {
        'success': true,
        'id': id,
        'message': 'Jewelry item added successfully',
      };
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to add jewelry item: $e',
      };
    }
  }

  static Future<String> _generateSKU(
      Database db, String category, String material) async {
    String prefix =
        '${material.substring(0, 2).toUpperCase()}-${category.substring(0, 3).toUpperCase()}';

    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM jewelry_items WHERE sku LIKE ?',
      ['$prefix-%'],
    );

    int count = (result.first['count'] as int) + 1;
    return '$prefix-${count.toString().padLeft(3, '0')}';
  }

  static Future<Map<String, dynamic>> deleteJewelryItem(int itemId) async {
    try {
      final db = await database;
      await db.delete('jewelry_items', where: 'id = ?', whereArgs: [itemId]);
      return {
        'success': true,
        'message': 'Jewelry item deleted successfully',
      };
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to delete jewelry item: $e',
      };
    }
  }

  // Order operations
  static Future<Map<String, dynamic>> placeOrder(
      int userId, int jewelryId, int quantity) async {
    try {
      final db = await database;

      // Get jewelry item to calculate total price
      final jewelryResult = await db.query(
        'jewelry_items',
        where: 'id = ?',
        whereArgs: [jewelryId],
      );

      if (jewelryResult.isEmpty) {
        return {
          'success': false,
          'error': 'Jewelry item not found',
        };
      }

      final jewelry = jewelryResult.first;
      final totalPrice = (jewelry['price'] as double) * quantity;

      await db.insert('orders', {
        'user_id': userId,
        'jewelry_id': jewelryId,
        'quantity': quantity,
        'total_price': totalPrice,
        'status': 'pending',
      });

      return {
        'success': true,
        'message': 'Order placed successfully',
      };
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to place order: $e',
      };
    }
  }

  static Future<List<Order>> getOrders([int? userId]) async {
    final db = await database;
    String query = '''
      SELECT o.*, j.name as jewelry_name, j.price as jewelry_price, u.username
      FROM orders o
      JOIN jewelry_items j ON o.jewelry_id = j.id
      JOIN users u ON o.user_id = u.id
    ''';

    List<dynamic> whereArgs = [];
    if (userId != null) {
      query += ' WHERE o.user_id = ?';
      whereArgs.add(userId);
    }

    query += ' ORDER BY o.created_at DESC';

    final result = await db.rawQuery(query, whereArgs);
    return result.map((order) => Order.fromJson(order)).toList();
  }

  // Admin operations
  static Future<List<User>> getUsers() async {
    final db = await database;
    final result = await db.query('users', orderBy: 'created_at DESC');
    return result.map((user) => User.fromJson(user)).toList();
  }

  static Future<Map<String, dynamic>> approveUser(int userId) async {
    try {
      final db = await database;
      await db.update(
        'users',
        {'is_approved': 1},
        where: 'id = ?',
        whereArgs: [userId],
      );
      return {
        'success': true,
        'message': 'User approved successfully',
      };
    } catch (e) {
      return {
        'success': false,
        'error': 'Failed to approve user: $e',
      };
    }
  }

  static Future<Map<String, dynamic>> getAdminStats() async {
    final db = await database;

    final totalItems =
        await db.rawQuery('SELECT COUNT(*) as count FROM jewelry_items');
    final totalUsers = await db
        .rawQuery('SELECT COUNT(*) as count FROM users WHERE role = "user"');
    final totalOrders =
        await db.rawQuery('SELECT COUNT(*) as count FROM orders');
    final pendingUsers = await db
        .rawQuery('SELECT COUNT(*) as count FROM users WHERE is_approved = 0');

    return {
      'totalItems': totalItems.first['count'],
      'totalUsers': totalUsers.first['count'],
      'totalOrders': totalOrders.first['count'],
      'pendingUsers': pendingUsers.first['count'],
    };
  }

  // Debug method to reset database
  static Future<void> resetDatabase() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }

    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);

    // Delete the database file
    final file = File(path);
    if (await file.exists()) {
      await file.delete();
    }

    // Reinitialize database
    _database = await _initDatabase();
  }

  // Additional user methods
  static Future<User?> getUserById(int userId) async {
    try {
      final db = await database;
      final result = await db.query(
        'users',
        where: 'id = ?',
        whereArgs: [userId],
      );

      if (result.isNotEmpty) {
        return User.fromJson(result.first);
      }
      return null;
    } catch (e) {
      print('❌ Error getting user by ID: $e');
      return null;
    }
  }

  static Future<Map<String, dynamic>> updateUser({
    required int userId,
    required String name,
    required String email,
    String? phone,
    String? address,
  }) async {
    try {
      final db = await database;

      final updateData = {
        'name': name,
        'email': email,
        'phone': phone,
        'address': address,
        'updated_at': DateTime.now().toIso8601String(),
      };

      final rowsAffected = await db.update(
        'users',
        updateData,
        where: 'id = ?',
        whereArgs: [userId],
      );

      if (rowsAffected > 0) {
        return {'success': true, 'message': 'Profile updated successfully!'};
      } else {
        return {'success': false, 'error': 'User not found'};
      }
    } catch (e) {
      return {'success': false, 'error': 'Failed to update user: $e'};
    }
  }
}
