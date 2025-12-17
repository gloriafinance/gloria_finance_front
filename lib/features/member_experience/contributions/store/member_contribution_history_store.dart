import 'package:church_finance_bk/features/member_experience/contributions/contribution_service.dart';
import 'package:church_finance_bk/features/member_experience/contributions/models/member_contribution_history_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MemberContributionHistoryStore extends ChangeNotifier {
  final ContributionService _service = ContributionService();

  bool isLoading = false;
  List<MemberContributionHistoryModel> contributions = [];
  int count = 0;
  int page = 1;
  int perPage = 10;
  String? nextPag;

  // Filters
  String type = 'ALL'; // ALL, TITHE, OFFERING
  late DateTime startDate;
  late DateTime endDate;

  MemberContributionHistoryStore() {
    final now = DateTime.now();
    startDate = DateTime(now.year, now.month, 1);
    endDate = now;
    fetchContributions();
  }

  Future<void> fetchContributions({bool refresh = false}) async {
    if (refresh) {
      page = 1;
      contributions = [];
    }

    isLoading = true;
    notifyListeners();

    try {
      final response = await _service.getContributions(
        page: page,
        perPage: perPage,
        type: type == 'ALL' ? null : type,
        startDate: startDate,
        endDate: endDate,
      );

      if (refresh) {
        contributions = response.results;
      } else {
        contributions.addAll(response.results);
      }

      count = response.count;
      nextPag = response.nextPag;
    } catch (e) {
      debugPrint('Error fetching contributions: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void setType(String? value) {
    if (value != null && type != value) {
      type = value;
      fetchContributions(refresh: true);
    }
  }

  void setStartDate(DateTime value) {
    if (startDate != value) {
      startDate = value;
      fetchContributions(refresh: true);
    }
  }

  void setEndDate(DateTime value) {
    if (endDate != value) {
      endDate = value;
      fetchContributions(refresh: true);
    }
  }

  void loadMore() {
    if (nextPag != null && !isLoading) {
      page++;
      fetchContributions();
    }
  }

  // Helper to group contributions by month/year
  Map<String, List<MemberContributionHistoryModel>> get groupedContributions {
    final Map<String, List<MemberContributionHistoryModel>> grouped = {};
    final locale = Intl.getCurrentLocale().isNotEmpty
        ? Intl.getCurrentLocale()
        : 'pt_BR';
    final dateFormat = DateFormat('MMMM yyyy', locale);

    for (var contribution in contributions) {
      final date = contribution.createdAt;
      final key = dateFormat.format(date);
      final formattedKey = toBeginningOfSentenceCase(key) ?? key;

      if (!grouped.containsKey(formattedKey)) {
        grouped[formattedKey] = [];
      }
      grouped[formattedKey]!.add(contribution);
    }

    return grouped;
  }
}
