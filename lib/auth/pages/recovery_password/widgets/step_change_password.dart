import 'package:church_finance_bk/core/theme/app_color.dart';
import 'package:church_finance_bk/core/theme/app_fonts.dart';
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
          height: 36,
        ),
        Icon(
          Icons.lock_outline_rounded,
          color: AppColors.grey,
          size: 60,
        ),
        Text('Defina uma nova senha',
            style: TextStyle(fontSize: 24, fontFamily: AppFonts.fontTitle)),
        SizedBox(
          height: 36,
        ),
        Text(
            'Crie uma nova senha. Certifique-se de que seja diferente de anteriores para segurança',
            style: TextStyle(fontFamily: AppFonts.fontText, fontSize: 17)),
        FormChangePassword(),
        SizedBox(
          height: 36,
        ),
      ],
    );
  }
}
