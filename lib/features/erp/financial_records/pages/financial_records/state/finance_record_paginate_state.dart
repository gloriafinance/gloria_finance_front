import 'package:church_finance_bk/core/paginate/paginate_response.dart';
import 'package:church_finance_bk/features/erp/financial_records/models/finance_record_filter_model.dart';

import '../../../models/finance_record_list_model.dart';

class FinanceRecordPaginateState {
  final PaginateResponse<FinanceRecordListModel> paginate;
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
      paginate: PaginateResponse<FinanceRecordListModel>(
        perPage: 10,
        results: [],
        count: 0,
      ),
    );
  }

  FinanceRecordPaginateState copyWith({
    PaginateResponse<FinanceRecordListModel>? paginate,
    bool? makeRequest,
    int? perPage,
    int? page,
    String? startDate,
    String? endDate,
    String? churchId,
    String? financialConceptId,
    String? availabilityAccountId,
    String? conceptType,
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
        availabilityAccountId: availabilityAccountId,
        conceptType: conceptType,
      ),
    );
  }
}
