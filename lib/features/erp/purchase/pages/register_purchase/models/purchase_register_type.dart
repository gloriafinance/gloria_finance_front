enum PurchaseRegisterType {
  cash('cash', 'Compra al contado'),
  credit('credit', 'Compra a credito');

  const PurchaseRegisterType(this.apiValue, this.label);

  final String apiValue;
  final String label;
}
