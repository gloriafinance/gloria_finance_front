import 'package:flutter/material.dart';
import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/theme/app_fonts.dart';
import 'package:gloria_finance/core/utils/app_localizations_ext.dart';
import 'package:gloria_finance/core/utils/currency_formatter.dart';
import 'package:gloria_finance/core/utils/date_formatter.dart';
import 'package:gloria_finance/core/utils/general.dart';
import 'package:gloria_finance/core/widgets/custom_button.dart';
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
/// Mobile usa bottom sheet; desktop e tablet usam modal central, porque uma
/// folha colada embaixo em uma tela larga afasta o conteúdo da ação.
Future<void> showRecurringPaymentExecutionDetail(
  BuildContext context, {
  required RecurringPaymentCompetenceModel item,
}) {
  if (isMobile(context)) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => RecurringPaymentExecutionDetail(item: item),
    );
  }

  return showDialog<void>(
    context: context,
    builder:
        (_) => Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: RecurringPaymentExecutionDetail(item: item),
          ),
        ),
  );
}

/// Conteúdo do detalhe da competência (público para testes e capturas).
class RecurringPaymentExecutionDetail extends StatelessWidget {
  const RecurringPaymentExecutionDetail({super.key, required this.item});

  final RecurringPaymentCompetenceModel item;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final payment = item.recurringPayment;
    final execution = item.execution;
    final settlement = item.settlement;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
      ),
      padding: const EdgeInsets.fromLTRB(22, 20, 22, 22),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        payment.name,
                        style: const TextStyle(
                          fontFamily: AppFonts.fontTitle,
                          fontSize: 17,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${l10n.recurringPaymentsExecution_period_label}: '
                        '${item.month.slashLabel}',
                        style: const TextStyle(
                          fontFamily: AppFonts.fontText,
                          fontSize: 12.5,
                          color: Color(0xFF5F5F5F),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                RecurringPaymentStatusChip(
                  status: item.status,
                  executionStatus: execution?.status,
                  label:
                      item.status?.friendlyName(l10n) ??
                      l10n.recurringPaymentsExecution_status_unknown,
                ),
              ],
            ),
            const SizedBox(height: 18),
            ..._body(context, execution, settlement),
            const SizedBox(height: 20),
            _actions(context),
          ],
        ),
      ),
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
        // Un mismatch no siempre cierra el intento: si el banco no confirmó el
        // rechazo, la operación puede seguir viva y el usuario tiene que ver por
        // qué no se ofrece un pago nuevo.
        if (execution?.isAmountMismatch ?? false) _mismatchBlock(context),
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
        if (execution?.isAmountMismatch ?? false) _mismatchBlock(context),
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

    return [
      _Note(
        icon: Icons.check_circle_outline,
        color: AppColors.green,
        title: l10n.recurringPaymentsExecution_paid_title,
        description:
            settlement.isManual
                ? l10n.recurringPaymentsExecution_origin_manual
                : l10n.recurringPaymentsExecution_origin_bank,
      ),
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
      _DetailField(
        label: l10n.recurringPaymentsExecution_field_origin,
        value:
            settlement.isManual
                ? l10n.recurringPaymentsExecution_origin_manual
                : l10n.recurringPaymentsExecution_origin_bank,
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
    final amount = execution.effectiveAmount;

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
              execution.method == RecurringPaymentMethodType.PIX
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

  Widget _mismatchBlock(BuildContext context) {
    final l10n = context.l10n;
    final execution = item.execution;
    final expected = item.recurringPayment.amount ?? execution?.amount;
    final providerValue =
        execution?.providerValueInCents == null
            ? null
            : execution!.providerValueInCents! / 100;

    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.red.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.red.withValues(alpha: 0.28)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.recurringPaymentsExecution_boleto_mismatch_title,
            style: const TextStyle(
              fontFamily: AppFonts.fontSubTitle,
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
              color: Color(0xFFA52A2E),
            ),
          ),
          const SizedBox(height: 8),
          if (expected != null)
            _DetailField(
              label: l10n.recurringPaymentsExecution_boleto_expected_value,
              value: CurrencyFormatter.formatCurrency(expected),
            ),
          if (providerValue != null)
            _DetailField(
              label: l10n.recurringPaymentsExecution_boleto_value,
              value: CurrencyFormatter.formatCurrency(providerValue),
            ),
          const SizedBox(height: 6),
          Text(
            l10n.recurringPaymentsExecution_mismatch_message,
            style: _noteStyle,
          ),
        ],
      ),
    );
  }

  Widget _actions(BuildContext context) {
    final l10n = context.l10n;
    final store = context.read<RecurringPaymentMonthlyStore>();
    final settlement = item.settlement;

    final buttons = <Widget>[];

    if (item.isInFlight || item.isBlocked) {
      buttons.add(
        CustomButton(
          text: l10n.recurringPaymentsExecution_blocked_refresh,
          backgroundColor: AppColors.blue,
          textColor: Colors.white,
          icon: Icons.sync,
          onPressed: () {
            Navigator.of(context).pop();
            store.load(force: true);
          },
        ),
      );
    }

    if (item.canRetry) {
      buttons.add(
        CustomButton(
          text: l10n.recurringPaymentsExecution_failed_retry,
          backgroundColor: AppColors.purple,
          textColor: Colors.white,
          icon: Icons.refresh,
          onPressed: () {
            Navigator.of(context).pop();
            openRecurringPaymentExecution(context, item: item);
          },
        ),
      );
    }

    if (settlement?.canBeCancelled ?? false) {
      buttons.add(
        CustomButton(
          text: l10n.recurringPaymentsExecution_cancel_record_action,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          icon: Icons.undo,
          onPressed: () => _confirmCancellation(context, store, settlement!),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final button in buttons) ...[button, const SizedBox(height: 8)],
        CustomButton(
          text: l10n.recurringPaymentsExecution_common_close,
          backgroundColor: AppColors.greyMiddle,
          textColor: Colors.black,
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }

  Future<void> _confirmCancellation(
    BuildContext context,
    RecurringPaymentMonthlyStore store,
    RecurringPaymentSettlementModel settlement,
  ) async {
    final l10n = context.l10n;

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

    await store.cancelRecord(settlement.financialRecordId);
    if (context.mounted) Navigator.of(context).pop();
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
