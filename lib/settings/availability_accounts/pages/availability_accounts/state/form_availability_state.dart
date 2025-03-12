class FormAvailabilityState {
  bool makeRequest;
  bool active;
  String churchId;
  String accountName;
  String accountType;
  dynamic source;

  FormAvailabilityState({
    required this.makeRequest,
    required this.active,
    required this.churchId,
    required this.accountName,
    required this.accountType,
    required this.source,
  });

  factory FormAvailabilityState.init() {
    return FormAvailabilityState(
      makeRequest: false,
      active: false,
      churchId: '',
      accountName: '',
      accountType: '',
      source: null,
    );
  }

  FormAvailabilityState copyWith({
    bool? makeRequest,
    bool? active,
    String? churchId,
    String? accountName,
    String? accountType,
    dynamic? source,
  }) {
    return FormAvailabilityState(
      makeRequest: makeRequest ?? this.makeRequest,
      active: active ?? this.active,
      churchId: churchId ?? this.churchId,
      accountName: accountName ?? this.accountName,
      accountType: accountType ?? this.accountType,
      source: source ?? this.source,
    );
  }

  Map<String, dynamic> toJson() => {
        'active': active,
        'churchId': churchId,
        'accountName': accountName,
        'accountType': accountType,
        'source': source?.toJson(),
      };
}
