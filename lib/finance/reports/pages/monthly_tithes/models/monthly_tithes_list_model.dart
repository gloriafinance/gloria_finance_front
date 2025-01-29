class MonthlyTithesModel {
  final double amount;
  final DateTime date;
  final String accountName;
  final String accountType;

  MonthlyTithesModel({
    required this.amount,
    required this.date,
    required this.accountName,
    required this.accountType,
  });

  factory MonthlyTithesModel.fromJson(Map<String, dynamic> json) {
    return MonthlyTithesModel(
      amount: double.parse(json['amount'].toString()),
      date: DateTime.parse(json['date']),
      accountName: json['availabilityAccountName'],
      accountType: json['availabilityAccountType'],
    );
  }
}

class MonthlyTithesListModel {
  final List<MonthlyTithesModel> results;
  final double total;
  final double tithesOfTithes;

  MonthlyTithesListModel({
    required this.results,
    required this.total,
    required this.tithesOfTithes,
  });

  factory MonthlyTithesListModel.fromJson(Map<String, dynamic> json) {
    return MonthlyTithesListModel(
      results: List<MonthlyTithesModel>.from(
        json['records'].map((x) => MonthlyTithesModel.fromJson(x)),
      ),
      total: double.parse(json['total'].toString()),
      tithesOfTithes: double.parse(json['tithesOfTithes'].toString()),
    );
  }
}
