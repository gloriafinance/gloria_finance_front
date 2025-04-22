import 'package:church_finance_bk/finance/accounts_payable/models/accounts_payable_model.dart';
import 'package:church_finance_bk/helpers/index.dart';

class FormAccountsPayableState {
  bool makeRequest;
  String supplierId;
  String supplierName; // Para mostrar en la UI
  String description;
  List<InstallmentModel> installments;

  FormAccountsPayableState({
    required this.makeRequest,
    required this.supplierId,
    required this.supplierName,
    required this.description,
    required this.installments,
  });

  factory FormAccountsPayableState.init() {
    return FormAccountsPayableState(
      makeRequest: false,
      supplierId: '',
      supplierName: '',
      description: '',
      installments: [],
    );
  }

  FormAccountsPayableState copyWith({
    bool? makeRequest,
    String? supplierId,
    String? supplierName,
    String? description,
    List<InstallmentModel>? installments,
  }) {
    return FormAccountsPayableState(
      makeRequest: makeRequest ?? this.makeRequest,
      supplierId: supplierId ?? this.supplierId,
      supplierName: supplierName ?? this.supplierName,
      description: description ?? this.description,
      installments: installments ?? this.installments,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'supplierId': supplierId,
      'description': description,
      'installments': installments
          .map((e) => {
                'amount': e.amount,
                'dueDate': convertDateFormat(e.dueDate),
              })
          .toList(),
    };
  }

  bool get isValid {
    return supplierId.isNotEmpty &&
        description.isNotEmpty &&
        installments.isNotEmpty;
  }
}
