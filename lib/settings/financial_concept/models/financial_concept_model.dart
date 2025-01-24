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

  String get apiValue {
    switch (this) {
      case FinancialConceptType.INCOME:
        return 'INCOME';
      case FinancialConceptType.OUTGO:
        return 'OUTGO';
      case FinancialConceptType.PURCHASE:
        return 'PURCHASE';
    }
  }
}

String getFriendlyNameFinancialConceptType(String apiValue) {
  final financialConceptType = FinancialConceptType.values
      .firstWhere((e) => e.toString().split('.').last == apiValue);

  return financialConceptType.friendlyName;
}

class FinancialConceptModel {
  final String financialConceptId;
  final String name;
  final String description;
  final bool active;
  final String type;

  //final String churchId;

  FinancialConceptModel({
    required this.financialConceptId,
    required this.name,
    required this.description,
    required this.active,
    required this.type,
    //required this.churchId,
  });

  factory FinancialConceptModel.fromJson(Map<String, dynamic> json) {
    return FinancialConceptModel(
      financialConceptId: json['financialConceptId'],
      name: json['name'],
      description: json['description'],
      active: json['active'],
      type: json['type'],
      //churchId: json['churchId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'financialConceptId': financialConceptId,
      'name': name,
      'description': description,
      'active': active,
      'type': type,
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
    //String? churchId,
  }) {
    return FinancialConceptModel(
      financialConceptId: financialConceptId ?? this.financialConceptId,
      name: name ?? this.name,
      description: description ?? this.description,
      active: active ?? this.active,
      type: type ?? this.type,
      //churchId: churchId ?? this.churchId,
    );
  }
}
