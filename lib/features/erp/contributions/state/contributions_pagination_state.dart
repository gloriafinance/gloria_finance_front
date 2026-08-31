import 'package:gloria_finance/core/paginate/paginate_response.dart';

import '../models/contribution_filter_model.dart';
import '../models/contribution_model.dart';

class ContributionPaginationState {
  final PaginateResponse<ContributionModel> paginate;
  final bool makeRequest;
  final ContributionFilterModel filter;
  final ContributionModel? viewedContribution;
  final bool viewContributionLoading;

  ContributionPaginationState({
    required this.makeRequest,
    required this.paginate,
    required this.filter,
    this.viewedContribution,
    this.viewContributionLoading = false,
  });

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
    String? endDate,
    String? status,
    String? memberId,
    ContributionModel? viewedContribution,
    bool? viewContributionLoading,
  }) {
    return ContributionPaginationState(
      makeRequest: makeRequest ?? this.makeRequest,
      paginate: paginate ?? this.paginate,
      viewedContribution: viewedContribution ?? this.viewedContribution,
      viewContributionLoading:
          viewContributionLoading ?? this.viewContributionLoading,
      filter: filter.copyWith(
        perPage: perPage,
        page: page,
        startDate: startDate,
        endDate: endDate,
        status: status,
        memberId: memberId,
      ),
    );
  }
}
