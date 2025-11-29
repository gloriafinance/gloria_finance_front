import 'package:church_finance_bk/features/erp//accounts_payable/models/accounts_payable_types.dart';
import 'package:flutter/material.dart';

import '../../store/form_accounts_payable_store.dart';
import '../../validators/form_accounts_payable_validator.dart';
import '../form_accounts_payable_inputs.dart';

Widget buildMobileLayout(
  BuildContext context,
  FormAccountsPayableStore formStore,
  FormAccountsPayableValidator validator,
  bool showValidationMessages,
) {
  final showTaxSection =
      formStore.state.documentType == AccountsPayableDocumentType.invoice;

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      generalInformationSection(formStore, validator),
      const SizedBox(height: 16),
      documentSection(context, formStore, validator),
      if (showTaxSection) ...[
        const SizedBox(height: 16),
        taxSection(context, formStore, validator, showValidationMessages),
        const SizedBox(height: 16),
      ],
      paymentSection(context, formStore, validator, showValidationMessages),
    ],
  );
}
