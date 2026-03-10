import 'package:gloria_finance/core/utils/index.dart';

class InternalTransferFormState {
  final bool makeRequest;
  final String fromAvailabilityAccountId;
  final String toAvailabilityAccountId;
  final String date;
  final double amount;
  final String description;
  final String symbolFormatMoney;

  InternalTransferFormState({
    required this.makeRequest,
    required this.fromAvailabilityAccountId,
    required this.toAvailabilityAccountId,
    required this.date,
    required this.amount,
    required this.description,
    required this.symbolFormatMoney,
  });

  factory InternalTransferFormState.init() {
    return InternalTransferFormState(
      makeRequest: false,
      fromAvailabilityAccountId: '',
      toAvailabilityAccountId: '',
      date: '',
      amount: 0,
      description: '',
      symbolFormatMoney: '',
    );
  }

  InternalTransferFormState copyWith({
    bool? makeRequest,
    String? fromAvailabilityAccountId,
    String? toAvailabilityAccountId,
    String? date,
    double? amount,
    String? description,
    String? symbolFormatMoney,
  }) {
    return InternalTransferFormState(
      makeRequest: makeRequest ?? this.makeRequest,
      fromAvailabilityAccountId:
          fromAvailabilityAccountId ?? this.fromAvailabilityAccountId,
      toAvailabilityAccountId:
          toAvailabilityAccountId ?? this.toAvailabilityAccountId,
      date: date ?? this.date,
      amount: amount ?? this.amount,
      description: description ?? this.description,
      symbolFormatMoney: symbolFormatMoney ?? this.symbolFormatMoney,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fromAvailabilityAccountId': fromAvailabilityAccountId,
      'toAvailabilityAccountId': toAvailabilityAccountId,
      'date': convertDateFormat(date),
      'amount': amount,
      if (description.trim().isNotEmpty) 'description': description.trim(),
    };
  }
}
