import '../../../models/bank_model.dart';

class BankFormState {
  final bool makeRequest;
  final String bankId;
  final String name;
  final String tag;
  final AccountBankType? accountType;
  final bool active;
  final String addressInstancePayment;
  final String codeBank;
  final String agency;
  final String account;

  const BankFormState({
    required this.makeRequest,
    required this.bankId,
    required this.name,
    required this.tag,
    required this.accountType,
    required this.active,
    required this.addressInstancePayment,
    required this.codeBank,
    required this.agency,
    required this.account,
  });

  factory BankFormState.init() {
    return const BankFormState(
      makeRequest: false,
      bankId: '',
      name: '',
      tag: '',
      accountType: null,
      active: true,
      addressInstancePayment: 'PIX',
      codeBank: '',
      agency: '',
      account: '',
    );
  }

  factory BankFormState.fromModel(BankModel model) {
    return BankFormState(
      makeRequest: false,
      bankId: model.bankId,
      name: model.name,
      tag: model.tag,
      accountType: model.accountType,
      active: model.active,
      addressInstancePayment: model.addressInstancePayment,
      codeBank: model.bankInstruction.codeBank,
      agency: model.bankInstruction.agency,
      account: model.bankInstruction.account,
    );
  }

  BankFormState copyWith({
    bool? makeRequest,
    String? bankId,
    String? name,
    String? tag,
    AccountBankType? accountType,
    bool? active,
    String? addressInstancePayment,
    String? codeBank,
    String? agency,
    String? account,
  }) {
    return BankFormState(
      makeRequest: makeRequest ?? this.makeRequest,
      bankId: bankId ?? this.bankId,
      name: name ?? this.name,
      tag: tag ?? this.tag,
      accountType: accountType ?? this.accountType,
      active: active ?? this.active,
      addressInstancePayment:
          addressInstancePayment ?? this.addressInstancePayment,
      codeBank: codeBank ?? this.codeBank,
      agency: agency ?? this.agency,
      account: account ?? this.account,
    );
  }

  bool get isEdit => bankId.isNotEmpty;

  Map<String, dynamic> toPayload(String churchId) {
    final payload = {
      'active': active,
      'name': name,
      'tag': tag,
      'addressInstancePayment': addressInstancePayment,
      'bankInstruction': {
        'codeBank': codeBank,
        'agency': agency,
        'account': account,
      },
      'churchId': churchId,
    };

    if (isEdit) {
      payload['bankId'] = bankId;
    }

    if (accountType != null) {
      payload['accountType'] = accountType!.apiValue;
    }

    return payload;
  }
}
