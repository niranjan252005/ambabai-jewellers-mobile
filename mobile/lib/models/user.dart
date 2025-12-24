class User {
  final int id;
  final String username;
  final String name;
  final String email;
  final String role;
  final bool isApproved;
  final String? phone;
  final String? address;

  User({
    required this.id,
    required this.username,
    required this.name,
    required this.email,
    required this.role,
    this.isApproved = false,
    this.phone,
    this.address,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      name: json['name'] ??
          json['username'], // Fallback to username if name is null
      email: json['email'],
      role: json['role'],
      isApproved: json['is_approved'] == 1,
      phone: json['phone'],
      address: json['address'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'name': name,
      'email': email,
      'role': role,
      'is_approved': isApproved ? 1 : 0,
      'phone': phone,
      'address': address,
    };
  }

  bool get isAdmin => role == 'admin';
}
