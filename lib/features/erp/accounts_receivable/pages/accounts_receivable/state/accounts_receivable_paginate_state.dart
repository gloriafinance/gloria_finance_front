import 'package:church_finance_bk/core/paginate/paginate_response.dart';

import '../../../models/index.dart';

class AccountsReceivablePaginateState {
  final PaginateResponse<AccountsReceivableModel> paginate;
  final bool makeRequest;
  final AccountsReceivableFilterModel filter;

  AccountsReceivablePaginateState.empty()
    : paginate = PaginateResponse<AccountsReceivableModel>(
        perPage: 10,
        results: [],
        count: 0,
      ),
      makeRequest = false,
      filter = AccountsReceivableFilterModel.init();

  AccountsReceivablePaginateState({
    required this.paginate,
    required this.makeRequest,
    required this.filter,
  });

  AccountsReceivablePaginateState copyWith({
    PaginateResponse<AccountsReceivableModel>? paginate,
    bool? makeRequest,
    int? perPage,
    int? page,
    String? startDate,
    String? endDate,
    String? status,
    String? debtor,
    //String? memberId,
  }) {
    return AccountsReceivablePaginateState(
      makeRequest: makeRequest ?? this.makeRequest,
      paginate: paginate ?? this.paginate,
      filter: filter.copyWith(
        perPage: perPage,
        page: page,
        startDate: startDate,
        endDate: endDate,
        status: status,
        debtor: debtor,
        //  memberId: memberId,
      ),
    );
  }
}
