import 'package:gloria_finance/features/erp/settings/availability_accounts/models/availability_account_model.dart';

class AvailabilityAccountEditState {
  final bool makeRequest;
  final String availabilityAccountId;
  final String accountName;
  final bool active;
  final AvailabilityAccountModel account;

  AvailabilityAccountEditState({
    required this.makeRequest,
    required this.availabilityAccountId,
    required this.accountName,
    required this.active,
    required this.account,
  });

  factory AvailabilityAccountEditState.fromModel(
    AvailabilityAccountModel account,
  ) {
    return AvailabilityAccountEditState(
      makeRequest: false,
      availabilityAccountId: account.availabilityAccountId,
      accountName: account.accountName,
      active: account.active,
      account: account,
    );
  }

  AvailabilityAccountEditState copyWith({
    bool? makeRequest,
    String? availabilityAccountId,
    String? accountName,
    bool? active,
    AvailabilityAccountModel? account,
  }) {
    return AvailabilityAccountEditState(
      makeRequest: makeRequest ?? this.makeRequest,
      availabilityAccountId:
          availabilityAccountId ?? this.availabilityAccountId,
      accountName: accountName ?? this.accountName,
      active: active ?? this.active,
      account: account ?? this.account,
    );
  }

  bool get isReady => availabilityAccountId.isNotEmpty;
}
