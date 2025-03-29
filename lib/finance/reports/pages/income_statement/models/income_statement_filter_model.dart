// lib/finance/reports/pages/income_statement/models/income_statement_filter_model.dart

class IncomeStatementFilterModel {
  String churchId;
  int month;
  int year;

  IncomeStatementFilterModel({
    required this.churchId,
    required this.month,
    required this.year,
  });

  factory IncomeStatementFilterModel.init() {
    return IncomeStatementFilterModel(
      churchId: '',
      month: DateTime.now().month,
      year: DateTime.now().year,
    );
  }

  IncomeStatementFilterModel copyWith({
    String? churchId,
    int? month,
    int? year,
  }) {
    return IncomeStatementFilterModel(
      churchId: churchId ?? this.churchId,
      month: month ?? this.month,
      year: year ?? this.year,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'churchId': churchId,
      'month': month,
      'year': year,
    };
  }
}
