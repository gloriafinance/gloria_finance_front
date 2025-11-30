import 'package:lucid_validation/lucid_validation.dart';

import '../store/add_item_purchase_from_store.dart';

class AddItemPurchaseValidator
    extends LucidValidator<AddItemPurchaseFromStore> {
  AddItemPurchaseValidator() {
    ruleFor((m) => m.product, key: 'product')
        .notEmpty(message: 'Nome do produto é obrigatório');

    ruleFor((m) => m.priceUnit, key: 'priceUnit')
        .greaterThan(0, message: 'Informe o valor');

    ruleFor((m) => m.quantity, key: 'quantity')
        .greaterThan(0, message: 'Informe o valor');

    ruleFor((m) => m.total, key: 'total')
        .greaterThan(0, message: 'Informe o valor');
  }
}
