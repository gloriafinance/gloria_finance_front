import 'package:church_finance_bk/core/utils/app_localizations_ext.dart';
import 'package:church_finance_bk/core/utils/index.dart';
import 'package:church_finance_bk/core/widgets/form_controls.dart';
import 'package:church_finance_bk/core/widgets/upload_file.dart';
import 'package:church_finance_bk/features/erp/settings/availability_accounts/models/availability_account_model.dart';
import 'package:church_finance_bk/features/erp/settings/availability_accounts/pages/list_availability_accounts/store/availability_accounts_list_store.dart';
import 'package:church_finance_bk/features/erp/settings/cost_center/store/cost_center_list_store.dart';
import 'package:church_finance_bk/features/erp/settings/financial_concept/models/financial_concept_model.dart';
import 'package:church_finance_bk/features/erp/settings/financial_concept/store/financial_concept_store.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../store/form_finance_record_store.dart';
import '../validators/form_financial_record_validator.dart';

final validator = FormFinancialRecordValidator();
final List<FinancialConceptModel> financialConcepts = [];

Widget description(BuildContext context, FormFinanceRecordStore formStore) {
  return Input(
    label: context.l10n.finance_records_form_field_description,
    initialValue: formStore.state.description,
    onChanged: (value) => formStore.state.description = value,
    onValidator: validator.byField(formStore.state, 'description'),
  );
}

Widget date(BuildContext context, FormFinanceRecordStore formStore) {
  return Input(
    label: context.l10n.finance_records_form_field_date,
    initialValue: formStore.state.date,
    keyboardType: TextInputType.number,
    onChanged: (value) {},
    onTap: () {
      selectDate(context).then((picked) {
        if (picked == null) return;
        formStore.setDate(convertDateFormatToDDMMYYYY(picked.toString()));
      });
    },
    onValidator: validator.byField(formStore.state, 'date'),
  );
}

Widget dropdownAvailabilityAccounts(
  BuildContext context,
  AvailabilityAccountsListStore availabilityAccountsListStore,
  FormFinanceRecordStore formStore,
) {
  return Dropdown(
    label: context.l10n.finance_records_filter_availability_account,
    items:
        availabilityAccountsListStore.state.availabilityAccounts
            .where((a) => a.accountType != AccountType.INVESTMENT.apiValue)
            .map((a) => a.accountName)
            .toList(),
    onChanged: (value) {
      final selectedAccount = availabilityAccountsListStore
          .state
          .availabilityAccounts
          .firstWhere((e) => e.accountName == value);

      selectedAccount.accountType == AccountType.BANK.apiValue
          ? formStore.setIsMovementBank(true)
          : formStore.setIsMovementBank(false);

      formStore.setAvailabilityAccountId(selectedAccount.availabilityAccountId);
    },
    onValidator: validator.byField(formStore.state, 'moneyLocation'),
  );
}

Widget amount(BuildContext context, FormFinanceRecordStore formStore) {
  return Input(
    label: context.l10n.finance_records_table_header_amount,
    keyboardType: TextInputType.number,
    inputFormatters: [
      CurrencyFormatter.getInputFormatters(CurrencyType.REAL.apiValue),
    ],
    onChanged: (value) {
      final cleanedValue = value
          .replaceAll(RegExp(r'[^\d,]'), '')
          .replaceAll(',', '.');

      formStore.setAmount(double.parse(cleanedValue));
    },
    onValidator: validator.byField(formStore.state, 'amount'),
  );
}

Widget searchFinancialConcepts(
  BuildContext context,
  FinancialConceptStore conceptStore,
  FormFinanceRecordStore formStore,
) {
  return Dropdown(
    label: context.l10n.finance_records_filter_concept,
    items: conceptStore.state.financialConcepts
        .where((e) => e.type != FinancialConceptType.PURCHASE.apiValue)
        .map((e) => e.name)
        .toList(growable: false),
    onValidator: validator.byField(formStore.state, 'financialConceptId'),
    onChanged: (value) {
      final v = conceptStore.state.financialConcepts.firstWhere(
        (e) => e.name == value,
      );

      formStore.setDescription(v.description);
      formStore.setFinancialConceptId(v.financialConceptId);
      formStore.setType(v.type);
    },
  );
}

Widget uploadFile(BuildContext context, FormFinanceRecordStore formStore) {
  if (formStore.state.isMovementBank) {
    return UploadFile(
      label: context.l10n.finance_records_form_field_receipt,
      multipartFile: (MultipartFile m) => formStore.setFile(m),
    );
  } else {
    return SizedBox.shrink();
  }
}

// Widget dropdownBank(BankStore bankStore, FormFinanceRecordStore formStore) {
//   if (formStore.state.isMovementBank) {
//     final data = bankStore.state.banks;
//
//     return Dropdown(
//       label: "Selecione o banco",
//       items: data.map((e) => e.name).toList(),
//       onChanged: (value) {
//         final selectedBank = data.firstWhere((e) => e.name == value);
//         formStore.setBankId(selectedBank.bankId);
//       },
//     );
//   }
//   return const SizedBox.shrink();
// }

Widget dropdownCostCenter(
  BuildContext context,
  CostCenterListStore costCenterStore,
  FinancialConceptStore conceptStore,
  FormFinanceRecordStore formStore,
) {
  if (conceptStore.state.financialConcepts.isEmpty ||
      formStore.state.financialConceptId.isEmpty) {
    return const SizedBox.shrink();
  }

  final concept = conceptStore.state.financialConcepts.firstWhere(
    (e) => e.financialConceptId == formStore.state.financialConceptId,
  );

  if (concept.type != FinancialConceptType.OUTGO.apiValue) {
    return const SizedBox.shrink();
  }

  return Dropdown(
    label: context.l10n.finance_records_form_field_cost_center,
    items: costCenterStore.state.costCenters.map((e) => e.name).toList(),
    onChanged: (value) {
      final selectedCostCenter = costCenterStore.state.costCenters.firstWhere(
        (e) => e.name == value,
      );
      formStore.setCostCenterId(selectedCostCenter.costCenterId);
    },
  );
}
