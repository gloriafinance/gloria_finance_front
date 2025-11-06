import 'package:dio/dio.dart';

class BankStatementImportState {
  final bool importing;
  final String? bankId;
  final int? month;
  final int? year;
  final MultipartFile? file;

  const BankStatementImportState({
    required this.importing,
    this.bankId,
    this.month,
    this.year,
    this.file,
  });

  factory BankStatementImportState.initial() {
    return const BankStatementImportState(
      importing: false,
      bankId: null,
      month: null,
      year: null,
      file: null,
    );
  }

  BankStatementImportState copyWith({
    bool? importing,
    String? bankId,
    int? month,
    int? year,
    MultipartFile? file,
    bool bankIdHasValue = false,
    bool monthHasValue = false,
    bool yearHasValue = false,
    bool fileHasValue = false,
  }) {
    return BankStatementImportState(
      importing: importing ?? this.importing,
      bankId: bankIdHasValue ? bankId : (bankId ?? this.bankId),
      month: monthHasValue ? month : (month ?? this.month),
      year: yearHasValue ? year : (year ?? this.year),
      file: fileHasValue ? file : (file ?? this.file),
    );
  }

  bool get isValid {
    return bankId != null &&
        bankId!.isNotEmpty &&
        month != null &&
        year != null &&
        file != null;
  }

  Map<String, dynamic> toJson() {
    if (!isValid) {
      throw StateError('Cannot create payload: state is not valid');
    }

    return {'bankId': bankId!, 'month': month!, 'year': year!, 'file': file!};
  }
}
