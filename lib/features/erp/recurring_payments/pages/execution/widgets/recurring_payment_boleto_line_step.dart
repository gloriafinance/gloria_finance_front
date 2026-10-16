import 'package:flutter/material.dart';
import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/utils/app_localizations_ext.dart';
import 'package:gloria_finance/core/widgets/custom_button.dart';
import 'package:gloria_finance/core/widgets/form_controls.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

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
    required this.onContinue,
    this.initialLine,
  });

  final VoidCallback onContinue;

  /// Linha já lida pela câmera, quando houver.
  final String? initialLine;

  @override
  Widget build(BuildContext context) {
    final store = context.watch<RecurringPaymentExecutionStore>();
    final state = store.state;
    final l10n = context.l10n;
    final line = initialLine ?? state.boletoLine;
    final isValid = RecurringPaymentBoleto.isValid(line);
    final hasValue = line.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Input(
          label: l10n.recurringPaymentsExecution_boleto_line_label,
          initialValue:
              line.isEmpty ? null : RecurringPaymentBoleto.grouped(line),
          keyboardType: TextInputType.number,
          inputFormatters: [
            _KeepBoletoDigitsOnly(),
            LengthLimitingTextInputFormatter(48),
          ],
          onChanged: store.setBoletoLine,
        ),
        if (hasValue) ...[
          const SizedBox(height: 5),
          Text(
            l10n.recurringPaymentsExecution_boleto_line_counter(
              RecurringPaymentBoleto.onlyDigits(line).length.toString(),
            ),
            style: const TextStyle(fontSize: 10.5, color: Color(0xFF667085)),
          ),
        ],
        if (hasValue && !isValid) ...[
          const SizedBox(height: 10),
          RecurringPaymentExecutionNotice(
            text: l10n.recurringPaymentsExecution_boleto_line_invalid,
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
          text: l10n.recurringPaymentsExecution_boleto_validate_action,
          backgroundColor: AppColors.green,
          textColor: Colors.black,
          icon: Icons.arrow_forward,
          onPressed: !isValid ? null : onContinue,
        ),
      ],
    );
  }
}

class _KeepBoletoDigitsOnly extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = RecurringPaymentBoleto.onlyDigits(newValue.text);
    final limited = digits.length > 48 ? digits.substring(0, 48) : digits;
    return TextEditingValue(
      text: limited,
      selection: TextSelection.collapsed(offset: limited.length),
    );
  }
}
