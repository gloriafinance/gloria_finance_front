import '../../../../models/installment_model.dart';
import '../../../models/index.dart';

class FormAccountsReceivableState {
  bool makeRequest;
  DebtorType debtorType;
  AccountsReceivableType type;
  String debtorDNI;
  String debtorName;
  String description;
  String debtorPhone;
  String debtorEmail;
  String debtorAddress;
  String churchId;
  List<InstallmentModel> installments;

  FormAccountsReceivableState({
    required this.makeRequest,
    required this.debtorType,
    required this.type,
    required this.debtorDNI,
    required this.debtorName,
    required this.description,
    required this.churchId,
    required this.installments,
    required this.debtorPhone,
    required this.debtorEmail,
    required this.debtorAddress
  });

  factory FormAccountsReceivableState.init() {
    return FormAccountsReceivableState(
      makeRequest: false,
      debtorType: DebtorType.MEMBER,
      type: AccountsReceivableType.CONTRIBUTION,
      debtorDNI: '',
      debtorName: '',
      description: '',
      churchId: '',
      installments: [],
      debtorPhone: '',
      debtorEmail: '',
      debtorAddress: '',
    );
  }

  FormAccountsReceivableState copyWith({
    bool? makeRequest,
    DebtorType? debtorType,
    AccountsReceivableType? type,
    String? debtorDNI,
    String? debtorName,
    String? description,
    String? churchId,
    List<InstallmentModel>? installments,
    String? debtorPhone,
    String? debtorEmail,
    String? debtorAddress,
  }) {
    return FormAccountsReceivableState(
      makeRequest: makeRequest ?? this.makeRequest,
      debtorType: debtorType ?? this.debtorType,
      type: type ?? this.type,
      debtorDNI: debtorDNI ?? this.debtorDNI,
      debtorName: debtorName ?? this.debtorName,
      description: description ?? this.description,
      churchId: churchId ?? this.churchId,
      installments: installments ?? this.installments,
      debtorPhone: debtorPhone ?? this.debtorPhone,
      debtorEmail: debtorEmail ?? this.debtorEmail,
      debtorAddress: debtorAddress ?? this.debtorAddress,
    );
  }

  toJson() {
    return {
      'debtor': {
        'debtorType': debtorType.apiValue,
        'debtorDNI': debtorDNI,
        'name': debtorName,
        'phone': debtorPhone,
        'email': debtorEmail,
        'address': debtorAddress,
      },
      'churchId': churchId,
      'description': description,
      'installments': installments.map((e) => e.toJson()).toList(),
      'type': type.apiValue,
    };
  }
}
