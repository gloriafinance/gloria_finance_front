import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'form_financial_record_inputs.dart';

Widget formMobileLayout(WidgetRef ref) {
  return Column(
    children: [
      SizedBox(height: 30),
      date(),
      const SizedBox(height: 10),
      amount(),
      const SizedBox(height: 10),
      searchFinancialConcepts(ref),
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
