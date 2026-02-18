import 'package:flutter/foundation.dart';
import 'package:gloria_finance/features/member_experience/devotional/models/member_devotional_models.dart';
import 'package:gloria_finance/features/member_experience/devotional/service/member_devotional_service.dart';

class MemberTodayDevotionalStore extends ChangeNotifier {
  final MemberDevotionalService _service;

  bool isLoading = false;
  String? errorMessage;
  MemberTodayDevotionalModel? devotional;

  MemberTodayDevotionalStore({MemberDevotionalService? service})
    : _service = service ?? MemberDevotionalService();

  Future<void> load() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      devotional = await _service.fetchTodayDevotional();
    } catch (e) {
      errorMessage = e.toString();
      devotional = null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
