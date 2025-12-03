import 'package:church_finance_bk/core/utils/app_localizations_ext.dart';
import 'package:church_finance_bk/core/utils/general.dart';
import 'package:church_finance_bk/core/widgets/form_controls.dart';
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
            _inputDNI(context),
            _inputName(context),
            _inputPhone(context),
            _inputEmail(context),
            _inputAddress(context),
          ],
        )
        : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(child: _inputDNI(context)),
                SizedBox(width: 16),
                Expanded(child: _inputName(context)),
                SizedBox(width: 16),
                Expanded(child: _inputPhone(context)),
                SizedBox(width: 16),
                Expanded(child: _inputEmail(context)),
                SizedBox(width: 16),
              ],
            ),

            SizedBox(width: 820, child: _inputAddress(context)),
          ],
        );
  }

  Widget _inputDNI(BuildContext context) {
    return Input(
      label: context.l10n.accountsReceivable_form_field_debtor_dni,
      initialValue: formStore.state.debtorDNI,
      onChanged: (value) => formStore.setDebtorDNI(value),
      onValidator: validator.byField(formStore.state, 'debtorDNI'),
    );
  }

  Widget _inputPhone(BuildContext context) {
    return Input(
      label: context.l10n.accountsReceivable_form_field_debtor_phone,
      initialValue: formStore.state.debtorPhone,
      onChanged: (value) => formStore.setDebtorPhone(value),
      onValidator: validator.byField(formStore.state, 'debtorPhone'),
    );
  }

  Widget _inputName(BuildContext context) {
    return Input(
      label: context.l10n.accountsReceivable_form_field_debtor_name,
      initialValue: formStore.state.debtorName,
      onChanged: (value) => formStore.setDebtorName(value),
      onValidator: validator.byField(formStore.state, 'debtorName'),
    );
  }

  Widget _inputEmail(BuildContext context) {
    return Input(
      label: context.l10n.accountsReceivable_form_field_debtor_email,
      initialValue: formStore.state.debtorEmail,
      onChanged: (value) => formStore.setDebtorEmail(value),
      onValidator: validator.byField(formStore.state, 'debtorEmail'),
    );
  }

  Widget _inputAddress(BuildContext context) {
    return Input(
      label: context.l10n.accountsReceivable_form_field_debtor_address,
      initialValue: formStore.state.debtorAddress,
      onChanged: (value) => formStore.setDebtorAddress(value),
      onValidator: validator.byField(formStore.state, 'debtorAddress'),
    );
  }
}
