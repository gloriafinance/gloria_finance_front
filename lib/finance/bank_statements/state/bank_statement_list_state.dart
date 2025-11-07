import 'package:church_finance_bk/finance/bank_statements/models/index.dart';

class BankStatementListState {
  final List<BankStatementModel> statements;
  final bool loading;
  final BankStatementFilterModel filter;
  final Map<String, bool> retrying;
  final Map<String, bool> linking;

  const BankStatementListState({
    required this.statements,
    required this.loading,
    required this.filter,
    required this.retrying,
    required this.linking,
  });

  factory BankStatementListState.initial() {
    return BankStatementListState(
      statements: const [],
      loading: false,
      filter: BankStatementFilterModel.initial(),
      retrying: const {},
      linking: const {},
    );
  }

  BankStatementListState copyWith({
    List<BankStatementModel>? statements,
    bool? loading,
    BankStatementFilterModel? filter,
    Map<String, bool>? retrying,
    Map<String, bool>? linking,
  }) {
    return BankStatementListState(
      statements: statements ?? this.statements,
      loading: loading ?? this.loading,
      filter: filter ?? this.filter,
      retrying: retrying ?? this.retrying,
      linking: linking ?? this.linking,
    );
  }

  bool isRetrying(String bankStatementId) {
    return retrying[bankStatementId] == true;
  }

  bool isLinking(String bankStatementId) {
    return linking[bankStatementId] == true;
  }
}
