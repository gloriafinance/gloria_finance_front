/// Payment modes accepted by the Accounts Payable backend contract.
enum AccountsPayablePaymentMode {
  single('SINGLE', 'Pagamento único'),
  manual('MANUAL_INSTALLMENTS', 'Parcelas manuais'),
  automatic('AUTOMATIC_INSTALLMENTS', 'Parcelas automáticas');

  const AccountsPayablePaymentMode(this.apiValue, this.friendlyName);

  final String apiValue;
  final String friendlyName;

  static AccountsPayablePaymentMode? fromApi(String? value) {
    if (value == null) return null;
    for (final mode in AccountsPayablePaymentMode.values) {
      if (mode.apiValue == value) {
        return mode;
      }
    }
    return null;
  }
}

/// Supported document kinds for attaching metadata to an account payable.
enum AccountsPayableDocumentType {
  invoice('INVOICE', 'Nota fiscal'),
  receipt('RECEIPT', 'Recibo'),
  contract('CONTRACT', 'Contrato'),
  other('OTHER', 'Outro documento');

  const AccountsPayableDocumentType(this.apiValue, this.friendlyName);

  final String apiValue;
  final String friendlyName;

  static AccountsPayableDocumentType fromApi(String? value) {
    if (value == null) {
      return AccountsPayableDocumentType.other;
    }

    for (final type in AccountsPayableDocumentType.values) {
      if (type.apiValue == value) {
        return type;
      }
    }
    return AccountsPayableDocumentType.other;
  }
}

/// Status used to classify tax situations for accounts payable documents.
enum AccountsPayableTaxStatus {
  exempt('EXEMPT', 'Isenta'),
  taxed('TAXED', 'Tributada'),
  substitution('SUBSTITUTION', 'Substituição tributária'),
  notApplicable('NOT_APPLICABLE', 'Sem nota fiscal');

  const AccountsPayableTaxStatus(this.apiValue, this.friendlyName);

  final String apiValue;
  final String friendlyName;

  static AccountsPayableTaxStatus? fromApi(String? value) {
    if (value == null) return null;
    for (final status in AccountsPayableTaxStatus.values) {
      if (status.apiValue == value) {
        return status;
      }
    }
    return null;
  }
}
