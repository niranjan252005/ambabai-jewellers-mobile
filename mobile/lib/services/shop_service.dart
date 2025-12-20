import 'package:shared_preferences/shared_preferences.dart';

class ShopService {
  static Future<Map<String, String>> getShopInfo() async {
    final prefs = await SharedPreferences.getInstance();
    
    return {
      'name': prefs.getString('shop_name') ?? 'Niranjan Jewelry Store',
      'address': prefs.getString('shop_address') ?? 'Main Market, City',
      'phone': prefs.getString('shop_phone') ?? '+91 98765 43210',
      'email': prefs.getString('shop_email') ?? 'contact@niranjanjewelry.com',
    };
  }

  static Future<int> getMaxAdmins() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('max_admins') ?? 3;
  }

  static Future<void> setShopInfo({
    required String name,
    required String address,
    required String phone,
    required String email,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    
    await prefs.setString('shop_name', name);
    await prefs.setString('shop_address', address);
    await prefs.setString('shop_phone', phone);
    await prefs.setString('shop_email', email);
  }

  static Future<void> setMaxAdmins(int maxAdmins) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('max_admins', maxAdmins);
  }
}