import 'package:flutter/material.dart';
import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/theme/app_fonts.dart';
import 'package:gloria_finance/core/utils/app_localizations_ext.dart';
import 'package:gloria_finance/core/widgets/custom_button.dart';
import 'package:gloria_finance/core/widgets/form_controls.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../models/recurring_payment_bill_simulation.dart';
import '../../../store/recurring_payment_execution_store.dart';
import '../../../utils/recurring_payment_boleto.dart';
import 'recurring_payment_execution_field.dart';

/// Digitação ou colagem da linha digitável.
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
          hintText: l10n.recurringPaymentsExecution_boleto_line_hint,
          initialValue:
              line.isEmpty ? null : RecurringPaymentBoleto.grouped(line),
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          iconRight: const Icon(Icons.content_paste_outlined),
          onIconTap: () => _pasteLine(context),
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
        const SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.receipt_long_outlined,
              size: 16,
              color: AppColors.purple,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                l10n.recurringPaymentsExecution_boleto_read_hint,
                style: const TextStyle(
                  fontFamily: AppFonts.fontText,
                  fontSize: 12,
                  color: AppColors.grey,
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        CustomButton(
          text:
              state.isSimulatingBill
                  ? l10n.recurringPaymentsExecution_boleto_simulating
                  : state.billSimulationError ==
                      RecurringPaymentBillSimulationError.unavailable
                  ? l10n.recurringPaymentsExecution_failed_retry
                  : l10n.recurringPaymentsExecution_boleto_validate_action,
          backgroundColor: AppColors.purple,
          textColor: Colors.white,
          icon: Icons.arrow_forward,
          onPressed: !hasValue || state.isSimulatingBill ? null : onValidate,
        ),
      ],
    );
  }

  Future<void> _pasteLine(BuildContext context) async {
    final store = context.read<RecurringPaymentExecutionStore>();
    final value = await Clipboard.getData(Clipboard.kTextPlain);
    final text = value?.text;
    if (text == null || text.isEmpty) return;
    store.setBoletoLine(text);
  }
}
