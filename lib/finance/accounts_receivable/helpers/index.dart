import 'package:church_finance_bk/core/theme/app_color.dart';
import 'package:flutter/material.dart';

Color getStatusColor(String status) {
  switch (status) {
    case 'PAID':
      return AppColors.green;
    case 'PENDING':
      return AppColors.mustard;
    default:
      return AppColors.grey;
  }
}
