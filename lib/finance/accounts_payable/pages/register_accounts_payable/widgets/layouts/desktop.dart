import 'package:flutter/material.dart';

import '../../store/form_accounts_payable_store.dart';
import '../form_accounts_payable_inputs.dart';
import '../installment_account_payable_form.dart';

Widget buildDesktopLayout(
  BuildContext context,
  FormAccountsPayableStore formStore,
) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: supplierDropdown(formStore)),
          const SizedBox(width: 16),
          Expanded(child: description(formStore)),
        ],
      ),
      const SizedBox(height: 24),
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: installmentsList(context, formStore),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: InstallmentAccountPayableForm(formStore: formStore),
          ),
        ],
      ),
    ],
  );
}
