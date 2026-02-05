import 'package:gloria_finance/core/layout/modal_page_layout.dart';
import 'package:gloria_finance/core/layout/view_detail_widgets.dart';
import 'package:gloria_finance/core/theme/index.dart';
import 'package:gloria_finance/core/utils/app_localizations_ext.dart';
import 'package:gloria_finance/core/utils/index.dart';
import 'package:gloria_finance/core/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../models/installment_model.dart';
import '../../../../widgets/installments_table.dart';
import '../../../models/accounts_receivable_model.dart';
import '../store/payment_account_receive_store.dart';
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
    final formStore = Provider.of<PaymentAccountReceiveStore>(context);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Información general
            _generalInformation(isMobile(context)),

            const SizedBox(height: 24),

            // Información del deudor
            Card(
              elevation: 0,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildSectionTitle(
                      context.l10n.accountsReceivable_view_debtor_section,
                    ),
                    const SizedBox(height: 16),
                    buildDetailRow(
                      isMobile(context),
                      context.l10n.accountsReceivable_view_debtor_name,
                      widget.account.debtor.name,
                    ),
                    buildDetailRow(
                      isMobile(context),
                      context.l10n.accountsReceivable_view_debtor_dni,
                      widget.account.debtor.debtorDNI ?? 'N/A',
                    ),
                    buildDetailRow(
                      isMobile(context),
                      context.l10n.accountsReceivable_view_debtor_type,
                      widget.account.debtor.getDebtorType() ?? 'N/A',
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            _listingInstallments(formStore),
          ],
        ),
      ),
    );
  }

  Widget _listingInstallments(PaymentAccountReceiveStore formStore) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildSectionTitle(
          context.l10n.accountsReceivable_view_installments_title,
        ),
        InstallmentsTable(
          setInstallmentIds: formStore.setInstallmentIds,
          installments: widget.account.installments,
          symbol: widget.account.symbol,
        ),

        const SizedBox(height: 16),

        // Botones para acciones en parcelas seleccionadas
        if (formStore.state.anyInstallmentSelected())
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              CustomButton(
                text: context.l10n.accountsReceivable_view_register_payment,
                backgroundColor: AppColors.green,
                textColor: Colors.white,
                onPressed: () => _handlePayment(formStore),
              ),
            ],
          ),
      ],
    );
  }

  Widget _generalInformation(bool isMobile) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildSectionTitle(
            context.l10n.accountsReceivable_view_general_section,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: buildDetailRow(
                  false,
                  context.l10n.accountsReceivable_view_general_created,
                  widget.account.createdAtFormatted,
                ),
              ),
              Expanded(
                flex: 1,
                child: buildDetailRow(
                  false,
                  context.l10n.accountsReceivable_view_general_updated,
                  widget.account.updatedAtFormatted,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 20 : 140,
                  ),
                  child: tagStatus(
                    getStatusColor(widget.account.status ?? 'N/A'),
                    AccountsReceivableStatus.values
                        .firstWhere(
                          (e) =>
                              e.toString().split('.').last ==
                              widget.account.status,
                        )
                        .friendlyName,
                  ),
                ),
              ),
            ],
          ),
          buildDetailRow(
            false,
            context.l10n.accountsReceivable_view_general_description,
            widget.account.description,
          ),
          buildDetailRow(
            false,
            context.l10n.accountsReceivable_view_general_type,
            widget.account.type?.friendlyName ?? '-',
          ),
          buildDetailRow(
            false,
            context.l10n.accountsReceivable_view_general_total,
            formatCurrency(
              widget.account.amountTotal ?? 0,
              symbol: widget.account.symbol,
            ),
          ),
          buildDetailRow(
            false,
            context.l10n.accountsReceivable_view_general_paid,
            formatCurrency(
              widget.account.amountPaid ?? 0,
              symbol: widget.account.symbol,
            ),
            statusColor: AppColors.green,
          ),
          buildDetailRow(
            false,
            context.l10n.accountsReceivable_view_general_pending,
            formatCurrency(
              widget.account.amountPending ?? 0,
              symbol: widget.account.symbol,
            ),
            statusColor:
                widget.account.amountPending! > 0
                    ? AppColors.mustard
                    : AppColors.green,
          ),
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

    formStore.setAccountReceivableId(widget.account.accountReceivableId!);

    ModalPage(
      title: context.l10n.accountsReceivable_view_register_payment,
      body: PaymentAccountReceiveModal(
        formStore: formStore,
        totalAmount: totalAmount,
      ),
    ).show(context);
  }

  // Obtiene un widget de texto con color según el estado
}
