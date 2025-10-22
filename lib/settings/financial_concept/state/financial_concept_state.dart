import '../models/financial_concept_model.dart';

class FinancialConceptState {
  final List<FinancialConceptModel> financialConcepts;
  final bool isLoading;
  final FinancialConceptType? selectedType;

  FinancialConceptState({
    required this.financialConcepts,
    required this.isLoading,
    required this.selectedType,
  });

  factory FinancialConceptState.init() {
    return FinancialConceptState(
      financialConcepts: [],
      isLoading: false,
      selectedType: null,
    );
  }

  FinancialConceptState copyWith({
    List<FinancialConceptModel>? financialConcepts,
    bool? isLoading,
    FinancialConceptType? selectedType,
    bool updateSelectedType = false,
  }) {
    return FinancialConceptState(
      financialConcepts: financialConcepts ?? this.financialConcepts,
      isLoading: isLoading ?? this.isLoading,
      selectedType:
          updateSelectedType ? selectedType : (selectedType ?? this.selectedType),
    );
  }
}
