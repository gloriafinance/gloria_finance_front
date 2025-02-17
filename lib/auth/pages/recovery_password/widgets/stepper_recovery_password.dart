import 'package:church_finance_bk/core/theme/app_fonts.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../store/stepper_store.dart';

class StepperRecoveryPassword extends StatelessWidget {
  final Widget temporalPassword;
  final Widget confirmationReceiveTemporalPassword;
  final Widget newPassword;

  const StepperRecoveryPassword(
      {super.key,
      required this.temporalPassword,
      required this.confirmationReceiveTemporalPassword,
      required this.newPassword});

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<StepperStore>(context);

    return Stepper(
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
          title: const Text(
            'Enviar senha temporaria',
            style: TextStyle(
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
              'Confirmaçāo do recevimento da senha temporaria',
              style: TextStyle(
                fontFamily: AppFonts.fontTitle,
              ),
            ),
            content: confirmationReceiveTemporalPassword),
        Step(
            state: store.state.isCompleteNewPassword
                ? StepState.complete
                : StepState.indexed,
            title: Text(
              'Definir nova senha',
              style: TextStyle(
                fontFamily: AppFonts.fontTitle,
              ),
            ),
            content: newPassword),
      ],
    );
  }
}
