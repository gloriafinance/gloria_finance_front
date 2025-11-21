import 'package:church_finance_bk/core/theme/app_color.dart';
import 'package:church_finance_bk/core/theme/app_fonts.dart';
import 'package:church_finance_bk/core/widgets/form_controls.dart';
import 'package:church_finance_bk/core/widgets/upload_file.dart';
import 'package:church_finance_bk/helpers/currency_formatter.dart';
import 'package:church_finance_bk/helpers/date_formatter.dart';
import 'package:church_finance_bk/settings/availability_accounts/models/availability_account_model.dart';
import 'package:church_finance_bk/settings/availability_accounts/pages/list_availability_accounts/store/availability_accounts_list_store.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../models/installment_model.dart';
import '../../../models/accounts_receivable_model.dart';
import '../store/payment_declaration_store.dart';

class PaymentDeclarationForm extends StatefulWidget {
  final AccountsReceivableModel commitment;
  final InstallmentModel installment;

  const PaymentDeclarationForm({
    super.key,
    required this.commitment,
    required this.installment,
  });

  @override
  State<PaymentDeclarationForm> createState() => _PaymentDeclarationFormState();
}

class _PaymentDeclarationFormState extends State<PaymentDeclarationForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _prefilledAmount = false;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PaymentDeclarationStore(),
      child: Consumer2<PaymentDeclarationStore, AvailabilityAccountsListStore>(
        builder: (context, declarationStore, availabilityStore, _) {
          if (!_prefilledAmount) {
            _prefilledAmount = true;
            declarationStore.setAmount(widget.installment.amount);
          }

          final state = declarationStore.state;
          final accounts = availabilityStore.state.availabilityAccounts
              .where((account) => account.active)
              .toList();

          if (accounts.isNotEmpty &&
              declarationStore.state.availabilityAccountId == null) {
            declarationStore.setAvailabilityAccount(accounts.first.availabilityAccountId);
          }

          return Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _commitmentInfo(),
                const SizedBox(height: 12),
                _availabilityDropdown(declarationStore, accounts),
                _amountField(declarationStore),
                _voucherPicker(declarationStore),
                if (state.errorMessage != null) _errorText(state.errorMessage!),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton.icon(
                    icon: state.isSubmitting
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.check),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.purple,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    ),
                    onPressed: state.isSubmitting
                        ? null
                        : () async {
                            final canProceed = _formKey.currentState?.validate() ?? false;
                            if (!canProceed) return;

                            final success = await declarationStore.submit(
                              widget.commitment,
                              widget.installment,
                            );

                            if (success && mounted) {
                              Navigator.of(context).pop();
                            }
                          },
                    label: Text(
                      state.isSubmitting ? 'Enviando...' : 'Declarar pagamento',
                      style: const TextStyle(fontFamily: AppFonts.fontSubTitle),
                    ),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _commitmentInfo() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.greyLight.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.commitment.description,
            style: const TextStyle(fontFamily: AppFonts.fontTitle, fontSize: 16),
          ),
          const SizedBox(height: 4),
          Text(
            'Parcela ${widget.installment.sequence ?? ''} · Vence em ${convertDateFormatToDDMMYYYY(widget.installment.dueDate)}',
            style: const TextStyle(fontFamily: AppFonts.fontSubTitle),
          ),
        ],
      ),
    );
  }

  Widget _availabilityDropdown(
    PaymentDeclarationStore declarationStore,
    List<AvailabilityAccountModel> accounts,
  ) {
    if (accounts.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'Conta de origem',
            style: TextStyle(
              color: AppColors.purple,
              fontFamily: AppFonts.fontTitle,
              fontSize: 15,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Nenhuma conta de disponibilidade encontrada. Adicione uma conta para continuar.',
            style: TextStyle(fontFamily: AppFonts.fontSubTitle),
          ),
        ],
      );
    }

    AvailabilityAccountModel? selected;
    if (declarationStore.state.availabilityAccountId != null) {
      try {
        selected = accounts.firstWhere(
          (account) =>
              account.availabilityAccountId == declarationStore.state.availabilityAccountId,
        );
      } catch (_) {
        selected = null;
      }
    }

    final selectedLabel = selected?.accountName;

    return Dropdown(
      label: 'Conta de origem',
      items: accounts.map((a) => a.accountName).toList(),
      initialValue: selectedLabel,
      onChanged: (value) {
        final account = accounts.firstWhere((a) => a.accountName == value);
        declarationStore.setAvailabilityAccount(account.availabilityAccountId);
      },
      onValidator: (value) {
        if (value == null || value.isEmpty) {
          return 'Selecione a conta de origem';
        }
        return null;
      },
    );
  }

  Widget _amountField(PaymentDeclarationStore declarationStore) {
    final formatter = CurrencyFormatter.getInputFormatters('R\$');

    return Input(
      label: 'Valor pago',
      initialValue: CurrencyFormatter.formatCurrency(widget.installment.amount),
      keyboardType: TextInputType.number,
      inputFormatters: [formatter],
      onChanged: (value) {
        final cleaned = CurrencyFormatter.cleanCurrency(value);
        declarationStore.setAmount(cleaned);
      },
      onValidator: (value) {
        if (value == null || value.isEmpty) {
          return 'Informe o valor pago';
        }
        final cleaned = CurrencyFormatter.cleanCurrency(value);
        if (cleaned <= 0) {
          return 'O valor deve ser maior que zero';
        }
        return null;
      },
    );
  }

  Widget _voucherPicker(PaymentDeclarationStore declarationStore) {
    return UploadFile(
      label: 'Comprovante (imagem ou PDF)',
      multipartFile: (file) {
        declarationStore.setVoucher(file);
      },
    );
  }

  Widget _errorText(String message) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: Colors.red),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(color: Colors.red, fontFamily: AppFonts.fontSubTitle),
            ),
          ),
        ],
      ),
    );
  }
}
