import 'package:gloria_finance/features/member_experience/commitments/models/member_commitment_model.dart';
import 'package:gloria_finance/features/member_experience/commitments/service/member_commitment_service.dart';
import 'package:flutter/material.dart';

class MemberCommitmentStore extends ChangeNotifier {
  final MemberCommitmentService _service = MemberCommitmentService();

  List<MemberCommitmentModel> commitments = [];
  bool isLoading = false;
  String? errorMessage;
  String? statusFilter;

  Future<void> loadCommitments({bool refresh = false}) async {
    if (isLoading && !refresh) return;
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final response = await _service.fetchCommitments(
        status: statusFilter,
      );
      commitments = response.results;
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void setStatusFilter(String? status) {
    statusFilter = status;
    loadCommitments(refresh: true);
  }
}
