import 'package:flutter/foundation.dart';
import 'package:gloria_finance/features/member_experience/devotional/models/member_devotional_models.dart';
import 'package:gloria_finance/features/member_experience/devotional/service/member_devotional_service.dart';
import 'package:gloria_finance/features/member_experience/devotional/utils/member_devotional_experience.dart';

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
      final todayDevotional = await _service.fetchTodayDevotional();
      devotional = todayDevotional;

      if (todayDevotional != null) {
        try {
          final detail = await _service.fetchDevotionalDetail(
            todayDevotional.devotionalId,
          );
          devotional = todayDevotional.copyWith(
            previewText: devotionalPreviewText(detail.devotional),
          );

          try {
            final community = await _service.fetchDevotionalCommunity(
              todayDevotional.devotionalId,
            );
            devotional = devotional?.copyWith(
              reactionCount: community.totalReactions,
              commentCount: community.totalComments,
            );
          } catch (_) {}
        } catch (_) {
          devotional = todayDevotional;
        }
      }
    } catch (e) {
      errorMessage = e.toString();
      devotional = null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
