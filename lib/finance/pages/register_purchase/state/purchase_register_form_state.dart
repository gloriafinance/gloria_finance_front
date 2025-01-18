import 'package:dio/dio.dart';

class PurchaseRegisterFormState {
  bool makeRequest;
  String financialConceptId;
  String churchId;
  String purchaseDate;
  double total;
  double tax;
  String description;
  String financingSource;
  String? bankId;
  MultipartFile invoice;
  List<PurchaseItem> items;

  PurchaseRegisterFormState(
      {required this.churchId,
      required this.makeRequest,
      required this.total,
      required this.tax,
      required this.purchaseDate,
      required this.financialConceptId,
      required this.description,
      required this.financingSource,
      required this.invoice,
      required this.items,
      this.bankId});

  factory PurchaseRegisterFormState.init() {
    return PurchaseRegisterFormState(
        churchId: '',
        makeRequest: false,
        total: 0.0,
        tax: 0.0,
        purchaseDate: '',
        financialConceptId: '',
        description: '',
        financingSource: '',
        invoice: MultipartFile.fromString(''),
        items: [],
        bankId: '');
  }

  PurchaseRegisterFormState copyWith(
      {String? churchId,
      bool? makeRequest,
      double? total,
      double? subTotal,
      double? tax,
      String? financialConceptId,
      String? description,
      String? financingSource,
      MultipartFile? invoice,
      String? purchaseDate,
      String? invoiceNumber,
      List<PurchaseItem>? items,
      String? bankId}) {
    return PurchaseRegisterFormState(
      bankId: bankId ?? this.bankId,
      churchId: churchId ?? this.churchId,
      makeRequest: makeRequest ?? this.makeRequest,
      total: total ?? this.total,
      tax: tax ?? this.tax,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      financialConceptId: financialConceptId ?? this.financialConceptId,
      description: description ?? this.description,
      financingSource: financingSource ?? this.financingSource,
      invoice: invoice ?? this.invoice,
      items: items ?? this.items,
    );
  }

  PurchaseRegisterFormState addItem(PurchaseItem item) {
    return copyWith(items: [...items, item]);
  }

  Map<String, dynamic> toJson() {
    return {
      'churchId': churchId,
      'bankId': bankId,
      'total': total,
      'tax': tax,
      'purchaseDate': purchaseDate,
      'financialConceptId': financialConceptId,
      'description': description,
      'financingSource': financingSource,
      'invoice': invoice,
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
      'priceUnit': priceUnit,
      'quantity': quantity,
      'total': total,
      'productName': productName,
    };
  }
}
