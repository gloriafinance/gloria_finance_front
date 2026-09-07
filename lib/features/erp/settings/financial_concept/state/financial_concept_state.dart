import '../models/financial_concept_model.dart';

class FinancialConceptState {
  final List<FinancialConceptModel> financialConcepts;
  final bool isLoading;
  final FinancialConceptType? selectedType;
  final StatementCategory? selectedStatementCategory;
  final String? creatingPixForConceptId;

  FinancialConceptState({
    required this.financialConcepts,
    required this.isLoading,
    required this.selectedType,
    required this.selectedStatementCategory,
    required this.creatingPixForConceptId,
  });

  factory FinancialConceptState.init() {
    return FinancialConceptState(
      financialConcepts: [],
      isLoading: false,
      selectedType: null,
      selectedStatementCategory: null,
      creatingPixForConceptId: null,
    );
  }

  FinancialConceptState copyWith({
    List<FinancialConceptModel>? financialConcepts,
    bool? isLoading,
    FinancialConceptType? selectedType,
    StatementCategory? selectedStatementCategory,
    bool updateSelectedType = false,
    bool updateSelectedStatementCategory = false,
    String? creatingPixForConceptId,
    bool updateCreatingPixForConceptId = false,
  }) {
    return FinancialConceptState(
      financialConcepts: financialConcepts ?? this.financialConcepts,
      isLoading: isLoading ?? this.isLoading,
      selectedType:
          updateSelectedType
              ? selectedType
              : (selectedType ?? this.selectedType),
      selectedStatementCategory:
          updateSelectedStatementCategory
              ? selectedStatementCategory
              : (selectedStatementCategory ?? this.selectedStatementCategory),
      creatingPixForConceptId:
          updateCreatingPixForConceptId
              ? creatingPixForConceptId
              : this.creatingPixForConceptId,
    );
  }
}
