class AccountsPayableFilterModel {
  int perPage;
  int page;
  String? startDate;
  String? endDate;
  String? status;

  AccountsPayableFilterModel({
    this.perPage = 20,
    this.page = 1,
    this.startDate,
    this.endDate,
    this.status,
  });

  AccountsPayableFilterModel.init()
      : perPage = 20,
        page = 1,
        startDate = null,
        endDate = null,
        status = null;

  AccountsPayableFilterModel copyWith({
    int? perPage,
    int? page,
    String? startDate,
    String? endDate,
    String? status,
  }) {
    return AccountsPayableFilterModel(
      page: page ?? this.page,
      perPage: perPage ?? this.perPage,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'perPage': perPage,
      'page': page,
      'startDate': startDate,
      'endDate': endDate,
      'status': status,
    };
  }
}
