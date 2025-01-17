import 'package:flutter/material.dart';

import '../../../stores/financial_concept_store.dart';
import '../store/purchase_register_form_store.dart';
import 'form_inputs.dart';

Widget formDesktopLayout(
    FinancialConceptStore conceptStore, PurchaseRegisterFormStore formStore) {
  return Column(
    children: [
      SizedBox(height: 30),
      dropdownFinancialConcepts(conceptStore, formStore),
      const SizedBox(height: 10),
      description(formStore),
      const SizedBox(height: 10),
      total(formStore),
      const SizedBox(height: 10),
      moneyLocation(formStore),
    ],
  );
}
