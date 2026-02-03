class AccountsReceivableFilterModel {
  int perPage;
  int page;
  String? startDate;
  String? endDate;
  String? status;
  String? debtor;

  AccountsReceivableFilterModel({
    this.perPage = 20,
    this.page = 1,
    this.startDate,
    this.endDate,
    this.status,
    this.debtor,
  });

  AccountsReceivableFilterModel.init()
    : perPage = 20,
      page = 1,
      startDate = null,
      endDate = null,
      debtor = null,
      status = null;

  AccountsReceivableFilterModel copyWith({
    int? perPage,
    int? page,
    String? startDate,
    String? endDate,
    String? status,
    String? debtor,
  }) {
    return AccountsReceivableFilterModel(
      page: page ?? this.page,
      perPage: perPage ?? this.perPage,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      status: status ?? this.status,
      debtor: debtor ?? this.debtor,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'perPage': perPage,
      'page': page,
      'startDate': startDate,
      'endDate': endDate,
      'status': status,
      'debtor': debtor,
    };
  }
}
