enum RecurringPaymentSourceCapability { manual, asaas }

/// Presentation-only payment source selected for this execution.
class RecurringPaymentSourceUiModel {
  const RecurringPaymentSourceUiModel({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.capability,
    this.availabilityAccountId,
    this.requiresVoucher = false,
  });

  final String id;
  final String name;
  final String subtitle;
  final RecurringPaymentSourceCapability capability;
  final String? availabilityAccountId;
  final bool requiresVoucher;

  bool get isAsaas => capability == RecurringPaymentSourceCapability.asaas;
}
