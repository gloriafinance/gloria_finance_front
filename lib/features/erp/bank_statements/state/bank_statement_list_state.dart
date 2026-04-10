import 'package:gloria_finance/features/erp/bank_statements/models/index.dart';

class BankStatementListState {
  final BankStatementPaginatedResponse paginated;
  final bool loading;
  final BankStatementFilterModel filter;
  final Map<String, bool> retrying;
  final Map<String, bool> linking;

  const BankStatementListState({
    required this.paginated,
    required this.loading,
    required this.filter,
    required this.retrying,
    required this.linking,
  });

  factory BankStatementListState.initial() {
    return const BankStatementListState(
      paginated: BankStatementPaginatedResponse(
        count: 0,
        nextPag: null,
        results: [],
      ),
      loading: false,
      filter: BankStatementFilterModel(page: 1, perPage: 20),
      retrying: {},
      linking: {},
    );
  }

  BankStatementListState copyWith({
    BankStatementPaginatedResponse? paginated,
    bool? loading,
    BankStatementFilterModel? filter,
    Map<String, bool>? retrying,
    Map<String, bool>? linking,
  }) {
    return BankStatementListState(
      paginated: paginated ?? this.paginated,
      loading: loading ?? this.loading,
      filter: filter ?? this.filter,
      retrying: retrying ?? this.retrying,
      linking: linking ?? this.linking,
    );
  }

  List<BankStatementModel> get statements => paginated.results;

  bool isRetrying(String bankStatementId) {
    return retrying[bankStatementId] == true;
  }

  bool isLinking(String bankStatementId) {
    return linking[bankStatementId] == true;
  }
}
