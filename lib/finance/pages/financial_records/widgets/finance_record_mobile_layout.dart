import 'package:flutter/material.dart';

import 'form_financial_record_inputs.dart';

Widget formMobileLayout() {
  return Column(
    children: [
      SizedBox(height: 30),
      date(),
      const SizedBox(height: 10),
      amount(),
      const SizedBox(height: 10),
      searchFinancialConcepts(),
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
