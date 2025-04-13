class FormLoginState {
  bool makeRequest;
  String email;
  String password;

  FormLoginState({
    required this.email,
    required this.password,
    required this.makeRequest,
  });

  factory FormLoginState.init() {
    return FormLoginState(
      email: '',
      password: '',
      makeRequest: false,
    );
  }

  FormLoginState copyWith({
    String? email,
    String? password,
    bool? makeRequest,
  }) {
    return FormLoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      makeRequest: makeRequest ?? this.makeRequest,
    );
  }

  Map<String, dynamic> toJson() {
    // print(email);
    // print(password);
    return {
      "email": email,
      "password": password,
    };
  }
}
