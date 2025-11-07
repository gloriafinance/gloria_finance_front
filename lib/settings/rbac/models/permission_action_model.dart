class PermissionActionModel {
  const PermissionActionModel({
    required this.module,
    required this.action,
    required this.label,
    this.granted = false,
    this.isInherited = false,
    this.isCritical = false,
    this.isReadOnly = false,
    this.description,
    this.impactLabel,
  });

  factory PermissionActionModel.fromJson(Map<String, dynamic> json) {
    return PermissionActionModel(
      module: json['module']?.toString() ?? '',
      action: json['action']?.toString() ?? '',
      label: json['label']?.toString() ?? '',
      granted: json['granted'] as bool? ?? false,
      isInherited: json['is_inherited'] as bool? ?? false,
      isCritical: json['is_critical'] as bool? ?? false,
      isReadOnly: json['is_read_only'] as bool? ?? false,
      description: json['description'] as String?,
      impactLabel: json['impact_label'] as String?,
    );
  }

  final String module;
  final String action;
  final String label;
  final bool granted;
  final bool isInherited;
  final bool isCritical;
  final bool isReadOnly;
  final String? description;
  final String? impactLabel;

  PermissionActionModel copyWith({
    bool? granted,
    bool? isInherited,
    bool? isCritical,
    bool? isReadOnly,
    String? description,
    String? impactLabel,
  }) {
    return PermissionActionModel(
      module: module,
      action: action,
      label: label,
      granted: granted ?? this.granted,
      isInherited: isInherited ?? this.isInherited,
      isCritical: isCritical ?? this.isCritical,
      isReadOnly: isReadOnly ?? this.isReadOnly,
      description: description ?? this.description,
      impactLabel: impactLabel ?? this.impactLabel,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'module': module,
      'action': action,
      'label': label,
      'granted': granted,
      'is_inherited': isInherited,
      'is_critical': isCritical,
      'is_read_only': isReadOnly,
      'description': description,
      'impact_label': impactLabel,
    };
  }

  @override
  int get hashCode => Object.hash(
        module,
        action,
        label,
        granted,
        isInherited,
        isCritical,
        isReadOnly,
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
        other.granted == granted &&
        other.isInherited == isInherited &&
        other.isCritical == isCritical &&
        other.isReadOnly == isReadOnly &&
        other.description == description &&
        other.impactLabel == impactLabel;
  }
}
