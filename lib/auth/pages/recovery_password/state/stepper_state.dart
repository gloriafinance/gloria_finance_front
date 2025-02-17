class StepperState {
  final int currentStep;
  final bool isCompleteTemporalPassword;
  final bool isCompleteReceiveTemporalPassword;
  final bool isCompleteNewPassword;

  StepperState({
    required this.currentStep,
    required this.isCompleteTemporalPassword,
    required this.isCompleteReceiveTemporalPassword,
    required this.isCompleteNewPassword,
  });

  factory StepperState.init() {
    return StepperState(
      currentStep: 0,
      isCompleteTemporalPassword: false,
      isCompleteReceiveTemporalPassword: false,
      isCompleteNewPassword: false,
    );
  }

  StepperState copyWith({
    int? currentStep,
    bool? isCompleteTemporalPassword,
    bool? isCompleteReceiveTemporalPassword,
    bool? isCompleteNewPassword,
  }) {
    return StepperState(
      currentStep: currentStep ?? this.currentStep,
      isCompleteTemporalPassword:
          isCompleteTemporalPassword ?? this.isCompleteTemporalPassword,
      isCompleteReceiveTemporalPassword: isCompleteReceiveTemporalPassword ??
          this.isCompleteReceiveTemporalPassword,
      isCompleteNewPassword:
          isCompleteNewPassword ?? this.isCompleteNewPassword,
    );
  }

  StepperState nextStep() {
    var newCurrentStep = currentStep + 1;
    switch (currentStep) {
      case 0:
        return copyWith(
          currentStep: newCurrentStep,
          isCompleteTemporalPassword: true,
        );
      case 1:
        return copyWith(
          currentStep: newCurrentStep,
          isCompleteReceiveTemporalPassword: true,
        );
      case 2:
        return copyWith(
          currentStep: newCurrentStep,
          isCompleteNewPassword: true,
        );
      default:
        return this;
    }
  }
}
