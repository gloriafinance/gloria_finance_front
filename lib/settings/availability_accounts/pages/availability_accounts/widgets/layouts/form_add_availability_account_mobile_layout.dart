import 'package:church_finance_bk/settings/banks/store/bank_store.dart';
import 'package:flutter/material.dart';

import '../../store/form_availability_store.dart';
import '../form_add_availability_account_inputs.dart';

Widget formAddAvailabilityAccountMobileLayout(
    FormAvailabilityStore formStore, BankStore bankStore) {
  return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    SizedBox(height: 30),
    accountName(formStore),
    SizedBox(height: 30),
    accountType(formStore),
    SizedBox(height: 30),
    source(formStore, bankStore),
  ]);
}
