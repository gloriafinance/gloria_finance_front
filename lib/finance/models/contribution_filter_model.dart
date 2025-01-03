class ContributionFilterModel {
  int perPage;
  int page;
  String? startDate;
  String? status;

  ContributionFilterModel({
    this.perPage = 10,
    this.page = 1,
    this.startDate,
    this.status,
  });

  factory ContributionFilterModel.init() {
    return ContributionFilterModel();
  }

  ContributionFilterModel copyWith({
    int? perPage,
    int? page,
    String? startDate,
    String? status,
  }) {
    return ContributionFilterModel(
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
