import 'package:church_finance_bk/features/erp/settings/banks/store/bank_store.dart';
import 'package:flutter/material.dart';

import '../../../../models/availability_account_model.dart';
import '../../store/form_availability_store.dart';
import '../form_add_availability_account_inputs.dart';

Widget formAddAvailabilityAccountDesktopLayout(
  FormAvailabilityStore formStore,
  BankStore bankStore,
) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox(height: 30),
      Row(
        children: [
          Expanded(child: accountName(formStore)),
          SizedBox(width: 36),
          Expanded(child: symbol(formStore)),
          SizedBox(width: 36),
          Expanded(child: balance(formStore)),
          SizedBox(width: 36),
          Expanded(child: accountType(formStore)),
        ],
      ),
      SizedBox(height: 30),
      Row(
        children: [
          if (formStore.state.accountType == AccountType.BANK.apiValue)
            SizedBox(width: 400, child: source(formStore, bankStore)),
          SizedBox(width: 36),
          SizedBox(
            width: 140,
            child: Padding(
              padding: EdgeInsets.only(top: 40),
              child: status(formStore),
            ),
          ),
        ],
      ),
    ],
  );
}
