import 'package:gloria_finance/core/utils/index.dart';

class FinanceRecordFilterModel {
  int perPage;
  int page;
  String? startDate;
  String? endDate;
  String churchId;
  String? financialConceptId;
  String? availabilityAccountId;
  String? conceptType;
  String? referenceType;
  String? referenceEntityId;

  FinanceRecordFilterModel({
    this.perPage = 20,
    this.page = 1,
    this.startDate,
    this.endDate,
    required this.churchId,
    this.financialConceptId,
    this.availabilityAccountId,
    this.conceptType,
    this.referenceType,
    this.referenceEntityId,
  });

  factory FinanceRecordFilterModel.init() {
    return FinanceRecordFilterModel(churchId: '');
  }

  FinanceRecordFilterModel copyWith({
    int? perPage,
    int? page,
    String? startDate,
    String? endDate,
    String? churchId,
    String? financialConceptId,
    String? availabilityAccountId,
    String? conceptType,
    String? referenceType,
    String? referenceEntityId,
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
      conceptType: conceptType ?? this.conceptType,
      referenceType: referenceType ?? this.referenceType,
      referenceEntityId: referenceEntityId ?? this.referenceEntityId,
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
      'conceptType': conceptType,
      'referenceType': referenceType,
      'referenceEntityId': referenceEntityId,
    };
  }
}
