import 'package:church_finance_bk/auth/auth_session_model.dart';
import 'package:church_finance_bk/auth/auth_store.dart';
import 'package:church_finance_bk/core/paginate_response.dart';
import 'package:church_finance_bk/finance/finance_service.dart';
import 'package:church_finance_bk/finance/models/contribution_filter_mnodel.dart';
import 'package:church_finance_bk/finance/models/contribution_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'contributions_provider.g.dart';

@Riverpod(keepAlive: true)
class ContributionService extends _$ContributionService {
  @override
  PaginateResponse<Contribution> build() =>
      PaginateResponse<Contribution>.init();

  Future<void> searchContributions(ContributionFilter filter) async {
    AuthSessionModel session = await AuthStore().restore();

    if (session.token == '') {
      throw Exception('No se ha iniciado sesión');
    }

    final response = await FinanceService(tokenAPI: session.token)
        .searchContribuitions(filter);

    state = response;
  }

  void nextPage() {
    if (state.nextPag == 0) {
      return;
    }
    state.nextPag++;
  }

  void prevPage() {
    if (state.nextPag > 0) {
      return;
    }
    state.nextPag--;
  }
}

@Riverpod(keepAlive: true)
class ContributionsFilter extends _$ContributionsFilter {
  @override
  ContributionFilter build() => ContributionFilter.init();

  // void nextPage() {
  //   state.page++;
  // }

  // void prevPage() {
  //   if (state.page > 1) state.page--;
  // }

  void setFilter(ContributionFilter filter) {
    state = filter;
  }
}
