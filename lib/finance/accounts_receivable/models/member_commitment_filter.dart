import 'accounts_receivable_model.dart';

class MemberCommitmentFilter {
  final AccountsReceivableStatus? status;
  final int page;
  final int perPage;

  const MemberCommitmentFilter({this.status, this.page = 1, this.perPage = 10});

  MemberCommitmentFilter copyWith({
    AccountsReceivableStatus? status,
    int? page,
    int? perPage,
  }) {
    return MemberCommitmentFilter(
      status: status ?? this.status,
      page: page ?? this.page,
      perPage: perPage ?? this.perPage,
    );
  }

  Map<String, dynamic> toQuery() {
    return {'status': status?.apiValue, 'page': page, 'perPage': perPage};
  }
}
