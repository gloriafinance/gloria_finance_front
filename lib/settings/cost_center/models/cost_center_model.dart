enum CostCenterCategory { ESPECIAL_PROJECT, MINISTRIES, OPERATIONS }

extension CostCenterCategoryExtension on CostCenterCategory {
  static CostCenterCategory fromApiValue(String value) {
    return CostCenterCategory.values.firstWhere(
      (element) => element.apiValue == value,
      orElse: () => CostCenterCategory.OPERATIONS,
    );
  }

  String get apiValue {
    return toString().split('.').last;
  }

  String get friendlyName {
    switch (this) {
      case CostCenterCategory.ESPECIAL_PROJECT:
        return 'Projetos especiais';
      case CostCenterCategory.MINISTRIES:
        return 'Ministérios';
      case CostCenterCategory.OPERATIONS:
        return 'Operações';
    }
  }
}

class CostCenterModel {
  final bool active;
  final String churchId;
  final String costCenterId;
  final String name;
  final String description;
  final CostCenterCategory category;
  final CostCenterResponsible? responsible;

  CostCenterModel({
    required this.active,
    required this.churchId,
    required this.costCenterId,
    required this.name,
    required this.description,
    required this.category,
    required this.responsible,
  });

  CostCenterModel.fromMap(Map<String, dynamic> map)
      : active = map['active'] ?? false,
        churchId = map['churchId'] ?? '',
        costCenterId = map['costCenterId'] ?? '',
        name = map['name'] ?? '',
        description = map['description'] ?? '',
        category = CostCenterCategoryExtension.fromApiValue(
          map['category'] ?? CostCenterCategory.OPERATIONS.apiValue,
        ),
        responsible = map['responsible'] is Map<String, dynamic>
            ? CostCenterResponsible.fromJson(
                map['responsible'] as Map<String, dynamic>,
              )
            : null;

  Map<String, dynamic> toJson() => {
        'active': active,
        'churchId': churchId,
        'costCenterId': costCenterId,
        'name': name,
        'description': description,
        'category': category.apiValue,
        if (responsible != null) 'responsible': responsible!.toJson(),
      };
}

class CostCenterResponsible {
  final String name;
  final String email;
  final String phone;

  const CostCenterResponsible({
    required this.name,
    required this.email,
    required this.phone,
  });

  factory CostCenterResponsible.fromJson(Map<String, dynamic> json) {
    return CostCenterResponsible(
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'phone': phone,
      };
}
