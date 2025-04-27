import 'package:flutter/material.dart';

import '../../store/form_accounts_payable_store.dart';
import '../form_accounts_payable_inputs.dart';
import '../installment_account_payable_form.dart';

Widget buildMobileLayout(
  BuildContext context,
  FormAccountsPayableStore formStore,
) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      supplierDropdown(formStore),
      const SizedBox(height: 16),
      description(formStore),
      const SizedBox(height: 24),
      installmentsList(context, formStore),
      const SizedBox(height: 24),
      InstallmentAccountPayableForm(formStore: formStore),
      const SizedBox(height: 32),
//        _buildSaveButton(context, formStore),
    ],
  );
}
