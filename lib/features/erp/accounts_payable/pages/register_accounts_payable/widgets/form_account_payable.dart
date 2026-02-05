import 'package:gloria_finance/core/theme/index.dart';
import 'package:gloria_finance/core/toast.dart';
import 'package:gloria_finance/core/utils/app_localizations_ext.dart';
import 'package:gloria_finance/core/utils/index.dart';
import 'package:gloria_finance/core/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../../../auth/pages/login/store/auth_session_store.dart';
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
  late FormAccountsPayableValidator validator;
  bool showValidationMessages = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final l10n = context.l10n;
    validator = FormAccountsPayableValidator(
      supplierRequired: l10n.accountsPayable_form_error_supplier_required,
      descriptionRequired: l10n.accountsPayable_form_error_description_required,
      documentTypeRequired:
          l10n.accountsPayable_form_error_document_type_required,
      documentNumberRequired:
          l10n.accountsPayable_form_error_document_number_required,
      documentDateRequired:
          l10n.accountsPayable_form_error_document_date_required,
      totalAmountRequired:
          l10n.accountsPayable_form_error_total_amount_required,
      singleDueDateRequired:
          l10n.accountsPayable_form_error_single_due_date_required,
      installmentsRequired:
          l10n.accountsPayable_form_error_installments_required,
      installmentsContents:
          l10n.accountsPayable_form_error_installments_contents,
      automaticInstallmentsRequired:
          l10n.accountsPayable_form_error_automatic_installments_required,
      automaticAmountRequired:
          l10n.accountsPayable_form_error_automatic_amount_required,
      automaticFirstDueDateRequired:
          l10n.accountsPayable_form_error_automatic_first_due_date_required,
      installmentsCountMismatch:
          l10n.accountsPayable_form_error_installments_count_mismatch,
      taxesRequired: l10n.accountsPayable_form_error_taxes_required,
      taxesInvalid: l10n.accountsPayable_form_error_taxes_invalid,
      taxExemptionReasonRequired:
          l10n.accountsPayable_form_error_tax_exemption_reason_required,
      taxExemptMustNotHaveTaxes:
          l10n.accountsPayable_form_error_tax_exempt_must_not_have_taxes,
      taxStatusMismatch: l10n.accountsPayable_form_error_tax_status_mismatch,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final storeAuth = Provider.of<AuthSessionStore>(context, listen: false);
      final formStore = Provider.of<FormAccountsPayableStore>(
        context,
        listen: false,
      );

      formStore.setSymbolFormatMoney(storeAuth.state.session.symbolFormatMoney);
    });
  }

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
      text: context.l10n.accountsPayable_form_save,
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
        context.l10n.accountsPayable_form_toast_saved_success,
        ToastType.info,
      );
      setState(() {
        showValidationMessages = false;
      });
      context.pop();
    } else if (mounted) {
      Toast.showMessage(
        context.l10n.accountsPayable_form_toast_saved_error,
        ToastType.error,
      );
    }
  }
}
