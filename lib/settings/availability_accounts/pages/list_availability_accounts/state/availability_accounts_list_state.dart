import '../../../models/availability_account_model.dart';

class AvailabilityAccountsListState {
  final bool makeRequest;
  final List<AvailabilityAccountModel> availabilityAccounts;

  AvailabilityAccountsListState(
      {required this.makeRequest, required this.availabilityAccounts});

  factory AvailabilityAccountsListState.empty() {
    return AvailabilityAccountsListState(
        makeRequest: false, availabilityAccounts: []);
  }

  AvailabilityAccountsListState copyWith(
      {bool? makeRequest,
      List<AvailabilityAccountModel>? availabilityAccounts}) {
    return AvailabilityAccountsListState(
      makeRequest: makeRequest ?? this.makeRequest,
      availabilityAccounts: availabilityAccounts ?? this.availabilityAccounts,
    );
  }
}
