class User {
  final int id;
  final String username;
  final String email;
  final String role;
  final bool isApproved;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.role,
    this.isApproved = false,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      role: json['role'],
      isApproved: json['is_approved'] == 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'role': role,
      'is_approved': isApproved ? 1 : 0,
    };
  }

  bool get isAdmin => role == 'admin';
}