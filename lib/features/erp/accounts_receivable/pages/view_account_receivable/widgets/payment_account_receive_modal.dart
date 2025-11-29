import 'package:church_finance_bk/core/layout/view_detail_widgets.dart';
import 'package:church_finance_bk/core/theme/index.dart';
import 'package:church_finance_bk/core/toast.dart';
import 'package:church_finance_bk/core/utils/index.dart';
import 'package:church_finance_bk/core/widgets/custom_button.dart';
import 'package:church_finance_bk/core/widgets/form_controls.dart';
import 'package:church_finance_bk/core/widgets/upload_file.dart';
import 'package:church_finance_bk/features/erp//settings/availability_accounts/models/availability_account_model.dart';
import 'package:church_finance_bk/features/erp//settings/availability_accounts/pages/list_availability_accounts/store/availability_accounts_list_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../store/payment_account_receive_store.dart';
import '../validators/payment_form_validator.dart';

class PaymentAccountReceiveModal extends StatefulWidget {
  final PaymentAccountReceiveStore formStore;
  final double totalAmount;

  const PaymentAccountReceiveModal({
    super.key,
    required this.totalAmount,
    required this.formStore,
  });

  @override
  State<PaymentAccountReceiveModal> createState() =>
      _PaymentAccountReceiveModalState();
}

class _PaymentAccountReceiveModalState
    extends State<PaymentAccountReceiveModal> {
  final formKey = GlobalKey<FormState>();
  final validator = PaymentFormValidator();

  @override
  Widget build(BuildContext context) {
    final availabilityStore = Provider.of<AvailabilityAccountsListStore>(
      context,
    );

    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      elevation: 4,
      child: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildDetailRow(
                isMobile(context),
                "Valor total que deve ser pago",
                formatCurrency(widget.totalAmount),
              ),
              SizedBox(height: 20),
              // Monto total a pagar
              _buildTotalAmount(widget.formStore),

              // Cuenta de disponibilidad
              _buildDropdownAvailabilityAccounts(
                availabilityStore,
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
                          text: "Enviar Pagamento",
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

  Widget _buildTotalAmount(PaymentAccountReceiveStore formStore) {
    return Input(
      label: "Valor do Pagamento",
      keyboardType: TextInputType.number,
      inputFormatters: [
        CurrencyInputFormatter(
          leadingSymbol: 'R\$ ',
          useSymbolPadding: true,
          mantissaLength: 2,
          thousandSeparator: ThousandSeparator.Period,
        ),
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

  Widget _buildDropdownAvailabilityAccounts(
    AvailabilityAccountsListStore availabilityStore,
    PaymentAccountReceiveStore formStore,
  ) {
    return Dropdown(
      label: "Conta de disponibilidade",
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

  Widget _buildUploadFile(PaymentAccountReceiveStore formStore) {
    return UploadFile(
      label: "Comprovante da transferência",
      multipartFile: (file) => formStore.setFile(file),
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
      context.go("/accounts-receivables");
      Toast.showMessage("Pagamento com registrado com sucesso", ToastType.info);
    }
  }
}
