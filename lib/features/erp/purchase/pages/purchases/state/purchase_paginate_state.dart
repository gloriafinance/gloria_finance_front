import 'package:church_finance_bk/core/paginate/paginate_response.dart';

import '../models/purchase_filter_model.dart';
import '../models/purchase_list_model.dart';

class PurchasePaginateState {
  final PaginateResponse<PurchaseListModel> paginate;
  final bool makeRequest;
  final PurchaseFilterModel filter;

  PurchasePaginateState({
    required this.filter,
    required this.paginate,
    required this.makeRequest,
  });

  factory PurchasePaginateState.empty() {
    return PurchasePaginateState(
      filter: PurchaseFilterModel.init(),
      makeRequest: false,
      paginate: PaginateResponse<PurchaseListModel>(
        perPage: 10,
        results: [],
        count: 0,
      ),
    );
  }

  PurchasePaginateState copyWith({
    PaginateResponse<PurchaseListModel>? paginate,
    bool? makeRequest,
    int? perPage,
    int? page,
    String? startDate,
    String? endDate,
    String? churchId,
  }) {
    return PurchasePaginateState(
      makeRequest: makeRequest ?? this.makeRequest,
      paginate: paginate ?? this.paginate,
      filter: filter.copyWith(
        perPage: perPage,
        page: page,
        startDate: startDate,
        endDate: endDate,
        churchId: churchId,
      ),
    );
  }
}
