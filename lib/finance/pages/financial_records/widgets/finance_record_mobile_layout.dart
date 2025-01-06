import 'package:flutter/material.dart';

import '../../../stores/finance_concept_store.dart';
import 'form_finance_record_inputs.dart';

Widget formMobileLayout(FinancialConceptStore conceptStore) {
  return Column(
    children: [
      SizedBox(height: 30),
      date(),
      const SizedBox(height: 10),
      amount(),
      const SizedBox(height: 10),
      searchFinancialConcepts(conceptStore),
      const SizedBox(height: 10),
      description(),
      const SizedBox(height: 10),
      moneyLocation(),
      const SizedBox(height: 10),
      SizedBox(width: 300, child: dropdownBank()),
      const SizedBox(height: 10),
      uploadFile(),
    ],
  );
}
