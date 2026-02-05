import 'package:gloria_finance/features/auth/auth_persistence.dart';
import 'package:gloria_finance/features/member_experience/home/models/member_generosity_summary_model.dart';
import 'package:gloria_finance/features/member_experience/home/service/member_generosity_summary_service.dart';
import 'package:flutter/foundation.dart';

class MemberGenerositySummaryStore extends ChangeNotifier {
  final MemberGenerositySummaryService _service;

  bool isLoading = false;
  String? errorMessage;
  String symbolFormatMoney = 'R\$';
  MemberGenerositySummaryModel summary =
      const MemberGenerositySummaryModel.empty();

  MemberGenerositySummaryStore({MemberGenerositySummaryService? service})
    : _service = service ?? MemberGenerositySummaryService();

  Future<void> load() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final session = await AuthPersistence().restore();
      symbolFormatMoney = session.symbolFormatMoney;
      summary = await _service.fetchSummary();
    } catch (e) {
      errorMessage = e.toString();
      summary = const MemberGenerositySummaryModel.empty();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
