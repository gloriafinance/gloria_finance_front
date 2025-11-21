import 'accounts_receivable_model.dart';

class MemberCommitmentFilter {
  final String debtorDNI;
  final AccountsReceivableStatus? status;
  final int page;
  final int perPage;

  const MemberCommitmentFilter({
    required this.debtorDNI,
    this.status,
    this.page = 1,
    this.perPage = 10,
  });

  MemberCommitmentFilter copyWith({
    String? debtorDNI,
    AccountsReceivableStatus? status,
    int? page,
    int? perPage,
  }) {
    return MemberCommitmentFilter(
      debtorDNI: debtorDNI ?? this.debtorDNI,
      status: status ?? this.status,
      page: page ?? this.page,
      perPage: perPage ?? this.perPage,
    );
  }

  Map<String, dynamic> toQuery() {
    return {
      'status': status?.apiValue,
      'page': page,
      'perPage': perPage,
    };
  }
}
