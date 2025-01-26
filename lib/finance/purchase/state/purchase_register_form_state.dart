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
  String availabilityAccountId;
  String? bankId;
  MultipartFile invoice;
  List<PurchaseItem> items;
  bool isMovementBank = false;
  String costCenterId;

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
      required this.availabilityAccountId,
      required this.isMovementBank,
      required this.costCenterId,
      this.bankId});

  factory PurchaseRegisterFormState.init() {
    return PurchaseRegisterFormState(
        costCenterId: '',
        isMovementBank: false,
        availabilityAccountId: '',
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
      {bool? isMovementBank,
      String? costCenterId,
      String? churchId,
      String? availabilityAccountId,
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
      costCenterId: costCenterId ?? this.costCenterId,
      isMovementBank: isMovementBank ?? this.isMovementBank,
      availabilityAccountId:
          availabilityAccountId ?? this.availabilityAccountId,
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
      'costCenterId': costCenterId,
      'churchId': churchId,
      'bankId': bankId,
      'total': total,
      'tax': tax,
      'purchaseDate': purchaseDate,
      'financialConceptId': financialConceptId,
      'description': description,
      'financingSource': financingSource,
      'invoice': invoice,
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
      'priceUnit': priceUnit,
      'quantity': quantity,
      'total': total,
      'productName': productName,
    };
  }
}
