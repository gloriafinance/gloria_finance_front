import 'package:flutter/material.dart';

import '../state/stepper_state.dart';

class StepperStore extends ChangeNotifier {
  StepperState state = StepperState.init();

  void nextStep() {
    state = state.nextStep();
    notifyListeners();
  }
}
