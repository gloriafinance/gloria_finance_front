import 'package:gloria_finance/features/erp/settings/availability_accounts/pages/list_availability_accounts/store/availability_accounts_list_store.dart';
import 'package:gloria_finance/features/erp/settings/cost_center/store/cost_center_list_store.dart';
import 'package:gloria_finance/features/erp/settings/financial_concept/store/financial_concept_store.dart';
import 'package:flutter/material.dart';

import '../../store/form_finance_record_store.dart';
import '../form_finance_record_inputs.dart';

Widget formMobileLayout(
  CostCenterListStore costCenterStore,
  AvailabilityAccountsListStore availabilityAccountsListStore,
  FinancialConceptStore conceptStore,
  FormFinanceRecordStore formStore,
  BuildContext context,
) {
  return Column(
    children: [
      SizedBox(height: 30),
      date(context, formStore),
      const SizedBox(height: 10),
      amount(context, formStore),
      const SizedBox(height: 10),
      searchFinancialConcepts(context, conceptStore, formStore),
      Container(
        margin: EdgeInsets.only(top: 10),
        child: dropdownCostCenter(
          context,
          costCenterStore,
          conceptStore,
          formStore,
        ),
      ),
      description(context, formStore),
      const SizedBox(height: 10),
      dropdownAvailabilityAccounts(
        context,
        availabilityAccountsListStore,
        formStore,
      ),
      const SizedBox(height: 10),
      uploadFile(context, formStore),
    ],
  );
}
