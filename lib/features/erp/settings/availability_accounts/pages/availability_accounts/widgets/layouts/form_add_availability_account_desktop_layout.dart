import 'package:gloria_finance/features/erp/settings/banks/store/bank_store.dart';
import 'package:flutter/material.dart';

import '../../../../models/availability_account_model.dart';
import '../../store/form_availability_store.dart';
import '../form_add_availability_account_inputs.dart';

Widget formAddAvailabilityAccountDesktopLayout(
  BuildContext context,
  FormAvailabilityStore formStore,
  BankStore bankStore,
) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox(height: 30),
      Row(
        children: [
          Expanded(child: accountName(context, formStore)),
          SizedBox(width: 36),
          Expanded(child: symbol(context, formStore)),
          SizedBox(width: 36),
          Expanded(child: balance(context, formStore)),
          SizedBox(width: 36),
          Expanded(child: accountType(context, formStore)),
        ],
      ),
      SizedBox(height: 30),
      Row(
        children: [
          if (formStore.state.accountType == AccountType.BANK.apiValue)
            SizedBox(width: 400, child: source(context, formStore, bankStore)),
          SizedBox(width: 36),
          SizedBox(
            width: 140,
            child: Padding(
              padding: EdgeInsets.only(top: 40),
              child: status(context, formStore),
            ),
          ),
        ],
      ),
    ],
  );
}
