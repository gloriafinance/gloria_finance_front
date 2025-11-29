import 'package:church_finance_bk/core/theme/index.dart';
import 'package:church_finance_bk/core/toast.dart';
import 'package:church_finance_bk/core/widgets/index.dart';
import 'package:church_finance_bk/core/utils/index.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../store/form_accounts_payable_store.dart';
import '../validators/form_accounts_payable_validator.dart';
import 'layouts/desktop.dart';
import 'layouts/mobile.dart';

class FormAccountPayable extends StatefulWidget {
  const FormAccountPayable({super.key});

  @override
  State<FormAccountPayable> createState() => _FormAccountPayableState();
}

class _FormAccountPayableState extends State<FormAccountPayable> {
  final formKey = GlobalKey<FormState>();
  final FormAccountsPayableValidator validator = FormAccountsPayableValidator();
  bool showValidationMessages = false;

  @override
  Widget build(BuildContext context) {
    final formStore = Provider.of<FormAccountsPayableStore>(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Form(
            key: formKey,
            child:
                isMobile(context)
                    ? buildMobileLayout(
                      context,
                      formStore,
                      validator,
                      showValidationMessages,
                    )
                    : buildDesktopLayout(
                      context,
                      formStore,
                      validator,
                      showValidationMessages,
                    ),
          ),
          isMobile(context)
              ? _buildSaveButton(formStore)
              : Align(
                alignment: Alignment.centerRight,
                child: SizedBox(width: 200, child: _buildSaveButton(formStore)),
              ),
        ],
      ),
    );
  }

  Widget _buildSaveButton(FormAccountsPayableStore formStore) {
    return CustomButton(
      text: 'Salvar',
      onPressed: () => _handleSave(formStore),
      backgroundColor: AppColors.green,
    );
  }

  void _handleSave(FormAccountsPayableStore formStore) async {
    setState(() {
      showValidationMessages = true;
    });

    final isValidForm = formKey.currentState?.validate() ?? false;
    final errors = validator.validateState(formStore.state);

    if (!isValidForm || errors.isNotEmpty) {
      if (errors.isNotEmpty) {
        Toast.showMessage(errors.values.first, ToastType.warning);
      }
      return;
    }

    final success = await formStore.save();

    if (success && mounted) {
      Toast.showMessage(
        'Conta a pagar registrada com sucesso!',
        ToastType.info,
      );
      setState(() {
        showValidationMessages = false;
      });
      context.pop();
    } else if (mounted) {
      Toast.showMessage('Erro ao registrar conta a pagar', ToastType.error);
    }
  }
}
