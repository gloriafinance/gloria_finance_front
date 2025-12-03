import 'package:church_finance_bk/core/theme/app_color.dart';
import 'package:church_finance_bk/core/theme/app_fonts.dart';
import 'package:church_finance_bk/core/toast.dart';
import 'package:church_finance_bk/core/utils/app_localizations_ext.dart';
import 'package:church_finance_bk/core/widgets/custom_button.dart';
import 'package:church_finance_bk/core/widgets/form_controls.dart';
import 'package:church_finance_bk/core/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../auth_service.dart';
import '../store/change_password_store.dart';
import '../store/stepper_store.dart';

class StepRequestTemporalPassword extends StatefulWidget {
  const StepRequestTemporalPassword({super.key});

  @override
  State<StatefulWidget> createState() => _StepRequestTemporalPasswordState();
}

class _StepRequestTemporalPasswordState
    extends State<StepRequestTemporalPassword> {
  late var makeRequest = false;
  late String email = "";

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //SizedBox(height: 26),
        Text(
          context.l10n.auth_recovery_request_title,
          textAlign: TextAlign.center,
          style: TextStyle(fontFamily: AppFonts.fontText, fontSize: 16),
        ),
        //SizedBox(height: 36),
        _form(),
      ],
    );
  }

  Widget _form() {
    return Column(
      children: [
        Input(
          label: context.l10n.auth_login_email_label,
          icon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
          onChanged: (value) {
            setState(() {
              email = value;
            });
          },
        ),
        SizedBox(height: 60),
        makeRequest
            ? Loading(label: context.l10n.auth_recovery_request_loading)
            : CustomButton(
              text: context.l10n.auth_recovery_request_submit,
              backgroundColor: AppColors.green,
              onPressed: () => _submit(),
            ),
      ],
    );
  }

  void _submit() async {
    if (email.isEmpty) {
      Toast.showMessage(
        context.l10n.auth_recovery_request_email_required,
        ToastType.warning,
      );
      return;
    }

    setState(() {
      makeRequest = true;
    });

    var isSuccess = await AuthService().recoveryPassword(email);

    if (isSuccess) {
      Provider.of<StepperStore>(context, listen: false).nextStep();
      Provider.of<ChangePasswordStore>(context, listen: false).setEmail(email);
    }

    setState(() {
      makeRequest = false;
    });
  }
}
