import '../../../models/bank_model.dart';

enum BankInstructionType { brazil, venezuela }

class BankFormState {
  final bool makeRequest;
  final String bankId;
  final BankInstructionType instructionType;
  final String name;
  final String tag;
  final AccountBankType? accountType;
  final bool active;
  final String addressInstancePayment;
  final String codeBank;
  final String agency;
  final String account;
  final String holderName;
  final String documentId;
  final String accountNumber;

  const BankFormState({
    required this.makeRequest,
    required this.bankId,
    required this.instructionType,
    required this.name,
    required this.tag,
    required this.accountType,
    required this.active,
    required this.addressInstancePayment,
    required this.codeBank,
    required this.agency,
    required this.account,
    required this.holderName,
    required this.documentId,
    required this.accountNumber,
  });

  static String _defaultPayment(BankInstructionType instructionType) {
    return instructionType == BankInstructionType.venezuela
        ? 'PAGO_MOVIL'
        : 'PIX';
  }

  factory BankFormState.init({
    required BankInstructionType instructionType,
  }) {
    return BankFormState(
      makeRequest: false,
      bankId: '',
      instructionType: instructionType,
      name: '',
      tag: '',
      accountType: null,
      active: true,
      addressInstancePayment: _defaultPayment(instructionType),
      codeBank: '',
      agency: '',
      account: '',
      holderName: '',
      documentId: '',
      accountNumber: '',
    );
  }

  factory BankFormState.fromModel(
    BankModel model, {
    required BankInstructionType instructionType,
  }) {
    final addressInstancePayment =
        model.addressInstancePayment.isNotEmpty
            ? model.addressInstancePayment
            : _defaultPayment(instructionType);
    return BankFormState(
      makeRequest: false,
      bankId: model.bankId,
      instructionType: instructionType,
      name: model.name,
      tag: model.tag,
      accountType: model.accountType,
      active: model.active,
      addressInstancePayment: addressInstancePayment,
      codeBank:
          instructionType == BankInstructionType.brazil
              ? model.bankInstruction.codeBank
              : '',
      agency:
          instructionType == BankInstructionType.brazil
              ? model.bankInstruction.agency
              : '',
      account:
          instructionType == BankInstructionType.brazil
              ? model.bankInstruction.account
              : '',
      holderName:
          instructionType == BankInstructionType.venezuela
              ? model.bankInstruction.codeBank
              : '',
      documentId:
          instructionType == BankInstructionType.venezuela
              ? model.bankInstruction.agency
              : '',
      accountNumber:
          instructionType == BankInstructionType.venezuela
              ? model.bankInstruction.account
              : '',
    );
  }

  BankFormState copyWith({
    bool? makeRequest,
    String? bankId,
    BankInstructionType? instructionType,
    String? name,
    String? tag,
    AccountBankType? accountType,
    bool? active,
    String? addressInstancePayment,
    String? codeBank,
    String? agency,
    String? account,
    String? holderName,
    String? documentId,
    String? accountNumber,
  }) {
    return BankFormState(
      makeRequest: makeRequest ?? this.makeRequest,
      bankId: bankId ?? this.bankId,
      instructionType: instructionType ?? this.instructionType,
      name: name ?? this.name,
      tag: tag ?? this.tag,
      accountType: accountType ?? this.accountType,
      active: active ?? this.active,
      addressInstancePayment:
          addressInstancePayment ?? this.addressInstancePayment,
      codeBank: codeBank ?? this.codeBank,
      agency: agency ?? this.agency,
      account: account ?? this.account,
      holderName: holderName ?? this.holderName,
      documentId: documentId ?? this.documentId,
      accountNumber: accountNumber ?? this.accountNumber,
    );
  }

  bool get isEdit => bankId.isNotEmpty;

  Map<String, dynamic> toPayload(String churchId) {
    final bankInstruction =
        instructionType == BankInstructionType.venezuela
            ? BankInstructionVenezuela(
              holderName: holderName,
              dni: documentId,
              accountNumber: accountNumber,
            ).toJson()
            : {
              'codeBank': codeBank,
              'agency': agency,
              'account': account,
            };
    final addressInstancePaymentPayload =
        instructionType == BankInstructionType.venezuela
            ? 'PAGO_MOVIL'
            : addressInstancePayment;
    final payload = {
      'active': active,
      'name': name,
      'tag': tag,
      'addressInstancePayment': addressInstancePaymentPayload,
      'bankInstruction': bankInstruction,
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
