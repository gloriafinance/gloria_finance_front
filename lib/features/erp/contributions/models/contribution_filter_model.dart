class ContributionFilterModel {
  int perPage;
  int page;
  String? startDate;
  String? endDate;
  String? status;
  String? memberId;

  ContributionFilterModel({
    this.perPage = 20,
    this.page = 1,
    this.startDate,
    this.endDate,
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
    String? endDate,
    String? status,
    String? memberId,
  }) {
    return ContributionFilterModel(
      page: page ?? this.page,
      perPage: perPage ?? this.perPage,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      status: status ?? this.status,
      memberId: memberId ?? this.memberId,
    );
  }

  Map<String, dynamic> toJson() {
    final payload = <String, dynamic>{
      'perPage': perPage,
      'page': page,
    };

    if (startDate != null && startDate!.isNotEmpty) {
      payload['startDate'] = startDate;
    }

    if (endDate != null && endDate!.isNotEmpty) {
      payload['endDate'] = endDate;
    }

    if (status != null && status!.isNotEmpty) {
      payload['status'] = status;
    }

    if (memberId != null && memberId!.isNotEmpty) {
      payload['memberId'] = memberId;
    }

    return payload;
  }
}
