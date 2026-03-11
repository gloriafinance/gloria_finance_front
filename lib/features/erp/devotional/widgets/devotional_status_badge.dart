import 'package:flutter/material.dart';

import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/theme/app_fonts.dart';

class DevotionalStatusBadge extends StatelessWidget {
  final String status;
  final String label;

  const DevotionalStatusBadge({
    super.key,
    required this.status,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final color = _resolveColor(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontFamily: AppFonts.fontSubTitle,
          fontSize: 12,
        ),
      ),
    );
  }

  Color _resolveColor(String value) {
    switch (value) {
      case 'sent':
        return Colors.green;
      case 'approved':
        return Colors.blue;
      case 'in_review':
        return Colors.orange;
      case 'sending':
        return Colors.indigo;
      case 'generating':
        return Colors.deepPurple;
      case 'failed':
      case 'error':
        return Colors.red;
      case 'partial':
        return Colors.amber;
      default:
        return AppColors.purple;
    }
  }
}
