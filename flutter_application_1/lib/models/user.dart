enum UserRole { citizen, admin }

UserRole userRoleFromString(String? value) {
  switch (value) {
    case 'ADMIN':
      return UserRole.admin;
    default:
      return UserRole.citizen;
  }
}

String userRoleToString(UserRole role) {
  switch (role) {
    case UserRole.admin:
      return 'ADMIN';
    case UserRole.citizen:
      return 'CITIZEN';
  }
}

class User {
  final int? id;
  final String openId;
  final String name;
  final String email;
  final String? loginMethod;
  final UserRole role;
  final int points;
  final String? address;
  final double? latitude;
  final double? longitude;

  User({
    this.id,
    required this.openId,
    required this.name,
    required this.email,
    this.loginMethod,
    this.role = UserRole.citizen,
    this.points = 0,
    this.address,
    this.latitude,
    this.longitude,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int?,
      openId: json['openId'] as String? ?? '',
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      loginMethod: json['loginMethod'] as String?,
      role: userRoleFromString(json['role'] as String?),
      points: (json['points'] as num?)?.toInt() ?? 0,
      address: json['address'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'openId': openId,
      'name': name,
      'email': email,
      if (loginMethod != null) 'loginMethod': loginMethod,
      'role': userRoleToString(role),
    };
  }

  Map<String, dynamic> toRef() {
    return {'id': id, 'openId': openId, 'name': name, 'email': email};
  }

  User copyWith({int? points}) {
    return User(
      id: id,
      openId: openId,
      name: name,
      email: email,
      loginMethod: loginMethod,
      role: role,
      points: points ?? this.points,
      address: address,
      latitude: latitude,
      longitude: longitude,
    );
  }
}
