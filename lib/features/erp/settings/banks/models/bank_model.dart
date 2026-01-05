enum AccountBankType { CURRENT, SAVINGS, PAYMENT, SALARY }

extension AccountBankTypeExtension on AccountBankType {
  static AccountBankType fromApiValue(String value) {
    return AccountBankType.values.firstWhere(
      (element) => element.apiValue == value,
      orElse: () => AccountBankType.CURRENT,
    );
  }

  String get apiValue {
    return toString().split('.').last;
  }

  String get friendlyName {
    switch (this) {
      case AccountBankType.CURRENT:
        return 'Conta Corrente';
      case AccountBankType.SAVINGS:
        return 'Conta Poupança';
      case AccountBankType.PAYMENT:
        return 'Conta Pagamento';
      case AccountBankType.SALARY:
        return 'Conta Salário';
    }
  }
}

class BankModel {
  final String? id;
  final AccountBankType accountType;
  final bool active;
  final String bankId;
  final String name;
  final String tag;
  final String addressInstancePayment;
  final BankInstruction bankInstruction;
  final String churchId;

  BankModel({
    this.id,
    required this.accountType,
    required this.active,
    required this.bankId,
    required this.name,
    required this.tag,
    required this.addressInstancePayment,
    required this.bankInstruction,
    required this.churchId,
  });

  factory BankModel.fromJson(Map<String, dynamic> json) {
    final rawInstruction = json['bankInstruction'];
    final hasBrazilInstruction =
        rawInstruction is Map<String, dynamic> &&
        (rawInstruction['codeBank'] != null ||
            rawInstruction['agency'] != null ||
            rawInstruction['account'] != null);
    final hasVenezuelaInstruction =
        rawInstruction is Map<String, dynamic> &&
        (rawInstruction['name'] != null ||
            rawInstruction['dni'] != null ||
            rawInstruction['accountNumber'] != null);

    return BankModel(
      id: json['id'],
      accountType:
          AccountBankTypeExtension.fromApiValue(json['accountType'] ?? ''),
      active: json['active'] ?? false,
      bankId: json['bankId'] ?? '',
      name: json['name'] ?? '',
      tag: json['tag'] ?? '',
      addressInstancePayment: json['addressInstancePayment'] ?? '',
      bankInstruction:
          hasBrazilInstruction
              ? BankInstruction.fromJson(rawInstruction)
              : hasVenezuelaInstruction
              ? BankInstruction(
                codeBank: rawInstruction['name'] ?? '',
                agency: rawInstruction['dni'] ?? '',
                account: rawInstruction['accountNumber'] ?? '',
              )
              : const BankInstruction(codeBank: '', agency: '', account: ''),
      churchId: json['churchId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'accountType': accountType.apiValue,
        'active': active,
        'bankId': bankId,
        'name': name,
        'tag': tag,
        'addressInstancePayment': addressInstancePayment,
        'bankInstruction': bankInstruction.toJson(),
        'churchId': churchId,
      };
}

class BankInstruction {
  final String codeBank;
  final String agency;
  final String account;

  const BankInstruction({
    required this.codeBank,
    required this.agency,
    required this.account,
  });

  factory BankInstruction.fromJson(Map<String, dynamic> json) {
    return BankInstruction(
      codeBank: json['codeBank'] ?? '',
      agency: json['agency'] ?? '',
      account: json['account'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'codeBank': codeBank,
        'agency': agency,
        'account': account,
      };
}

class BankInstructionVenezuela {
  final String holderName;
  final String dni;
  final String accountNumber;

  const BankInstructionVenezuela({
    required this.holderName,
    required this.dni,
    required this.accountNumber,
  });

  factory BankInstructionVenezuela.fromJson(Map<String, dynamic> json) {
    return BankInstructionVenezuela(
      holderName: json['holderName'] ?? json['name'] ?? '',
      dni: json['dni'] ?? json['documentId'] ?? '',
      accountNumber: json['accountNumber'] ?? json['account'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'name': holderName,
        'dni': dni,
        'accountNumber': accountNumber,
      };
}
