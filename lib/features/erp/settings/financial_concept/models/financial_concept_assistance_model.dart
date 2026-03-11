class FinancialConceptAssistanceModel {
  final bool needsCreate;
  final String justification;
  final FinancialConceptAssistanceSuggestion concept;

  const FinancialConceptAssistanceModel({
    required this.needsCreate,
    required this.justification,
    required this.concept,
  });

  factory FinancialConceptAssistanceModel.fromJson(Map<String, dynamic> json) {
    return FinancialConceptAssistanceModel(
      needsCreate: json['needsCreate'] == true,
      justification: (json['justification'] ?? '').toString(),
      concept: FinancialConceptAssistanceSuggestion.fromJson(
        Map<String, dynamic>.from(json['concept'] ?? const {}),
      ),
    );
  }
}

class FinancialConceptAssistanceSuggestion {
  final String financialConceptId;
  final String name;
  final String description;
  final String type;
  final String statementCategory;
  final bool affectsCashFlow;
  final bool affectsResult;
  final bool affectsBalance;
  final bool isOperational;

  const FinancialConceptAssistanceSuggestion({
    required this.financialConceptId,
    required this.name,
    required this.description,
    required this.type,
    required this.statementCategory,
    required this.affectsCashFlow,
    required this.affectsResult,
    required this.affectsBalance,
    required this.isOperational,
  });

  factory FinancialConceptAssistanceSuggestion.fromJson(
    Map<String, dynamic> json,
  ) {
    return FinancialConceptAssistanceSuggestion(
      financialConceptId: (json['financialConceptId'] ?? '').toString(),
      name: (json['name'] ?? '').toString(),
      description: (json['description'] ?? '').toString(),
      type: (json['type'] ?? '').toString(),
      statementCategory: (json['statementCategory'] ?? '').toString(),
      affectsCashFlow: json['affectsCashFlow'] == true,
      affectsResult: json['affectsResult'] == true,
      affectsBalance: json['affectsBalance'] == true,
      isOperational: json['isOperational'] == true,
    );
  }
}
