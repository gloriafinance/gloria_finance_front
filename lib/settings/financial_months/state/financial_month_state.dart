import '../models/financial_month_model.dart';

class FinancialMonthState {
  final List<FinancialMonthModel> months;
  final bool isLoading;
  final int selectedYear;

  FinancialMonthState({
    required this.months,
    required this.isLoading,
    required this.selectedYear,
  });

  factory FinancialMonthState.empty() {
    return FinancialMonthState(
      months: [],
      isLoading: false,
      selectedYear: DateTime.now().year,
    );
  }

  FinancialMonthState copyWith({
    List<FinancialMonthModel>? months,
    bool? isLoading,
    int? selectedYear,
  }) {
    return FinancialMonthState(
      months: months ?? this.months,
      isLoading: isLoading ?? this.isLoading,
      selectedYear: selectedYear ?? this.selectedYear,
    );
  }
}
