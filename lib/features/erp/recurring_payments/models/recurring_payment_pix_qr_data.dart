/// Amount decoded by Gloria Finance API from an Asaas PIX QR payload.
class RecurringPaymentPixQrData {
  const RecurringPaymentPixQrData({required this.amountInCents});

  final int amountInCents;

  factory RecurringPaymentPixQrData.fromJson(Map<String, dynamic> json) {
    return RecurringPaymentPixQrData(
      amountInCents: (json['amountInCents'] as num).toInt(),
    );
  }
}
