class RoleModel {
  const RoleModel({
    required this.id,
    required this.name,
    this.roleId = '',
    this.churchId,
    this.description,
    this.isSystem = false,
    this.isCustom = true,
    this.isDefault = false,
    this.isActive = true,
    this.assignedUsers = const [],
    this.createdAt,
  });

  factory RoleModel.fromJson(Map<String, dynamic> json) {
    return RoleModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      roleId: json['roleId']?.toString() ?? json['role_id']?.toString() ?? '',
      churchId: json['churchId']?.toString() ?? json['church_id']?.toString(),
      description: json['description'] as String?,
      isSystem: json['isSystem'] as bool? ?? json['is_system'] as bool? ?? false,
      isCustom: json['is_custom'] as bool? ??
          !(json['isSystem'] as bool? ?? json['is_system'] as bool? ?? false),
      isDefault: json['is_default'] as bool? ?? false,
      isActive: json['is_active'] as bool? ?? true,
      assignedUsers: _extractUsers(json),
      createdAt: _parseDate(json['createdAt'] ?? json['created_at']),
    );
  }

  final String id;
  final String name;
  final String roleId;
  final String? churchId;
  final String? description;
  final bool isSystem;
  final bool isCustom;
  final bool isDefault;
  final bool isActive;
  final List<String> assignedUsers;
  final DateTime? createdAt;

  RoleModel copyWith({
    String? id,
    String? name,
    String? roleId,
    String? churchId,
    String? description,
    bool? isSystem,
    bool? isCustom,
    bool? isDefault,
    bool? isActive,
    List<String>? assignedUsers,
    DateTime? createdAt,
  }) {
    return RoleModel(
      id: id ?? this.id,
      name: name ?? this.name,
      roleId: roleId ?? this.roleId,
      churchId: churchId ?? this.churchId,
      description: description ?? this.description,
      isSystem: isSystem ?? this.isSystem,
      isCustom: isCustom ?? this.isCustom,
      isDefault: isDefault ?? this.isDefault,
      isActive: isActive ?? this.isActive,
      assignedUsers: assignedUsers ?? this.assignedUsers,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'roleId': roleId,
      'churchId': churchId,
      'description': description,
      'isSystem': isSystem,
      'is_custom': isCustom,
      'is_default': isDefault,
      'is_active': isActive,
      'assigned_users': assignedUsers,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  int get membersCount => assignedUsers.length;

  String get apiIdentifier => roleId.isNotEmpty ? roleId : id;

  @override
  int get hashCode => Object.hash(
        id,
        name,
        roleId,
        churchId,
        description,
        isSystem,
        isCustom,
        isDefault,
        isActive,
        Object.hashAll(assignedUsers),
        createdAt,
      );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    return other is RoleModel &&
        other.id == id &&
        other.name == name &&
        other.roleId == roleId &&
        other.churchId == churchId &&
        other.description == description &&
        other.isSystem == isSystem &&
        other.isCustom == isCustom &&
        other.isDefault == isDefault &&
        other.isActive == isActive &&
        _listEquals(other.assignedUsers, assignedUsers) &&
        other.createdAt == createdAt;
  }

  bool _listEquals(List<String> a, List<String> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }

  static List<String> _extractUsers(Map<String, dynamic> json) {
    final candidates = [
      json['assigned_users'],
      json['users'],
      json['members'],
    ];
    for (final candidate in candidates) {
      if (candidate is List) {
        return candidate.map((item) => item.toString()).toList();
      }
    }
    return const [];
  }

  static DateTime? _parseDate(dynamic value) {
    if (value is DateTime) {
      return value;
    }
    if (value is String && value.isNotEmpty) {
      return DateTime.tryParse(value);
    }
    return null;
  }
}
