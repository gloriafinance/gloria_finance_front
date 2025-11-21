import 'package:church_finance_bk/auth/auth_persistence.dart';
import 'package:church_finance_bk/core/toast.dart';
import 'package:church_finance_bk/finance/accounts_receivable/accounts_receivable_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../../models/index.dart';
import '../state/member_commitments_state.dart';

class MemberCommitmentsStore extends ChangeNotifier {
  final AccountsReceivableService service;
  MemberCommitmentsState state;

  MemberCommitmentsStore({
    String? debtorDNI,
    AccountsReceivableService? service,
  })  : service = service ?? AccountsReceivableService(),
        state = MemberCommitmentsState.initial(debtorDNI ?? '');

  Future<void> initialize({String? debtorDNI}) async {
    var dni = debtorDNI ?? state.filter.debtorDNI;

    if (dni.isEmpty) {
      final session = await AuthPersistence().restore();
      dni = session.memberId ?? '';
    }

    if (dni.isEmpty) {
      state = state.copyWith(errorMessage: 'Não foi possível localizar seus dados.');
      notifyListeners();
      return;
    }

    state = MemberCommitmentsState.initial(dni);
    notifyListeners();
    await fetchCommitments();
  }

  Future<void> fetchCommitments() async {
    if (state.filter.debtorDNI.isEmpty) return;

    state = state.copyWith(isLoading: true, permissionDenied: false, errorMessage: null);
    notifyListeners();

    try {
      final paginate = await service.listMemberCommitments(state.filter);
      state = state.copyWith(paginate: paginate, isLoading: false);
      notifyListeners();
    } on DioException catch (e) {
      final isForbidden = e.response?.statusCode == 403;
      state = state.copyWith(
        isLoading: false,
        permissionDenied: isForbidden,
        errorMessage: isForbidden
            ? 'Você não tem permissão para visualizar esta informação.'
            : 'Não foi possível carregar seus compromissos. Tente novamente.',
      );
      notifyListeners();
    }
  }

  void setStatusFilter(AccountsReceivableStatus? status) {
    state = state.copyWith(
      filter: state.filter.copyWith(status: status, page: 1),
    );
    notifyListeners();
    fetchCommitments();
  }

  void setPage(int page) {
    final nextPage = page < 1 ? 1 : page;
    state = state.copyWith(filter: state.filter.copyWith(page: nextPage));
    notifyListeners();
    fetchCommitments();
  }

  void setPerPage(int perPage) {
    state = state.copyWith(filter: state.filter.copyWith(perPage: perPage, page: 1));
    notifyListeners();
    fetchCommitments();
  }

  String statusLabel(String? status) {
    final parsed = AccountsReceivableStatusHelper.fromApiValue(status);
    return parsed?.friendlyName ?? 'Sem status';
  }

  void showFeedback(String message, ToastType type) {
    Toast.showMessage(message, type);
  }
}
