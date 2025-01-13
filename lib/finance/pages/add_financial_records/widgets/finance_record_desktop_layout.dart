import 'package:flutter/material.dart';

import '../../../stores/bank_store.dart';
import '../../../stores/financial_concept_store.dart';
import 'form_finance_record_inputs.dart';

Widget formDesktopLayout(BankStore bankStore,
    FinancialConceptStore conceptStore, BuildContext context) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox(height: 30),
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: date(context)),
          const SizedBox(width: 16),
          Expanded(flex: 2, child: searchFinancialConcepts(conceptStore)),
        ],
      ),
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: description()),
        ],
      ),
      const SizedBox(height: 16),
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: 2, child: amount()),
          const SizedBox(width: 16),
          Expanded(flex: 3, child: moneyLocation()),
        ],
      ),
      const SizedBox(height: 16),
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 300, child: dropdownBank(bankStore)),
          const SizedBox(width: 16),
          SizedBox(width: 330, child: uploadFile()),
        ],
      )
    ],
  );
}
