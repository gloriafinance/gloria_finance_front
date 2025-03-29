class AvailabilityAccountItem {
  final String availabilityAccountId;
  final String accountName;
  final String symbol;

  AvailabilityAccountItem(
      {required this.availabilityAccountId,
      required this.accountName,
      required this.symbol});

  factory AvailabilityAccountItem.fromJson(Map<String, dynamic> json) {
    return AvailabilityAccountItem(
      availabilityAccountId: json['availabilityAccountId'],
      accountName: json['accountName'],
      symbol: json['symbol'],
    );
  }
}

class AccountMaster {
  final int month;
  final int year;
  final double totalOutput;
  final double totalInput;
  final AvailabilityAccountItem availabilityAccount;
  final String availabilityAccountMasterId;
  final String churchId;

  AccountMaster({
    required this.month,
    required this.year,
    required this.totalOutput,
    required this.totalInput,
    required this.availabilityAccount,
    required this.availabilityAccountMasterId,
    required this.churchId,
  });

  factory AccountMaster.fromJson(Map<String, dynamic> json) {
    return AccountMaster(
      month: json['month'],
      year: json['year'],
      totalOutput: json['totalOutput'].toDouble(),
      totalInput: json['totalInput'].toDouble(),
      availabilityAccount:
          AvailabilityAccountItem.fromJson(json['availabilityAccount']),
      availabilityAccountMasterId: json['availabilityAccountMasterId'],
      churchId: json['churchId'],
    );
  }

  double getBalance() {
    return totalInput - totalOutput;
  }
}

class CostCenterItem {
  final String costCenterId;
  final String costCenterName;

  CostCenterItem({
    required this.costCenterId,
    required this.costCenterName,
  });

  factory CostCenterItem.fromJson(Map<String, dynamic> json) {
    return CostCenterItem(
      costCenterId: json['costCenterId'],
      costCenterName: json['costCenterName'],
    );
  }
}

class CostCenterMaster {
  final String id;
  final int month;
  final int year;
  final double total;
  final CostCenterItem costCenter;
  final String churchId;
  final DateTime lastMove;

  CostCenterMaster({
    required this.id,
    required this.month,
    required this.year,
    required this.total,
    required this.costCenter,
    required this.churchId,
    required this.lastMove,
  });

  factory CostCenterMaster.fromJson(Map<String, dynamic> json) {
    return CostCenterMaster(
      id: json['id'],
      month: json['month'],
      year: json['year'],
      total: json['total'].toDouble(),
      costCenter: CostCenterItem.fromJson(json['costCenter']),
      churchId: json['churchId'],
      lastMove: DateTime.parse(json['lastMove']),
    );
  }

  double getTotal() {
    return total;
  }
}

class IncomeStatementModel {
  final double result;
  final Assets assets;
  final Liabilities liabilities;

  IncomeStatementModel({
    required this.result,
    required this.assets,
    required this.liabilities,
  });

  factory IncomeStatementModel.fromJson(Map<String, dynamic> json) {
    return IncomeStatementModel(
      result: json['result'].toDouble(),
      assets: Assets.fromJson(json['assets']),
      liabilities: Liabilities.fromJson(json['liabilities']),
    );
  }

  factory IncomeStatementModel.empty() {
    return IncomeStatementModel(
      result: 0.0,
      assets: Assets(accounts: [], total: 0.0),
      liabilities: Liabilities(costCenters: [], total: 0.0),
    );
  }
}

class Assets {
  final List<AccountMaster> accounts;
  final double total;

  Assets({
    required this.accounts,
    required this.total,
  });

  factory Assets.fromJson(Map<String, dynamic> json) {
    return Assets(
      accounts: (json['accounts'] as List)
          .map((account) => AccountMaster.fromJson(account))
          .toList(),
      total: json['total'].toDouble(),
    );
  }
}

class Liabilities {
  final List<CostCenterMaster> costCenters;
  final double total;

  Liabilities({
    required this.costCenters,
    required this.total,
  });

  factory Liabilities.fromJson(Map<String, dynamic> json) {
    return Liabilities(
      costCenters: (json['costCenters'] as List)
          .map((costCenter) => CostCenterMaster.fromJson(costCenter))
          .toList(),
      total: json['total'].toDouble(),
    );
  }
}
