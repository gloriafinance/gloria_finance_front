import 'package:gloria_finance/core/paginate/paginate_response.dart';

import '../models/member_filter_model.dart';
import '../models/member_model.dart';

class MemberPaginateState {
  final PaginateResponse<MemberModel> paginate;
  final bool makeRequest;
  final bool deleting;
  final String? deletingMemberId;
  final String? deleteError;
  final MemberFilterModel filter;

  MemberPaginateState({
    required this.filter,
    required this.paginate,
    required this.makeRequest,
    required this.deleting,
    this.deletingMemberId,
    this.deleteError,
  });

  factory MemberPaginateState.empty() {
    return MemberPaginateState(
      filter: MemberFilterModel.init(),
      makeRequest: false,
      deleting: false,
      paginate: PaginateResponse<MemberModel>(
        perPage: 10,
        results: [],
        count: 0,
      ),
    );
  }

  MemberPaginateState copyWith({
    PaginateResponse<MemberModel>? paginate,
    bool? makeRequest,
    bool? deleting,
    String? deletingMemberId,
    String? deleteError,
    bool clearDeletingMemberId = false,
    bool clearDeleteError = false,
    int? perPage,
    int? page,
    String? churchId,
  }) {
    return MemberPaginateState(
      makeRequest: makeRequest ?? this.makeRequest,
      paginate: paginate ?? this.paginate,
      deleting: deleting ?? this.deleting,
      deletingMemberId:
          clearDeletingMemberId
              ? null
              : deletingMemberId ?? this.deletingMemberId,
      deleteError: clearDeleteError ? null : deleteError ?? this.deleteError,
      filter: filter.copyWith(perPage: perPage, page: page, churchId: churchId),
    );
  }
}
