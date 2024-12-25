import 'package:church_finance_bk/finance/models/contribution_model.dart';

class ContributionFilter {
  int perPage;
  int page;
  String? startDate;
  ContributionStatus? status;

  ContributionFilter({
    this.perPage = 10,
    this.page = 1,
    this.startDate,
    this.status,
  });

  factory ContributionFilter.init() {
    return ContributionFilter();
  }

  toMap() {
    return {
      'perPage': perPage,
      'page': page,
      'startDate': startDate,
      'status': status?.toString().split('.').last,
    };
  }
}
