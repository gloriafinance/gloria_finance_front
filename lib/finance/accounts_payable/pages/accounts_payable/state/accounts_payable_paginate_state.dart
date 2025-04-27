import 'package:church_finance_bk/core/paginate/paginate_response.dart';
import 'package:church_finance_bk/finance/accounts_payable/models/accounts_payable_model.dart';

import '../../../models/accounts_payable_filter_model.dart';

class AccountsPayablePaginateState {
  final PaginateResponse<AccountsPayableModel> paginate;
  final bool makeRequest;
  final AccountsPayableFilterModel filter;

  AccountsPayablePaginateState.empty()
      : paginate = PaginateResponse<AccountsPayableModel>(
          perPage: 10,
          results: [],
          count: 0,
        ),
        makeRequest = false,
        filter = AccountsPayableFilterModel.init();

  AccountsPayablePaginateState({
    required this.paginate,
    required this.makeRequest,
    required this.filter,
  });

  AccountsPayablePaginateState copyWith({
    PaginateResponse<AccountsPayableModel>? paginate,
    bool? makeRequest,
    int? perPage,
    int? page,
    String? startDate,
    String? endDate,
    String? status,
  }) {
    return AccountsPayablePaginateState(
      makeRequest: makeRequest ?? this.makeRequest,
      paginate: paginate ?? this.paginate,
      filter: filter.copyWith(
        perPage: perPage,
        page: page,
        startDate: startDate,
        endDate: endDate,
        status: status,
      ),
    );
  }
}
