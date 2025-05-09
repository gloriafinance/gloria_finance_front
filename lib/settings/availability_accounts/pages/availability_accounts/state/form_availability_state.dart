class FormAvailabilityState {
  bool makeRequest;
  bool active;
  String churchId;
  String accountName;
  String accountType;
  double balance;
  String? source;
  String? symbol;

  FormAvailabilityState({
    required this.makeRequest,
    required this.active,
    required this.churchId,
    required this.accountName,
    required this.accountType,
    required this.source,
    required this.balance,
    required this.symbol,
  });

  factory FormAvailabilityState.init() {
    return FormAvailabilityState(
      makeRequest: false,
      active: false,
      churchId: '',
      accountName: '',
      accountType: '',
      source: null,
      balance: 0.0,
      symbol: 'R\$',
    );
  }

  FormAvailabilityState copyWith({
    bool? makeRequest,
    bool? active,
    String? churchId,
    String? accountName,
    String? accountType,
    String? source,
    double? balance,
    String? symbol,
  }) {
    return FormAvailabilityState(
      makeRequest: makeRequest ?? this.makeRequest,
      active: active ?? this.active,
      churchId: churchId ?? this.churchId,
      accountName: accountName ?? this.accountName,
      accountType: accountType ?? this.accountType,
      source: source ?? this.source,
      balance: balance ?? this.balance,
      symbol: symbol ?? this.symbol,
    );
  }

  Map<String, dynamic> toJson() => {
    'active': active,
    'accountName': accountName,
    'accountType': accountType,
    'source': source,
    'balance': balance,
    'symbol': symbol,
  };
}
