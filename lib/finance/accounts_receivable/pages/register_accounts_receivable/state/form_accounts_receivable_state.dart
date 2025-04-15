import '../../../models/index.dart';

class FormAccountsReceivableState {
  bool makeRequest;
  DebtorType debtorType;
  String debtorDNI;
  String debtorName;
  String description;
  String debtorPhone;
  String churchId;
  List<InstallmentModel> installments;

  FormAccountsReceivableState({
    required this.makeRequest,
    required this.debtorType,
    required this.debtorDNI,
    required this.debtorName,
    required this.description,
    required this.churchId,
    required this.installments,
    required this.debtorPhone,
  });

  factory FormAccountsReceivableState.init() {
    return FormAccountsReceivableState(
      makeRequest: false,
      debtorType: DebtorType.MEMBER,
      debtorDNI: '',
      debtorName: '',
      description: '',
      churchId: '',
      installments: [],
      debtorPhone: '',
    );
  }

  FormAccountsReceivableState copyWith({
    bool? makeRequest,
    DebtorType? debtorType,
    String? debtorDNI,
    String? debtorName,
    String? description,
    String? churchId,
    List<InstallmentModel>? installments,
    String? debtorPhone,
  }) {
    return FormAccountsReceivableState(
      makeRequest: makeRequest ?? this.makeRequest,
      debtorType: debtorType ?? this.debtorType,
      debtorDNI: debtorDNI ?? this.debtorDNI,
      debtorName: debtorName ?? this.debtorName,
      description: description ?? this.description,
      churchId: churchId ?? this.churchId,
      installments: installments ?? this.installments,
      debtorPhone: debtorPhone ?? this.debtorPhone,
    );
  }

  toJson() {
    return {
      'debtor': {
        'debtorType': debtorType.apiValue,
        'debtorDNI': debtorDNI,
        'name': debtorName,
        'phone': debtorPhone,
      },
      'churchId': churchId,
      'description': description,
      'installments': installments.map((e) => e.toJson()).toList(),
    };
  }
}
