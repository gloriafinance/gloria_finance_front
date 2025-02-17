import 'package:church_finance_bk/core/theme/app_color.dart';
import 'package:church_finance_bk/core/theme/app_fonts.dart';
import 'package:church_finance_bk/core/toast.dart';
import 'package:church_finance_bk/helpers/index.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../widgets/layout_auth.dart';
import 'store/change_password_store.dart';
import 'store/stepper_store.dart';
import 'widgets/step_change_password.dart';
import 'widgets/step_request_temporal_password.dart';
import 'widgets/step_success_temporal_password.dart';
import 'widgets/stepper_recovery_password.dart';

class RecoveryPasswordScreen extends StatefulWidget {
  const RecoveryPasswordScreen({super.key});

  @override
  State<RecoveryPasswordScreen> createState() => _RecoveryPasswordScreenState();
}

class _RecoveryPasswordScreenState extends State<RecoveryPasswordScreen> {
  @override
  Widget build(BuildContext context) {
    Toast.init(context);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ChangePasswordStore()),
        ChangeNotifierProvider(create: (_) => StepperStore())
      ],
      child: LayoutAuth(
        width: isMobile(context) ? null : 750,
        child: Column(
          children: [
            StepperRecoveryPassword(
              temporalPassword: StepRequestTemporalPassword(),
              confirmationReceiveTemporalPassword:
                  StepSuccessTemporalPassword(),
              newPassword: StepChangePassword(),
            ),
            _backToLogin(),
            SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }

  Widget _backToLogin() {
    return GestureDetector(
      onTap: () {
        context.go('/');
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.arrow_circle_left_outlined,
            color: AppColors.grey,
          ),
          SizedBox(
            width: 5,
          ),
          Text(
            'Voltar para fazer login',
            style:
                TextStyle(fontFamily: AppFonts.fontText, color: AppColors.grey),
          )
        ],
      ),
    );
  }
}
