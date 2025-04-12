import 'package:church_finance_bk/core/layout/modal_page_layout.dart';
import 'package:church_finance_bk/core/layout/view_detail_widgets.dart';
import 'package:church_finance_bk/core/theme/index.dart';
import 'package:church_finance_bk/core/widgets/index.dart';
import 'package:church_finance_bk/helpers/index.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/accounts_receivable_model.dart';
import '../../../models/installment_model.dart';
import '../store/payment_account_receive_store.dart';
import 'installments_table.dart';
import 'payment_account_receive_modal.dart';

class AccountReceive extends StatefulWidget {
  final AccountsReceivableModel account;

  const AccountReceive({super.key, required this.account});

  @override
  State<AccountReceive> createState() => _AccountReceiveState();
}

class _AccountReceiveState extends State<AccountReceive> {
  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    final formStore = Provider.of<PaymentAccountReceiveStore>(context);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Información general
            _generalInformation(isMobile, formStore),

            const SizedBox(height: 24),

            // Información del deudor
            Card(
              elevation: 0,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildSectionTitle('Informações do Devedor'),
                    const SizedBox(height: 16),
                    buildDetailRow(
                        isMobile, 'Nome', widget.account.debtor.name),
                    buildDetailRow(isMobile, 'CPF/CNPJ',
                        widget.account.debtor.debtorDNI ?? 'N/A'),
                    buildDetailRow(isMobile, 'Tipo de devedor',
                        widget.account.debtor.getDebtorType() ?? 'N/A'),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            _listingInstallments(formStore)
          ],
        ),
      ),
    );
  }

  Widget _listingInstallments(PaymentAccountReceiveStore formStore) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildSectionTitle('Listagem de Parcelas'),
        InstallmentsTable(
            paymentAccountReceiveStore: formStore,
            installments: widget.account.installments),

        const SizedBox(height: 16),

        // Botones para acciones en parcelas seleccionadas
        if (formStore.state.anyInstallmentSelected())
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              CustomButton(
                text: 'Registrar Pagamento',
                backgroundColor: AppColors.green,
                textColor: Colors.white,
                onPressed: () => _handlePayment(formStore),
              )
            ],
          ),
      ],
    );
  }

  Widget _generalInformation(
      bool isMobile, PaymentAccountReceiveStore formStore) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildSectionTitle('Informações Gerais'),
          const SizedBox(height: 16),
          Row(children: [
            Expanded(
                flex: 1,
                child: buildDetailRow(
                    false, 'Criado', widget.account.createdAtFormatted)),
            Expanded(
              flex: 1,
              child: buildDetailRow(
                  false, 'Atualizado', widget.account.updatedAtFormatted),
            ),
            Expanded(
                child: buildDetailRow(
              false,
              'Estado',
              widget.account.status ?? 'N/A',
              statusColor: _getStatusColor(widget.account.status),
            ))
          ]),
          buildDetailRow(false, 'Descrição', widget.account.description),
          buildDetailRow(
            false,
            'Valor Total',
            formatCurrency(widget.account.amountTotal ?? 0),
          ),
          buildDetailRow(
            false,
            'Valor Pago',
            formatCurrency(widget.account.amountPaid ?? 0),
            statusColor: AppColors.green,
          ),
          buildDetailRow(
            false,
            'Valor Pendente',
            formatCurrency(widget.account.amountPending ?? 0),
            statusColor: widget.account.amountPending! > 0
                ? AppColors.mustard
                : AppColors.green,
          )
        ],
      ),
    );
  }

  // Maneja el registro de pago para las parcelas seleccionadas
  void _handlePayment(PaymentAccountReceiveStore formStore) {
    double totalAmount = 0;
    for (var installmentId in formStore.state.installmentIds) {
      final installment = widget.account.installments.firstWhere(
        (element) => element.installmentId == installmentId,
        orElse: () => InstallmentModel(amount: 0, dueDate: ''),
      );
      totalAmount += installment.amountPending ?? installment.amount;
    }

    formStore.setAccountReceivableId(widget.account.accountReceivableId ?? '');

    ModalPage(
      title: "Registrar Pagamento",
      body: PaymentAccountReceiveModal(
        formStore: formStore,
        totalAmount: totalAmount,
      ),
    ).show(context);
  }

  // Obtiene el color según el estado
  Color? _getStatusColor(String? status) {
    if (status == null) return null;

    switch (status) {
      case 'PAID':
        return AppColors.green;
      case 'PENDING':
        return AppColors.mustard;
      default:
        return null;
    }
  }

// Obtiene un widget de texto con color según el estado
}
