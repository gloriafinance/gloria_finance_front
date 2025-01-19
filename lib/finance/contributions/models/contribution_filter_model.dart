class ContributionFilterModel {
  int perPage;
  int page;
  String? startDate;
  String? status;
  String? memberId;

  ContributionFilterModel({
    this.perPage = 10,
    this.page = 1,
    this.startDate,
    this.status,
    this.memberId,
  });

  factory ContributionFilterModel.init() {
    return ContributionFilterModel();
  }

  ContributionFilterModel copyWith({
    int? perPage,
    int? page,
    String? startDate,
    String? status,
    String? memberId,
  }) {
    return ContributionFilterModel(
      page: page ?? this.page,
      perPage: perPage ?? this.perPage,
      startDate: startDate ?? this.startDate,
      status: status ?? this.status,
      memberId: memberId ?? this.memberId,
    );
  }

  toJson() {
    return {
      'perPage': perPage,
      'page': page,
      'startDate': startDate,
      'status': status,
      'memberId': memberId,
    };
  }
}
