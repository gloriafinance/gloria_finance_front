import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/toast.dart';
import 'package:gloria_finance/core/utils/app_localizations_ext.dart';
import 'package:gloria_finance/core/utils/index.dart';
import 'package:gloria_finance/core/widgets/custom_button.dart';
import 'package:gloria_finance/core/widgets/form_controls.dart';
import 'package:gloria_finance/core/widgets/loading.dart';
import 'package:gloria_finance/features/erp/settings/banks/models/bank_model.dart';
import 'package:gloria_finance/features/erp/settings/banks/pages/bank_form/store/bank_form_store.dart';
import 'package:gloria_finance/features/erp/settings/banks/store/bank_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class BankForm extends StatefulWidget {
  const BankForm({super.key});

  @override
  State<BankForm> createState() => _BankFormState();
}

class _BankFormState extends State<BankForm> {
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
        _buildNameField(formStore),
        _buildTagField(formStore),
        _buildAccountTypeField(formStore),
        _buildPixField(formStore),
        _buildInstructionSection(formStore, isMobileLayout: true),
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
            Expanded(child: _buildAccountTypeField(formStore)),
            const SizedBox(width: 24),
            Expanded(child: _buildNameField(formStore)),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _buildTagField(formStore)),
            const SizedBox(width: 24),
            Expanded(child: _buildPixField(formStore)),
          ],
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: _buildActiveToggle(formStore),
        ),
        const SizedBox(height: 24),
        _buildInstructionSection(formStore, isMobileLayout: false),
        const SizedBox(height: 24),
        Align(
          alignment: Alignment.centerRight,
          child: SizedBox(width: 300, child: _buildSubmitButton(formStore)),
        ),
      ],
    );
  }

  Widget _buildNameField(BankFormStore formStore) {
    return Input(
      label: context.l10n.settings_banks_field_name,
      initialValue: formStore.state.name,
      onValidator: _requiredValidator,
      onChanged: formStore.setName,
    );
  }

  Widget _buildTagField(BankFormStore formStore) {
    return Input(
      label: context.l10n.settings_banks_field_tag,
      initialValue: formStore.state.tag,
      onChanged: formStore.setTag,
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

  Widget _buildPixField(BankFormStore formStore) {
    return Input(
      label: context.l10n.settings_banks_field_pix_key,
      initialValue: formStore.state.addressInstancePayment,
      onValidator: _requiredValidator,
      onChanged: formStore.setAddressInstancePayment,
    );
  }

  Widget _buildInstructionSection(
    BankFormStore formStore, {
    required bool isMobileLayout,
  }) {
    if (isMobileLayout) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCodeBankField(formStore),
          _buildAgencyField(formStore),
          _buildAccountField(formStore),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _buildCodeBankField(formStore)),
            const SizedBox(width: 24),
            Expanded(child: _buildAgencyField(formStore)),
            const SizedBox(width: 24),
            Expanded(child: _buildAccountField(formStore)),
          ],
        ),
      ],
    );
  }

  Widget _buildCodeBankField(BankFormStore formStore) {
    return Input(
      label: context.l10n.settings_banks_field_bank_code,
      initialValue: formStore.state.codeBank,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      onValidator: _requiredNumberValidator,
      onChanged: formStore.setCodeBank,
    );
  }

  Widget _buildAgencyField(BankFormStore formStore) {
    return Input(
      label: context.l10n.settings_banks_field_agency,
      initialValue: formStore.state.agency,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      onValidator: _requiredNumberValidator,
      onChanged: formStore.setAgency,
    );
  }

  Widget _buildAccountField(BankFormStore formStore) {
    return Input(
      label: context.l10n.settings_banks_field_account,
      initialValue: formStore.state.account,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      onValidator: _requiredNumberValidator,
      onChanged: formStore.setAccount,
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
