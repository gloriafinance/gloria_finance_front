import 'package:flutter/material.dart';

import '../../store/form_accounts_payable_store.dart';
import '../form_accounts_payable_inputs.dart';
import '../validators/form_accounts_payable_validator.dart';

Widget buildDesktopLayout(
  BuildContext context,
  FormAccountsPayableStore formStore,
  FormAccountsPayableValidator validator,
  bool showValidationMessages,
) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                generalInformationSection(formStore, validator),
                const SizedBox(height: 16),
                documentSection(context, formStore, validator),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: paymentSection(
              context,
              formStore,
              validator,
              showValidationMessages,
            ),
          ),
        ],
      ),
    ],
  );
}
