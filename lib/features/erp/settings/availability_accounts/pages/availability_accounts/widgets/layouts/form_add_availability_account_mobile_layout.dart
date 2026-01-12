import 'package:church_finance_bk/features/erp/settings/banks/store/bank_store.dart';
import 'package:flutter/material.dart';

import '../../../../models/availability_account_model.dart';
import '../../store/form_availability_store.dart';
import '../form_add_availability_account_inputs.dart';

Widget formAddAvailabilityAccountMobileLayout(
  BuildContext context,
  FormAvailabilityStore formStore,
  BankStore bankStore,
) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox(height: 30),
      accountName(context, formStore),
      SizedBox(height: 30),
      symbol(context, formStore),
      SizedBox(height: 30),
      balance(context, formStore),
      SizedBox(height: 30),
      accountType(context, formStore),
      SizedBox(height: 30),
      if (formStore.state.accountType == AccountType.BANK.apiValue)
        source(context, formStore, bankStore),
    ],
  );
}
