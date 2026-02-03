class MonthlyTithesModel {
  final double amount;
  final DateTime date;
  final String accountName;
  final String accountType;
  final String symbol;

  MonthlyTithesModel({
    required this.amount,
    required this.date,
    required this.accountName,
    required this.accountType,
    required this.symbol,
  });

  factory MonthlyTithesModel.fromJson(Map<String, dynamic> json) {
    return MonthlyTithesModel(
      amount: double.parse(json['amount'].toString()),
      date: DateTime.parse(json['date']),
      accountName: json['availabilityAccountName'],
      accountType: json['availabilityAccountType'],
      symbol: (json['symbol'] ?? '').toString(),
    );
  }
}

class MonthlyTithesTotalBySymbol {
  final String symbol;
  final double total;

  MonthlyTithesTotalBySymbol({required this.symbol, required this.total});

  factory MonthlyTithesTotalBySymbol.fromJson(Map<String, dynamic> json) {
    return MonthlyTithesTotalBySymbol(
      symbol: (json['symbol'] ?? '').toString(),
      total: double.parse((json['total'] ?? 0).toString()),
    );
  }
}

class MonthlyTithesListModel {
  final List<MonthlyTithesModel> results;
  final List<MonthlyTithesTotalBySymbol> totals;

  MonthlyTithesListModel({required this.results, required this.totals});

  factory MonthlyTithesListModel.fromJson(Map<String, dynamic> json) {
    return MonthlyTithesListModel(
      results: List<MonthlyTithesModel>.from(
        (json['records'] ?? []).map((x) => MonthlyTithesModel.fromJson(x)),
      ),
      totals: List<MonthlyTithesTotalBySymbol>.from(
        (json['totals'] ?? []).map(
          (x) => MonthlyTithesTotalBySymbol.fromJson(x),
        ),
      ),
    );
  }

  List<MonthlyTithesTotalBySymbol> get totalsBySymbol {
    if (totals.isNotEmpty) {
      return totals;
    }

    final map = <String, double>{};
    for (final item in results) {
      map[item.symbol] = (map[item.symbol] ?? 0) + item.amount;
    }

    return map.entries
        .map(
          (entry) =>
              MonthlyTithesTotalBySymbol(symbol: entry.key, total: entry.value),
        )
        .toList();
  }

  Map<String, List<MonthlyTithesModel>> get recordsBySymbol {
    final grouped = <String, List<MonthlyTithesModel>>{};
    for (final item in results) {
      grouped.putIfAbsent(item.symbol, () => <MonthlyTithesModel>[]).add(item);
    }

    for (final entry in grouped.entries) {
      entry.value.sort((a, b) => a.date.compareTo(b.date));
    }

    return grouped;
  }

  List<String> get orderedSymbols {
    final fromTotals = [...totalsBySymbol]..sort((a, b) {
      final totalCompare = b.total.compareTo(a.total);
      if (totalCompare != 0) {
        return totalCompare;
      }
      return a.symbol.compareTo(b.symbol);
    });

    final symbols = fromTotals.map((item) => item.symbol).toList();
    final fromRecords =
        recordsBySymbol.keys.where((s) => !symbols.contains(s)).toList()
          ..sort();

    symbols.addAll(fromRecords);
    return symbols;
  }

  int get currencyCount => orderedSymbols.length;
}
