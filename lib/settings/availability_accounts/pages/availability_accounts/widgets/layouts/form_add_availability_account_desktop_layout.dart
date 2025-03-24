import 'package:church_finance_bk/settings/banks/store/bank_store.dart';
import 'package:flutter/material.dart';

import '../../store/form_availability_store.dart';
import '../form_add_availability_account_inputs.dart';

Widget formAddAvailabilityAccountDesktopLayout(
    FormAvailabilityStore formStore, BankStore bankStore) {
  return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    SizedBox(height: 30),
    Row(
      children: [
        Expanded(
          child: accountName(formStore),
        ),
        SizedBox(
          width: 36,
        ),
        Expanded(child: symbol(formStore)),
        SizedBox(
          width: 36,
        ),
        Expanded(child: balance(formStore)),
        SizedBox(
          width: 36,
        ),
        Expanded(
          child: accountType(formStore),
        ),
      ],
    ),
    Row(
      children: [
        SizedBox(
          width: 400,
          child: source(formStore, bankStore),
        ),
      ],
    )
  ]);
}
