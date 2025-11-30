class ChangePasswordState {
  String oldPassword;
  String newPassword;
  String email;
  bool makeRequest;

  ChangePasswordState({
    required this.oldPassword,
    required this.newPassword,
    required this.email,
    required this.makeRequest,
  });

  factory ChangePasswordState.init() {
    return ChangePasswordState(
      oldPassword: '',
      newPassword: '',
      email: '',
      makeRequest: false,
    );
  }

  ChangePasswordState copyWith({
    String? oldPassword,
    String? newPassword,
    String? email,
    bool? makeRequest,
  }) {
    return ChangePasswordState(
      oldPassword: oldPassword ?? this.oldPassword,
      newPassword: newPassword ?? this.newPassword,
      email: email ?? this.email,
      makeRequest: makeRequest ?? this.makeRequest,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'oldPassword': oldPassword,
      'newPassword': newPassword,
      'email': email,
    };
  }
}
