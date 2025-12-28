class PurchaseListModel {
  final String purchaseId;
  final String description;
  final List<PurchaseItemModel> items;
  final String purchaseDate;
  final double total;
  final double tax;
  final String invoice;

  PurchaseListModel({
    required this.invoice,
    required this.purchaseId,
    required this.description,
    required this.items,
    required this.purchaseDate,
    required this.total,
    required this.tax,
  });

  factory PurchaseListModel.fromJson(Map<String, dynamic> json) {
    return PurchaseListModel(
      invoice: json['invoice'],
      purchaseId: json['purchaseId'],
      description: json['description'],
      items: (json['items'] as List)
          .map((item) => PurchaseItemModel.fromJson(item))
          .toList(),
      purchaseDate: json['purchaseDate'],
      total: _toDouble(json['total']),
      tax: _toDouble(json['tax']),
    );
  }
}

class PurchaseItemModel {
  double price;
  int quantity;
  double total;
  String name;

  PurchaseItemModel({
    required this.price,
    required this.quantity,
    required this.total,
    required this.name,
  });

  factory PurchaseItemModel.fromJson(Map<String, dynamic> json) {
    return PurchaseItemModel(
      price: _toDouble(json['price']),
      quantity: _toInt(json['quantity']),
      total: _toDouble(json['total']),
      name: json['name'],
    );
  }
}

double _toDouble(dynamic value) {
  if (value is num) return value.toDouble();
  return double.parse(value.toString());
}

int _toInt(dynamic value) {
  if (value is num) return value.toInt();
  return int.parse(value.toString());
}
