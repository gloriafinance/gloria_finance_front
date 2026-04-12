import 'package:flutter/material.dart';
import 'package:gloria_finance/features/erp/accounts_payable/models/accounts_payable_types.dart';
import 'package:gloria_finance/features/erp/accounts_payable/pages/register_accounts_payable/validators/form_accounts_payable_validator.dart';
import 'package:gloria_finance/features/erp/accounts_payable/pages/register_accounts_payable/widgets/form_accounts_payable_inputs.dart';
import 'package:gloria_finance/features/erp/purchase/pages/register_purchase/store/credit_purchase_register_store.dart';
import 'package:gloria_finance/features/erp/purchase/pages/register_purchase/validators/credit_purchase_register_validator.dart';

import '../credit_purchase_sections.dart';

Widget creditPurchaseMobileLayout(
  BuildContext context,
  CreditPurchaseRegisterStore store,
  CreditPurchaseRegisterValidator purchaseValidator,
  FormAccountsPayableValidator accountsPayableValidator,
  bool showValidationMessages,
) {
  final showTaxSection =
      store.state.documentType == AccountsPayableDocumentType.invoice;

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      creditPurchaseInformationSection(
        context,
        store,
        purchaseValidator,
        accountsPayableValidator,
      ),
      const SizedBox(height: 16),
      documentSection(context, store, accountsPayableValidator),
      if (showTaxSection) ...[
        const SizedBox(height: 16),
        taxSection(
          context,
          store,
          accountsPayableValidator,
          showValidationMessages,
        ),
      ],
      const SizedBox(height: 16),
      creditPurchasePaymentSection(
        context,
        store,
        accountsPayableValidator,
        showValidationMessages,
      ),
      const SizedBox(height: 16),
      creditPurchaseItemsSection(
        context,
        store,
        purchaseValidator,
        showValidationMessages,
      ),
    ],
  );
}
