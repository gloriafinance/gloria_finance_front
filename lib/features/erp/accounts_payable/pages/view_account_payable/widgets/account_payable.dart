import 'package:church_finance_bk/core/layout/modal_page_layout.dart';
import 'package:church_finance_bk/core/layout/view_detail_widgets.dart';
import 'package:church_finance_bk/core/theme/index.dart';
import 'package:church_finance_bk/core/utils/app_localizations_ext.dart';
import 'package:church_finance_bk/core/utils/index.dart';
import 'package:church_finance_bk/core/widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../models/installment_model.dart';
import '../../../../widgets/installments_table.dart';
import '../../../models/accounts_payable_model.dart';
import '../store/payment_account_payable_state.dart';
import 'payment_account_payable_modal.dart';

class AccountPayable extends StatefulWidget {
  final AccountsPayableModel account;

  const AccountPayable({super.key, required this.account});

  @override
  State<AccountPayable> createState() => _AccountPayableState();
}

class _AccountPayableState extends State<AccountPayable> {
  @override
  Widget build(BuildContext context) {
    final formStore = Provider.of<PaymentAccountPayableStore>(context);
    var mobile = isMobile(context);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _generalInformation(mobile),
            const SizedBox(height: 24),
            Card(
              elevation: 0,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [_getProvider(mobile)],
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

  Widget _listingInstallments(PaymentAccountPayableStore formStore) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildSectionTitle(context.l10n.accountsPayable_view_installments_title),
        InstallmentsTable(
          setInstallmentIds: formStore.setInstallmentIds,
          installments: widget.account.installments,
        ),
        const SizedBox(height: 16),
        if (formStore.state.anyInstallmentSelected())
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
             children: [
              CustomButton(
                text: context.l10n.accountsPayable_view_register_payment,
                backgroundColor: AppColors.green,
                textColor: Colors.white,
                onPressed: () => _handlePayment(formStore),
              ),
            ],
          ),
      ],
    );
  }

  Widget _getProvider(bool isMobile) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildSectionTitle(context.l10n.accountsPayable_view_provider_section),
          const SizedBox(height: 16),
          buildDetailRow(
            isMobile,
            context.l10n.accountsPayable_view_provider_name,
            widget.account.supplier?.name ?? 'N/A',
          ),
          buildDetailRow(
            isMobile,
            context.l10n.accountsPayable_view_provider_dni,
            widget.account.supplier?.dni ?? 'N/A',
          ),
          buildDetailRow(
            isMobile,
            context.l10n.accountsPayable_view_provider_phone,
            widget.account.supplier?.phone ?? 'N/A',
          ),
          buildDetailRow(
            isMobile,
            context.l10n.accountsPayable_view_provider_email,
            widget.account.supplier?.email ?? 'N/A',
          ),
          buildDetailRow(
            isMobile,
            context.l10n.accountsPayable_view_provider_type,
            widget.account.supplier?.getType() ?? 'N/A',
          ),
        ],
      ),
    );
  }

  Widget _generalInformation(bool isMobile) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildSectionTitle(context.l10n.accountsPayable_view_general_section),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: buildDetailRow(
                  false,
                  context.l10n.accountsPayable_view_general_created,
                  widget.account.createdAtFormatted,
                ),
              ),
              Expanded(
                flex: 1,
                child: buildDetailRow(
                  false,
                  context.l10n.accountsPayable_view_general_updated,
                  widget.account.updatedAtFormatted,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 20 : 140,
                  ),
                  child: tagStatus(
                    getStatusColor(widget.account.status ?? ''),
                    widget.account.statusLabel,
                  ),
                ),
              ),
            ],
          ),
          buildDetailRow(
            false,
            context.l10n.accountsPayable_view_general_description,
            widget.account.description,
          ),
          buildDetailRow(
            false,
            context.l10n.accountsPayable_view_general_total,
            formatCurrency(widget.account.amountTotal ?? 0),
          ),
          buildDetailRow(
            false,
            context.l10n.accountsPayable_view_general_paid,
            formatCurrency(widget.account.amountPaid ?? 0),
            statusColor: AppColors.green,
          ),
          buildDetailRow(
            false,
            context.l10n.accountsPayable_view_general_pending,
            formatCurrency(widget.account.amountPending ?? 0),
            statusColor:
                widget.account.amountPending! > 0
                    ? AppColors.mustard
                    : AppColors.green,
          ),
        ],
      ),
    );
  }

  void _handlePayment(PaymentAccountPayableStore formStore) {
    double totalAmount = 0;

    for (var installmentId in formStore.state.installmentIds) {
      final installment = widget.account.installments.firstWhere(
        (element) => element.installmentId == installmentId,
        orElse: () => InstallmentModel(amount: 0, dueDate: ''),
      );
      totalAmount += installment.amountPending ?? installment.amount;
    }

    formStore.setAccountPayableId(widget.account.accountPayableId!);

    ModalPage(
      title: "Registrar Pagamento",
      body: PaymentAccountPayableModal(
        formStore: formStore,
        totalAmount: totalAmount,
      ),
    ).show(context);
  }
}
