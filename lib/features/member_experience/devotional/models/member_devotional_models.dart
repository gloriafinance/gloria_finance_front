class MemberTodayDevotionalModel {
  final String devotionalId;
  final String scheduleDate;
  final String dayOfWeek;
  final DateTime? scheduledAt;
  final String status;
  final String title;

  const MemberTodayDevotionalModel({
    required this.devotionalId,
    required this.scheduleDate,
    required this.dayOfWeek,
    required this.scheduledAt,
    required this.status,
    required this.title,
  });

  factory MemberTodayDevotionalModel.fromAgendaJson(Map<String, dynamic> json) {
    return MemberTodayDevotionalModel(
      devotionalId: json['devotionalId']?.toString() ?? '',
      scheduleDate: json['scheduleDate']?.toString() ?? '',
      dayOfWeek: json['dayOfWeek']?.toString() ?? '',
      scheduledAt:
          json['scheduledAt'] != null
              ? DateTime.tryParse(json['scheduledAt'].toString())
              : null,
      status: json['status']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
    );
  }
}

class MemberDevotionalScriptureModel {
  final String reference;
  final String quote;

  const MemberDevotionalScriptureModel({
    required this.reference,
    required this.quote,
  });

  factory MemberDevotionalScriptureModel.fromJson(Map<String, dynamic> json) {
    return MemberDevotionalScriptureModel(
      reference: json['reference']?.toString() ?? '',
      quote: json['quote']?.toString() ?? '',
    );
  }
}

class MemberDevotionalDetailModel {
  final String devotionalId;
  final String scheduleDate;
  final String dayOfWeek;
  final DateTime? scheduledAt;
  final String status;
  final String title;
  final String devotional;
  final List<MemberDevotionalScriptureModel> scriptures;

  const MemberDevotionalDetailModel({
    required this.devotionalId,
    required this.scheduleDate,
    required this.dayOfWeek,
    required this.scheduledAt,
    required this.status,
    required this.title,
    required this.devotional,
    required this.scriptures,
  });

  bool get hasContent => devotional.trim().isNotEmpty;

  factory MemberDevotionalDetailModel.fromDetailResponse(
    Map<String, dynamic> response,
  ) {
    final data = Map<String, dynamic>.from(response['data'] ?? response);
    final content = Map<String, dynamic>.from(data['content'] ?? const {});
    final rawScriptures = content['scriptures'];

    return MemberDevotionalDetailModel(
      devotionalId: data['devotionalId']?.toString() ?? '',
      scheduleDate: data['scheduleDate']?.toString() ?? '',
      dayOfWeek: data['dayOfWeek']?.toString() ?? '',
      scheduledAt:
          data['scheduledAt'] != null
              ? DateTime.tryParse(data['scheduledAt'].toString())
              : null,
      status: data['status']?.toString() ?? '',
      title: content['title']?.toString() ?? data['title']?.toString() ?? '',
      devotional: content['devotional']?.toString() ?? '',
      scriptures:
          rawScriptures is List
              ? rawScriptures
                  .map(
                    (item) => MemberDevotionalScriptureModel.fromJson(
                      Map<String, dynamic>.from(item),
                    ),
                  )
                  .toList()
              : const [],
    );
  }
}
