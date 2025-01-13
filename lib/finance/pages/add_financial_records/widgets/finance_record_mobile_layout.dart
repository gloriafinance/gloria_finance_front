import 'package:flutter/material.dart';

import '../../../stores/bank_store.dart';
import '../../../stores/financial_concept_store.dart';
import 'form_finance_record_inputs.dart';

Widget formMobileLayout(BankStore bankStore, FinancialConceptStore conceptStore,
    BuildContext context) {
  return Column(
    children: [
      SizedBox(height: 30),
      date(context),
      const SizedBox(height: 10),
      amount(),
      const SizedBox(height: 10),
      searchFinancialConcepts(conceptStore),
      const SizedBox(height: 10),
      description(),
      const SizedBox(height: 10),
      moneyLocation(),
      const SizedBox(height: 10),
      SizedBox(width: 300, child: dropdownBank(bankStore)),
      const SizedBox(height: 10),
      uploadFile(),
    ],
  );
}
