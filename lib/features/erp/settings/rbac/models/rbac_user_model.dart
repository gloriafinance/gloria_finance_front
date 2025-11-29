class RbacUserModel {
  const RbacUserModel({
    required this.userId,
    required this.name,
    required this.email,
    required this.churchId,
    required this.isActive,
    this.memberId,
    this.createdAt,
    this.lastLogin,
    this.assignedRoles = const [],
  });

  factory RbacUserModel.fromJson(Map<String, dynamic> json) {
    final createdAtRaw = json['createdAt'] ?? json['created_at'];
    final lastLoginRaw = json['lastLogin'] ?? json['last_login'];

    return RbacUserModel(
      userId: json['userId']?.toString() ?? json['user_id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      churchId: json['churchId']?.toString() ?? json['church_id']?.toString() ?? '',
      isActive: json['isActive'] as bool? ?? json['is_active'] as bool? ?? true,
      memberId: json['memberId']?.toString() ?? json['member_id']?.toString(),
      createdAt: _parseDate(createdAtRaw),
      lastLogin: _parseDate(lastLoginRaw),
      assignedRoles:
          (json['roles'] is List)
              ? (json['roles'] as List).map((role) => role.toString()).toList()
              : const [],
    );
  }

  final String userId;
  final String name;
  final String email;
  final String churchId;
  final bool isActive;
  final String? memberId;
  final DateTime? createdAt;
  final DateTime? lastLogin;
  final List<String> assignedRoles;

  RbacUserModel copyWith({
    String? name,
    String? email,
    bool? isActive,
    String? memberId,
    DateTime? createdAt,
    DateTime? lastLogin,
    List<String>? assignedRoles,
  }) {
    return RbacUserModel(
      userId: userId,
      churchId: churchId,
      name: name ?? this.name,
      email: email ?? this.email,
      isActive: isActive ?? this.isActive,
      memberId: memberId ?? this.memberId,
      createdAt: createdAt ?? this.createdAt,
      lastLogin: lastLogin ?? this.lastLogin,
      assignedRoles: assignedRoles ?? this.assignedRoles,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'name': name,
      'email': email,
      'is_active': isActive,
      'church_id': churchId,
      'member_id': memberId,
      'created_at': createdAt?.toIso8601String(),
      'last_login': lastLogin?.toIso8601String(),
      'roles': assignedRoles,
    };
  }

  bool matchesQuery(String query) {
    if (query.isEmpty) {
      return true;
    }
    final normalized = query.toLowerCase();
    return name.toLowerCase().contains(normalized) ||
        email.toLowerCase().contains(normalized) ||
        assignedRoles.any((role) => role.toLowerCase().contains(normalized));
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null) {
      return null;
    }
    if (value is DateTime) {
      return value;
    }
    final stringValue = value.toString();
    if (stringValue.isEmpty || stringValue == 'null') {
      return null;
    }
    return DateTime.tryParse(stringValue);
  }
}
