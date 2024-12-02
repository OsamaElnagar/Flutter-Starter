class UserResponse {
  final User user;

  final String token;

  UserResponse({
    required this.user,
    required this.token,
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    return UserResponse(
      user: User.fromJson(json['user']),
      token: json['token'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user.toJson(),
      'token': token,
    };
  }
}

class User {
  final int id;

  final int? storeId;

  final String name;
  final String avatar;

  final String email;

  final String? phoneNumber;

  final String type;

  final String? lastActive;

  final String? emailVerifiedAt;

  final String createdAt;

  final String updatedAt;

  User({
    required this.id,
    this.storeId,
    required this.name,
    required this.email,
    required this.avatar,
    this.phoneNumber,
    required this.type,
    this.lastActive,
    this.emailVerifiedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: int.parse(json['id']),
      storeId: int.parse(json['store_id']),
      name: json['name'],
      email: json['email'],
      avatar: json['avatar'],
      phoneNumber: json['phone_number'] ?? "",
      type: json['type'],
      lastActive: json['last_active'] ?? "",
      emailVerifiedAt: json['email_verified_at'] ?? "",
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'store_id': storeId,
      'name': name,
      'email': email,
      'avatar': avatar,
      'phone_number': phoneNumber,
      'type': type,
      'last_active': lastActive,
      'email_verified_at': emailVerifiedAt,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
