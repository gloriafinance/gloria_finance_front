import 'package:church_finance_bk/core/theme/app_color.dart';
import 'package:church_finance_bk/core/theme/app_fonts.dart';
import 'package:church_finance_bk/core/toast.dart';
import 'package:church_finance_bk/core/widgets/custom_button.dart';
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
        Text('Verifique seu e-mail',
            style: TextStyle(fontSize: 20, fontFamily: AppFonts.fontTitle)),
        SizedBox(
          height: 36,
        ),
        Text(
          'Enviamos uma senha temporaria no e-mail ${changePasswordStore.state.email} se não encontrar verifique a caixa de spam.  Se recebeu o e-mail, clique no botāo abaxio.',
          style: TextStyle(fontFamily: AppFonts.fontText),
        ),
        SizedBox(
          height: 36,
        ),
        CustomButton(
            text: "Continuar",
            backgroundColor: AppColors.green,
            onPressed: () => stepperStore.nextStep()),
        SizedBox(
          height: 36,
        ),
        _resendEmail(changePasswordStore)
      ],
    );
  }

  Widget _resendEmail(ChangePasswordStore changePasswordStore) {
    return GestureDetector(
      onTap: () {
        AuthService()
            .recoveryPassword(changePasswordStore.state.email)
            .then((value) {
          if (value) {
            Toast.showMessage('E-mail reenviado com sucesso', ToastType.info);
            return;
          }

          Toast.showMessage('Erro ao reenviar e-mail', ToastType.error);
        });
      },
      child: Text(
        'Ainda não recebeu o e-mail? Reenviar e-mail',
        style: TextStyle(fontFamily: AppFonts.fontText, color: AppColors.blue),
      ),
    );
  }
}
