import 'package:church_finance_bk/core/widgets/form_controls.dart';
import 'package:church_finance_bk/helpers/general.dart';
import 'package:flutter/material.dart';

import '../store/form_accounts_receivable_store.dart';
import '../validators/form_accounts_receivable_validator.dart';

class ExternalDebtorForm extends StatelessWidget {
  final FormAccountsReceivableStore formStore;
  final FormAccountsReceivableValidator validator;

  const ExternalDebtorForm({
    super.key,
    required this.formStore,
    required this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return isMobile(context)
        ? Column(
          children: [
            _inputDNI(),
            _inputName(),
            _inputPhone(),
            -_inputEmail(),
            _inputAddress(),
          ],
        )
        : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(child: _inputDNI()),
                SizedBox(width: 16),
                Expanded(child: _inputName()),
                SizedBox(width: 16),
                Expanded(child: _inputPhone()),
                SizedBox(width: 16),
                Expanded(child: _inputEmail()),
                SizedBox(width: 16),
              ],
            ),

            SizedBox(width: 820, child: _inputAddress()),
          ],
        );
  }

  _inputDNI() {
    return Input(
      label: 'CNPJ/CPJ do Deudor',
      initialValue: formStore.state.debtorDNI,
      onChanged: (value) => formStore.setDebtorDNI(value),
      onValidator: validator.byField(formStore.state, 'debtorDNI'),
    );
  }

  _inputPhone() {
    return Input(
      label: 'Telefone do Deudor',
      initialValue: formStore.state.debtorPhone,
      onChanged: (value) => formStore.setDebtorPhone(value),
      onValidator: validator.byField(formStore.state, 'debtorPhone'),
    );
  }

  _inputName() {
    return Input(
      label: 'Nome do Deudor',
      initialValue: formStore.state.debtorName,
      onChanged: (value) => formStore.setDebtorName(value),
      onValidator: validator.byField(formStore.state, 'debtorName'),
    );
  }

  _inputEmail() {
    return Input(
      label: 'Email do Deudor',
      initialValue: formStore.state.debtorEmail,
      onChanged: (value) => formStore.setDebtorEmail(value),
      onValidator: validator.byField(formStore.state, 'debtorEmail'),
    );
  }

  _inputAddress() {
    return Input(
      label: 'Endereço do Deudor',
      initialValue: formStore.state.debtorAddress,
      onChanged: (value) => formStore.setDebtorAddress(value),
      onValidator: validator.byField(formStore.state, 'debtorAddress'),
    );
  }
}
