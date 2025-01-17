import 'package:church_finance_bk/finance/pages/register_purchase/store/add_item_purchase_from_store.dart';
import 'package:lucid_validation/lucid_validation.dart';

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
