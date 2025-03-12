import 'package:church_finance_bk/settings/availability_accounts/pages/list_availability_accounts/store/availability_accounts_list_store.dart';
import 'package:church_finance_bk/settings/cost_center/store/cost_center_list_store.dart';
import 'package:church_finance_bk/settings/financial_concept/store/financial_concept_store.dart';
import 'package:flutter/material.dart';

import '../../store/form_finance_record_store.dart';
import '../form_finance_record_inputs.dart';

Widget formDesktopLayout(
    CostCenterListStore costCenterStore,
    AvailabilityAccountsListStore availabilityAccountsListStore,
    FinancialConceptStore conceptStore,
    FormFinanceRecordStore formStore,
    BuildContext context) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox(height: 30),
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: date(context, formStore)),
          const SizedBox(width: 16),
          Expanded(
              flex: 2, child: searchFinancialConcepts(conceptStore, formStore)),
          const SizedBox(width: 16),
          Expanded(
              flex: 2,
              child:
                  dropdownCostCenter(costCenterStore, conceptStore, formStore)),
        ],
      ),
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: description(formStore)),
        ],
      ),
      const SizedBox(height: 16),
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: 2, child: amount(formStore)),
          const SizedBox(width: 16),
          Expanded(
              flex: 3,
              child: dropdownAvailabilityAccounts(
                  availabilityAccountsListStore, formStore)),
        ],
      ),
      const SizedBox(height: 16),
      Row(
        children: [
          const SizedBox(width: 16),
          SizedBox(width: 330, child: uploadFile(formStore)),
        ],
      )
    ],
  );
}
