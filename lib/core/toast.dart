import 'package:church_finance_bk/core/theme/app_fonts.dart';
import 'package:flutter/material.dart';
import 'package:motion_toast/motion_toast.dart';

enum ToastType { info, warning, error }

class Toast {
  static late BuildContext _context;

  static init(BuildContext context) {
    _context = context;
  }

  static showMessage(String message, ToastType type) {
    switch (type) {
      case ToastType.warning:
        MotionToast.warning(
            animationDuration: const Duration(seconds: 14),
            title: const Text(
              "Algo salio mal",
              style: TextStyle(fontFamily: AppFonts.fontRegular),
            ),
            description: Text(
              message,
              style: const TextStyle(fontFamily: AppFonts.fontRegular),
            )).show(_context);
        break;
      case ToastType.error:
        MotionToast.error(
            animationDuration: const Duration(seconds: 14),
            title: const Text(
              "Algo salio mal",
              style: TextStyle(fontFamily: AppFonts.fontRegular),
            ),
            description: Text(
              message,
              style: const TextStyle(fontFamily: AppFonts.fontMedium),
            )).show(_context);
        break;

      default:
        MotionToast.success(
            animationDuration: const Duration(seconds: 14),
            description: Text(
              message,
              style: const TextStyle(fontFamily: AppFonts.fontRegular),
            )).show(_context);
    }
  }
}
