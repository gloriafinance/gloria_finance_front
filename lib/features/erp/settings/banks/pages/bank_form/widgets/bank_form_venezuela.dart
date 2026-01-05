import 'package:church_finance_bk/core/theme/app_color.dart';
import 'package:church_finance_bk/core/toast.dart';
import 'package:church_finance_bk/core/utils/app_localizations_ext.dart';
import 'package:church_finance_bk/core/utils/index.dart';
import 'package:church_finance_bk/core/widgets/custom_button.dart';
import 'package:church_finance_bk/core/widgets/form_controls.dart';
import 'package:church_finance_bk/core/widgets/loading.dart';
import 'package:church_finance_bk/features/erp/settings/banks/models/bank_model.dart';
import 'package:church_finance_bk/features/erp/settings/banks/pages/bank_form/store/bank_form_store.dart';
import 'package:church_finance_bk/features/erp/settings/banks/store/bank_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class BankFormVenezuela extends StatefulWidget {
  const BankFormVenezuela({super.key});

  @override
  State<BankFormVenezuela> createState() => _BankFormVenezuelaState();
}

class _BankFormVenezuelaState extends State<BankFormVenezuela> {
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final formStore = context.watch<BankFormStore>();

    return SingleChildScrollView(
      child: Form(
        key: formKey,
        child:
            isMobile(context)
                ? _buildMobileLayout(formStore)
                : _buildDesktopLayout(formStore),
      ),
    );
  }

  Widget _buildMobileLayout(BankFormStore formStore) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildBankNameField(formStore),
        _buildHolderNameField(formStore),
        _buildDocumentIdField(formStore),
        _buildAccountTypeField(formStore),
        _buildAccountNumberField(formStore),
        const SizedBox(height: 16),
        _buildActiveToggle(formStore),
        const SizedBox(height: 24),
        _buildSubmitButton(formStore),
      ],
    );
  }

  Widget _buildDesktopLayout(BankFormStore formStore) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _buildBankNameField(formStore)),
            const SizedBox(width: 24),
            Expanded(child: _buildHolderNameField(formStore)),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _buildDocumentIdField(formStore)),
            const SizedBox(width: 24),
            Expanded(child: _buildAccountTypeField(formStore)),
          ],
        ),
        _buildAccountNumberField(formStore),
        const SizedBox(height: 16),
        Align(
          alignment: Alignment.centerLeft,
          child: _buildActiveToggle(formStore),
        ),
        const SizedBox(height: 24),
        Align(
          alignment: Alignment.centerRight,
          child: SizedBox(width: 300, child: _buildSubmitButton(formStore)),
        ),
      ],
    );
  }

  Widget _buildBankNameField(BankFormStore formStore) {
    return Input(
      label: context.l10n.settings_banks_field_name,
      initialValue: formStore.state.name,
      onValidator: _requiredValidator,
      onChanged: formStore.setBankName,
    );
  }

  Widget _buildHolderNameField(BankFormStore formStore) {
    return Input(
      label: context.l10n.settings_banks_field_holder_name,
      initialValue: formStore.state.holderName,
      onValidator: _requiredValidator,
      onChanged: formStore.setHolderName,
    );
  }

  Widget _buildDocumentIdField(BankFormStore formStore) {
    return Input(
      label: context.l10n.settings_banks_field_document_id,
      initialValue: formStore.state.documentId,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      onValidator: _requiredNumberValidator,
      onChanged: formStore.setDocumentId,
    );
  }

  Widget _buildAccountNumberField(BankFormStore formStore) {
    return Input(
      label: context.l10n.settings_banks_field_account,
      initialValue: formStore.state.accountNumber,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      onValidator: _requiredNumberValidator,
      onChanged: formStore.setAccountNumber,
    );
  }

  Widget _buildAccountTypeField(BankFormStore formStore) {
    return Dropdown(
      label: context.l10n.settings_banks_field_account_type,
      initialValue: formStore.state.accountType?.friendlyName,
      items: AccountBankType.values.map((type) => type.friendlyName).toList(),
      onValidator: (value) {
        if (value == null || value.isEmpty) {
          return context.l10n.settings_banks_error_select_account_type;
        }
        return null;
      },
      onChanged: (value) {
        final selected = AccountBankType.values.firstWhere(
          (element) => element.friendlyName == value,
        );
        formStore.setAccountType(selected);
      },
    );
  }

  Widget _buildActiveToggle(BankFormStore formStore) {
    return Row(
      children: [
        Text(context.l10n.settings_banks_field_active),
        Switch(
          value: formStore.state.active,
          onChanged: formStore.setActive,
          activeColor: AppColors.green,
        ),
      ],
    );
  }

  Widget _buildSubmitButton(BankFormStore formStore) {
    if (formStore.state.makeRequest) {
      return const Loading();
    }

    return CustomButton(
      text: context.l10n.settings_banks_save,
      backgroundColor: AppColors.green,
      textColor: Colors.black,
      onPressed: () => _save(formStore),
    );
  }

  Future<void> _save(BankFormStore formStore) async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    final success = await formStore.submit();

    if (success && mounted) {
      Toast.showMessage(
        context.l10n.settings_banks_toast_saved,
        ToastType.info,
      );
      final bankStore = context.read<BankStore>();
      await bankStore.searchBanks();
      context.go('/banks');
    }
  }

  String? _requiredValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return context.l10n.settings_banks_error_required;
    }
    return null;
  }

  String? _requiredNumberValidator(String? value) {
    final requiredError = _requiredValidator(value);
    if (requiredError != null) {
      return requiredError;
    }

    final normalized = value!.trim();
    final isValid = RegExp(r'^\d+$').hasMatch(normalized);
    if (!isValid) {
      return context.l10n.settings_banks_error_invalid_number;
    }

    return null;
  }
}
