import 'package:church_finance_bk/finance/bank_statements/models/bank_statement_model.dart';

class BankStatementFilterModel {
  final String? bankId;
  final BankStatementReconciliationStatus? status;
  final int? month;
  final int? year;
  final String? churchId;
  final DateTime? dateFrom;
  final DateTime? dateTo;
  final int? page;
  final int? perPage;

  const BankStatementFilterModel({
    this.bankId,
    this.status,
    this.month,
    this.year,
    this.churchId,
    this.dateFrom,
    this.dateTo,
    this.page,
    this.perPage,
  });

  factory BankStatementFilterModel.initial() {
    return const BankStatementFilterModel();
  }

  BankStatementFilterModel copyWith({
    String? bankId,
    BankStatementReconciliationStatus? status,
    int? month,
    int? year,
    String? churchId,
    DateTime? dateFrom,
    DateTime? dateTo,
    int? page,
    int? perPage,
  }) {
    return BankStatementFilterModel(
      bankId: bankId ?? this.bankId,
      status: status ?? this.status,
      month: month ?? this.month,
      year: year ?? this.year,
      churchId: churchId ?? this.churchId,
      dateFrom: dateFrom ?? this.dateFrom,
      dateTo: dateTo ?? this.dateTo,
      page: page ?? this.page,
      perPage: perPage ?? this.perPage,
    );
  }

  Map<String, dynamic> toQueryParameters() {
    return {
      if (bankId != null && bankId!.isNotEmpty) 'bankId': bankId,
      if (status != null) 'status': status!.apiValue,
      if (month != null) 'month': month,
      if (year != null) 'year': year,
      if (churchId != null && churchId!.isNotEmpty) 'churchId': churchId,
      if (dateFrom != null) 'dateFrom': _formatDate(dateFrom),
      if (dateTo != null) 'dateTo': _formatDate(dateTo),
      if (page != null) 'page': page,
      if (perPage != null) 'perPage': perPage,
    };
  }

  Map<String, dynamic> toJson() => toQueryParameters();

  static String? _formatDate(DateTime? value) {
    if (value == null) return null;
    return value.toIso8601String().split('T').first;
  }

  bool get hasAnyFilter {
    return (bankId != null && bankId!.isNotEmpty) ||
        status != null ||
        month != null ||
        year != null ||
        dateFrom != null ||
        dateTo != null ||
        (churchId != null && churchId!.isNotEmpty);
  }
}
