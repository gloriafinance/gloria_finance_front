enum FinancialConceptType { INCOME, OUTGO, PURCHASE }

extension FinancialConceptTypeExtension on FinancialConceptType {
  String get friendlyName {
    switch (this) {
      case FinancialConceptType.INCOME:
        return 'Ingreso';
      case FinancialConceptType.OUTGO:
        return 'Gasto';
      case FinancialConceptType.PURCHASE:
        return 'Compra';
    }
  }
}

class FinancialConcept {
  final String financialConceptId;
  final String name;
  final String description;
  final bool active;
  final String type;
  final String churchId;

  FinancialConcept({
    required this.financialConceptId,
    required this.name,
    required this.description,
    required this.active,
    required this.type,
    required this.churchId,
  });

  factory FinancialConcept.fromJson(Map<String, dynamic> json) {
    return FinancialConcept(
      financialConceptId: json['financialConceptId'],
      name: json['name'],
      description: json['description'],
      active: json['active'],
      type: json['type'],
      churchId: json['churchId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'financialConceptId': financialConceptId,
      'name': name,
      'description': description,
      'active': active,
      'type': type,
      'churchId': churchId,
    };
  }

  FinancialConcept copyWith({
    String? id,
    String? financialConceptId,
    String? name,
    String? description,
    bool? active,
    String? type,
    DateTime? createdAt,
    String? churchId,
  }) {
    return FinancialConcept(
      financialConceptId: financialConceptId ?? this.financialConceptId,
      name: name ?? this.name,
      description: description ?? this.description,
      active: active ?? this.active,
      type: type ?? this.type,
      churchId: churchId ?? this.churchId,
    );
  }
}
