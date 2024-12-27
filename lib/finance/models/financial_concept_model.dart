enum FinancialConceptType {
  INCOME,
  EXPENSE,
}

extension FinancialConceptTypeExtension on FinancialConceptType {
  String get friendlyName {
    switch (this) {
      case FinancialConceptType.INCOME:
        return 'Ingreso';
      case FinancialConceptType.EXPENSE:
        return 'Gasto';
    }
  }
}

class FinancialConcept {
  final String financeConceptId;
  final String name;
  final String description;
  final bool active;
  final String type;
  final String churchId;

  FinancialConcept({
    required this.financeConceptId,
    required this.name,
    required this.description,
    required this.active,
    required this.type,
    required this.churchId,
  });

  factory FinancialConcept.fromJson(Map<String, dynamic> json) {
    return FinancialConcept(
      financeConceptId: json['financeConceptId'],
      name: json['name'],
      description: json['description'],
      active: json['active'],
      type: json['type'],
      churchId: json['churchId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'financeConceptId': financeConceptId,
      'name': name,
      'description': description,
      'active': active,
      'type': type,
      'churchId': churchId,
    };
  }

  FinancialConcept copyWith({
    String? id,
    String? financeConceptId,
    String? name,
    String? description,
    bool? active,
    String? type,
    DateTime? createdAt,
    String? churchId,
  }) {
    return FinancialConcept(
      financeConceptId: financeConceptId ?? this.financeConceptId,
      name: name ?? this.name,
      description: description ?? this.description,
      active: active ?? this.active,
      type: type ?? this.type,
      churchId: churchId ?? this.churchId,
    );
  }
}
