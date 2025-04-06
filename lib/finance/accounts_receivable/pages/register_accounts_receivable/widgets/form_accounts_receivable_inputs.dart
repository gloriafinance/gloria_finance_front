import 'package:church_finance_bk/core/widgets/form_controls.dart';
import 'package:flutter/material.dart';

import '../store/form_accounts_receivable_store.dart';
import '../validators/form_accounts_receivable_validator.dart';

Widget description(FormAccountsReceivableStore formStore,
    FormAccountsReceivableValidator validator) {
  return Input(
    label: 'Descrição do Empréstimo',
    initialValue: formStore.state.description,
    onChanged: (value) => formStore.setDescription(value),
    onValidator: validator.byField(formStore.state, 'description'),
  );
}
