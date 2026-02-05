import 'package:gloria_finance/core/paginate/paginate_response.dart';

import '../models/member_filter_model.dart';
import '../models/member_model.dart';

class MemberPaginateState {
  final PaginateResponse<MemberModel> paginate;
  final bool makeRequest;
  final MemberFilterModel filter;

  MemberPaginateState({
    required this.filter,
    required this.paginate,
    required this.makeRequest,
  });

  factory MemberPaginateState.empty() {
    return MemberPaginateState(
      filter: MemberFilterModel.init(),
      makeRequest: false,
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
    int? perPage,
    int? page,
    String? churchId,
  }) {
    return MemberPaginateState(
      makeRequest: makeRequest ?? this.makeRequest,
      paginate: paginate ?? this.paginate,
      filter: filter.copyWith(
        perPage: perPage,
        page: page,
        churchId: churchId,
      ),
    );
  }
}
