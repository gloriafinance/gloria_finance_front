import 'package:church_finance_bk/features/erp/settings/availability_accounts/pages/list_availability_accounts/store/availability_accounts_list_store.dart';
import 'package:church_finance_bk/features/erp/settings/cost_center/store/cost_center_list_store.dart';
import 'package:church_finance_bk/features/erp/settings/financial_concept/store/financial_concept_store.dart';
import 'package:flutter/material.dart';

import '../../store/purchase_register_form_store.dart';
import '../form_inputs.dart';

Widget formMobileLayout(
  BuildContext context,
  CostCenterListStore costCenterStore,
  AvailabilityAccountsListStore availabilityAccountsListStore,
  FinancialConceptStore conceptStore,
  PurchaseRegisterFormStore formStore,
) {
  return Column(
    children: [
      SizedBox(height: 30),
      dropdownCostCenter(costCenterStore, conceptStore, formStore),
      dropdownFinancialConcepts(conceptStore, formStore),
      description(formStore),
      Row(
        children: [
          Expanded(flex: 2, child: total(formStore)),
          const SizedBox(width: 8),
          Expanded(flex: 2, child: tax(formStore)),
        ],
      ),
      Row(
        children: [
          Expanded(flex: 2, child: purchaseDate(context, formStore)),
          const SizedBox(width: 8),
          Expanded(
            flex: 2,
            child: dropdownAvailabilityAccounts(
              availabilityAccountsListStore,
              formStore,
            ),
          ),
        ],
      ),
      SizedBox(width: 250, child: uploadFile(formStore)),
    ],
  );
}
