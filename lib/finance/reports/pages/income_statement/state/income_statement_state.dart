// lib/finance/reports/pages/income_statement/state/income_statement_state.dart

import '../models/income_statement_filter_model.dart';
import '../models/income_statement_model.dart';

class IncomeStatementState {
  final bool makeRequest;
  final IncomeStatementFilterModel filter;
  final IncomeStatementModel data;

  IncomeStatementState({
    required this.makeRequest,
    required this.filter,
    required this.data,
  });

  factory IncomeStatementState.empty() {
    return IncomeStatementState(
      makeRequest: false,
      filter: IncomeStatementFilterModel.init(),
      data: IncomeStatementModel.empty(),
    );
  }

  IncomeStatementState copyWith({
    bool? makeRequest,
    IncomeStatementModel? data,
    String? churchId,
    int? month,
    int? year,
  }) {
    return IncomeStatementState(
      makeRequest: makeRequest ?? this.makeRequest,
      data: data ?? this.data,
      filter: filter.copyWith(
        churchId: churchId,
        month: month,
        year: year,
      ),
    );
  }
}
