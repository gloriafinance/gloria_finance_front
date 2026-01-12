import 'package:church_finance_bk/l10n/app_localizations.dart';

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

  String friendlyName(AppLocalizations l10n) {
    switch (this) {
      case CostCenterCategory.ESPECIAL_PROJECT:
        return l10n.settings_cost_center_category_special_project;
      case CostCenterCategory.MINISTRIES:
        return l10n.settings_cost_center_category_ministries;
      case CostCenterCategory.OPERATIONS:
        return l10n.settings_cost_center_category_operations;
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
  final String? responsibleMemberId;

  CostCenterModel({
    required this.active,
    required this.churchId,
    required this.costCenterId,
    required this.name,
    required this.description,
    required this.category,
    required this.responsible,
    required this.responsibleMemberId,
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
            : null,
        responsibleMemberId = (map['responsibleMemberId'] ??
                (map['responsible']?['memberId']))
            ?.toString();

  Map<String, dynamic> toJson() => {
        'active': active,
        'churchId': churchId,
        'costCenterId': costCenterId,
        'name': name,
        'description': description,
        'category': category.apiValue,
        if (responsible != null) 'responsible': responsible!.toJson(),
        if (responsibleMemberId != null)
          'responsibleMemberId': responsibleMemberId,
      };
}

class CostCenterResponsible {
  final String? memberId;
  final String name;
  final String email;
  final String phone;

  const CostCenterResponsible({
    this.memberId,
    required this.name,
    required this.email,
    required this.phone,
  });

  factory CostCenterResponsible.fromJson(Map<String, dynamic> json) {
    return CostCenterResponsible(
      memberId: (json['memberId'] ?? json['id'])?.toString(),
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        if (memberId != null) 'memberId': memberId,
        'name': name,
        'email': email,
        'phone': phone,
      };
}
