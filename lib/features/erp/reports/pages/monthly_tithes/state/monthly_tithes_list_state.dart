import 'package:church_finance_bk/features/erp/reports/pages/monthly_tithes/models/monthly_tithes_filter_model.dart';

import '../models/monthly_tithes_list_model.dart';

class MonthlyTithesListState {
  final bool makeRequest;
  final MonthlyTithesFilterModel filter;
  final MonthlyTithesListModel data;

  MonthlyTithesListState({
    required this.filter,
    required this.data,
    required this.makeRequest,
  });

  factory MonthlyTithesListState.empty() {
    return MonthlyTithesListState(
      filter: MonthlyTithesFilterModel.init(),
      makeRequest: false,
      data: MonthlyTithesListModel(results: [], totals: []),
    );
  }

  MonthlyTithesListState copyWith({
    MonthlyTithesListModel? data,
    bool? makeRequest,
    String? churchId,
    int? month,
    int? year,
  }) {
    return MonthlyTithesListState(
      makeRequest: makeRequest ?? this.makeRequest,
      data: data ?? this.data,
      filter: filter.copyWith(churchId: churchId, month: month, year: year),
    );
  }
}
