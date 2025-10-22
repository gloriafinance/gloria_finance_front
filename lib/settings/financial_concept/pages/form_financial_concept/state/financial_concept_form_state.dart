import '../../../models/financial_concept_model.dart';

class FinancialConceptFormState {
  final bool makeRequest;
  final String? financialConceptId;
  final String name;
  final String description;
  final FinancialConceptType? type;
  final StatementCategory? statementCategory;
  final bool active;

  FinancialConceptFormState({
    required this.makeRequest,
    required this.financialConceptId,
    required this.name,
    required this.description,
    required this.type,
    required this.statementCategory,
    required this.active,
  });

  factory FinancialConceptFormState.init() {
    return FinancialConceptFormState(
      makeRequest: false,
      financialConceptId: null,
      name: '',
      description: '',
      type: null,
      statementCategory: null,
      active: true,
    );
  }

  factory FinancialConceptFormState.fromModel(FinancialConceptModel model) {
    return FinancialConceptFormState(
      makeRequest: false,
      financialConceptId: model.financialConceptId,
      name: model.name,
      description: model.description,
      type: FinancialConceptType.values.firstWhere(
        (element) => element.apiValue == model.type,
        orElse: () => FinancialConceptType.OUTGO,
      ),
      statementCategory: StatementCategory.values.firstWhere(
        (element) => element.apiValue == model.statementCategory,
        orElse: () => StatementCategory.OTHER,
      ),
      active: model.active,
    );
  }

  FinancialConceptFormState copyWith({
    bool? makeRequest,
    String? financialConceptId,
    String? name,
    String? description,
    FinancialConceptType? type,
    StatementCategory? statementCategory,
    bool? active,
  }) {
    return FinancialConceptFormState(
      makeRequest: makeRequest ?? this.makeRequest,
      financialConceptId: financialConceptId ?? this.financialConceptId,
      name: name ?? this.name,
      description: description ?? this.description,
      type: type ?? this.type,
      statementCategory: statementCategory ?? this.statementCategory,
      active: active ?? this.active,
    );
  }

  bool get isEdit => financialConceptId != null;

  Map<String, dynamic> toPayload() {
    final payload = <String, dynamic>{
      'name': name,
      'description': description,
      'active': active,
    };

    if (type != null) {
      payload['type'] = type!.apiValue;
    }

    if (statementCategory != null) {
      payload['statementCategory'] = statementCategory!.apiValue;
    }

    if (financialConceptId != null) {
      payload['financialConceptId'] = financialConceptId;
    }

    return payload;
  }
}
