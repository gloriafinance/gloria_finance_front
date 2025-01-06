import '../pages/financial_records/helpers.dart';
import 'finance_record_model.dart';

class FinanceRecordFilterModel {
  int perPage;
  int page;
  String? startDate;
  String? endDate;
  String churchId;
  String? financialConceptId;
  String? moneyLocation;

  FinanceRecordFilterModel({
    this.perPage = 10,
    this.page = 1,
    this.startDate,
    this.endDate,
    required this.churchId,
    this.financialConceptId,
    this.moneyLocation,
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
    String? moneyLocation,
  }) {
    return FinanceRecordFilterModel(
      page: page ?? this.page,
      perPage: perPage ?? this.perPage,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      churchId: churchId ?? this.churchId,
      financialConceptId: financialConceptId ?? this.financialConceptId,
      moneyLocation: moneyLocation ?? this.moneyLocation,
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
      'moneyLocation': getMoneyLocationFromFriendlyName(moneyLocation)
          ?.toString()
          .split('.')
          .last,
    };
  }
}
