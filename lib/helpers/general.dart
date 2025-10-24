import 'package:church_finance_bk/core/theme/app_color.dart';
import 'package:flutter/material.dart';

bool isMobile(BuildContext context) {
  return MediaQuery.of(context).size.width < 768;
}

Color getStatusColor(String status) {
  final normalized = status.toUpperCase();
  switch (normalized) {
    case 'PAID':
      return AppColors.green;
    case 'PENDING':
    case 'OPEN':
    case 'AWAITING_PAYMENT':
      return AppColors.mustard;
    case 'PARTIAL':
    case 'PARTIAL_PAYMENT':
    case 'PARTIALLY_PAID':
      return AppColors.mustard;
    case 'OVERDUE':
    case 'LATE':
    case 'CANCELLED':
    case 'CANCELED':
      return Colors.red;
    default:
      return AppColors.grey;
  }
}
