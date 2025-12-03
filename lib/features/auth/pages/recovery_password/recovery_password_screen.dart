import 'package:church_finance_bk/core/theme/app_color.dart';
import 'package:church_finance_bk/core/theme/app_fonts.dart';
import 'package:church_finance_bk/core/toast.dart';
import 'package:church_finance_bk/core/utils/app_localizations_ext.dart';
import 'package:church_finance_bk/core/widgets/app_logo.dart';
import 'package:church_finance_bk/core/utils/index.dart';
import 'package:flutter/gestures.dart';
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
        ChangeNotifierProvider(create: (_) => StepperStore()),
      ],
      child: LayoutAuth(
        width: isMobile(context) ? null : 750,
        child: Column(
          children: [
            // Logo en la parte superior - asegúrate de añadir tu imagen aquí
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: const ApplicationLogo(height: 100),
            ),
            Expanded(
              child: GestureDetector(
                // Esto asegura que los gestos se propaguen correctamente
                behavior: HitTestBehavior.translucent,
                child: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(context).copyWith(
                    dragDevices: {
                      PointerDeviceKind.touch,
                      PointerDeviceKind.mouse,
                      PointerDeviceKind.trackpad,
                    },
                  ),
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      children: [
                        SizedBox(height: 20),
                        StepperRecoveryPassword(
                          temporalPassword: StepRequestTemporalPassword(),
                          confirmationReceiveTemporalPassword:
                              StepSuccessTemporalPassword(),
                          newPassword: StepChangePassword(),
                        ),
                        SizedBox(height: 20),
                        _backToLogin(),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ),
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
          Icon(Icons.arrow_circle_left_outlined, color: AppColors.grey),
          SizedBox(width: 5),
          Text(
            context.l10n.auth_recovery_back_to_login,
            style: TextStyle(
              fontFamily: AppFonts.fontText,
              color: AppColors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
