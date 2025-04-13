import 'package:church_finance_bk/auth/auth_persistence.dart';
import 'package:church_finance_bk/core/theme/app_fonts.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:motion_toast/motion_toast.dart';

enum ToastType { info, warning, error }

class Toast {
  static late BuildContext _context;

  static init(BuildContext context) {
    _context = context;
  }

  static showMessage(String message, ToastType type) {
    if (message == 'Unauthorized.') {
      AuthPersistence().clear();
      _context.go('/');
    }

    switch (type) {
      case ToastType.warning:
        MotionToast.warning(
            animationDuration: const Duration(seconds: 60),
            toastAlignment: Alignment.topCenter,
            description: Text(
              message,
              style: const TextStyle(
                  fontFamily: AppFonts.fontSubTitle, fontSize: 18),
            )).show(_context);
        break;
      case ToastType.error:
        MotionToast.error(
            animationDuration: const Duration(seconds: 60),
            toastAlignment: Alignment.topCenter,
            description: Text(
              message,
              style: const TextStyle(
                  fontFamily: AppFonts.fontSubTitle, fontSize: 18),
            )).show(_context);
        break;

      default:
        MotionToast.success(
            animationDuration: const Duration(seconds: 60),
            toastAlignment: Alignment.topCenter,
            description: Text(
              message,
              style: const TextStyle(
                  fontFamily: AppFonts.fontSubTitle, fontSize: 18),
            )).show(_context);
    }
  }
}
