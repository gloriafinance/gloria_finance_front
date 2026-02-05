import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/theme/app_fonts.dart';
import 'package:gloria_finance/core/utils/app_localizations_ext.dart';
import 'package:flutter/material.dart';

import 'form_change_password.dart';

class StepChangePassword extends StatelessWidget {
  const StepChangePassword({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 26,
        ),
        Icon(
          Icons.lock_outline_rounded,
          color: AppColors.grey,
          size: 50,
        ),
        Text(
          context.l10n.auth_recovery_change_title,
          style: TextStyle(fontSize: 20, fontFamily: AppFonts.fontTitle),
        ),
        SizedBox(
          height: 16,
        ),
        Text(
          context.l10n.auth_recovery_change_description,
          style: TextStyle(fontFamily: AppFonts.fontText),
        ),
        FormChangePassword(),
        SizedBox(
          height: 36,
        ),
      ],
    );
  }
}
