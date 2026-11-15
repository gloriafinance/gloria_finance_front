import 'package:flutter/material.dart';
import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/utils/app_localizations_ext.dart';
import 'package:gloria_finance/core/widgets/custom_button.dart';
import 'package:gloria_finance/core/widgets/form_controls.dart';

class RecurringPaymentPixQrPasteStep extends StatefulWidget {
  const RecurringPaymentPixQrPasteStep({
    super.key,
    required this.onContinue,
    required this.isLoading,
  });
  final Future<void> Function(String) onContinue;
  final bool isLoading;
  @override
  State<RecurringPaymentPixQrPasteStep> createState() =>
      _RecurringPaymentPixQrPasteStepState();
}

class _RecurringPaymentPixQrPasteStepState
    extends State<RecurringPaymentPixQrPasteStep> {
  String _payload = '';
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Input(
          label: l10n.recurringPaymentsExecution_qr_paste_label,
          hintText: l10n.recurringPaymentsExecution_qr_paste_placeholder,
          initialValue: _payload.isEmpty ? null : _payload,
          maxLines: 5,
          keyboardType: TextInputType.multiline,
          icon: Icons.pix,
          onChanged: (value) => setState(() => _payload = value),
        ),
        const SizedBox(height: 18),
        CustomButton(
          text:
              widget.isLoading
                  ? l10n.recurringPaymentsExecution_qr_decoding
                  : l10n.recurringPaymentsExecution_source_continue,
          backgroundColor: AppColors.green,
          disabledBackgroundColor: AppColors.green.withValues(alpha: 0.4),
          textColor: Colors.black,
          icon: Icons.arrow_forward,
          onPressed:
              _payload.trim().isEmpty || widget.isLoading
                  ? null
                  : () => widget.onContinue(_payload),
        ),
      ],
    );
  }
}
