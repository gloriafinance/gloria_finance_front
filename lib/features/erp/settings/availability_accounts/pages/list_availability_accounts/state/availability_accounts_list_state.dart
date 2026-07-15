import '../../../models/availability_account_model.dart';

class AvailabilityAccountsListState {
  final bool makeRequest;
  final bool deleting;
  final List<AvailabilityAccountModel> availabilityAccounts;

  AvailabilityAccountsListState({
    required this.makeRequest,
    this.deleting = false,
    required this.availabilityAccounts,
  });

  factory AvailabilityAccountsListState.empty() {
    return AvailabilityAccountsListState(
      makeRequest: false,
      deleting: false,
      availabilityAccounts: [],
    );
  }

  AvailabilityAccountsListState copyWith({
    bool? makeRequest,
    bool? deleting,
    List<AvailabilityAccountModel>? availabilityAccounts,
  }) {
    return AvailabilityAccountsListState(
      makeRequest: makeRequest ?? this.makeRequest,
      deleting: deleting ?? this.deleting,
      availabilityAccounts: availabilityAccounts ?? this.availabilityAccounts,
    );
  }
}
