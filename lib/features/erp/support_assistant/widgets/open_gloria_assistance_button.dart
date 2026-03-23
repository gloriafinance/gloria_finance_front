import 'package:flutter/material.dart';
import 'package:gloria_finance/core/theme/app_color.dart';

class OpenGloriaAssistanceButton extends StatelessWidget {
  const OpenGloriaAssistanceButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: const Icon(Icons.auto_awesome_rounded, color: AppColors.purple),
      label: Text(label),
    );
  }
}
