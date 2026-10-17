import 'package:flutter/material.dart';
import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/utils/app_localizations_ext.dart';
import 'package:gloria_finance/core/widgets/custom_button.dart';
import 'package:gloria_finance/core/widgets/form_controls.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../models/recurring_payment_bill_simulation.dart';
import '../../../store/recurring_payment_execution_store.dart';
import '../../../utils/recurring_payment_boleto.dart';
import 'recurring_payment_execution_field.dart';

/// Digitação da linha digitável.
///
/// O campo é largo por natureza (47 dígitos), então usa fonte monoespaçada e
/// agrupamento visual para não virar uma sopa de números.
class RecurringPaymentBoletoLineStep extends StatelessWidget {
  const RecurringPaymentBoletoLineStep({
    super.key,
    required this.onValidate,
    this.initialLine,
  });

  final Future<void> Function() onValidate;

  /// Linha já lida pela câmera, quando houver.
  final String? initialLine;

  @override
  Widget build(BuildContext context) {
    final store = context.watch<RecurringPaymentExecutionStore>();
    final state = store.state;
    final l10n = context.l10n;
    final line = initialLine ?? state.boletoLine;
    final hasValue = line.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Input(
          label: l10n.recurringPaymentsExecution_boleto_line_label,
          initialValue:
              line.isEmpty ? null : RecurringPaymentBoleto.grouped(line),
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          onChanged: store.setBoletoLine,
        ),
        if (state.billSimulationError != null) ...[
          const SizedBox(height: 10),
          RecurringPaymentExecutionNotice(
            text: switch (state.billSimulationError!) {
              RecurringPaymentBillSimulationError.invalid =>
                l10n.recurringPaymentsExecution_boleto_simulation_invalid,
              RecurringPaymentBillSimulationError.unavailable =>
                l10n.recurringPaymentsExecution_boleto_simulation_unavailable,
              RecurringPaymentBillSimulationError.generic =>
                l10n.recurringPaymentsExecution_boleto_simulation_generic,
            },
            icon: Icons.error_outline,
            color: Colors.red,
          ),
        ],
        const SizedBox(height: 10),
        RecurringPaymentExecutionNotice(
          text: l10n.recurringPaymentsExecution_boleto_read_hint,
          icon: Icons.receipt_long,
          color: AppColors.blue,
        ),
        const SizedBox(height: 20),
        CustomButton(
          text:
              state.isSimulatingBill
                  ? l10n.recurringPaymentsExecution_boleto_simulating
                  : state.billSimulationError ==
                      RecurringPaymentBillSimulationError.unavailable
                  ? l10n.recurringPaymentsExecution_failed_retry
                  : l10n.recurringPaymentsExecution_boleto_validate_action,
          backgroundColor: AppColors.green,
          textColor: Colors.black,
          icon: Icons.arrow_forward,
          onPressed: !hasValue || state.isSimulatingBill ? null : onValidate,
        ),
      ],
    );
  }
}
