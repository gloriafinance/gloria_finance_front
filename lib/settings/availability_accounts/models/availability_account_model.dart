import '../../banks/models/bank_model.dart';

enum AccountType { BANK, CASH, WALLET }

extension AccountTypeExtension on AccountType {
  String get friendlyName {
    switch (this) {
      case AccountType.BANK:
        return 'Banco';
      case AccountType.CASH:
        return 'Dinheiro';
      case AccountType.WALLET:
        return 'Carteira Digital';
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
  final dynamic source;
  final String symbol;

  AvailabilityAccountModel(
      {required this.churchId,
      required this.availabilityAccountId,
      required this.accountName,
      required this.balance,
      required this.active,
      required this.accountType,
      required this.source,
      required this.symbol});

  AvailabilityAccountModel.fromMap(Map<String, dynamic> map)
      : churchId = map['churchId'],
        availabilityAccountId = map['availabilityAccountId'],
        accountName = map['accountName'],
        balance = double.parse(map['balance'].toString()),
        active = map['active'],
        accountType = map['accountType'],
        source = map['source'],
        symbol = map['symbol'];

  Map<String, dynamic> toJson() => {
        'churchId': churchId,
        'availabilityAccountId': availabilityAccountId,
        'accountName': accountName,
        'balance': balance,
        'active': active,
        'accountType': accountType,
        'source': source,
        'symbol': symbol,
      };

  dynamic getSource() {
    if (AccountType.BANK.apiValue == accountType) {
      return BankModel.fromJson(source);
    }

    return null;

    // if (AccountType.WALLET.apiValue == accountType) {
    //   return WalletModel.fromMap(source);
    // }
    //
    // if (AccountType.INVESTMENT.apiValue == accountType) {
    //   return InvestmentModel.fromMap(source);
    // }
  }
}
