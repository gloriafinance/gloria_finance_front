import 'package:dio/dio.dart';

class PaymentDeclarationModel {
  final String accountReceivableId;
  final String installmentId;
  final String availabilityAccountId;
  final double amount;
  final MultipartFile? voucher;
  final String? memberId;

  PaymentDeclarationModel({
    required this.accountReceivableId,
    required this.installmentId,
    required this.availabilityAccountId,
    required this.amount,
    this.voucher,
    this.memberId,
  });

  FormData toFormData() {
    return FormData.fromMap({
      'accountReceivableId': accountReceivableId,
      'installmentId': installmentId,
      'availabilityAccountId': availabilityAccountId,
      'amount': amount,
      if (memberId != null) 'memberId': memberId,
      if (voucher != null) 'voucher': voucher,
    });
  }
}
