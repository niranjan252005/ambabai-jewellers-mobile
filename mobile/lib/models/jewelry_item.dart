class JewelryItem {
  final int id;
  final String name;
  final String description;
  final double price;
  final String category;
  final String material;
  final double weight;
  final String? imagePath;
  final int stockQuantity;
  final DateTime createdAt;
  
  // Additional fields
  final String? brand;
  final String? size;
  final String? color;
  final String? gender;
  final bool isCertified;
  final bool isHandmade;
  
  // Melting data
  final String? purity;
  final int? karat;
  final double? meltingWeight;
  final double? meltingValue;
  final double? wastagePercentage;
  final double? makingCharges;
  
  // Business fields
  final String? sku;
  final String? supplier;
  final double? purchasePrice;
  final double? marginPercentage;
  final double? stoneWeight;
  final String? stoneType;
  final int? stoneCount;
  final int? warrantyMonths;
  final bool isFeatured;
  final bool isBestseller;
  final bool isNewArrival;

  JewelryItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.material,
    required this.weight,
    this.imagePath,
    required this.stockQuantity,
    required this.createdAt,
    this.brand,
    this.size,
    this.color,
    this.gender,
    this.isCertified = false,
    this.isHandmade = false,
    this.purity,
    this.karat,
    this.meltingWeight,
    this.meltingValue,
    this.wastagePercentage,
    this.makingCharges,
    this.sku,
    this.supplier,
    this.purchasePrice,
    this.marginPercentage,
    this.stoneWeight,
    this.stoneType,
    this.stoneCount,
    this.warrantyMonths,
    this.isFeatured = false,
    this.isBestseller = false,
    this.isNewArrival = false,
  });

  factory JewelryItem.fromJson(Map<String, dynamic> json) {
    return JewelryItem(
      id: json['id'],
      name: json['name'],
      description: json['description'] ?? '',
      price: (json['price'] as num).toDouble(),
      category: json['category'] ?? '',
      material: json['material'] ?? '',
      weight: (json['weight'] as num?)?.toDouble() ?? 0.0,
      imagePath: json['image_path'],
      stockQuantity: json['stock_quantity'] ?? 0,
      createdAt: DateTime.parse(json['created_at']),
      brand: json['brand'],
      size: json['size'],
      color: json['color'],
      gender: json['gender'],
      isCertified: json['is_certified'] == 1,
      isHandmade: json['is_handmade'] == 1,
      purity: json['purity'],
      karat: json['karat'],
      meltingWeight: (json['melting_weight'] as num?)?.toDouble(),
      meltingValue: (json['melting_value'] as num?)?.toDouble(),
      wastagePercentage: (json['wastage_percentage'] as num?)?.toDouble(),
      makingCharges: (json['making_charges'] as num?)?.toDouble(),
      sku: json['sku'],
      supplier: json['supplier'],
      purchasePrice: (json['purchase_price'] as num?)?.toDouble(),
      marginPercentage: (json['margin_percentage'] as num?)?.toDouble(),
      stoneWeight: (json['stone_weight'] as num?)?.toDouble(),
      stoneType: json['stone_type'],
      stoneCount: json['stone_count'],
      warrantyMonths: json['warranty_months'],
      isFeatured: json['is_featured'] == 1,
      isBestseller: json['is_bestseller'] == 1,
      isNewArrival: json['is_new_arrival'] == 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'category': category,
      'material': material,
      'weight': weight,
      'image_path': imagePath,
      'stock_quantity': stockQuantity,
      'created_at': createdAt.toIso8601String(),
    };
  }

  String get formattedPrice => '₹${price.toStringAsFixed(2)}';
  String get formattedWeight => '${weight.toStringAsFixed(1)}g';
  String get formattedMeltingWeight => meltingWeight != null ? '${meltingWeight!.toStringAsFixed(1)}g' : 'N/A';
  String get formattedMeltingValue => meltingValue != null ? '\$${meltingValue!.toStringAsFixed(2)}' : 'N/A';
  String get formattedMakingCharges => makingCharges != null ? '\$${makingCharges!.toStringAsFixed(2)}' : 'N/A';
  String get formattedPurity => purity != null ? '$purity (${karat}K)' : 'N/A';
  String get formattedStoneInfo => stoneCount != null && stoneCount! > 0 
      ? '$stoneCount ${stoneType ?? 'stones'} (${stoneWeight?.toStringAsFixed(2) ?? '0'}g)'
      : 'No stones';
  String get formattedWarranty => warrantyMonths != null ? '$warrantyMonths months' : 'No warranty';
  bool get isInStock => stockQuantity > 0;
  bool get hasMeltingData => meltingWeight != null && meltingValue != null;
}