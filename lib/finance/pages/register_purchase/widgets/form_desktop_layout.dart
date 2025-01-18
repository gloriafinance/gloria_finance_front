import 'package:flutter/material.dart';

import '../../../stores/bank_store.dart';
import '../../../stores/financial_concept_store.dart';
import '../store/purchase_register_form_store.dart';
import 'form_inputs.dart';

Widget formDesktopLayout(BuildContext context, BankStore bankStore,
    FinancialConceptStore conceptStore, PurchaseRegisterFormStore formStore) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox(height: 30),
      Row(
        children: [
          Expanded(child: dropdownFinancialConcepts(conceptStore, formStore)),
          const SizedBox(width: 16),
          Expanded(flex: 2, child: description(formStore)),
        ],
      ),
      const SizedBox(height: 10),
      Row(
        children: [
          Expanded(flex: 2, child: total(formStore)),
          const SizedBox(width: 16),
          Expanded(flex: 3, child: tax(formStore)),
        ],
      ),
      const SizedBox(height: 10),
      Row(
        children: [
          Expanded(flex: 2, child: purchaseDate(context, formStore)),
          const SizedBox(width: 16),
          Expanded(flex: 3, child: moneyLocation(formStore)),
          const SizedBox(width: 16),
          Expanded(flex: 3, child: dropdownBank(bankStore, formStore)),
          SizedBox(width: 260)
        ],
      ),
      Align(
        alignment: Alignment.center,
        child: SizedBox(
          width: 250,
          child: uploadFile(formStore),
        ),
      ),
    ],
  );
}
