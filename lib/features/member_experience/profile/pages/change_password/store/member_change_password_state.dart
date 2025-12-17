class MemberChangePasswordState {
  final String currentPassword;
  final String newPassword;
  final String confirmPassword;
  final bool isCurrentPasswordVisible;
  final bool isNewPasswordVisible;
  final bool isConfirmPasswordVisible;
  final bool isLoading;
  final String? errorMessage;
  final bool isSuccess;

  MemberChangePasswordState({
    required this.currentPassword,
    required this.newPassword,
    required this.confirmPassword,
    required this.isCurrentPasswordVisible,
    required this.isNewPasswordVisible,
    required this.isConfirmPasswordVisible,
    required this.isLoading,
    this.errorMessage,
    required this.isSuccess,
  });

  factory MemberChangePasswordState.initial() {
    return MemberChangePasswordState(
      currentPassword: '',
      newPassword: '',
      confirmPassword: '',
      isCurrentPasswordVisible: false,
      isNewPasswordVisible: false,
      isConfirmPasswordVisible: false,
      isLoading: false,
      isSuccess: false,
    );
  }

  MemberChangePasswordState copyWith({
    String? currentPassword,
    String? newPassword,
    String? confirmPassword,
    bool? isCurrentPasswordVisible,
    bool? isNewPasswordVisible,
    bool? isConfirmPasswordVisible,
    bool? isLoading,
    String? errorMessage,
    bool? isSuccess,
  }) {
    return MemberChangePasswordState(
      currentPassword: currentPassword ?? this.currentPassword,
      newPassword: newPassword ?? this.newPassword,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      isCurrentPasswordVisible:
          isCurrentPasswordVisible ?? this.isCurrentPasswordVisible,
      isNewPasswordVisible: isNewPasswordVisible ?? this.isNewPasswordVisible,
      isConfirmPasswordVisible:
          isConfirmPasswordVisible ?? this.isConfirmPasswordVisible,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }
}
