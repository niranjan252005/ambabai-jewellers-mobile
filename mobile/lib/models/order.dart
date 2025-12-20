import 'package:flutter/material.dart';

class Order {
  final int id;
  final int userId;
  final int jewelryId;
  final int quantity;
  final double totalPrice;
  final String status;
  final DateTime createdAt;
  final String? jewelryName;
  final String? imageUrl;
  final String? username;

  Order({
    required this.id,
    required this.userId,
    required this.jewelryId,
    required this.quantity,
    required this.totalPrice,
    required this.status,
    required this.createdAt,
    this.jewelryName,
    this.imageUrl,
    this.username,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      userId: json['user_id'],
      jewelryId: json['jewelry_id'],
      quantity: json['quantity'],
      totalPrice: (json['total_price'] as num).toDouble(),
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
      jewelryName: json['jewelry_name'],
      imageUrl: json['image_url'],
      username: json['username'],
    );
  }

  String get formattedTotalPrice => '₹${totalPrice.toStringAsFixed(2)}';
  
  Color get statusColor {
    switch (status.toLowerCase()) {
      case 'pending':
        return const Color(0xFFFF9800);
      case 'confirmed':
        return const Color(0xFF4CAF50);
      case 'shipped':
        return const Color(0xFF2196F3);
      case 'delivered':
        return const Color(0xFF8BC34A);
      case 'cancelled':
        return const Color(0xFFF44336);
      default:
        return const Color(0xFF9E9E9E);
    }
  }
}