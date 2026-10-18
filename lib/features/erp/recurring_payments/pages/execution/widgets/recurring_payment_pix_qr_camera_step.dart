import 'package:flutter/material.dart';
import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/utils/app_localizations_ext.dart';
import 'package:gloria_finance/core/widgets/custom_button.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class RecurringPaymentPixQrCameraStep extends StatefulWidget {
  const RecurringPaymentPixQrCameraStep({
    super.key,
    required this.onDetected,
    required this.onPaste,
  });
  final ValueChanged<String> onDetected;
  final VoidCallback onPaste;
  @override
  State<RecurringPaymentPixQrCameraStep> createState() =>
      _RecurringPaymentPixQrCameraStepState();
}

class _RecurringPaymentPixQrCameraStepState
    extends State<RecurringPaymentPixQrCameraStep> {
  late final MobileScannerController _controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
    formats: const [BarcodeFormat.qrCode],
  );
  bool _handled = false;
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    if (_handled) return;
    final payload =
        capture.barcodes
            .map((item) => item.rawValue)
            .whereType<String>()
            .firstOrNull;
    if (payload == null) return;
    _handled = true;
    _controller.stop();
    widget.onDetected(payload);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(l10n.recurringPaymentsExecution_qr_scan_instruction),
        const SizedBox(height: 12),
        ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: AspectRatio(
            aspectRatio: 1,
            child: Stack(
              fit: StackFit.expand,
              children: [
                MobileScanner(
                  controller: _controller,
                  onDetect: _onDetect,
                  errorBuilder:
                      (context, error) => ColoredBox(
                        color: const Color(0xFF1F1F1F),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Text(
                              error.errorCode ==
                                      MobileScannerErrorCode.permissionDenied
                                  ? context
                                      .l10n
                                      .recurringPaymentsExecution_qr_camera_permission
                                  : context
                                      .l10n
                                      .recurringPaymentsExecution_qr_camera_error,
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                ),
                IgnorePointer(
                  child: Center(
                    child: Container(
                      width: 230,
                      height: 230,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 3),
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 14),
        CustomButton(
          text: l10n.recurringPaymentsExecution_qr_paste,
          backgroundColor: AppColors.green,
          textColor: Colors.black,
          icon: Icons.content_paste,
          onPressed: widget.onPaste,
        ),
      ],
    );
  }
}
