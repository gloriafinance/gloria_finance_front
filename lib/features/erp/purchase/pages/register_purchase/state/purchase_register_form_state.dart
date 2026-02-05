import 'package:gloria_finance/core/utils/index.dart';
import 'package:dio/dio.dart';

class PurchaseRegisterFormState {
  bool makeRequest;
  String financialConceptId;
  String purchaseDate;
  double total;
  double tax;
  String description;
  String availabilityAccountId;
  List<MultipartFile> files;
  List<PurchaseItem> items;
  bool isMovementBank = false;
  String costCenterId;
  String symbol;

  PurchaseRegisterFormState({
    required this.makeRequest,
    required this.total,
    required this.tax,
    required this.purchaseDate,
    required this.financialConceptId,
    required this.description,
    required this.files,
    required this.items,
    required this.availabilityAccountId,
    required this.isMovementBank,
    required this.costCenterId,
    required this.symbol,
  });

  factory PurchaseRegisterFormState.init() {
    return PurchaseRegisterFormState(
      costCenterId: '',
      isMovementBank: false,
      availabilityAccountId: '',
      makeRequest: false,
      total: 0.0,
      tax: 0.0,
      purchaseDate: '',
      financialConceptId: '',
      description: '',
      files: [],
      items: [],
      symbol: '',
    );
  }

  PurchaseRegisterFormState copyWith({
    bool? isMovementBank,
    String? costCenterId,
    String? availabilityAccountId,
    bool? makeRequest,
    double? total,
    double? subTotal,
    double? tax,
    String? financialConceptId,
    String? description,
    String? financingSource,
    List<MultipartFile>? files,
    String? purchaseDate,
    String? invoiceNumber,
    List<PurchaseItem>? items,
    String? symbol,
    String? bankId,
  }) {
    return PurchaseRegisterFormState(
      costCenterId: costCenterId ?? this.costCenterId,
      isMovementBank: isMovementBank ?? this.isMovementBank,
      availabilityAccountId:
          availabilityAccountId ?? this.availabilityAccountId,
      makeRequest: makeRequest ?? this.makeRequest,
      total: total ?? this.total,
      tax: tax ?? this.tax,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      financialConceptId: financialConceptId ?? this.financialConceptId,
      description: description ?? this.description,
      files: files ?? this.files,
      items: items ?? this.items,
      symbol: symbol ?? this.symbol,
    );
  }

  PurchaseRegisterFormState addItem(PurchaseItem item) {
    return copyWith(items: [...items, item]);
  }

  Map<String, dynamic> toJson() {
    return {
      'costCenterId': costCenterId,
      'total': total,
      'tax': tax,
      'purchaseDate': convertDateFormat(purchaseDate),
      'financialConceptId': financialConceptId,
      'description': description,
      if (files.isNotEmpty) 'file': files,
      'availabilityAccountId': availabilityAccountId,
      'items': items.map((e) => e.toJson()).toList(),
    };
  }
}

class PurchaseItem {
  double priceUnit;
  int quantity;
  double total;
  String productName;

  PurchaseItem({
    required this.priceUnit,
    required this.quantity,
    required this.total,
    required this.productName,
  });

  factory PurchaseItem.fromJson(Map<String, dynamic> json) {
    return PurchaseItem(
      priceUnit: json['priceUnit'],
      quantity: json['quantity'],
      total: json['total'],
      productName: json['productName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'price': priceUnit,
      'quantity': quantity,
      'total': total,
      'name': productName,
    };
  }
}
