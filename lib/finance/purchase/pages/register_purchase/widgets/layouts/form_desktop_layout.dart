import 'package:church_finance_bk/settings/availability_accounts/store/availability_accounts_list_store.dart';
import 'package:church_finance_bk/settings/cost_center/store/cost_center_list_store.dart';
import 'package:church_finance_bk/settings/financial_concept/store/financial_concept_store.dart';
import 'package:flutter/material.dart';

import '../../store/purchase_register_form_store.dart';
import '../form_inputs.dart';

Widget formDesktopLayout(
    BuildContext context,
    CostCenterListStore costCenterStore,
    AvailabilityAccountsListStore availabilityAccountsListStore,
    FinancialConceptStore conceptStore,
    PurchaseRegisterFormStore formStore) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox(height: 30),
      Row(
        children: [
          Expanded(
              child:
                  dropdownCostCenter(costCenterStore, conceptStore, formStore)),
          const SizedBox(width: 16),
          Expanded(child: dropdownFinancialConcepts(conceptStore, formStore)),
          const SizedBox(width: 16),
          Expanded(flex: 2, child: description(formStore)),
        ],
      ),
      const SizedBox(height: 10),
      Row(
        children: [
          Expanded(flex: 2, child: purchaseDate(context, formStore)),
          const SizedBox(width: 16),
          Expanded(flex: 2, child: total(formStore)),
          const SizedBox(width: 16),
          Expanded(flex: 3, child: tax(formStore)),
        ],
      ),
      const SizedBox(height: 10),
      Row(
        children: [
          SizedBox(
            width: 460,
            child: dropdownAvailabilityAccounts(
                availabilityAccountsListStore, formStore),
          ),
          const SizedBox(width: 16),
          SizedBox(width: 260)
        ],
      ),
      Align(
        alignment: Alignment.center,
        child: SizedBox(
          width: 250,
          child: uploadFile(formStore),
        ),
      ),
    ],
  );
}
