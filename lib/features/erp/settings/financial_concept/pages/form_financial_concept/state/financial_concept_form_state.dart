import '../../../models/financial_concept_model.dart';

class FinancialConceptFormState {
  final bool makeRequest;
  final String? financialConceptId;
  final String name;
  final String description;
  final FinancialConceptType? type;
  final StatementCategory? statementCategory;
  final bool active;
  final bool affectsCashFlow;
  final bool affectsResult;
  final bool affectsBalance;
  final bool isOperational;
  final bool indicatorsEdited;

  FinancialConceptFormState({
    required this.makeRequest,
    required this.financialConceptId,
    required this.name,
    required this.description,
    required this.type,
    required this.statementCategory,
    required this.active,
    required this.affectsCashFlow,
    required this.affectsResult,
    required this.affectsBalance,
    required this.isOperational,
    required this.indicatorsEdited,
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
      affectsCashFlow: true,
      affectsResult: true,
      affectsBalance: false,
      isOperational: true,
      indicatorsEdited: false,
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
      affectsCashFlow: model.affectsCashFlow,
      affectsResult: model.affectsResult,
      affectsBalance: model.affectsBalance,
      isOperational: model.isOperational,
      indicatorsEdited: true,
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
    bool? affectsCashFlow,
    bool? affectsResult,
    bool? affectsBalance,
    bool? isOperational,
    bool? indicatorsEdited,
  }) {
    return FinancialConceptFormState(
      makeRequest: makeRequest ?? this.makeRequest,
      financialConceptId: financialConceptId ?? this.financialConceptId,
      name: name ?? this.name,
      description: description ?? this.description,
      type: type ?? this.type,
      statementCategory: statementCategory ?? this.statementCategory,
      active: active ?? this.active,
      affectsCashFlow: affectsCashFlow ?? this.affectsCashFlow,
      affectsResult: affectsResult ?? this.affectsResult,
      affectsBalance: affectsBalance ?? this.affectsBalance,
      isOperational: isOperational ?? this.isOperational,
      indicatorsEdited: indicatorsEdited ?? this.indicatorsEdited,
    );
  }

  bool get isEdit => financialConceptId != null;

  Map<String, dynamic> toPayload() {
    final payload = <String, dynamic>{
      'name': name,
      'description': description,
      'active': active,
      'affectsCashFlow': affectsCashFlow,
      'affectsResult': affectsResult,
      'affectsBalance': affectsBalance,
      'isOperational': isOperational,
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
