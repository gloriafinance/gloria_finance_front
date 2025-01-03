enum AccountBankType { CURRENT, SAVINGS, PAYMENT, SALARY }

extension AccountBankTypeExtension on AccountBankType {
  String get name {
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
  String accountType;
  bool active;
  String bankId;
  String name;
  String tag;
  String addressInstancePayment;
  BankInstruction bankInstruction;
  String churchId;

  BankModel({
    required this.accountType,
    required this.active,
    required this.bankId,
    required this.name,
    required this.tag,
    required this.addressInstancePayment,
    required this.bankInstruction,
    required this.churchId,
  });

  BankModel.fromJson(Map<String, dynamic> json)
      : accountType = json['accountType'],
        active = json['active'],
        bankId = json['bankId'],
        name = json['name'],
        tag = json['tag'],
        addressInstancePayment = json['addressInstancePayment'],
        bankInstruction = BankInstruction.fromJson(json['bankInstruction']),
        churchId = json['churchId'];

  Map<String, dynamic> toJson() => {
        'accountType': accountType,
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
  String codeBank;
  String agency;
  String account;

  BankInstruction({
    required this.codeBank,
    required this.agency,
    required this.account,
  });

  BankInstruction.fromJson(Map<String, dynamic> json)
      : codeBank = json['codeBank'],
        agency = json['agency'],
        account = json['account'];

  Map<String, dynamic> toJson() => {
        'codeBank': codeBank,
        'agency': agency,
        'account': account,
      };
}
