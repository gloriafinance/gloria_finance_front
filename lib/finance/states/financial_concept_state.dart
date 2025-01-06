import '../models/financial_concept_model.dart';

class FinancialConceptState {
  final List<FinancialConceptModel> financialConcepts;

  FinancialConceptState({
    required this.financialConcepts,
  });

  factory FinancialConceptState.init() {
    return FinancialConceptState(
      financialConcepts: [],
    );
  }

  FinancialConceptState copyWith({
    List<FinancialConceptModel>? financialConcepts,
  }) {
    return FinancialConceptState(
      financialConcepts: financialConcepts ?? this.financialConcepts,
    );
  }
}
