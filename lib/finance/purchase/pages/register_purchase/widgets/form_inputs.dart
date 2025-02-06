import 'package:church_finance_bk/core/widgets/form_controls.dart';
import 'package:church_finance_bk/core/widgets/upload_file.dart';
import 'package:church_finance_bk/helpers/index.dart';
import 'package:church_finance_bk/settings/availability_accounts/models/availability_account_model.dart';
import 'package:church_finance_bk/settings/availability_accounts/store/availability_accounts_list_store.dart';
import 'package:church_finance_bk/settings/banks/store/bank_store.dart';
import 'package:church_finance_bk/settings/cost_center/store/cost_center_list_store.dart';
import 'package:church_finance_bk/settings/financial_concept/store/financial_concept_store.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/formatters/currency_input_formatter.dart';
import 'package:flutter_multi_formatter/formatters/money_input_enums.dart';

import '../store/purchase_register_form_store.dart';
import '../validators/purchase_register_form_validator.dart';

final validator = PurchaseRegisterFormValidator();

Widget description(PurchaseRegisterFormStore formStore) {
  return Input(
    label: 'Descrição',
    initialValue: formStore.state.description,
    onChanged: (value) => formStore.state.description = value,
    onValidator: validator.byField(formStore.state, 'description'),
  );
}

Widget dropdownFinancialConcepts(
    FinancialConceptStore conceptStore, PurchaseRegisterFormStore formStore) {
  return Dropdown(
    label: "Conceito financeiro",
    items: conceptStore.state.financialConcepts
        .where((e) => e.type == 'PURCHASE')
        .map((e) => e.name)
        .toList(growable: false),
    onValidator: validator.byField(formStore.state, 'financialConceptId'),
    onChanged: (value) {
      final v = conceptStore.state.financialConcepts
          .firstWhere((e) => e.name == value);
      print("DES ${v.description}");
      formStore.setDescription(v.description);
      formStore.setFinancialConceptId(v.financialConceptId);
    },
  );
}

Widget dropdownAvailabilityAccounts(
    AvailabilityAccountsListStore availabilityAccountsListStore,
    PurchaseRegisterFormStore formStore) {
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

Widget total(PurchaseRegisterFormStore formStore) {
  return Input(
    label: "Total da fatura",
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

      formStore.setTotal(double.parse(cleanedValue));
    },
    onValidator: validator.byField(formStore.state, 'amount'),
  );
}

Widget tax(PurchaseRegisterFormStore formStore) {
  return Input(
    label: "Imposto",
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

      formStore.setTax(double.parse(cleanedValue));
    },
    onValidator: validator.byField(formStore.state, 'tax'),
  );
}

Widget uploadFile(PurchaseRegisterFormStore formStore) {
  return UploadFile(
    label: "Faça o upload da nota fiscal",
    multipartFile: (MultipartFile m) => formStore.setInvoice(m),
  );
}

Widget purchaseDate(BuildContext context, PurchaseRegisterFormStore formStore) {
  return Input(
    label: "Data da compra",
    initialValue: formStore.state.purchaseDate,
    keyboardType: TextInputType.number,
    onChanged: (value) {},
    onTap: () {
      selectDate(context).then((picked) {
        if (picked == null) return;
        formStore
            .setPurchaseDate(convertDateFormatToDDMMYYYY(picked.toString()));
      });
    },
    onValidator: validator.byField(formStore.state, 'date'),
  );
}

Widget dropdownBank(BankStore bankStore, PurchaseRegisterFormStore formStore) {
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
  }

  return const SizedBox(width: 0);
}

Widget dropdownCostCenter(CostCenterListStore costCenterStore,
    FinancialConceptStore conceptStore, PurchaseRegisterFormStore formStore) {
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
