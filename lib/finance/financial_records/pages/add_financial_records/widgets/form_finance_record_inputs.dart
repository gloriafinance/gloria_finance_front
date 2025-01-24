import 'package:church_finance_bk/core/widgets/form_controls.dart';
import 'package:church_finance_bk/core/widgets/upload_file.dart';
import 'package:church_finance_bk/helpers/index.dart';
import 'package:church_finance_bk/settings/availability_accounts/models/availability_account_model.dart';
import 'package:church_finance_bk/settings/availability_accounts/store/availability_accounts_list_store.dart';
import 'package:church_finance_bk/settings/banks/store/bank_store.dart';
import 'package:church_finance_bk/settings/cost_center/store/cost_center_list_store.dart';
import 'package:church_finance_bk/settings/financial_concept/models/financial_concept_model.dart';
import 'package:church_finance_bk/settings/financial_concept/store/financial_concept_store.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';

import '../../../store/form_finance_record_store.dart';
import '../../../validators/form_financial_record_validator.dart';

final validator = FormFinancialRecordValidator();
final List<FinancialConceptModel> financialConcepts = [];

Widget description(FormFinanceRecordStore formStore) {
  return Input(
    label: 'Descrição',
    initialValue: formStore.state.description,
    onChanged: (value) => formStore.state.description = value,
    onValidator: validator.byField(formStore.state, 'description'),
  );
}

Widget date(BuildContext context, FormFinanceRecordStore formStore) {
  return Input(
    label: "Data",
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

Widget availabilityAccounts(
    AvailabilityAccountsListStore availabilityAccountsListStore,
    FormFinanceRecordStore formStore) {
  return Dropdown(
      label: "Conta de disponiblidade",
      items: availabilityAccountsListStore.state.availabilityAccounts
          .map((a) => a.accountName)
          .toList(),
      onChanged: (value) {
        final selectedAccount = availabilityAccountsListStore
            .state.availabilityAccounts
            .firstWhere((e) => e.accountName == value);

        selectedAccount.accountType == AccountType.BANK.apiValue
            ? formStore.setIsMovementBank(true)
            : formStore.setIsMovementBank(false);

        formStore
            .setAvailabilityAccountId(selectedAccount.availabilityAccountId);
      },
      onValidator: validator.byField(formStore.state, 'moneyLocation'));
}

Widget amount(FormFinanceRecordStore formStore) {
  return Input(
    label: "Valor",
    keyboardType: TextInputType.number,
    inputFormatters: [
      CurrencyInputFormatter(
        leadingSymbol: 'R\$ ',
        useSymbolPadding: true,
        mantissaLength: 2,
        thousandSeparator: ThousandSeparator.Period,
      ),
    ],
    onChanged: (value) {
      final cleanedValue =
          value.replaceAll(RegExp(r'[^\d,]'), '').replaceAll(',', '.');

      formStore.setAmount(double.parse(cleanedValue));
    },
    onValidator: validator.byField(formStore.state, 'amount'),
  );
}

Widget searchFinancialConcepts(
    FinancialConceptStore conceptStore, FormFinanceRecordStore formStore) {
  return Dropdown(
    label: "Conceito",
    items: conceptStore.state.financialConcepts.map((e) => e.name).toList(),
    onValidator: validator.byField(formStore.state, 'financialConceptId'),
    onChanged: (value) {
      final v = conceptStore.state.financialConcepts
          .firstWhere((e) => e.name == value);
      print(v.type);
      formStore.setDescription(v.description);
      formStore.setFinancialConceptId(v.financialConceptId);
      formStore.setType(v.type);
    },
  );
}

Widget uploadFile(FormFinanceRecordStore formStore) {
  if (formStore.state.isMovementBank) {
    return UploadFile(
      label: "Comprovante do movimento bancario",
      multipartFile: (MultipartFile m) => formStore.setFile(m),
    );
  } else {
    return SizedBox.shrink();
  }
}

Widget dropdownBank(BankStore bankStore, FormFinanceRecordStore formStore) {
  if (formStore.state.isMovementBank) {
    final data = bankStore.state.banks;

    return Dropdown(
      label: "Selecione o banco",
      items: data.map((e) => e.name).toList(),
      onChanged: (value) {
        final selectedBank = data.firstWhere((e) => e.name == value);
        formStore.setBankId(selectedBank.bankId);
      },
    );
  } else {
    return const SizedBox.shrink();
  }
}

Widget dropdownCostCenter(CostCenterListStore costCenterStore,
    FinancialConceptStore conceptStore, FormFinanceRecordStore formStore) {
  if (conceptStore.state.financialConcepts.isEmpty ||
      formStore.state.financialConceptId.isEmpty) {
    return const SizedBox.shrink();
  }
  final concept = conceptStore.state.financialConcepts.firstWhere(
      (e) => e.financialConceptId == formStore.state.financialConceptId);

  if (concept.type != FinancialConceptType.OUTGO.apiValue) {
    return const SizedBox.shrink();
  }

  print("ESTOU AQUI");

  return Dropdown(
    label: "Centro de custo",
    items: costCenterStore.state.costCenters.map((e) => e.name).toList(),
    onChanged: (value) {
      final selectedCostCenter =
          costCenterStore.state.costCenters.firstWhere((e) => e.name == value);
      formStore.setCostCenterId(selectedCostCenter.costCenterId);
    },
  );
}
