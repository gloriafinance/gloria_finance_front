import 'package:church_finance_bk/core/theme/app_color.dart';
import 'package:church_finance_bk/core/toast.dart';
import 'package:church_finance_bk/core/widgets/custom_button.dart';
import 'package:church_finance_bk/core/widgets/form_controls.dart';
import 'package:church_finance_bk/core/widgets/loading.dart';
import 'package:church_finance_bk/helpers/index.dart';
import 'package:church_finance_bk/settings/banks/models/bank_model.dart';
import 'package:church_finance_bk/settings/banks/pages/bank_form/store/bank_form_store.dart';
import 'package:church_finance_bk/settings/banks/store/bank_store.dart';
import 'package:flutter/material.dart';
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
        child: isMobile(context)
            ? _buildMobileLayout(formStore)
            : _buildDesktopLayout(formStore),
      ),
    );
  }

  Widget _buildMobileLayout(BankFormStore formStore) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildBankIdField(formStore),
        _buildNameField(formStore),
        _buildTagField(formStore),
        _buildAccountTypeField(formStore),
        _buildAddressField(formStore),
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
            Expanded(child: _buildBankIdField(formStore)),
            const SizedBox(width: 24),
            Expanded(child: _buildAccountTypeField(formStore)),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _buildNameField(formStore)),
            const SizedBox(width: 24),
            Expanded(child: _buildTagField(formStore)),
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _buildAddressField(formStore)),
            const SizedBox(width: 24),
            Expanded(child: _buildActiveToggle(formStore)),
          ],
        ),
        const SizedBox(height: 24),
        _buildInstructionSection(formStore, isMobileLayout: false),
        const SizedBox(height: 24),
        Align(
          alignment: Alignment.centerRight,
          child: SizedBox(
            width: 300,
            child: _buildSubmitButton(formStore),
          ),
        ),
      ],
    );
  }

  Widget _buildBankIdField(BankFormStore formStore) {
    return Input(
      label: 'Identificador do banco (bankId)',
      initialValue: formStore.state.bankId,
      onValidator: _requiredValidator,
      onChanged: formStore.setBankId,
    );
  }

  Widget _buildNameField(BankFormStore formStore) {
    return Input(
      label: 'Nome',
      initialValue: formStore.state.name,
      onValidator: _requiredValidator,
      onChanged: formStore.setName,
    );
  }

  Widget _buildTagField(BankFormStore formStore) {
    return Input(
      label: 'Tag',
      initialValue: formStore.state.tag,
      onChanged: formStore.setTag,
    );
  }

  Widget _buildAccountTypeField(BankFormStore formStore) {
    return Dropdown(
      label: 'Tipo de conta',
      initialValue: formStore.state.accountType?.friendlyName,
      items: AccountBankType.values
          .map((type) => type.friendlyName)
          .toList(),
      onValidator: (value) {
        if (value == null || value.isEmpty) {
          return 'Selecione o tipo de conta';
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

  Widget _buildAddressField(BankFormStore formStore) {
    return Input(
      label: 'Endereço de pagamento',
      initialValue: formStore.state.addressInstancePayment,
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
      label: 'Código do banco',
      initialValue: formStore.state.codeBank,
      onValidator: _requiredValidator,
      onChanged: formStore.setCodeBank,
    );
  }

  Widget _buildAgencyField(BankFormStore formStore) {
    return Input(
      label: 'Agência',
      initialValue: formStore.state.agency,
      onValidator: _requiredValidator,
      onChanged: formStore.setAgency,
    );
  }

  Widget _buildAccountField(BankFormStore formStore) {
    return Input(
      label: 'Conta',
      initialValue: formStore.state.account,
      onValidator: _requiredValidator,
      onChanged: formStore.setAccount,
    );
  }

  Widget _buildActiveToggle(BankFormStore formStore) {
    return Row(
      children: [
        const Text('Ativo'),
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
      text: 'Salvar',
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
      Toast.showMessage('Registro salvo com sucesso', ToastType.info);
      final bankStore = context.read<BankStore>();
      await bankStore.searchBanks();
      context.go('/banks');
    }
  }

  String? _requiredValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Campo obrigatório';
    }
    return null;
  }
}
