import 'package:gloria_finance/features/erp/settings/banks/models/bank_model.dart';

class BankState {
  final List<BankModel> banks;
  final bool makeRequest;

  BankState({required this.banks, required this.makeRequest});

  factory BankState.empty() {
    return BankState(banks: [], makeRequest: false);
  }

  BankState copyWith({List<BankModel>? banks, bool? makeRequest}) {
    return BankState(
      banks: banks ?? this.banks,
      makeRequest: makeRequest ?? this.makeRequest,
    );
  }

  bool get isLoading => makeRequest;
}
