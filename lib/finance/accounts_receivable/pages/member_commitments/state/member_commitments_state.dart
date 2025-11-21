import 'package:church_finance_bk/core/paginate/paginate_response.dart';

import '../../../models/index.dart';

class MemberCommitmentsState {
  final PaginateResponse<AccountsReceivableModel> paginate;
  final MemberCommitmentFilter filter;
  final bool isLoading;
  final bool permissionDenied;
  final String? errorMessage;

  const MemberCommitmentsState({
    required this.paginate,
    required this.filter,
    this.isLoading = false,
    this.permissionDenied = false,
    this.errorMessage,
  });

  factory MemberCommitmentsState.initial(String debtorDNI) {
    return MemberCommitmentsState(
      paginate: PaginateResponse.init(),
      filter: MemberCommitmentFilter(debtorDNI: debtorDNI),
    );
  }

  MemberCommitmentsState copyWith({
    PaginateResponse<AccountsReceivableModel>? paginate,
    MemberCommitmentFilter? filter,
    bool? isLoading,
    bool? permissionDenied,
    String? errorMessage,
  }) {
    return MemberCommitmentsState(
      paginate: paginate ?? this.paginate,
      filter: filter ?? this.filter,
      isLoading: isLoading ?? this.isLoading,
      permissionDenied: permissionDenied ?? this.permissionDenied,
      errorMessage: errorMessage,
    );
  }
}
