import 'package:church_finance_bk/core/widgets/form_controls.dart';
import 'package:church_finance_bk/core/widgets/upload_file.dart';
import 'package:church_finance_bk/helpers/index.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/formatters/currency_input_formatter.dart';
import 'package:flutter_multi_formatter/formatters/money_input_enums.dart';

import '../../../models/finance_record_model.dart';
import '../../../stores/bank_store.dart';
import '../../../stores/financial_concept_store.dart';
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
    label: "Conceito",
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

Widget moneyLocation(PurchaseRegisterFormStore formStore) {
  return Dropdown(
      label: "Fonte de financiamento",
      items: MoneyLocation.values.map((e) => e.friendlyName).toList(),
      onChanged: (value) => formStore.setFinancingSource(value),
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
  if (formStore.state.financingSource == MoneyLocation.BANK.friendlyName) {
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
    return const SizedBox(width: 0);
  }
}
