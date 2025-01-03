import 'package:church_finance_bk/core/paginate/paginate_response.dart';

import '../models/contribution_filter_model.dart';
import '../models/contribution_model.dart';

class ContributionPaginationState {
  final PaginateResponse<ContributionModel> paginate;
  final bool makeRequest;
  final ContributionFilterModel filter;

  ContributionPaginationState(
      {required this.makeRequest,
      required this.paginate,
      required this.filter});

  factory ContributionPaginationState.empty() {
    return ContributionPaginationState(
      filter: ContributionFilterModel.init(),
      makeRequest: false,
      paginate: PaginateResponse<ContributionModel>(
        perPage: 10,
        results: [],
        count: 0,
      ),
    );
  }

  ContributionPaginationState copyWith({
    PaginateResponse<ContributionModel>? paginate,
    bool? makeRequest,
    int? perPage,
    int? page,
    String? startDate,
    String? status,
  }) {
    return ContributionPaginationState(
        makeRequest: makeRequest ?? this.makeRequest,
        paginate: paginate ?? this.paginate,
        filter: filter.copyWith(
          perPage: perPage,
          page: page,
          startDate: startDate,
          status: status,
        ));
  }

  updateStatusContributionModel(String contributionId, String status) {
    final List<ContributionModel> contributions =
        paginate.results.map<ContributionModel>((e) {
      if (e.contributionId == contributionId) {
        return e.copyWith(status: status);
      }
      return e;
    }).toList();

    return copyWith(paginate: paginate.copyWith(results: contributions));
  }
}
