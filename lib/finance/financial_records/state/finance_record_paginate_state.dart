import 'package:church_finance_bk/core/paginate/paginate_response.dart';
import 'package:church_finance_bk/finance/financial_records/models/finance_record_filter_model.dart';

import '../models/finance_record_model.dart';

class FinanceRecordPaginateState {
  final PaginateResponse<FinanceRecordModel> paginate;
  final bool makeRequest;
  final FinanceRecordFilterModel filter;

  FinanceRecordPaginateState({
    required this.filter,
    required this.paginate,
    required this.makeRequest,
  });

  factory FinanceRecordPaginateState.empty() {
    return FinanceRecordPaginateState(
      filter: FinanceRecordFilterModel.init(),
      makeRequest: false,
      paginate: PaginateResponse<FinanceRecordModel>(
        perPage: 10,
        results: [],
        count: 0,
      ),
    );
  }

  FinanceRecordPaginateState copyWith({
    PaginateResponse<FinanceRecordModel>? paginate,
    bool? makeRequest,
    int? perPage,
    int? page,
    String? startDate,
    String? endDate,
    String? churchId,
    String? financialConceptId,
    String? moneyLocation,
  }) {
    return FinanceRecordPaginateState(
      makeRequest: makeRequest ?? this.makeRequest,
      paginate: paginate ?? this.paginate,
      filter: filter.copyWith(
        perPage: perPage,
        page: page,
        startDate: startDate,
        endDate: endDate,
        churchId: churchId,
        financialConceptId: financialConceptId,
        moneyLocation: moneyLocation,
      ),
    );
  }
}
