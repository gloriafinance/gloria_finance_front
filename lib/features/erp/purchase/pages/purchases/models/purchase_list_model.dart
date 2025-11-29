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
      total: double.parse(json['total']),
      tax: double.parse(json['tax']),
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
      price: double.parse(json['price']),
      quantity: int.parse(json['quantity']),
      total: double.parse(json['total']),
      name: json['name'],
    );
  }
}
