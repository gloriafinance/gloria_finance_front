import 'package:flutter/material.dart';

import '../../../stores/bank_store.dart';
import '../../../stores/financial_concept_store.dart';
import '../store/form_finance_record_store.dart';
import 'form_finance_record_inputs.dart';

Widget formDesktopLayout(
    BankStore bankStore,
    FinancialConceptStore conceptStore,
    FormFinanceRecordStore formStore,
    BuildContext context) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox(height: 30),
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: date(context, formStore)),
          const SizedBox(width: 16),
          Expanded(
              flex: 2, child: searchFinancialConcepts(conceptStore, formStore)),
        ],
      ),
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: description(formStore)),
        ],
      ),
      const SizedBox(height: 16),
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: 2, child: amount(formStore)),
          const SizedBox(width: 16),
          Expanded(flex: 3, child: moneyLocation(formStore)),
        ],
      ),
      const SizedBox(height: 16),
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 300, child: dropdownBank(bankStore, formStore)),
          const SizedBox(width: 16),
          SizedBox(width: 330, child: uploadFile(formStore)),
        ],
      )
    ],
  );
}
