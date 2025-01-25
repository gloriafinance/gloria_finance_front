enum AccountType { BANK, CASH, WALLET, INVESTMENT }

extension AccountTypeExtension on AccountType {
  String get friendlyName {
    switch (this) {
      case AccountType.BANK:
        return 'Banco';
      case AccountType.CASH:
        return 'Dinheiro';
      case AccountType.WALLET:
        return 'Carteira Digital';
      case AccountType.INVESTMENT:
        return 'Investimento';
    }
  }

  String get apiValue {
    switch (this) {
      case AccountType.BANK:
        return 'BANK';
      case AccountType.CASH:
        return 'CASH';
      case AccountType.WALLET:
        return 'WALLET';
      case AccountType.INVESTMENT:
        return 'INVESTMENT';
    }
  }
}

class AvailabilityAccountModel {
  final String churchId;
  final String availabilityAccountId;
  final String accountName;
  final double balance;
  final bool active;
  final String accountType;

  AvailabilityAccountModel({
    required this.churchId,
    required this.availabilityAccountId,
    required this.accountName,
    required this.balance,
    required this.active,
    required this.accountType,
  });

  AvailabilityAccountModel.fromMap(Map<String, dynamic> map)
      : churchId = map['churchId'],
        availabilityAccountId = map['availabilityAccountId'],
        accountName = map['accountName'],
        balance = double.parse(map['balance'].toString()),
        active = map['active'],
        accountType = map['accountType'];

  Map<String, dynamic> toJson() => {
        'churchId': churchId,
        'availabilityAccountId': availabilityAccountId,
        'accountName': accountName,
        'balance': balance,
        'active': active,
        'accountType': accountType,
      };
}
