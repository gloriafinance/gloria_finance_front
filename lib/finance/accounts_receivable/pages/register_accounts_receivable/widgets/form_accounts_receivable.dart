import 'package:church_finance_bk/core/layout/modal_page_layout.dart';
import 'package:church_finance_bk/core/theme/index.dart';
import 'package:church_finance_bk/core/toast.dart';
import 'package:church_finance_bk/core/widgets/index.dart';
import 'package:church_finance_bk/helpers/index.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../models/index.dart';
import '../store/form_accounts_receivable_store.dart';
import '../validators/form_accounts_receivable_validator.dart';
import 'external_debtor_form.dart';
import 'installment_form.dart';
import 'installments_table.dart';
import 'member_selector.dart';

class FormAccountsReceivable extends StatefulWidget {
  const FormAccountsReceivable({super.key});

  @override
  State<FormAccountsReceivable> createState() => _FormAccountsReceivableState();
}

class _FormAccountsReceivableState extends State<FormAccountsReceivable> {
  final formKey = GlobalKey<FormState>();
  final validator = FormAccountsReceivableValidator();

  @override
  Widget build(BuildContext context) {
    final formStore = Provider.of<FormAccountsReceivableStore>(context);

    return SingleChildScrollView(
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 40),

            // Tipo de deudor selector
            _debtorTypeSelector(formStore),
            SizedBox(height: 20),

            // Campos según el tipo de deudor
            formStore.state.debtorType == DebtorType.MEMBER
                ? MemberSelector(formStore: formStore)
                : ExternalDebtorForm(
                    formStore: formStore, validator: validator),

            SizedBox(height: 20),

            _description(formStore, validator),

            SizedBox(height: 20),

            Align(
              alignment: Alignment.centerLeft,
              child: Text('Registrar parcelas',
                  style: TextStyle(
                      fontSize: 16,
                      color: AppColors.grey,
                      fontFamily: AppFonts.fontSubTitle)),
            ),
            _btnAddItem(formStore),
            formStore.state.installments.isNotEmpty
                ? InstallmentsTable(
                    installments: formStore.state.installments,
                    onRemove: (index) => formStore.removeInstallment(index),
                  )
                : Center(
                    child: Text(
                      'Nenhuma parcela adicionada',
                      style: TextStyle(
                        fontFamily: AppFonts.fontText,
                        fontSize: 16,
                        color: AppColors.grey,
                      ),
                    ),
                  ),

            // SizedBox(height: 30),

            isMobile(context)
                ? _btnSave(formStore)
                : Align(
                    alignment: Alignment.centerRight,
                    child: SizedBox(
                      width: 300,
                      child: _btnSave(formStore),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _description(FormAccountsReceivableStore formStore,
      FormAccountsReceivableValidator validator) {
    return Input(
      label: 'Descrição do Empréstimo',
      initialValue: formStore.state.description,
      onChanged: (value) => formStore.setDescription(value),
      onValidator: validator.byField(formStore.state, 'description'),
    );
  }

  Widget _btnAddItem(FormAccountsReceivableStore formStore) {
    return Row(
      children: [
        ButtonActionTable(
            color: AppColors.blue,
            text: "Adicionar parcela",
            onPressed: () {
              ModalPage(
                title: "Adicionar parcela",
                body: InstallmentForm(
                  onCallback: (InstallmentModel item) {
                    formStore.addInstallment(item);
                  },
                  formStore: formStore,
                ),
              ).show(context);
            },
            icon: Icons.add_box_outlined),
      ],
    );
  }

  Widget _debtorTypeSelector(FormAccountsReceivableStore formStore) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tipo de Deudor',
          style: TextStyle(
            color: AppColors.purple,
            fontFamily: AppFonts.fontTitle,
            fontSize: 15,
          ),
        ),
        SizedBox(height: 8),
        Row(
          children: [
            Radio<DebtorType>(
              value: DebtorType.MEMBER,
              groupValue: formStore.state.debtorType,
              onChanged: (value) {
                if (value != null) {
                  formStore.setDebtorType(value);
                }
              },
            ),
            Text('Membro da Igreja'),
            SizedBox(width: 20),
            Radio<DebtorType>(
              value: DebtorType.EXTERNAL,
              groupValue: formStore.state.debtorType,
              onChanged: (value) {
                if (value != null) {
                  formStore.setDebtorType(value);
                }
              },
            ),
            Text('Externo'),
          ],
        ),
      ],
    );
  }

  Widget _btnSave(FormAccountsReceivableStore formStore) {
    return (formStore.state.makeRequest)
        ? const Loading()
        : Padding(
            padding: EdgeInsets.only(top: 20),
            child: CustomButton(
                text: "Salvar",
                backgroundColor: AppColors.green,
                textColor: Colors.black,
                onPressed: () => _saveRecord(formStore)));
  }

  void _saveRecord(FormAccountsReceivableStore formStore) async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    if (formStore.state.installments.isEmpty) {
      Toast.showMessage('Adicione pelo menos uma parcela', ToastType.warning);
      return;
    }

    try {
      await formStore.save();
      Toast.showMessage('Empréstimo salvo com sucesso', ToastType.info);
      Future.delayed(Duration(seconds: 1), () {
        context.go('/accounts-receivables');
      });
    } catch (e) {
      Toast.showMessage('Erro ao salvar o empréstimo', ToastType.error);
    }
  }
}
