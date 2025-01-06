import 'package:flutter/material.dart';

import 'form_financial_record_inputs.dart';

Widget formDesktopLayout() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox(height: 30),
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: date()),
          const SizedBox(width: 16),
          Expanded(flex: 2, child: searchFinancialConcepts()),
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
          SizedBox(width: 300, child: dropdownBank()),
          const SizedBox(width: 16),
          SizedBox(width: 330, child: uploadFile()),
        ],
      )
    ],
  );
}
