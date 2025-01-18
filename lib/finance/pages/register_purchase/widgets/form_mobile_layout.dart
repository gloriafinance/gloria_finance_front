import 'package:flutter/material.dart';

import '../../../stores/bank_store.dart';
import '../../../stores/financial_concept_store.dart';
import '../store/purchase_register_form_store.dart';
import 'form_inputs.dart';

Widget formMobileLayout(BuildContext context, BankStore bankStore,
    FinancialConceptStore conceptStore, PurchaseRegisterFormStore formStore) {
  return Column(
    children: [
      SizedBox(height: 30),
      dropdownFinancialConcepts(conceptStore, formStore),
      description(formStore),
      Row(
        children: [
          Expanded(flex: 2, child: total(formStore)),
          const SizedBox(width: 8),
          Expanded(flex: 2, child: tax(formStore)),
        ],
      ),
      Row(
        children: [
          Expanded(flex: 2, child: purchaseDate(context, formStore)),
          const SizedBox(width: 8),
          Expanded(flex: 2, child: moneyLocation(formStore)),
        ],
      ),
      SizedBox(
        width: 250,
        child: uploadFile(formStore),
      )
    ],
  );
}
