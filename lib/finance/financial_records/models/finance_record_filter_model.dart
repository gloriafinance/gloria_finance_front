import 'package:church_finance_bk/helpers/index.dart';

class FinanceRecordFilterModel {
  int perPage;
  int page;
  String? startDate;
  String? endDate;
  String churchId;
  String? financialConceptId;
  String? availabilityAccountId;

  FinanceRecordFilterModel({
    this.perPage = 20,
    this.page = 1,
    this.startDate,
    this.endDate,
    required this.churchId,
    this.financialConceptId,
    this.availabilityAccountId,
  });

  factory FinanceRecordFilterModel.init() {
    return FinanceRecordFilterModel(
      churchId: '',
    );
  }

  FinanceRecordFilterModel copyWith({
    int? perPage,
    int? page,
    String? startDate,
    String? endDate,
    String? churchId,
    String? financialConceptId,
    String? availabilityAccountId,
  }) {
    return FinanceRecordFilterModel(
      page: page ?? this.page,
      perPage: perPage ?? this.perPage,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      churchId: churchId ?? this.churchId,
      financialConceptId: financialConceptId ?? this.financialConceptId,
      availabilityAccountId:
          availabilityAccountId ?? this.availabilityAccountId,
    );
  }

  toJson() {
    return {
      'perPage': perPage,
      'page': page,
      'startDate': convertDateFormat(startDate),
      'endDate': convertDateFormat(endDate),
      'churchId': churchId,
      'financialConceptId': financialConceptId,
      'availabilityAccountId': availabilityAccountId,
    };
  }
}
