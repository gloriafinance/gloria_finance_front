import 'package:church_finance_bk/core/widgets/form_controls.dart';
import 'package:church_finance_bk/core/widgets/upload_file.dart';
import 'package:church_finance_bk/finance/models/financial_concept_model.dart';
import 'package:church_finance_bk/finance/stores/finance_concept_store.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';

import '../../../models/finance_record_model.dart';
import '../../../stores/bank_store.dart';
import '../state/finance_record_state.dart';
import '../validators/form_financial_record_validator.dart';

final validator = FormFinancialRecordValidator();
final List<FinancialConceptModel> financialConcepts = [];

final formFinanceRecordState = FormFinanceRecordState.init();

final bankStore = BankStore();

Widget description() {
  return ListenableBuilder(
    listenable: formFinanceRecordState,
    builder: (
      context,
      child,
    ) {
      return Input(
        label: 'Descrição',
        initialValue: formFinanceRecordState.description,
        onChanged: (value) => formFinanceRecordState.description = value,
        onValidator: validator.byField(formFinanceRecordState, 'description'),
      );
    },
  );
}

Widget date() {
  return Input(
    label: "Data",
    keyboardType: TextInputType.number,
    inputFormatters: [
      MaskedInputFormatter('##/##/####'),
    ],
    onChanged: (value) => formFinanceRecordState.copyWith(date: value),
    onValidator: validator.byField(formFinanceRecordState, 'date'),
  );
}

Widget moneyLocation() {
  return Dropdown(
      label: "Fonte de financiamento",
      items: MoneyLocation.values.map((e) => e.friendlyName).toList(),
      onChanged: (value) =>
          formFinanceRecordState.copyWith(moneyLocation: value),
      onValidator: validator.byField(formFinanceRecordState, 'moneyLocation'));
}

Widget amount() {
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

      formFinanceRecordState.copyWith(amount: double.parse(cleanedValue));
    },
    onValidator: validator.byField(formFinanceRecordState, 'amount'),
  );
}

Widget searchFinancialConcepts(FinancialConceptStore conceptStore) {
  return Dropdown(
    label: "Conceito",
    items: conceptStore.state.financialConcepts.map((e) => e.name).toList(),
    onValidator:
        validator.byField(formFinanceRecordState, 'financialConceptId'),
    onChanged: (value) {
      final v = conceptStore.state.financialConcepts
          .firstWhere((e) => e.name == value);

      formFinanceRecordState.copyWith(
        financialConceptId: v.financialConceptId,
        description: v.description,
        type: v.type,
      );
    },
  );
}

Widget uploadFile() {
  return ListenableBuilder(
    listenable: formFinanceRecordState,
    builder: (context, child) {
      if (formFinanceRecordState.moneyLocation ==
          MoneyLocation.BANK.friendlyName) {
        return UploadFile(
          label: "Comprovante do movimento bancario",
          multipartFile: (MultipartFile m) =>
              formFinanceRecordState.copyWith(file: m),
        );
      } else {
        return SizedBox.shrink();
      }
    },
  );
}

Widget dropdownBank() {
  return ListenableBuilder(
    listenable: formFinanceRecordState,
    builder: (context, child) {
      // Verificar la selección de moneyLocation
      if (formFinanceRecordState.moneyLocation ==
          MoneyLocation.BANK.friendlyName) {
        return ListenableBuilder(
          listenable: bankStore,
          builder: (context, child) {
            final data = bankStore.state.banks;

            return Dropdown(
              label: "Selecione o banco",
              items: data.map((e) => e.name).toList(),
              onChanged: (value) {
                final selectedBank = data.firstWhere((e) => e.name == value);
                formFinanceRecordState.copyWith(bankId: selectedBank.bankId);
              },
            );
          },
        );
      } else {
        return const SizedBox.shrink();
      }
    },
  );
}
