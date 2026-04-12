import 'package:flutter/material.dart';
import 'package:gloria_finance/core/theme/index.dart';
import 'package:gloria_finance/core/toast.dart';
import 'package:gloria_finance/core/utils/app_localizations_ext.dart';
import 'package:gloria_finance/core/utils/index.dart';
import 'package:gloria_finance/core/widgets/custom_button.dart';
import 'package:gloria_finance/features/erp/accounts_payable/pages/register_accounts_payable/validators/form_accounts_payable_validator.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../store/credit_purchase_register_store.dart';
import '../validators/credit_purchase_register_validator.dart';
import 'credit_purchase_sections.dart';
import 'layouts/credit_purchase_desktop_layout.dart';
import 'layouts/credit_purchase_mobile_layout.dart';

class FormCreditPurchase extends StatefulWidget {
  const FormCreditPurchase({super.key});

  @override
  State<FormCreditPurchase> createState() => _FormCreditPurchaseState();
}

class _FormCreditPurchaseState extends State<FormCreditPurchase> {
  final formKey = GlobalKey<FormState>();
  late CreditPurchaseRegisterValidator purchaseValidator;
  late FormAccountsPayableValidator accountsPayableValidator;
  bool showValidationMessages = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    syncCreditPurchaseCurrency(context);

    purchaseValidator = CreditPurchaseRegisterValidator(
      costCenterRequired: 'Centro de custo e obrigatorio',
      purchaseDateRequired: 'Data da compra e obrigatoria',
      totalRequired: 'Total da fatura e obrigatorio',
      itemsRequired: 'Adicione pelo menos um item a compra',
    );

    final l10n = context.l10n;
    accountsPayableValidator = FormAccountsPayableValidator(
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
  }

  @override
  Widget build(BuildContext context) {
    final formStore = Provider.of<CreditPurchaseRegisterStore>(context);

    return SingleChildScrollView(
      child: Column(
        children: [
          Form(
            key: formKey,
            child:
                isMobile(context)
                    ? creditPurchaseMobileLayout(
                      context,
                      formStore,
                      purchaseValidator,
                      accountsPayableValidator,
                      showValidationMessages,
                    )
                    : creditPurchaseDesktopLayout(
                      context,
                      formStore,
                      purchaseValidator,
                      accountsPayableValidator,
                      showValidationMessages,
                    ),
          ),
          isMobile(context)
              ? _saveButton(formStore)
              : Align(
                alignment: Alignment.centerRight,
                child: SizedBox(width: 260, child: _saveButton(formStore)),
              ),
        ],
      ),
    );
  }

  Widget _saveButton(CreditPurchaseRegisterStore formStore) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: CustomButton(
        text: 'Salvar compra a credito',
        backgroundColor: AppColors.green,
        textColor: Colors.black,
        onPressed:
            formStore.purchaseState.makeRequest
                ? null
                : () => _handleSave(formStore),
      ),
    );
  }

  Future<void> _handleSave(CreditPurchaseRegisterStore formStore) async {
    setState(() {
      showValidationMessages = true;
    });

    final isValidForm = formKey.currentState?.validate() ?? false;
    final purchaseErrors = purchaseValidator.validateState(
      formStore.purchaseState,
    );
    final accountsPayableErrors = accountsPayableValidator.validateState(
      formStore.state,
    );

    if (formStore.hasInstallmentsTotalMismatch) {
      purchaseErrors['installmentsTotal'] =
          'La suma de las cuotas debe coincidir con el total de la compra.';
    }

    if (!isValidForm ||
        purchaseErrors.isNotEmpty ||
        accountsPayableErrors.isNotEmpty) {
      final message =
          _firstError(purchaseErrors) ??
          _firstError(accountsPayableErrors) ??
          'Revisa los datos de la compra.';
      Toast.showMessage(message, ToastType.warning);
      return;
    }

    final success = await formStore.send();

    if (!mounted) return;

    if (success) {
      Toast.showMessage(
        'Compra a credito registrada con sucesso',
        ToastType.info,
      );
      context.go('/purchase');
      return;
    }

    Toast.showMessage('Erro ao registrar compra a credito', ToastType.error);
  }

  String? _firstError(Map<String, String> errors) {
    if (errors.isEmpty) {
      return null;
    }

    return errors.values.first;
  }
}
