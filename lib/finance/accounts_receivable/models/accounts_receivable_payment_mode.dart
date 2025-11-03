enum AccountsReceivablePaymentMode {
  single,
  automatic,
}

extension AccountsReceivablePaymentModeExtension
    on AccountsReceivablePaymentMode {
  String get friendlyName {
    switch (this) {
      case AccountsReceivablePaymentMode.single:
        return 'Pagamento único';
      case AccountsReceivablePaymentMode.automatic:
        return 'Parcelas automáticas';
    }
  }
}
