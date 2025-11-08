import 'permission_action_model.dart';

class PermissionModuleGroup {
  const PermissionModuleGroup({
    required this.module,
    required this.label,
    required this.permissions,
    this.description,
  });

  factory PermissionModuleGroup.fromJson(Map<String, dynamic> json) {
    final module = json['module']?.toString() ?? '';
    final label = _resolveLabel(json['label'], module);
    final description = json['description'] as String? ??
        json['module_description'] as String? ??
        json['tooltip'] as String?;

    return PermissionModuleGroup(
      module: module,
      label: label,
      description: description,
      permissions: (json['permissions'] as List?)
              ?.whereType<Map<String, dynamic>>()
              .map((item) {
                final map = Map<String, dynamic>.from(item);
                map['module'] = map['module'] ?? module;
                map['label'] = map['label'] ?? map['title'] ?? map['name'];
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
    String? label,
    String? description,
    List<PermissionActionModel>? permissions,
  }) {
    return PermissionModuleGroup(
      module: module,
      label: label ?? this.label,
      description: description ?? this.description,
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

String _resolveLabel(dynamic rawLabel, String module) {
  final label = rawLabel?.toString() ?? '';
  if (label.trim().isNotEmpty) {
    return label.trim();
  }
  return _humanizeIdentifier(module);
}

String _humanizeIdentifier(String value) {
  if (value.isEmpty) {
    return '';
  }
  return value
      .replaceAll(RegExp(r'[_\-]+'), ' ')
      .split(' ')
      .where((segment) => segment.isNotEmpty)
      .map((segment) =>
          segment[0].toUpperCase() + segment.substring(1).toLowerCase())
      .join(' ');
}
