import 'package:flutter/material.dart';
import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/utils/app_localizations_ext.dart';
import 'package:gloria_finance/core/widgets/button_acton_table.dart';
import 'package:provider/provider.dart';

import '../../../models/recurring_payment_competence_model.dart';
import '../../../store/recurring_payment_monthly_store.dart';
import '../../execution/recurring_payment_execution_sheet.dart';
import 'recurring_payment_execution_detail_sheet.dart';

/// Ações de uma competência, que mudam com o estado.
///
/// - PENDING/UPCOMING: executar (PAGAR com banca, REGISTRAR PAGAMENTO sem ela).
/// - PROCESSING/BLOCKED: nada de nova operação, só consultar o estado.
/// - FAILED: o intento terminou, então pode ser repetido como execução nova.
/// - PAID: só informa (e permite cancelar o registro quando é manual).
class RecurringPaymentMonthlyActions extends StatelessWidget {
  const RecurringPaymentMonthlyActions({
    super.key,
    required this.item,
    required this.hasBanking,
    this.expanded = false,
  });

  final RecurringPaymentCompetenceModel item;
  final bool hasBanking;

  /// No card (mobile/tablet) a ação principal ocupa a largura toda.
  final bool expanded;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final store = context.read<RecurringPaymentMonthlyStore>();
    final inFlight = store.state.inFlight;

    // Enquanto existe uma operação viva no mês, nenhum outro pagamento começa:
    // o backend recusaria e a tela não deve oferecer o que será negado.
    final blockedByInFlight = inFlight != null && inFlight.id != item.id;

    if (item.canExecute) {
      if (blockedByInFlight) {
        return _detailsButton(context);
      }

      final label =
          hasBanking
              ? l10n.recurringPaymentsExecution_pay_action
              : l10n.recurringPaymentsExecution_register_action;

      return _withDetails(
        context,
        primary: _primary(
          ButtonActionTable(
            color: AppColors.purple,
            text: label,
            icon: Icons.payments_outlined,
            onPressed: () => openRecurringPaymentExecution(context, item: item),
          ),
        ),
      );
    }

    if (item.canRetry) {
      return _withDetails(
        context,
        primary: _primary(
          ButtonActionTable(
            color: AppColors.purple,
            text: l10n.recurringPaymentsExecution_failed_retry,
            icon: Icons.refresh,
            onPressed: () => openRecurringPaymentExecution(context, item: item),
          ),
        ),
      );
    }

    if (item.isInFlight || item.isBlocked) {
      return _withDetails(
        context,
        primary: _primary(
          ButtonActionTable(
            color: AppColors.blue,
            text: l10n.recurringPaymentsExecution_blocked_refresh,
            icon: Icons.sync,
            onPressed: () => store.load(force: true),
          ),
        ),
      );
    }

    return _detailsButton(context);
  }

  Widget _withDetails(BuildContext context, {required Widget primary}) {
    if (expanded) {
      return Column(
        children: [
          primary,
          const SizedBox(height: 8),
          _detailsButton(context, expanded: true),
        ],
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [primary, const SizedBox(width: 4), _detailsButton(context)],
    );
  }

  Widget _detailsButton(BuildContext context, {bool expanded = false}) {
    final button = ButtonActionTable(
      color: AppColors.grey,
      text: context.l10n.recurringPaymentsExecution_details_action,
      icon: Icons.info_outline,
      onPressed: () => showRecurringPaymentExecutionDetail(context, item: item),
    );

    return expanded ? SizedBox(width: double.infinity, child: button) : button;
  }

  /// No card a ação principal ocupa a largura toda; na tabela é compacta.
  Widget _primary(ButtonActionTable button) =>
      expanded ? SizedBox(width: double.infinity, child: button) : button;
}
