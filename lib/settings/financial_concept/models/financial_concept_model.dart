enum FinancialConceptType { INCOME, OUTGO, PURCHASE, REVERSAL }

extension FinancialConceptTypeExtension on FinancialConceptType {
  String get friendlyName {
    switch (this) {
      case FinancialConceptType.INCOME:
        return 'Ingreso';
      case FinancialConceptType.OUTGO:
        return 'Saida';
      case FinancialConceptType.PURCHASE:
        return 'Compra';
      case FinancialConceptType.REVERSAL:
        return 'Reversão';
    }
  }

  String get apiValue {
    switch (this) {
      case FinancialConceptType.INCOME:
        return 'INCOME';
      case FinancialConceptType.OUTGO:
        return 'OUTGO';
      case FinancialConceptType.PURCHASE:
        return 'PURCHASE';
      case FinancialConceptType.REVERSAL:
        return 'REVERSAL';
    }
  }

  static List<String> get listFriendlyName {
    return FinancialConceptType.values.map((e) => e.friendlyName).toList();
  }

  static List<FinancialConceptType> get listValues {
    return FinancialConceptType.values;
  }
}

String getFriendlyNameFinancialConceptType(String apiValue) {
  final financialConceptType = FinancialConceptType.values.firstWhere(
    (e) => e.toString().split('.').last == apiValue,
  );

  return financialConceptType.friendlyName;
}

enum StatementCategory { OPEX, CAPEX, OTHER }

extension StatementCategoryExtension on StatementCategory {
  String get friendlyName {
    switch (this) {
      case StatementCategory.OPEX:
        return 'Operacional (OPEX)';
      case StatementCategory.CAPEX:
        return 'Investimento (CAPEX)';
      case StatementCategory.OTHER:
        return 'Outros';
    }
  }

  String get apiValue {
    switch (this) {
      case StatementCategory.OPEX:
        return 'OPEX';
      case StatementCategory.CAPEX:
        return 'CAPEX';
      case StatementCategory.OTHER:
        return 'OTHER';
    }
  }

  static List<String> get listFriendlyName {
    return StatementCategory.values.map((e) => e.friendlyName).toList();
  }

  static StatementCategory fromFriendlyName(String friendlyName) {
    return StatementCategory.values.firstWhere(
      (element) => element.friendlyName == friendlyName,
    );
  }
}

String getFriendlyNameStatementCategory(String apiValue) {
  final category = StatementCategory.values.firstWhere(
    (e) => e.apiValue == apiValue,
    orElse: () => StatementCategory.OTHER,
  );

  return category.friendlyName;
}

class FinancialConceptModel {
  final String? id;
  final String financialConceptId;
  final String name;
  final String description;
  final bool active;
  final String type;
  final String statementCategory;
  final DateTime? createdAt;
  final String? churchId;

  //final String churchId;

  FinancialConceptModel({
    required this.id,
    required this.financialConceptId,
    required this.name,
    required this.description,
    required this.active,
    required this.type,
    required this.statementCategory,
    required this.createdAt,
    required this.churchId,
    //required this.churchId,
  });

  factory FinancialConceptModel.fromJson(Map<String, dynamic> json) {
    return FinancialConceptModel(
      id: json['id'],
      financialConceptId: json['financialConceptId'],
      name: json['name'],
      description: json['description'],
      active: json['active'],
      type: json['type'],
      statementCategory: json['statementCategory'] ?? 'OTHER',
      createdAt:
          json['createdAt'] != null ? DateTime.tryParse(json['createdAt']) : null,
      churchId: json['churchId'],
      //churchId: json['churchId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'financialConceptId': financialConceptId,
      'name': name,
      'description': description,
      'active': active,
      'type': type,
      'statementCategory': statementCategory,
      'createdAt': createdAt?.toIso8601String(),
      'churchId': churchId,
      //'churchId': churchId,
    };
  }

  FinancialConceptModel copyWith({
    String? id,
    String? financialConceptId,
    String? name,
    String? description,
    bool? active,
    String? type,
    DateTime? createdAt,
    String? statementCategory,
    String? churchId,
    //String? churchId,
  }) {
    return FinancialConceptModel(
      id: id ?? this.id,
      financialConceptId: financialConceptId ?? this.financialConceptId,
      name: name ?? this.name,
      description: description ?? this.description,
      active: active ?? this.active,
      type: type ?? this.type,
      statementCategory: statementCategory ?? this.statementCategory,
      //churchId: churchId ?? this.churchId,
      createdAt: createdAt ?? this.createdAt,
      churchId: churchId ?? this.churchId,
    );
  }
}
