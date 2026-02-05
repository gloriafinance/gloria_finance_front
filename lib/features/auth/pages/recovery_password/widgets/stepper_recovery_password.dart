import 'package:gloria_finance/core/theme/app_fonts.dart';
import 'package:gloria_finance/core/utils/app_localizations_ext.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../store/stepper_store.dart';

class StepperRecoveryPassword extends StatelessWidget {
  final Widget temporalPassword;
  final Widget confirmationReceiveTemporalPassword;
  final Widget newPassword;

  const StepperRecoveryPassword({
    super.key,
    required this.temporalPassword,
    required this.confirmationReceiveTemporalPassword,
    required this.newPassword,
  });

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<StepperStore>(context);

    return ScrollConfiguration(
      // Esto es clave: configura un comportamiento personalizado de scroll
      behavior: ScrollConfiguration.of(context).copyWith(
        dragDevices: {
          PointerDeviceKind.touch,
          PointerDeviceKind.mouse,
          PointerDeviceKind.trackpad,
        },
      ),
      child: Stepper(
        // Física de scroll que permite siempre el desplazamiento
        physics: const ClampingScrollPhysics(),
        currentStep: store.state.currentStep,
        onStepContinue: () => store.nextStep(),
        controlsBuilder: (BuildContext context, ControlsDetails details) {
          return const SizedBox.shrink();
        },
        steps: <Step>[
          Step(
            state: store.state.isCompleteTemporalPassword
                ? StepState.complete
                : StepState.indexed,
            title: Text(
              context.l10n.auth_recovery_step_title_request,
              style: const TextStyle(
                fontFamily: AppFonts.fontTitle,
              ),
            ),
            content: temporalPassword,
          ),
          Step(
            state: store.state.isCompleteReceiveTemporalPassword
                ? StepState.complete
                : StepState.indexed,
            title: Text(
              context.l10n.auth_recovery_step_title_confirm,
              style: TextStyle(
                fontFamily: AppFonts.fontTitle,
              ),
            ),
            content: confirmationReceiveTemporalPassword,
          ),
          Step(
            state: store.state.isCompleteNewPassword
                ? StepState.complete
                : StepState.indexed,
            title: Text(
              context.l10n.auth_recovery_step_title_new_password,
              style: TextStyle(
                fontFamily: AppFonts.fontTitle,
              ),
            ),
            content: newPassword,
          ),
        ],
      ),
    );
  }
}
