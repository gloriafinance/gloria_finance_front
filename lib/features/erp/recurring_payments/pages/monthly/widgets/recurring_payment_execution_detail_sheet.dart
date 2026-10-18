import 'package:flutter/material.dart';
import 'package:gloria_finance/core/layout/modal_page_layout.dart';
import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/toast.dart';
import 'package:gloria_finance/core/theme/app_fonts.dart';
import 'package:gloria_finance/core/utils/app_localizations_ext.dart';
import 'package:gloria_finance/core/utils/currency_formatter.dart';
import 'package:gloria_finance/core/utils/date_formatter.dart';
import 'package:gloria_finance/core/widgets/button_acton_table.dart';
import 'package:gloria_finance/features/erp/settings/availability_accounts/pages/list_availability_accounts/store/availability_accounts_list_store.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../models/recurring_payment_competence_model.dart';
import '../../../models/recurring_payment_competence_status.dart';
import '../../../models/recurring_payment_execution_model.dart';
import '../../../models/recurring_payment_settlement_model.dart';
import '../../../store/recurring_payment_monthly_store.dart';
import '../../execution/recurring_payment_execution_sheet.dart';
import 'recurring_payment_status_chip.dart';

/// Detalhe da competência: o que aconteceu com a operação ou como ela foi paga.
///
/// Usa o `ModalPage` do ERP (título, ações no cabeçalho e X para fechar), sem
/// rodapé de botão cinza: as únicas ações oferecidas são as reais.
Future<void> showRecurringPaymentExecutionDetail(
  BuildContext context, {
  required RecurringPaymentCompetenceModel item,
}) {
  return ModalPage(
    title: item.recurringPayment.name,
    width: 560,
    actions: _detailActions(context, item),
    contentPadding: const EdgeInsets.fromLTRB(20, 16, 20, 22),
    headerSpacing: 14,
    borderRadius: 22,
    backgroundColor: Colors.white,
    body: RecurringPaymentExecutionDetail(item: item),
  ).show<void>(context);
}

/// Ações do cabeçalho, por estado. Nada de "fechar" aqui: o X do modal fecha.
List<Widget> _detailActions(
  BuildContext context,
  RecurringPaymentCompetenceModel item,
) {
  final l10n = context.l10n;
  final store = context.read<RecurringPaymentMonthlyStore>();

  if (item.isInFlight || item.isBlocked) {
    return [
      TextButton.icon(
        onPressed: () {
          Navigator.of(context).pop();
          store.load(force: true);
        },
        icon: const Icon(Icons.sync, size: 18),
        label: Text(l10n.recurringPaymentsExecution_blocked_refresh),
        style: TextButton.styleFrom(foregroundColor: AppColors.blue),
      ),
    ];
  }

  if (item.canRetry) {
    return [
      TextButton.icon(
        onPressed: () {
          Navigator.of(context).pop();
          openRecurringPaymentExecution(context, item: item);
        },
        icon: const Icon(Icons.refresh, size: 18),
        label: Text(l10n.recurringPaymentsExecution_failed_retry),
        style: TextButton.styleFrom(foregroundColor: AppColors.purple),
      ),
    ];
  }

  if (item.settlement?.canBeCancelled ?? false) {
    return [_CancelRecordAction(item: item)];
  }

  return const [];
}

/// Detalhe da competência: o que aconteceu com a operação ou como ela foi paga.
///
/// Conteúdo do detalhe da competência (público para testes e capturas).
class RecurringPaymentExecutionDetail extends StatelessWidget {
  const RecurringPaymentExecutionDetail({super.key, required this.item});

