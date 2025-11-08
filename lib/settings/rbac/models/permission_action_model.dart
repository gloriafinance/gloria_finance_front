class PermissionActionModel {
  const PermissionActionModel({
    required this.module,
    required this.action,
    required this.label,
    this.permissionId,
    this.granted = false,
    this.isInherited = false,
    this.isCritical = false,
    this.isReadOnly = false,
    this.isSystem = false,
    this.description,
    this.impactLabel,
  });

  factory PermissionActionModel.fromJson(Map<String, dynamic> json) {
    final normalized = _normalizeJson(json);
    return PermissionActionModel(
      module: normalized['module']?.toString() ?? '',
      action: normalized['action']?.toString() ?? '',
      label: normalized['label']?.toString() ?? '',
      permissionId: normalized['permission_id']?.toString(),
      granted: normalized['granted'] as bool? ?? false,
      isInherited: normalized['is_inherited'] as bool? ?? false,
      isCritical: normalized['is_critical'] as bool? ?? false,
      isReadOnly: normalized['is_read_only'] as bool? ?? false,
      isSystem: normalized['is_system'] as bool? ?? false,
      description: normalized['description'] as String?,
      impactLabel: normalized['impact_label'] as String?,
    );
  }

  final String module;
  final String action;
  final String label;
  final String? permissionId;
  final bool granted;
  final bool isInherited;
  final bool isCritical;
  final bool isReadOnly;
  final bool isSystem;
  final String? description;
  final String? impactLabel;

  PermissionActionModel copyWith({
    String? module,
    String? action,
    String? label,
    String? permissionId,
    bool? granted,
    bool? isInherited,
    bool? isCritical,
    bool? isReadOnly,
    bool? isSystem,
    String? description,
    String? impactLabel,
  }) {
    return PermissionActionModel(
      module: module ?? this.module,
      action: action ?? this.action,
      label: label ?? this.label,
      permissionId: permissionId ?? this.permissionId,
      granted: granted ?? this.granted,
      isInherited: isInherited ?? this.isInherited,
      isCritical: isCritical ?? this.isCritical,
      isReadOnly: isReadOnly ?? this.isReadOnly,
      isSystem: isSystem ?? this.isSystem,
      description: description ?? this.description,
      impactLabel: impactLabel ?? this.impactLabel,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'module': module,
      'action': action,
      'label': label,
      'permission_id': permissionId,
      'granted': granted,
      'is_inherited': isInherited,
      'is_critical': isCritical,
      'is_read_only': isReadOnly,
      'is_system': isSystem,
      'description': description,
      'impact_label': impactLabel,
    };
  }

  @override
  int get hashCode => Object.hash(
        module,
        action,
        label,
        permissionId,
        granted,
        isInherited,
        isCritical,
        isReadOnly,
        isSystem,
        description,
        impactLabel,
      );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    return other is PermissionActionModel &&
        other.module == module &&
        other.action == action &&
        other.label == label &&
        other.permissionId == permissionId &&
        other.granted == granted &&
        other.isInherited == isInherited &&
        other.isCritical == isCritical &&
        other.isReadOnly == isReadOnly &&
        other.isSystem == isSystem &&
        other.description == description &&
        other.impactLabel == impactLabel;
  }
}

Map<String, dynamic> _normalizeJson(Map<String, dynamic> source) {
  final normalized = <String, dynamic>{...source};

  void ensureKey(String target, List<String> aliases) {
    if (normalized.containsKey(target)) {
      return;
    }
    for (final alias in aliases) {
      if (normalized.containsKey(alias)) {
        normalized[target] = normalized[alias];
        return;
      }
    }
  }

  ensureKey('module', ['moduleId', 'module_name']);
  ensureKey('action', ['actionId', 'permission']);
  ensureKey('permission_id', ['permissionId', 'id']);
  ensureKey('is_inherited', ['isInherited', 'inherited']);
  ensureKey('is_critical', ['isCritical', 'critical']);
  ensureKey('is_read_only', ['isReadOnly', 'readOnly']);
  ensureKey('is_system', ['isSystem']);
  ensureKey('impact_label', ['impactLabel']);
  ensureKey('description', ['detail', 'summary']);
  ensureKey('label', ['title', 'name']);

  if (normalized['label'] == null ||
      normalized['label'].toString().trim().isEmpty) {
    final description = normalized['description']?.toString();
    if (description != null && description.trim().isNotEmpty) {
      normalized['label'] = description.trim();
    } else {
      final action = normalized['action']?.toString() ?? '';
      normalized['label'] = _humanizeIdentifier(action);
    }
  }

  if (!normalized.containsKey('granted')) {
    ensureKey('granted', ['isGranted', 'assigned', 'enabled']);
  }

  void normalizeBool(String key) {
    if (!normalized.containsKey(key)) {
      return;
    }
    final value = normalized[key];
    final converted = _coerceBool(value);
    if (converted != null) {
      normalized[key] = converted;
    }
  }

  for (final key in [
    'granted',
    'is_inherited',
    'is_critical',
    'is_read_only',
    'is_system',
  ]) {
    normalizeBool(key);
  }

  return normalized;
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

bool? _coerceBool(dynamic value) {
  if (value is bool) {
    return value;
  }
  if (value is num) {
    return value != 0;
  }
  if (value is String) {
    final normalized = value.trim().toLowerCase();
    if (normalized == 'true' || normalized == '1') {
      return true;
    }
    if (normalized == 'false' || normalized == '0') {
      return false;
    }
  }
  return null;
}
