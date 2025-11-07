import 'permission_action_model.dart';

class PermissionModuleGroup {
  const PermissionModuleGroup({
    required this.module,
    required this.label,
    required this.permissions,
    this.description,
  });

  factory PermissionModuleGroup.fromJson(Map<String, dynamic> json) {
    return PermissionModuleGroup(
      module: json['module']?.toString() ?? '',
      label: json['label']?.toString() ?? '',
      description: json['description'] as String?,
      permissions: (json['permissions'] as List?)
              ?.map((item) {
                final map = <String, dynamic>{
                  'module': json['module'],
                  ...Map<String, dynamic>.from(
                    item is Map<String, dynamic> ? item : {},
                  ),
                };
                if (!map.containsKey('label')) {
                  map['label'] = map['action']?.toString() ?? '';
                }
                return PermissionActionModel.fromJson(map);
              })
              .toList() ??
          const [],
    );
  }

  final String module;
  final String label;
  final String? description;
  final List<PermissionActionModel> permissions;

  PermissionModuleGroup copyWith({
    List<PermissionActionModel>? permissions,
  }) {
    return PermissionModuleGroup(
      module: module,
      label: label,
      description: description,
      permissions: permissions ?? this.permissions,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'module': module,
      'label': label,
      'description': description,
      'permissions': permissions.map((permission) => permission.toJson()).toList(),
    };
  }

  int get grantedCount =>
      permissions.where((permission) => permission.granted).length;

  bool get isFullyGranted =>
      permissions.isNotEmpty && grantedCount == permissions.length;

  bool get hasAnyGrant => grantedCount > 0;

  bool matchesSearch(String query) {
    if (query.isEmpty) {
      return true;
    }
    final normalizedQuery = query.toLowerCase();
    if (module.toLowerCase().contains(normalizedQuery) ||
        label.toLowerCase().contains(normalizedQuery)) {
      return true;
    }
    return permissions.any(
      (permission) =>
          permission.label.toLowerCase().contains(normalizedQuery) ||
          permission.action.toLowerCase().contains(normalizedQuery),
    );
  }
}
