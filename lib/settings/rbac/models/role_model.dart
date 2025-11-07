class RoleModel {
  const RoleModel({
    required this.id,
    required this.name,
    this.description,
    this.isCustom = true,
    this.isDefault = false,
    this.isActive = true,
    this.assignedUsers = const [],
  });

  factory RoleModel.fromJson(Map<String, dynamic> json) {
    return RoleModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      description: json['description'] as String?,
      isCustom: json['is_custom'] as bool? ?? true,
      isDefault: json['is_default'] as bool? ?? false,
      isActive: json['is_active'] as bool? ?? true,
      assignedUsers: (json['assigned_users'] as List?)
              ?.map((item) => item.toString())
              .toList() ??
          const [],
    );
  }

  final String id;
  final String name;
  final String? description;
  final bool isCustom;
  final bool isDefault;
  final bool isActive;
  final List<String> assignedUsers;

  RoleModel copyWith({
    String? id,
    String? name,
    String? description,
    bool? isCustom,
    bool? isDefault,
    bool? isActive,
    List<String>? assignedUsers,
  }) {
    return RoleModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      isCustom: isCustom ?? this.isCustom,
      isDefault: isDefault ?? this.isDefault,
      isActive: isActive ?? this.isActive,
      assignedUsers: assignedUsers ?? this.assignedUsers,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'is_custom': isCustom,
      'is_default': isDefault,
      'is_active': isActive,
      'assigned_users': assignedUsers,
    };
  }

  int get membersCount => assignedUsers.length;

  @override
  int get hashCode => Object.hash(
        id,
        name,
        description,
        isCustom,
        isDefault,
        isActive,
        Object.hashAll(assignedUsers),
      );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    return other is RoleModel &&
        other.id == id &&
        other.name == name &&
        other.description == description &&
        other.isCustom == isCustom &&
        other.isDefault == isDefault &&
        other.isActive == isActive &&
        _listEquals(other.assignedUsers, assignedUsers);
  }

  bool _listEquals(List<String> a, List<String> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}