  final RecurringPaymentCompetenceModel item;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final execution = item.execution;
    final settlement = item.settlement;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // O nome já é o título do modal: aqui ficam só o período e o estado.
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                '${l10n.recurringPaymentsExecution_period_label}: '
                '${item.month.slashLabel}',
                style: const TextStyle(
                  fontFamily: AppFonts.fontText,
                  fontSize: 13,
                  color: Color(0xFF5F5F5F),
                ),
              ),
            ),
            if (!item.isPaid || settlement == null) ...[
              const SizedBox(width: 10),
              RecurringPaymentStatusChip(
                status: item.status,
                executionStatus: execution?.status,
                label:
                    item.status?.friendlyName(l10n) ??
                    l10n.recurringPaymentsExecution_status_unknown,
              ),
            ],
          ],
        ),
        const SizedBox(height: 18),
        ..._body(context, execution, settlement),
      ],
    );
  }

  List<Widget> _body(
    BuildContext context,
    RecurringPaymentExecutionModel? execution,
    RecurringPaymentSettlementModel? settlement,
  ) {
    final l10n = context.l10n;

    if (item.isPaid && settlement != null) {
      return _paidBody(context, settlement);
    }

    if (item.isInFlight) {
      return [
        _Note(
          icon: Icons.hourglass_top,
          color: AppColors.blue,
          title: l10n.recurringPaymentsExecution_processing_title,
          description: l10n.recurringPaymentsExecution_processing_description,
        ),
        if (execution != null) ..._executionFields(context, execution),
        const SizedBox(height: 10),
        Text(
          l10n.recurringPaymentsExecution_processing_blocked_note,
          style: _noteStyle,
        ),
      ];
    }

    if (item.isBlocked) {
      return [
        _Note(
          icon: Icons.pause_circle_outline,
          color: AppColors.mustard,
          title: l10n.recurringPaymentsExecution_blocked_title,
          description: l10n.recurringPaymentsExecution_blocked_description,
        ),
        if (execution != null) ..._executionFields(context, execution),
      ];
    }

    if (item.isFailed) {
      return [
        _Note(
          icon: Icons.error_outline,
          color: Colors.red,
          title: l10n.recurringPaymentsExecution_failed_title,
          description: l10n.recurringPaymentsExecution_failed_description,
        ),
        if (execution != null) ..._executionFields(context, execution),
      ];
    }

    // PENDING, UPCOMING, INACTIVE ou estado desconhecido.
    return [
      if (item.status?.isPaid != true)
        _DetailField(
          label: l10n.recurringPaymentsExecution_field_value,
          value: _valueLabel(context),
        ),
      if (item.isPaidButInactive) ...[
        const SizedBox(height: 10),
        Text(
          l10n.recurringPaymentsExecution_paid_inactive_note,
          style: _noteStyle,
        ),
      ],
    ];
  }

  List<Widget> _paidBody(
    BuildContext context,
    RecurringPaymentSettlementModel settlement,
  ) {
    final l10n = context.l10n;
    final accounts =
        context
            .watch<AvailabilityAccountsListStore>()
            .state
            .availabilityAccounts;
    String? accountName;
    for (final account in accounts) {
      if (account.availabilityAccountId == settlement.availabilityAccountId) {
        accountName = account.accountName;
        break;
      }
    }

    final fields = <Widget>[
      _DetailField(
        label: l10n.recurringPaymentsExecution_field_value,
        value: CurrencyFormatter.formatCurrency(settlement.amount),
      ),
      _DetailField(
        label: l10n.recurringPaymentsExecution_field_payment_date,
        value: convertDateFormatToDDMMYYYY(
          settlement.date?.toIso8601String().substring(0, 10),
        ),
      ),
      if (accountName != null)
        _DetailField(
          label: l10n.recurringPaymentsExecution_field_account,
          value: accountName,
        ),
      _DetailField(
        label: l10n.recurringPaymentsExecution_field_voucher,
        value:
            settlement.voucher == null || settlement.voucher!.isEmpty
                ? l10n.recurringPaymentsExecution_voucher_none
                : l10n.recurringPaymentsExecution_voucher_view,
        onTap:
            settlement.voucher == null || settlement.voucher!.isEmpty
                ? null
                : () => launchUrl(
                  Uri.parse(settlement.voucher!),
                  mode: LaunchMode.externalApplication,
                ),
      ),
    ];

    return [
      Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.green.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.green.withValues(alpha: 0.22)),
        ),
        child: _Note(
          icon: Icons.check_circle_outline,
          color: AppColors.green,
          title: l10n.recurringPaymentsExecution_paid_title,
          description:
              settlement.isManual
                  ? l10n.recurringPaymentsExecution_origin_manual
                  : l10n.recurringPaymentsExecution_origin_bank,
        ),
      ),
      const SizedBox(height: 14),
      Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xFFFAFAFA),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.greyMiddle),
        ),
        child: Column(
          children: [
            for (var index = 0; index < fields.length; index++) ...[
              if (index > 0)
                const Divider(height: 1, color: AppColors.greyMiddle),
              fields[index],
            ],
          ],
        ),
      ),
      if (!settlement.isManual) ...[
        const SizedBox(height: 10),
        Text(
          l10n.recurringPaymentsExecution_cancel_reconciled_note,
          style: _noteStyle,
        ),
      ],
    ];
  }

  List<Widget> _executionFields(
    BuildContext context,
    RecurringPaymentExecutionModel execution,
  ) {
    final l10n = context.l10n;
    final amount = execution.amount;

    return [
      if (amount != null)
        _DetailField(
          label: l10n.recurringPaymentsExecution_field_value,
          value: CurrencyFormatter.formatCurrency(amount),
        ),
      if (execution.method != null)
        _DetailField(
          label: l10n.recurringPaymentsExecution_field_method,
          value:
              execution.method == RecurringPaymentMethodType.PIX ||
                      execution.method == RecurringPaymentMethodType.PIX_QR
                  ? l10n.recurringPaymentsExecution_method_pix
                  : l10n.recurringPaymentsExecution_method_bill,
        ),
      if (execution.externalReference.isNotEmpty)
        _DetailField(
          label: l10n.recurringPaymentsExecution_field_reference,
          value: execution.externalReference,
        ),
      if (execution.updatedAt != null)
        _DetailField(
          label: l10n.recurringPaymentsExecution_field_updated_at,
          value:
              '${convertDateFormatToDDMMYYYY(execution.updatedAt!.toIso8601String().substring(0, 10))} '
              '${execution.updatedAt!.toLocal().hour.toString().padLeft(2, '0')}:'
              '${execution.updatedAt!.toLocal().minute.toString().padLeft(2, '0')}',
        ),
    ];
  }

  String _valueLabel(BuildContext context) {
    final payment = item.recurringPayment;
    if (payment.isFixed && payment.amount != null) {
      return CurrencyFormatter.formatCurrency(payment.amount!);
    }
    return context.l10n.recurringPaymentsExecution_value_variable;
  }

  static const TextStyle _noteStyle = TextStyle(
    fontFamily: AppFonts.fontText,
    fontSize: 12,
    height: 1.6,
    color: Color(0xFF5F5F5F),
  );
}

