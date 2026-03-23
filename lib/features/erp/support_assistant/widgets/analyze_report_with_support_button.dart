import 'package:flutter/material.dart';
import 'package:gloria_finance/features/erp/support_assistant/widgets/open_gloria_assistance_button.dart';

class AnalyzeReportWithSupportButton extends StatelessWidget {
  const AnalyzeReportWithSupportButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return OpenGloriaAssistanceButton(label: label, onPressed: onPressed);
  }
}
