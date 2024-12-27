import 'package:church_finance_bk/auth/auth_session_model.dart';
import 'package:church_finance_bk/auth/auth_store.dart';
import 'package:church_finance_bk/core/paginate/paginate_response.dart';
import 'package:church_finance_bk/finance/finance_service.dart';
import 'package:church_finance_bk/finance/models/contribution_filter_model.dart';
import 'package:church_finance_bk/finance/models/contribution_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'contributions_provider.g.dart';

@riverpod
Future<PaginateResponse<Contribution>> searchContributions(Ref ref) async {
  AuthSessionModel session = await AuthStore().restore();

  ContributionFilter filter = ref.watch(contributionsFilterProvider);

  if (session.token == '') {
    throw Exception('No se ha iniciado sesión');
  }

  return await FinanceService(tokenAPI: session.token)
      .searchContribuitions(filter);
}

final contributionsFilterProvider =
    StateNotifierProvider<ContributionFilterNotifier, ContributionFilter>(
  (ref) => ContributionFilterNotifier(),
);

class ContributionFilterNotifier extends StateNotifier<ContributionFilter> {
  ContributionFilterNotifier() : super(ContributionFilter.init());

  void setPerPage(int perPage) {
    state = state.copyWith(perPage: perPage, page: 1);
  }

  void nextPage() {
    state = state.copyWith(page: state.page + 1);
  }

  void prevPage() {
    if (state.page > 1) {
      state = state.copyWith(page: state.page - 1);
    }
  }

  void status(String status) {
    final v =
        ContributionStatus.values.firstWhere((e) => e.friendlyName == status);

    state = state.copyWith(status: v.toString().split('.').last);
  }

  void setStartDate(String startDate) {
    state.startDate = startDate;
  }
}