/// Cancelar un registro manual: confirma no próprio modal antes de anular.
class _CancelRecordAction extends StatelessWidget {
  const _CancelRecordAction({required this.item});

  final RecurringPaymentCompetenceModel item;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return ButtonActionTable(
      color: Colors.red.shade700,
      text: l10n.recurringPaymentsExecution_cancel_record_action,
      icon: Icons.undo,
      onPressed: () => _confirm(context),
    );
  }

  Future<void> _confirm(BuildContext context) async {
    final l10n = context.l10n;
    final store = context.read<RecurringPaymentMonthlyStore>();
    final settlement = item.settlement;
    if (settlement == null) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (dialogContext) => AlertDialog(
            title: Text(l10n.recurringPaymentsExecution_cancel_title),
            content: Text(l10n.recurringPaymentsExecution_cancel_message),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(false),
                child: Text(l10n.recurringPaymentsExecution_cancel_dismiss),
              ),
              TextButton(
                onPressed: () => Navigator.of(dialogContext).pop(true),
                child: Text(l10n.recurringPaymentsExecution_cancel_confirm),
              ),
            ],
          ),
    );

    if (confirmed != true || !context.mounted) return;

    final cancelled = await store.cancelRecord(settlement.financialRecordId);
    if (!context.mounted) return;

    Toast.showMessage(
      cancelled
          ? l10n.recurringPaymentsExecution_cancel_success
          : l10n.recurringPaymentsExecution_cancel_error,
      cancelled ? ToastType.success : ToastType.error,
    );
    if (cancelled) Navigator.of(context).pop();
  }
}

class _Note extends StatelessWidget {
  const _Note({
    required this.icon,
    required this.color,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final Color color;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: color),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontFamily: AppFonts.fontSubTitle,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                description,
                style: RecurringPaymentExecutionDetail._noteStyle,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DetailField extends StatelessWidget {
  const _DetailField({required this.label, required this.value, this.onTap});

  final String label;
  final String value;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 132,
            child: Text(
              label,
              style: const TextStyle(
                fontFamily: AppFonts.fontText,
                fontSize: 12.5,
                color: AppColors.grey,
              ),
            ),
          ),
          Expanded(
            child:
                onTap == null
                    ? Text(
                      value,
                      style: const TextStyle(
                        fontFamily: AppFonts.fontSubTitle,
                        fontSize: 13,
                        color: Colors.black,
                      ),
                    )
                    : InkWell(
                      onTap: onTap,
                      child: Text(
                        value,
                        style: const TextStyle(
                          fontFamily: AppFonts.fontSubTitle,
                          fontSize: 13,
                          color: AppColors.blue,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
          ),
        ],
      ),
    );
  }
}
