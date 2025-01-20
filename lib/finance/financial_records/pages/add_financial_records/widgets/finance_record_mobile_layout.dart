import 'package:church_finance_bk/settings/availability_accounts/store/availability_accounts_list_store.dart';
import 'package:church_finance_bk/settings/banks/store/bank_store.dart';
import 'package:church_finance_bk/settings/financial_concept/store/financial_concept_store.dart';
import 'package:flutter/material.dart';

import '../../../store/form_finance_record_store.dart';
import 'form_finance_record_inputs.dart';

Widget formMobileLayout(
    AvailabilityAccountsListStore availabilityAccountsListStore,
    BankStore bankStore,
    FinancialConceptStore conceptStore,
    FormFinanceRecordStore formStore,
    BuildContext context) {
  return Column(
    children: [
      SizedBox(height: 30),
      date(context, formStore),
      const SizedBox(height: 10),
      amount(formStore),
      const SizedBox(height: 10),
      searchFinancialConcepts(conceptStore, formStore),
      const SizedBox(height: 10),
      description(formStore),
      const SizedBox(height: 10),
      availabilityAccounts(availabilityAccountsListStore, formStore),
      const SizedBox(height: 10),
      SizedBox(width: 300, child: dropdownBank(bankStore, formStore)),
      const SizedBox(height: 10),
      uploadFile(formStore),
    ],
  );
}
