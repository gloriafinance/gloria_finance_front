import 'package:gloria_finance/features/erp/settings/availability_accounts/pages/list_availability_accounts/store/availability_accounts_list_store.dart';
import 'package:gloria_finance/features/erp/settings/cost_center/store/cost_center_list_store.dart';
import 'package:gloria_finance/features/erp/settings/financial_concept/store/financial_concept_store.dart';
import 'package:flutter/material.dart';

import '../../store/purchase_register_form_store.dart';
import '../form_inputs.dart';

Widget formDesktopLayout(
  BuildContext context,
  CostCenterListStore costCenterStore,
  AvailabilityAccountsListStore availabilityAccountsListStore,
  FinancialConceptStore conceptStore,
  PurchaseRegisterFormStore formStore,
) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox(height: 30),
      Row(
        children: [
          Expanded(
            child: dropdownCostCenter(costCenterStore, conceptStore, formStore),
          ),
          const SizedBox(width: 16),
          Expanded(child: dropdownFinancialConcepts(conceptStore, formStore)),
          const SizedBox(width: 16),
          Expanded(
            child: dropdownAvailabilityAccounts(
              availabilityAccountsListStore,
              formStore,
            ),
          ),
        ],
      ),
      const SizedBox(height: 10),
      Row(
        children: [
          Expanded(flex: 2, child: purchaseDate(context, formStore)),
          const SizedBox(width: 16),
          Expanded(flex: 2, child: total(formStore)),
          const SizedBox(width: 16),
          Expanded(flex: 2, child: tax(formStore)),
          const SizedBox(width: 16),
          Expanded(flex: 6, child: description(formStore)),
        ],
      ),
      const SizedBox(height: 10),
      Row(children: [const SizedBox(width: 16), SizedBox(width: 260)]),
      Align(
        alignment: Alignment.center,
        child: SizedBox(width: 450, child: uploadFile(formStore)),
      ),
    ],
  );
}
