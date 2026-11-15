import 'package:flutter/material.dart';
import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/theme/app_fonts.dart';
import 'package:gloria_finance/core/utils/app_localizations_ext.dart';
import 'package:gloria_finance/core/widgets/custom_button.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';

import '../../../models/recurring_payment_bill_simulation.dart';
import '../../../store/recurring_payment_execution_store.dart';
import '../../../utils/recurring_payment_boleto.dart';

/// Leitura do código de barras com a câmera.
///
/// A alternativa manual fica sempre visível: permissão negada, câmera ocupada ou
/// boleto amassado não podem deixar o tesoureiro sem saída.
class RecurringPaymentBoletoCameraStep extends StatefulWidget {
  const RecurringPaymentBoletoCameraStep({
    super.key,
    required this.onDetected,
    required this.onTypeManually,
  });

  final Future<bool> Function(String barcode) onDetected;
  final VoidCallback onTypeManually;

  @override
  State<RecurringPaymentBoletoCameraStep> createState() =>
      _RecurringPaymentBoletoCameraStepState();
}

class _RecurringPaymentBoletoCameraStepState
    extends State<RecurringPaymentBoletoCameraStep> {
  late final MobileScannerController _controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
    formats: const [BarcodeFormat.itf2of5],
  );

  bool _handled = false;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    if (_handled) return;

    for (final barcode in capture.barcodes) {
      final raw = barcode.rawValue;
      if (raw == null) continue;

      _handled = true;
      _isSubmitting = true;
      setState(() {});
      _controller.stop();
      widget.onDetected(RecurringPaymentBoleto.onlyDigits(raw)).then((success) {
        if (!mounted || success) return;
        setState(() {
          _handled = false;
          _isSubmitting = false;
        });
        _controller.start();
      });
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final state = context.watch<RecurringPaymentExecutionStore>().state;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          (_isSubmitting || state.isSimulatingBill)
              ? l10n.recurringPaymentsExecution_boleto_simulating
              : l10n.recurringPaymentsExecution_boleto_scan_instruction,
          style: const TextStyle(
            fontFamily: AppFonts.fontText,
            fontSize: 12.5,
            color: AppColors.grey,
          ),
        ),
        const SizedBox(height: 12),
        if (state.billSimulationError != null) ...[
          _CameraSimulationError(error: state.billSimulationError!),
          if (state.billSimulationError ==
              RecurringPaymentBillSimulationError.unavailable)
            CustomButton(
              text: l10n.recurringPaymentsExecution_failed_retry,
              backgroundColor: AppColors.green,
              textColor: Colors.black,
              onPressed: () {
                context
                    .read<RecurringPaymentExecutionStore>()
                    .clearBillSimulation();
                _controller.start();
              },
            ),
          const SizedBox(height: 10),
        ],
        ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: AspectRatio(
            aspectRatio: 1.35,
            child: Stack(
              fit: StackFit.expand,
              children: [
                MobileScanner(
                  controller: _controller,
                  onDetect: _onDetect,
                  errorBuilder:
                      (context, error) => _CameraProblem(
                        permissionDenied:
                            error.errorCode ==
                            MobileScannerErrorCode.permissionDenied,
                        onRetry: _controller.start,
                        onTypeManually: widget.onTypeManually,
                      ),
                ),
                // Guia visual: o código precisa caber na faixa central.
                IgnorePointer(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.85),
                        width: 2,
                      ),
                    ),
                    margin: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 42,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 14),
        CustomButton(
          text: l10n.recurringPaymentsExecution_boleto_scan_manual_action,
          backgroundColor: AppColors.green,
          textColor: Colors.black,
          icon: Icons.keyboard_alt_outlined,
          onPressed: widget.onTypeManually,
        ),
      ],
    );
  }
}

class _CameraProblem extends StatelessWidget {
  const _CameraProblem({
    required this.permissionDenied,
    required this.onRetry,
    required this.onTypeManually,
  });

  final bool permissionDenied;
  final VoidCallback onRetry;
  final VoidCallback onTypeManually;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return ColoredBox(
      color: const Color(0xFF1F1F1F),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.no_photography_outlined,
              size: 30,
              color: Colors.white,
            ),
            const SizedBox(height: 12),
            Text(
              permissionDenied
                  ? l10n
                      .recurringPaymentsExecution_boleto_camera_permission_title
                  : l10n.recurringPaymentsExecution_boleto_camera_denied,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: AppFonts.fontSubTitle,
                fontSize: 13.5,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              permissionDenied
                  ? l10n
                      .recurringPaymentsExecution_boleto_camera_permission_description
                  : l10n.recurringPaymentsExecution_boleto_camera_error,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: AppFonts.fontText,
                fontSize: 12,
                height: 1.5,
                color: Color(0xFFCFCFCF),
              ),
            ),
            const SizedBox(height: 14),
            if (permissionDenied)
              OutlinedButton(
                onPressed: onRetry,
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: AppColors.green,
                  side: BorderSide.none,
                ),
                child: Text(
                  l10n.recurringPaymentsExecution_boleto_camera_permission_action,
                ),
              )
            else
              OutlinedButton(
                onPressed: onTypeManually,
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: AppColors.green,
                  side: BorderSide.none,
                ),
                child: Text(
                  l10n.recurringPaymentsExecution_boleto_camera_denied_action,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _CameraSimulationError extends StatelessWidget {
  const _CameraSimulationError({required this.error});

  final RecurringPaymentBillSimulationError error;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final text = switch (error) {
      RecurringPaymentBillSimulationError.invalid =>
        l10n.recurringPaymentsExecution_boleto_simulation_invalid,
      RecurringPaymentBillSimulationError.unavailable =>
        l10n.recurringPaymentsExecution_boleto_simulation_unavailable,
      RecurringPaymentBillSimulationError.generic =>
        l10n.recurringPaymentsExecution_boleto_simulation_generic,
    };

    return Text(
      text,
      style: const TextStyle(
        fontFamily: AppFonts.fontText,
        fontSize: 12.5,
        color: Colors.red,
      ),
    );
  }
}
