import 'package:lucid_validation/lucid_validation.dart';

import '../state/credit_purchase_register_state.dart';

class CreditPurchaseRegisterValidator
    extends LucidValidator<CreditPurchaseRegisterState> {
  final String costCenterRequired;
  final String purchaseDateRequired;
  final String totalRequired;
  final String itemsRequired;

  CreditPurchaseRegisterValidator({
    required this.costCenterRequired,
    required this.purchaseDateRequired,
    required this.totalRequired,
    required this.itemsRequired,
  }) {
    ruleFor((m) => m.costCenterId, key: 'costCenterId')
        .notEmpty(message: costCenterRequired);
    ruleFor((m) => m.purchaseDate, key: 'purchaseDate')
        .notEmpty(message: purchaseDateRequired);
    ruleFor((m) => m, key: 'total').must(
      (state) => state.total > 0,
      totalRequired,
      'total_required',
    );
    ruleFor((m) => m, key: 'items').must(
      (state) => state.items.isNotEmpty,
      itemsRequired,
      'items_required',
    );
  }

  Map<String, String> validateState(CreditPurchaseRegisterState state) {
    final errors = <String, String>{};

    if (state.costCenterId.isEmpty) {
      errors['costCenterId'] = costCenterRequired;
    }

    if (state.purchaseDate.isEmpty) {
      errors['purchaseDate'] = purchaseDateRequired;
    }

    if (state.total <= 0) {
      errors['total'] = totalRequired;
    }

    if (state.items.isEmpty) {
      errors['items'] = itemsRequired;
    }

    return errors;
  }

  String? errorByKey(CreditPurchaseRegisterState state, String key) {
    final errors = validateState(state);
    return errors[key];
  }
}
