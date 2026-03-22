import '../models/financial_concept_model.dart';

class FinancialConceptState {
  final List<FinancialConceptModel> financialConcepts;
  final bool isLoading;
  final FinancialConceptType? selectedType;
  final StatementCategory? selectedStatementCategory;

  FinancialConceptState({
    required this.financialConcepts,
    required this.isLoading,
    required this.selectedType,
    required this.selectedStatementCategory,
  });

  factory FinancialConceptState.init() {
    return FinancialConceptState(
      financialConcepts: [],
      isLoading: false,
      selectedType: null,
      selectedStatementCategory: null,
    );
  }

  FinancialConceptState copyWith({
    List<FinancialConceptModel>? financialConcepts,
    bool? isLoading,
    FinancialConceptType? selectedType,
    StatementCategory? selectedStatementCategory,
    bool updateSelectedType = false,
    bool updateSelectedStatementCategory = false,
  }) {
    return FinancialConceptState(
      financialConcepts: financialConcepts ?? this.financialConcepts,
      isLoading: isLoading ?? this.isLoading,
      selectedType:
          updateSelectedType ? selectedType : (selectedType ?? this.selectedType),
      selectedStatementCategory:
          updateSelectedStatementCategory
              ? selectedStatementCategory
              : (selectedStatementCategory ?? this.selectedStatementCategory),
    );
  }
}
