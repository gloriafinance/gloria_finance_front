import 'package:gloria_finance/core/theme/app_color.dart';
import 'package:gloria_finance/core/theme/app_fonts.dart';
import 'package:gloria_finance/core/toast.dart';
import 'package:gloria_finance/core/utils/app_localizations_ext.dart';
import 'package:gloria_finance/core/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../auth_service.dart';
import '../store/change_password_store.dart';
import '../store/stepper_store.dart';

class StepSuccessTemporalPassword extends StatelessWidget {
  const StepSuccessTemporalPassword({super.key});

  @override
  Widget build(BuildContext context) {
    final changePasswordStore = Provider.of<ChangePasswordStore>(context);
    final stepperStore = Provider.of<StepperStore>(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 36,
        ),
        Icon(
          Icons.mark_email_read_outlined,
          color: AppColors.grey,
          size: 50,
        ),
        Text(
          context.l10n.auth_recovery_success_title,
          style: TextStyle(fontSize: 20, fontFamily: AppFonts.fontTitle),
        ),
        SizedBox(
          height: 36,
        ),
        Text(
          context.l10n.auth_recovery_success_body(
            changePasswordStore.state.email,
          ),
          style: TextStyle(fontFamily: AppFonts.fontText),
        ),
        SizedBox(
          height: 36,
        ),
        CustomButton(
            text: context.l10n.auth_recovery_success_continue,
            backgroundColor: AppColors.green,
            onPressed: () => stepperStore.nextStep()),
        SizedBox(
          height: 36,
        ),
        _resendEmail(context, changePasswordStore)
      ],
    );
  }

  Widget _resendEmail(
    BuildContext context,
    ChangePasswordStore changePasswordStore,
  ) {
    return GestureDetector(
      onTap: () {
        AuthService()
            .recoveryPassword(changePasswordStore.state.email)
            .then((value) {
          if (value) {
            Toast.showMessage(
              context.l10n.auth_recovery_success_resend_ok,
              ToastType.info,
            );
            return;
          }

          Toast.showMessage(
            context.l10n.auth_recovery_success_resend_error,
            ToastType.error,
          );
        });
      },
      child: Text(
        context.l10n.auth_recovery_success_resend,
        style: TextStyle(fontFamily: AppFonts.fontText, color: AppColors.blue),
      ),
    );
  }
}
