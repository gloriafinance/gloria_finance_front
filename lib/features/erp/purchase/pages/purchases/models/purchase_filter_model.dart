import 'package:gloria_finance/core/utils/index.dart';

class PurchaseFilterModel {
  int perPage;
  int page;
  String? startDate;
  String? endDate;

  PurchaseFilterModel({
    this.perPage = 20,
    this.page = 1,
    this.startDate,
    this.endDate,
  });

  factory PurchaseFilterModel.init() {
    return PurchaseFilterModel();
  }

  PurchaseFilterModel copyWith({
    int? perPage,
    int? page,
    String? startDate,
    String? endDate,
    String? churchId,
  }) {
    return PurchaseFilterModel(
      page: page ?? this.page,
      perPage: perPage ?? this.perPage,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }

  toJson() {
    return {
      'perPage': perPage,
      'page': page,
      'startDate': convertDateFormat(startDate),
      'endDate': convertDateFormat(endDate),
    };
  }
}
