class ContributionFilter {
  int perPage;
  int page;
  String? startDate;
  String? status;

  ContributionFilter({
    this.perPage = 10,
    this.page = 1,
    this.startDate,
    this.status,
  });

  factory ContributionFilter.init() {
    return ContributionFilter();
  }

  ContributionFilter copyWith({
    int? perPage,
    int? page,
    String? startDate,
    String? status,
  }) {
    return ContributionFilter(
      page: page ?? this.page,
      perPage: perPage ?? this.perPage,
      startDate: startDate ?? this.startDate,
      status: status ?? this.status,
    );
  }

  toMap() {
    return {
      'perPage': perPage,
      'page': page,
      'startDate': startDate,
      'status': status,
    };
  }
}
