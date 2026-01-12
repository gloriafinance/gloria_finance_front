import 'package:church_finance_bk/core/utils/app_localizations_ext.dart';
import 'package:church_finance_bk/core/utils/index.dart';
import 'package:church_finance_bk/core/widgets/form_controls.dart';
import 'package:church_finance_bk/features/erp/settings/banks/store/bank_store.dart';
import 'package:flutter/material.dart';

import '../../../models/availability_account_model.dart';
import '../store/form_availability_store.dart';
import '../validators/form_availability_validator.dart';

final validator = FormAvailabilityValidator();

Widget accountName(FormAvailabilityStore formStore) {
  return Input(
    label: 'Nome da conta',
    initialValue: formStore.state.accountName,
    onChanged: (value) => formStore.setAccountName(value),
    onValidator: validator.byField(formStore.state, 'accountName'),
  );
}

List<String> _accountTypeFriendlyName(BuildContext context) {
  final l10n = context.l10n;
  return [
    AccountType.BANK.friendlyName(l10n),
    AccountType.CASH.friendlyName(l10n),
    AccountType.WALLET.friendlyName(l10n),
    AccountType.INVESTMENT.friendlyName(l10n),
  ];
}

Widget accountType(BuildContext context, FormAvailabilityStore formStore) {
  final l10n = context.l10n;
  var initValue =
      formStore.state.accountType != ''
          ? (AccountType.values.firstWhere(
            (e) => e.apiValue == formStore.state.accountType,
          )).friendlyName(l10n)
          : null;

  return Dropdown(
    label: "Tipo de conta",
    initialValue: initValue,
    items: _accountTypeFriendlyName(context).map((item) => item).toList(),
    onValidator: validator.byField(formStore.state, 'accountType'),
    onChanged: (value) {
      final accountType = AccountType.values.firstWhere(
        (e) => e.friendlyName(l10n) == value,
      );

      formStore.setAccountType(accountType.apiValue);
    },
  );
}

Widget source(FormAvailabilityStore formStore, BankStore bankStore) {
  final data = bankStore.state.banks;

  return Dropdown(
    label: "Selecione o banco",
    items: data.map((e) => "${e.name} - ${e.tag}").toList(),
    onChanged: (value) {
      final selectedBank = data.firstWhere(
        (e) => "${e.name} - ${e.tag}" == value,
      );
      formStore.setSource(selectedBank.bankId);
    },
  );
}

Widget symbol(FormAvailabilityStore formStore) {
  return Dropdown(
    label: "Moeda",
    initialValue:
        formStore.state.symbol != ''
            ? CurrencyType.values
                .firstWhere((e) => e.apiValue == formStore.state.symbol)
                .friendlyName
            : null,
    items: CurrencyType.values.map((e) => e.friendlyName).toList(),
    onChanged: (value) {
      var symbol =
          CurrencyType.values
              .firstWhere((e) => e.friendlyName == value)
              .apiValue;
      formStore.setSymbol(symbol);
    },
  );
}

Widget balance(FormAvailabilityStore formStore) {
  return Input(
    label: 'Saldo',
    initialValue: formStore.state.balance,
    keyboardType: TextInputType.number,
    inputFormatters: [
      CurrencyFormatter.getInputFormatters(CurrencyType.REAL.apiValue),
    ],
    onChanged: (value) {
      final cleanedValue = value
          .replaceAll(RegExp(r'[^\d,]'), '')
          .replaceAll(',', '.');

      formStore.setBalance(double.parse(cleanedValue));
    },
  );
}

Widget status(FormAvailabilityStore formStore) {
  return Row(
    children: [
      Text('Ativo'),
      Switch(
        value: formStore.state.active,
        onChanged: (value) => formStore.setActive(value),
      ),
    ],
  );
}
