import 'package:church_finance_bk/features/erp/bank_statements/models/bank_statement_model.dart';

class BankStatementPaginatedResponse {
  final int count;
  final int? nextPag;
  final List<BankStatementModel> results;

  const BankStatementPaginatedResponse({
    required this.count,
    required this.nextPag,
    required this.results,
  });

  factory BankStatementPaginatedResponse.fromJson(Map<String, dynamic> json) {
    final resultsRaw = json['results'] as List? ?? [];
    final results =
        resultsRaw
            .map(
              (item) => BankStatementModel.fromJson(
                Map<String, dynamic>.from(item as Map),
              ),
            )
            .toList();

    return BankStatementPaginatedResponse(
      count: int.tryParse(json['count'].toString()) ?? 0,
      nextPag:
          json['nextPag'] != null
              ? int.tryParse(json['nextPag'].toString())
              : null,
      results: results,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'count': count,
      'nextPag': nextPag,
      'results': results.map((item) => item.toJson()).toList(),
    };
  }

  bool get hasNextPage => nextPag != null;
}
