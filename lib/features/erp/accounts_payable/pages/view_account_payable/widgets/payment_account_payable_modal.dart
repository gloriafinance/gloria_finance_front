import 'package:gloria_finance/core/layout/view_detail_widgets.dart';
import 'package:gloria_finance/core/theme/index.dart';
import 'package:gloria_finance/core/toast.dart';
import 'package:gloria_finance/core/utils/app_localizations_ext.dart';
import 'package:gloria_finance/core/utils/index.dart';
import 'package:gloria_finance/core/widgets/index.dart';
import 'package:gloria_finance/features/erp/settings/availability_accounts/models/availability_account_model.dart';
import 'package:gloria_finance/features/erp/settings/availability_accounts/pages/list_availability_accounts/store/availability_accounts_list_store.dart';
import 'package:gloria_finance/features/erp/settings/cost_center/store/cost_center_list_store.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../store/payment_account_payable_state.dart';
import '../validators/payment_account_payable_validator.dart';

class PaymentAccountPayableModal extends StatefulWidget {
  final PaymentAccountPayableStore formStore;
  final double totalAmount;

  const PaymentAccountPayableModal({
    super.key,
    required this.totalAmount,
    required this.formStore,
  });

  @override
  State<StatefulWidget> createState() => _PaymentAccountPayableModal();
}

class _PaymentAccountPayableModal extends State<PaymentAccountPayableModal> {
  final formKey = GlobalKey<FormState>();
  final validator = PaymentAccountPayableValidator();

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      elevation: 0,
      child: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildDetailRow(
                isMobile(context),
                context.l10n.accountsPayable_payment_total_label,
                formatCurrency(widget.totalAmount),
              ),
              SizedBox(height: 20),
              _buildTotalAmount(widget.formStore),

              // Cuenta de disponibilidad
              _buildDropdownAvailabilityAccounts(
                Provider.of<AvailabilityAccountsListStore>(context),
                widget.formStore,
              ),
              SizedBox(height: 20),
              // Centro de costo
              _buildDropdownCostCenter(
                Provider.of<CostCenterListStore>(context),
                widget.formStore,
              ),

              // Comprobante de transferencia (solo si es movimiento bancario)
              Builder(
                builder: (context) {
                  // Acceso al estado más reciente
                  if (widget.formStore.state.isMovementBank) {
                    return _buildUploadFile(widget.formStore);
                  }
                  return const SizedBox.shrink();
                },
              ),
              const SizedBox(height: 24),

              // Botón de guardar
              Center(
                child:
                    widget.formStore.state.makeRequest
                        ? const CircularProgressIndicator()
                        : CustomButton(
                          text: context.l10n.accountsPayable_payment_submit,
                          backgroundColor: AppColors.green,
                          textColor: Colors.white,
                          onPressed: () => _handleSubmit(),
                        ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleSubmit() async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    setState(() {});

    final result = await widget.formStore.sendPayment();
    if (result) {
      Navigator.of(context).pop();
      context.go("/accounts-payable/list");
      Toast.showMessage(
        context.l10n.accountsPayable_payment_toast_success,
        ToastType.info,
      );
    }
  }

  Widget _buildUploadFile(PaymentAccountPayableStore formStore) {
    return UploadFile(
      label: context.l10n.accountsPayable_payment_receipt_label,
      multipartFile: (file) => formStore.setFile(file),
    );
  }

  Widget _buildDropdownCostCenter(
    CostCenterListStore costCenterStore,
    PaymentAccountPayableStore formStore,
  ) {
    return Dropdown(
      label: context.l10n.accountsPayable_payment_cost_center_label,
      items: costCenterStore.state.costCenters.map((e) => e.name).toList(),
      onChanged: (value) {
        final selectedCostCenter = costCenterStore.state.costCenters.firstWhere(
          (e) => e.name == value,
        );
        formStore.setCostCenterId(selectedCostCenter.costCenterId);
      },
    );
  }

  Widget _buildDropdownAvailabilityAccounts(
    AvailabilityAccountsListStore availabilityStore,
    PaymentAccountPayableStore formStore,
  ) {
    return Dropdown(
      label: context.l10n.accountsPayable_payment_availability_account_label,
      items:
          availabilityStore.state.availabilityAccounts
              .where((a) => a.accountType != AccountType.INVESTMENT.apiValue)
              .map((a) => a.accountName)
              .toList(),
      onChanged: (value) {
        if (value == null) return;

        final selectedAccount = availabilityStore.state.availabilityAccounts
            .firstWhere((e) => e.accountName == value);

        // Actualizar primero la cuenta de disponibilidad
        formStore.setAvailabilityAccountId(
          selectedAccount.availabilityAccountId,
        );

        // Luego actualizar si es movimiento bancario según el tipo de cuenta
        final isBankAccount =
            selectedAccount.accountType == AccountType.BANK.apiValue;
        formStore.setIsMovementBank(isBankAccount);

        // Forzar actualización del estado para que se muestre/oculte el campo de comprobante
        setState(() {});
      },
      onValidator: validator.byField(formStore.state, 'availabilityAccountId'),
    );
  }

  Widget _buildTotalAmount(PaymentAccountPayableStore formStore) {
    return Input(
      label: context.l10n.accountsPayable_payment_amount_label,
      keyboardType: TextInputType.number,
      inputFormatters: [
        CurrencyFormatter.getInputFormatters(CurrencyType.REAL.apiValue),
      ],
      onChanged: (value) {
        final cleanedValue = value
            .replaceAll(RegExp(r'[^\d,]'), '')
            .replaceAll(',', '.');
        if (cleanedValue.isNotEmpty) {
          formStore.setAmount(double.parse(cleanedValue));
        }
      },
      onValidator: validator.byField(formStore.state, 'amount'),
    );
  }
}
